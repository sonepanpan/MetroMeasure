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

//ARView in global space
let arViewContainer = ARViewContainer()

struct ARViewContainer: UIViewRepresentable {
    
    typealias UIViewType = ARViewFunctions
    let arView = ARViewFunctions(frame: .zero)
    
    func makeUIView(context: UIViewRepresentableContext<ARViewContainer>) -> ARViewFunctions {
        let supportLiDAR = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        if supportLiDAR{
            config.sceneReconstruction = .mesh
        }
        
        arView.session.run(config, options: [])
        
        //DEBUG
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
