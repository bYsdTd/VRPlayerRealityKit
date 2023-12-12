////
////  DrawableTextureManager.swift
////  VRPlayerRealityKit
////
////  Created by ByteDance on 2023/12/3.
////
//
//import RealityKit
//import MetalKit
//
//public class DrawableTextureManager {
//    
//    public lazy var mtlDevice: MTLDevice = {
//        guard let device = MTLCreateSystemDefaultDevice() else {
//            fatalError()
//        }
//        return device
//    }()
//    
////    public let textureResource: TextureResource
////    var shaderGraphMaterial: ShaderGraphMaterial
//    // 声明 drawableQueue，但不立即初始化
////    var drawableQueue: TextureResource.DrawableQueue?
////    var textureName: String
//    
//    
//    public let drawableQueue2 = try! TextureResource.DrawableQueue(.init(pixelFormat: .bgra8Unorm, width: 256, height: 256, usage: [.renderTarget, .shaderRead, .shaderWrite], mipmapsMode: .none))
//    
//    // 方法，根据传入的宽度和高度创建 DrawableQueue
////    func createDrawableQueue(width: Int, height: Int) -> TextureResource.DrawableQueue {
////        if drawableQueue != nil {
////            return drawableQueue!
////        }
////        let descriptor = TextureResource.DrawableQueue.Descriptor(
////            pixelFormat: .bgra8Unorm,
////            width: width,
////            height: height,
////            usage: [.shaderRead, .shaderWrite, .renderTarget],
////            mipmapsMode: .none
////        )
////
////        do {
////            let queue = try TextureResource.DrawableQueue(descriptor)
////            queue.allowsNextDrawableTimeout = true
////            
////            // 用drawableQueue relace TextureResource
////            textureResource.replace(withDrawables: queue)
////            // 更新材质
////            try? self.shaderGraphMaterial.setParameter(name: textureName, value: .textureResource(textureResource))
////            
////            self.drawableQueue = queue
////            return queue
////        } catch {
////            fatalError("Could not create DrawableQueue: \(error)")
////        }
////    }
//    
//    let context = CIContext()
//    private lazy var commandQueue: MTLCommandQueue? = {
//        return mtlDevice.makeCommandQueue()
//    }()
//    
//    // 初始化材质信息，把textureResouce更新到ShaderGraphMaterial上
//    public init(shaderGraphMaterial : ShaderGraphMaterial, textureName : String) {
////        self.textureName = textureName
////        self.shaderGraphMaterial = shaderGraphMaterial
////        // 创建一个 1x1 像素的 UIImage
////        let size = CGSize(width: 1, height: 1)
////        UIGraphicsBeginImageContext(size)
////        let context = UIGraphicsGetCurrentContext()!
////
////        // 设置像素颜色，例如白色
////        context.setFillColor(UIColor.white.cgColor)
////        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
////
////        let image = UIGraphicsGetImageFromCurrentImageContext()!
////        UIGraphicsEndImageContext()
////        
////        // 使用 RealityKit 的 TextureResource.generate 方法
////        guard let cgImage = image.cgImage,
////        let textureResource = try? TextureResource.generate(from: cgImage, withName: nil, options: .init(semantic: .color))
////        else {
////          fatalError("DrawableTextureManager could not be instantiated")
////        }
////        
////        textureResource.replace(withDrawables: drawableQueue2)
////        self.textureResource = textureResource
//        
////        do {
////            let color = CIImage(color: .red).cropped(to: CGRect(origin: .zero, size: .init(width: 256, height: 256)))
////            let image = context.createCGImage(color, from: color.extent)!
////            let textureResource = try await TextureResource.generate(from: image, options: .init(semantic: .color))
////
////            textureResource.replace(withDrawables: drawableQueue2)
////            
////            
////        } catch {
////            print(error.localizedDescription)
////        }
//
//    }
//}
//
//public extension DrawableTextureManager {
//  func update(with texture: MTLTexture) {
////      guard let drawableQueue = drawableQueue,
////            let commandBuffer = commandQueue?.makeCommandBuffer() else {
////          return
////      }
//
//      do {
//          let drawable = try drawableQueue2.nextDrawable()
////          // 后续使用 drawable 和 commandBuffer 的代码...
////          // 创建一个 Blit 命令编码器
////          guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else {
////            fatalError("Could not create a blit command encoder")
////          }
////
////          blitCommandEncoder.copy(from: texture, to: drawable.texture)
////          blitCommandEncoder.endEncoding()
////          commandBuffer.commit()
////          commandBuffer.waitUntilCompleted()
//          drawable.present()
//
//      } catch {
//          // 错误处理: 打印出错信息
//          print("Error while getting the drawable: \(error.localizedDescription)")
//      }
//  }
//}
//
//
