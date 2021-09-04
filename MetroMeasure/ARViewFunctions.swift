//
//  ARViewFunctions.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import Foundation
import ARKit
import RealityKit

class ARViewFunctions: ARView{
    
    var point1: SIMD3<Float>? = nil
    var point2: SIMD3<Float>? = nil
    
    
    func setMasterAnchor(){
        let zeroPoint = Entity()
        // SIMD3<Float>.init(x:0,y:0,z:0) == .zero
        zeroPoint.setPosition(SIMD3<Float>.init(x:0,y:0,z:0), relativeTo: nil)
        
        let raycastAnchor = ARAnchor(name: "target", transform: zeroPoint.transformMatrix(relativeTo: nil))
        self.session.add(anchor: raycastAnchor)
        
        let masterAnchor = Entity()
        masterAnchor.name = "masterAnchor"
        
        let ARAnchorEntity = AnchorEntity(anchor: raycastAnchor)
        self.scene.addAnchor(ARAnchorEntity)
        ARAnchorEntity.addChild(masterAnchor)
    }
    
    func castRay() -> Bool {
        let location = CGPoint(x: bounds.midX, y: bounds.midY)
        let result = self.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
        
        if let firstResult = result.first{
            let target = firstResult.worldTransform.Position()
            if point1 == nil {
                point1 = target
                addDot(position: point1!, name: "point1")
                print("DEBUG: First Point Build")
                return true
            }
            else if point2 == nil {
                point2 = target
                addDot(position: point2!, name: "point2")
                print("DEBUG: Second Point Build")
                return true
            }
        }
        print("DEBUG: Fall to hit")
        return false
    }
    
    func safeAndCalculate() -> Float {
        if point1 != nil && point2 != nil{
            //calculate
            let height = calculateDistance(point1!, point2!)
            print("measured \(height*100)cm")
            return height
            //next page
        }
        else {
            return -1.0
        }
    }
    
    func resetAPoint() -> String{
        if point2 == nil
        {
            guard let p1 = self.scene.findEntity(named: "point1") else {print("cant find point1")
                return "Cant find point1"}
            p1.removeFromParent()
            point1 = nil
            print("DEBUG: Reset point1.")
            return "Choose first point"
        }
        else
        {
            guard let p2 = self.scene.findEntity(named: "point2") else {print("cant find point2")
                return "Cant find point2" }
            p2.removeFromParent()
            point2 = nil
            print("DEBUG: Reset point2.")
            return "Choose second point"
        }
    }
    
    func resetAllPoint(){
        guard let p1 = self.scene.findEntity(named: "point1") else {print("cant find point1")
            return }
        guard let p2 = self.scene.findEntity(named: "point2") else {print("cant find point2")
            return}
        p1.removeFromParent()
        p2.removeFromParent()
        point1 = nil
        point2 = nil
        print("DEBUG: Reset ALL Points.")
    }
    
    func calculateDistance(_ point1: SIMD3<Float>,_ point2: SIMD3<Float>) -> Float{
        let vector = point1 - point2
        let gravity = SIMD3<Float>(x:0, y:1, z:0)
        let height = simd_dot(vector, gravity)/simd_length(gravity)
        return abs(height)
        
    }
    
    func addDot(position: SIMD3<Float>, name: String){
        let dotMesh : MeshResource = .generateSphere(radius: 0.003)
        let material = UnlitMaterial(color: UIColor.init(red: 77/255, green: 132/255, blue: 160/255, alpha: 0.7))
        let dot = ModelEntity.init(mesh: dotMesh, materials: [material])
        dot.name = name
        dot.setPosition(position, relativeTo: nil)
        guard let masterAnchor = self.scene.findEntity(named: "masterAnchor")
        else {print("Cant find master anchor")
            return }
        masterAnchor.addChild(dot, preservingWorldTransform: true)
    }
}


extension simd_float4x4{
    
    func Position() -> SIMD3<Float>{
        let readEntity = Entity.init()
        readEntity.setTransformMatrix(self, relativeTo: nil)
        return readEntity.position
    }
    
    func Rotation() -> simd_quatf{
        let readEntity = Entity.init()
        readEntity.setTransformMatrix(self, relativeTo: nil)
        return readEntity.orientation
    }
    
    func Scale() -> SIMD3<Float>{
        let readEntity = Entity.init()
        readEntity.setTransformMatrix(self, relativeTo: nil)
        return readEntity.scale
    }
    
    func NormalVector() -> SIMD3<Float>{
        let vector = self.Rotation().act(.init(x: 0, y: 0, z: 1))
        return simd_normalize(vector)
    }
}
