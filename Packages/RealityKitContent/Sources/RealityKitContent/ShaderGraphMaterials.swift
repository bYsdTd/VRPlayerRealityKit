//
//  File.swift
//  
//
//  Created by ByteDance on 2023/12/4.
//

/*
Abstract:
An extension on entity-containing methods to help when updating Shader Graph material parameters.
*/

import RealityKit

public extension Entity {

    var modelComponent: ModelComponent? {
        components[ModelComponent.self]
    }

    var shaderGraphMaterial: ShaderGraphMaterial? {
        if modelComponent?.materials != nil {
            for mat in modelComponent!.materials {
                print(mat.name)
            }
        }
        return modelComponent?.materials.first as? ShaderGraphMaterial
    }

    func update(shaderGraphMaterial oldMaterial: ShaderGraphMaterial,
                _ handler: (inout ShaderGraphMaterial) throws -> Void) rethrows {
        var material = oldMaterial
        try handler(&material)

        if var component = modelComponent {
            component.materials = [material]
            components.set(component)
        }
    }
    
    var parameterNames: [String]? {
        shaderGraphMaterial?.parameterNames
    }
    
    func hasMaterialParameter(named: String) -> Bool {
        parameterNames?.contains(where: { $0 == named }) ?? false
    }
}

