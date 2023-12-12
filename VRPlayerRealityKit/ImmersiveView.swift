//
//  ImmersiveView.swift
//  VRPlayerRealityKit
//
//  Created by ByteDance on 2023/12/3.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {
    
    @State private var cancellables = Set<AnyCancellable>()
    @State private var vrplayer: VRVideoPlayer?
    @State private var textureResource: TextureResource?
    
    var body: some View {
        RealityView { content in
            
            do {
                // 原加载场景代码
                var rootEntity = try await Entity(named: "vr_player_scene", in: realityKitContentBundle)
                content.add(rootEntity)
                let matEntity = rootEntity.findEntity(named: "Mesh");
                var dynamicMaterial = matEntity?.shaderGraphMaterial;
                    
                    // 动态加载material
//                    var dynamicMaterial = try await ShaderGraphMaterial(named: "/Sphere/DynamicMaterial", from: "vr_player_scene.usdc", in: realityKitContentBundle)
                    
                let image = GetTempOnePixelUIImage()!
                textureResource = try await TextureResource.generate(from: image, options: .init(semantic: .color))
                try dynamicMaterial?.setParameter(name: "VideoTexture", value: .textureResource(textureResource!))
                
                try matEntity?.update(shaderGraphMaterial: dynamicMaterial!, {material in
                    try material.setParameter(name: "VideoTexture", value: .textureResource(textureResource!))
                })
                
//                dynamicMaterial.setParameter(name: MaterialParameterTypes.FaceCulling as String, value: materpa)
                // start play a video from URL
                let urlString = URL(string: "http://10.37.24.71/movie/test.mp4")
                self.vrplayer = VRVideoPlayer(url: urlString!)
                self.vrplayer!.play()
                
                
//                // create a sphere
//                let box = Entity()
//                box.name = "sphere"
//                
//                box.components.set(ModelComponent(mesh: .generateSphere(radius: 2), materials: [dynamicMaterial]))
//                
//                content.add(box)
                
            } catch {
                fatalError(error.localizedDescription)
            }
        }.task {
            
            Timer.publish(every: 0.003, on: .main, in: .common).autoconnect().sink { output in
//                let t = output.timeIntervalSince1970
//                let red = abs(sin(t))
//                let color = CIImage(color: .init(red: red, green: 0, blue: 0)).cropped(to: CGRect(origin: .zero, size: .init(width: 256, height: 256)))
                
                vrplayer?.update(textureResource: textureResource!)
                
            }.store(in: &cancellables)
        }
    }

    // 第一种方法获取1像素贴图
    func GetTempOnePixelUIImage() -> CGImage? {
        // 创建一个 1x1 像素的 UIImage
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!

        // 设置像素颜色，例如白色
        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image.cgImage
    }
    
    // 第二种方法获得一像素贴图
    func GetTempOnePixelUIImage2() -> CGImage {
        let context = CIContext()
        let color = CIImage(color: .red).cropped(to: CGRect(origin: .zero, size: .init(width: 1, height: 1)))
        let image = context.createCGImage(color, from: color.extent)!
        return image
    }
}
