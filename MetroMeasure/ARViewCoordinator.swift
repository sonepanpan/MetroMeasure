//
//  ARViewCoordinator.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit
import FocusEntity


//ARView in global space
let arViewContainer = ARViewContainer()

struct ARViewContainer: UIViewRepresentable {
    
    typealias UIViewType = ARViewFunctions
    let arView = ARViewFunctions(frame: .zero)
    
    func makeUIView(context: UIViewRepresentableContext<ARViewContainer>) -> ARViewFunctions {
        
//        DEBUG
//        arViewContainer.arView.debugOptions.insert(.showSceneUnderstanding) //LiDAR mesh reconstruction
//        arViewContainer.arView.debugOptions.insert(.showPhysics)
//        arViewContainer.arView.debugOptions.insert(.showStatistics)
//        arViewContainer.arView.debugOptions.insert(.showFeaturePoints)
        
        arView.setMasterAnchor()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARViewFunctions, context: UIViewRepresentableContext<ARViewContainer>) {
            
            
        }
    
}


