//
//  VRVideoPlayer.swift
//  VRPlayerRealityKit
//
//  Created by ByteDance on 2023/12/9.
//

import AVFoundation
import MetalKit
import RealityKit

public class VRVideoPlayer {
    private var player: AVPlayer?
    private var playerItemVideoOutput: AVPlayerItemVideoOutput?

    public var width: Int
    public var height: Int
    private var queue: TextureResource.DrawableQueue?
    
    init(url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        // 设置 AVPlayerItemVideoOutput 以获取视频帧
        let outputSettings: [String: Any] = [
            (kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32BGRA),
            (kCVPixelBufferMetalCompatibilityKey as String): true
        ]
        playerItemVideoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: outputSettings)
        playerItem.add(playerItemVideoOutput!)
        
        player = AVPlayer(playerItem: playerItem)
        width = 1920
        height = 1080
    }

    func play() {
        player?.play()
    }
    
    public lazy var mtlDevice: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError()
        }
        return device
    }()
    
    private lazy var commandQueue: MTLCommandQueue? = {
        return mtlDevice.makeCommandQueue()
    }()
    
    func update(textureResource: TextureResource){
        
        let texture = getCurrentFrameTexture(device: mtlDevice)
        if texture == nil {
            return
        }
        
        if queue == nil {
            queue = try! TextureResource.DrawableQueue(.init(pixelFormat: .bgra8Unorm, width: width, height: height, usage: [.renderTarget, .shaderRead, .shaderWrite], mipmapsMode: .none))
            if queue != nil {
                textureResource.replace(withDrawables: queue!)
            }
        }
        
        do {
            let drawable = try queue?.nextDrawable()
            
            guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
                return
            }
            
            // 创建一个 Blit 命令编码器
            guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else {
              fatalError("Could not create a blit command encoder")
            }
  
            blitCommandEncoder.copy(from: texture!, to: (drawable?.texture)!)
            blitCommandEncoder.endEncoding()
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            
            drawable?.present()
        } catch {
            print(error.localizedDescription)
        }

    }
    
    func updateTexture(with texture: MTLTexture, queue: TextureResource.DrawableQueue){
        
          guard let commandBuffer = commandQueue?.makeCommandBuffer() else {
              return
          }
        
        do {
            let drawable = try queue.nextDrawable()
            // 创建一个 Blit 命令编码器
            guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else {
              fatalError("Could not create a blit command encoder")
            }
  
            blitCommandEncoder.copy(from: texture, to: drawable.texture)
            blitCommandEncoder.endEncoding()
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            drawable.present()

        } catch {
            // 错误处理: 打印出错信息
            print("Error while getting the drawable: \(error.localizedDescription)")
        }
        
    }
    
    // 获取当前视频帧作为 MTLTexture
    func getCurrentFrameTexture(device: MTLDevice) -> MTLTexture? {
        guard let playerItemVideoOutput = playerItemVideoOutput else { return nil }
        
        let itemTime = playerItemVideoOutput.itemTime(forHostTime: CACurrentMediaTime())
        
        if playerItemVideoOutput.hasNewPixelBuffer(forItemTime: itemTime),
           let pixelBuffer = playerItemVideoOutput.copyPixelBuffer(forItemTime: itemTime, itemTimeForDisplay: nil) {
            return createMTLTexture(from: pixelBuffer, device: device)
        }
        
        return nil
    }

    // 创建 MTLTexture 从 CVPixelBuffer
    private func createMTLTexture(from pixelBuffer: CVPixelBuffer, device: MTLDevice) -> MTLTexture? {
        // 确保 Metal 支持该设备
        guard let textureCache = createTextureCache(device: device) else { return nil }

        var maybeTexture: CVMetalTexture?
        width = CVPixelBufferGetWidth(pixelBuffer)
        height = CVPixelBufferGetHeight(pixelBuffer)

        let status = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                               textureCache,
                                                               pixelBuffer,
                                                               nil,
                                                               .bgra8Unorm,
                                                               width,
                                                               height,
                                                               0,
                                                               &maybeTexture)

        guard status == kCVReturnSuccess, let metalTexture = maybeTexture else { return nil }

        return CVMetalTextureGetTexture(metalTexture)
    }

    // 创建 Texture Cache
    private func createTextureCache(device: MTLDevice) -> CVMetalTextureCache? {
        var textureCache: CVMetalTextureCache?
        let status = CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil, &textureCache)
        
        if status != kCVReturnSuccess {
            return nil
        }
        
        return textureCache
    }
}
