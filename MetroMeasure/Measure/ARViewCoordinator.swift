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
//var arViewContainer : ARViewContainer? = nil

struct ARViewContainer: UIViewRepresentable {
    
    typealias UIViewType = ARViewFunctions
    let arView = ARViewFunctions(frame: .zero)
    
    func makeUIView(context: UIViewRepresentableContext<ARViewContainer>) -> ARViewFunctions {
        
//        DEBUG
        arView.debugOptions.insert(.showSceneUnderstanding) //LiDAR mesh reconstruction
//        arView.debugOptions.insert(.showPhysics)
//        arView.debugOptions.insert(.showStatistics)
//        arView.debugOptions.insert(.showFeaturePoints)
        
        //?
        arView.setMasterAnchor()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARViewFunctions, context: UIViewRepresentableContext<ARViewContainer>) {
            
        }
    
}


