//
//  VRPlayerRealityKitApp.swift
//  VRPlayerRealityKit
//
//  Created by ByteDance on 2023/12/3.
//

import SwiftUI

@main
struct VRPlayerRealityKitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
