//
//  ARViewFunctions.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//
// test test test

import Foundation
import ARKit
import RealityKit
import FocusEntity
import SwiftUI

class ARViewFunctions: ARView{
    
    var pointDevice: SIMD3<Float>? = nil
    var pointRail: SIMD3<Float>? = nil
    var average_after_Device: Float = -1.0
    var average_after_Rail: Float = -1.0
    
    // FocusEntity
    enum FocusStyleChoices {
        case classic
        case material
        case color
    }
    
    // FocuseEntuty: Style to be displayed in the example
//    let focusStyle: FocusStyleChoices = .classic
//    var focusEntity: FocusEntity?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        
        self.setupConfig()
        
//        switch self.focusStyle {
//        case .color:
//            self.focusEntity = FocusEntity(on: self, focus: .plane)
//        case .material:
//            do {
//                let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
//                let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
//                self.focusEntity = FocusEntity(
//                    on: self,
//                    style: .colored(
//                        onColor: onColor, offColor: offColor,
//                        nonTrackingColor: offColor
//                    )
//                )
//            } catch {
//                self.focusEntity = FocusEntity(on: self, focus: .classic)
//                print("Unable to load plane textures")
//                print(error.localizedDescription)
//            }
//        default:
//            self.focusEntity = FocusEntity(on: self, focus: .classic)
//        }
    }
    

//    //Anchor
//    func placeDot(position: SIMD3<Float>, name: String){
//
//        let dotMesh : MeshResource = .generateSphere(radius: 0.003)
//        let material = UnlitMaterial(color: UIColor.init(red: 77/255, green: 132/255, blue: 160/255, alpha: 0.7))
//        let dot = ModelEntity.init(mesh: dotMesh, materials: [material])
//        dot.name = name
////        dot.setPosition(position, relativeTo: nil)
//        let anchorEntity = AnchorEntity(plane: .any)
//        anchorEntity.addChild(dot)
//        self.scene.addAnchor(anchorEntity)
//        print("add dot \(dot.position)")
//    }
//
    
    //Origin Feature
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
    
    
    func castRayToRail() -> Bool {
        var y_Rail_List: [Float] = []
        let location = CGPoint(x: bounds.midX, y: bounds.midY)
        //let location = CGPoint(x: self.view.frame.height / 2, y:self.view.frame.height / 2)
        let result = self.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
        var i: Int = 0
        if let firstResult = result.first{
            let target = firstResult.worldTransform.Position()
            for delta_y in -3...3
            {
                for delta_x in -3...3{
                    let point = CGPoint(x: bounds.midX+CGFloat(Double(delta_x)*2), y: bounds.midY + CGFloat(Double(delta_y)*3))
                    let result = self.raycast(from: point, allowing: .estimatedPlane, alignment: .any)
                    if result.first != nil{
                        //正方形射線範圍顯示
                        //                        addDot(position: result.first!.worldTransform.Position(), name: "point_\(delta_x)_\(delta_y)")
//                        addDot(position: result.first!.worldTransform.Position(), name: "point_\(i)")
                        //                        print("point_\(delta_x)_\(delta_y): \(result.first!.worldTransform.Position())")
                        print("point_Rail_\(i): \(result.first!.worldTransform.Position())")
                        i+=1
                        y_Rail_List.append(result.first!.worldTransform.Position().y)
                    }
                }
            }
            
            pointRail = target
            addDot(position: pointRail!, name: "pointRail")
            print("DEBUG: Rail Point Build")
            average_after_Rail = deleteOutlier(array: y_Rail_List)
            pointRail!.y=average_after_Rail
            addCheckDot(position: pointRail!, name: "pointRail_Check")

            print("\(average_after_Rail)")
            return true
            
        }
        print("DEBUG: Fall to hit")
        return false
    }
    
    
    func castRayToDevice() -> Bool {
        var y_List: [Float] = []
        var y_Device_List: [Float] = []
        let location = CGPoint(x: bounds.midX, y: bounds.midY)
        //let location = CGPoint(x: self.view.frame.height / 2, y:self.view.frame.height / 2)
        let result = self.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
        var i: Int = 0
        if let firstResult = result.first{
            let target = firstResult.worldTransform.Position()
            for delta_x in -1...1
            {
                for delta_y in -20...20
                {
                    let point = CGPoint(x: bounds.midX + CGFloat(Double(delta_x)*10), y: bounds.midY + CGFloat(Double(delta_y)*2))
                    let result = self.raycast(from: point, allowing: .estimatedPlane, alignment: .any)
//                    self.trackedRaycast(from: point, allowing: .estimatedPlane, alignment: .any, updateHandler: { [self] result in
//                        if result.first != nil{
//                            self.addDot(position: result.first!.worldTransform.Position(), name: "point_Device_\(i)")
//
//                            i+=1
//                            y_Device_List.append(result.first!.worldTransform.Position().y)
//                        }
//
//                    })
                    if result.first != nil{
                        //射線範圍顯示
                        //                        addDot(position: result.first!.worldTransform.Position(), name: "point_\(delta_x)_\(delta_y)")
                        addDot(position: result.first!.worldTransform.Position(), name: "point_Device_\(i)")
                        //                        print("point_\(delta_x)_\(delta_y): \(result.first!.worldTransform.Position())")
                        print("point_Device_\(i): \(result.first!.worldTransform.Position())")
                        i+=1
                        y_Device_List.append(result.first!.worldTransform.Position().y)
                    }
                }
                let temp_y = findMax(array: y_Device_List)
                if temp_y != 0.0{
                    y_List.append(temp_y)
                }
                else{
                    y_List.append(target.y)
                }
            }
            
            pointDevice = target
            addDot(position: pointDevice!, name: "pointDevice")

            
            average_after_Device = average(array: y_List)
            pointDevice!.y = average_after_Device
            addCheckDot(position: pointDevice!, name: "pointDevice_Check")

            print("\(average_after_Device)")
            return true
        }
        print("DEBUG: Fall to hit")
        return false
    }
    
    
    func SafeDeviceHeight() -> Float{
        print(average_after_Device)
        return average_after_Device
    }
    
    func SafeRailHeight() -> Float {
        return average_after_Rail
    }
    
    func resetAPoint(name: String) -> String{
        guard let p = self.scene.findEntity(named: "point"+name) else {print("cant find point\(name)")
            return "Cant find point\(name)"}
        
        guard let p1 = self.scene.findEntity(named: "point\(name)_Check") else {print("cant find point\(name)_Check")
            return "Cant find point\(name)_Check" }
        
        p.removeFromParent()
        p1.removeFromParent()

        if pointRail == nil{
            pointDevice = nil
            average_after_Device = -1
        }
        else{
            pointRail = nil
            average_after_Rail = -1
        }
        print("DEBUG: Reset point\(name).")
        return "Cast Ray at \(name)"
        

    }
    
    //height not pass
    func resetAllPoint(){
        guard let p1 = self.scene.findEntity(named: "pointRail") else {print("cant find pointRail")
            return }
        guard let p2 = self.scene.findEntity(named: "pointDevice") else {print("cant find pointDevice")
            return}
        average_after_Rail = -1
        average_after_Device = -1
        p1.removeFromParent()
        p2.removeFromParent()
        pointRail = nil
        pointDevice = nil
        print("DEBUG: Reset ALL Points.")
            
        guard let p3 = self.scene.findEntity(named: "pointRail_Check") else {print("cant find pointRail_Check")
            return }
        guard let p4 = self.scene.findEntity(named: "pointDevice_Check") else {print("cant find pointDevice+Check")
            return}
        p3.removeFromParent()
        p4.removeFromParent()
    }
    
    func average(array: [Float]) -> Float{
        var sum: Float = 0.0
        for y in array{
            sum += y
        }
        return sum/(Float(array.count))
        
    }
    
    
    func std(array: [Float]) -> Float{
        let average_origin = average(array: array)
        var sum_std: Float=0.0
        for z in array{
            sum_std += pow((z - average_origin),2)
        }
        return sqrt((sum_std/(Float(array.count)-1)))
    }
    
    func findMax (array: [Float]) -> Float{
        let List: [Float] = array
        @State var i: Int = 0
        var max=List[i]
        for i in 1..<List.count{
            if(max < List[i]){
                max = List[i]
            }
        }
        return max
    }
    
    func chooseEdgePoint(array: [Float]) -> Float{
        let List: [Float] = array
        @State var i: Int = 0
        
        while(i<List.count-2){
            if (List[i]-List[i+1]>0.0){
                i+=1
                continue
            }
            else{
                return List[i]
            }
        }
        return 0.0
    }
    
    func removeOtherPoints(array: [Float]) -> Float{
        var List: [Float] = array
        var Delete_index: [Int]=[]
        var hasUnqualified = false
        var index=0
        
        while !hasUnqualified {
            if abs(List[index] - List[index+1])*100 > 1{
                print("remove: \(index), \(abs(List[index] - List[index+1])*100)")
                hasUnqualified=true
                index+=1
                break
            }
            else{
                index+=1
                if(index==List.count-1){
                    break
                }
            }
        }
//        print(hasUnqualified)
        
        if hasUnqualified{
            for i in index..<List.count{
                Delete_index.append(i)
            }
            print(Delete_index)
            Delete_index.reverse()
            for j in 0..<Delete_index.count{
//                print("\(j) \(Delete_index[j])")
                List.remove(at: Delete_index[j])
//                guard let p = self.scene.findEntity(named: "point_Device_\(Delete_index[j])")
//                else {print("cant find point_\(Delete_index[j])")
//                    return -1.0
//                }
//                p.removeFromParent()
            }
        }
        print(List)
        return average(array: List)
    }
    
    func deleteOutlier(array: [Float]) -> Float{
        var List: [Float] = array
        let std = self.std(array: List)
        let average = self.average(array: List)
        for (i,y) in List.enumerated(){
            if abs(y - average) > 3*std{
                List.remove(at: i)
                print("remove: \(i)")
            }
        }
        
        return self.average(array: List)
    }
    
    func calculateDistance(_ point1: SIMD3<Float>,_ point2: SIMD3<Float>) -> Float{
        let vector = point1 - point2
        let gravity = SIMD3<Float>(x:0, y:1, z:0)
        let height = simd_dot(vector, gravity)/simd_length(gravity)
        return abs(height)
        
    }
    
    func addDot(position: SIMD3<Float>, name: String){
        
        let dotMesh : MeshResource = .generateSphere(radius: 0.001)
        let material = UnlitMaterial(color: UIColor.init(red: 77/255, green: 132/255, blue: 160/255, alpha: 0.7))
        let dot = ModelEntity.init(mesh: dotMesh, materials: [material])
        dot.name = name
        dot.setPosition(position, relativeTo: nil)
        
        

        guard let masterAnchor = self.scene.findEntity(named: "masterAnchor")
        else {print("Cant find master anchor")
            return }
        masterAnchor.addChild(dot, preservingWorldTransform: true)
    }
    
    func addCheckDot(position: SIMD3<Float>, name: String){
        
        let dotMesh : MeshResource = .generateSphere(radius: 0.001)
        let material = UnlitMaterial(color: UIColor.init(red: 10/255, green: 255/255, blue: 10/255, alpha: 0.7))
        let dot = ModelEntity.init(mesh: dotMesh, materials: [material])
        dot.name = name
        dot.setPosition(position, relativeTo: nil)
        
        

        guard let masterAnchor = self.scene.findEntity(named: "masterAnchor")
        else {print("Cant find master anchor")
            return }
        masterAnchor.addChild(dot, preservingWorldTransform: true)
    }
    
    
    
    func setupConfig()
    {
        let supportLiDAR = ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        if supportLiDAR{
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config, options: [])
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ARViewFunctions: FocusEntityDelegate {
    func toTrackingState() {
        print("tracking")
    }
    func toInitializingState() {
        print("initializing")
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
