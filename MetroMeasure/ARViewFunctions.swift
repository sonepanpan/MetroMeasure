//
//  ARViewFunctions.swift
//  MetroMeasure
//
//  Created by 潘婷蓁 on 2021/9/2.
//

import Foundation
import ARKit
import RealityKit
import FocusEntity

class ARViewFunctions: ARView{
    
    var point1: SIMD3<Float>? = nil
    var point2: SIMD3<Float>? = nil
    var average_after_1: Float = -1.0
    var average_after_2: Float = -1.0

    // FocusEntity
    enum FocusStyleChoices {
      case classic
      case material
      case color
    }

    // FocuseEntuty: Style to be displayed in the example
    let focusStyle: FocusStyleChoices = .classic
    var focusEntity: FocusEntity?
    required init(frame frameRect: CGRect) {
      super.init(frame: frameRect)
      self.setupConfig()

      switch self.focusStyle {
      case .color:
        self.focusEntity = FocusEntity(on: self, focus: .plane)
      case .material:
        do {
          let onColor: MaterialColorParameter = try .texture(.load(named: "Add"))
          let offColor: MaterialColorParameter = try .texture(.load(named: "Open"))
          self.focusEntity = FocusEntity(
            on: self,
            style: .colored(
              onColor: onColor, offColor: offColor,
              nonTrackingColor: offColor
            )
          )
        } catch {
          self.focusEntity = FocusEntity(on: self, focus: .classic)
          print("Unable to load plane textures")
          print(error.localizedDescription)
        }
      default:
        self.focusEntity = FocusEntity(on: self, focus: .classic)
      }
    }

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

    
    func castRay() -> Bool {
        var y_List: [Float] = []
        let location = CGPoint(x: bounds.midX, y: bounds.midY)
        //let location = CGPoint(x: self.view.frame.height / 2, y:self.view.frame.height / 2)
        let result = self.raycast(from: location, allowing: .estimatedPlane, alignment: .any)
        
        if let firstResult = result.first{
            let target = firstResult.worldTransform.Position()
            for delta_x in -2...2
            {
                for delta_y in -2...2{
                    let point = CGPoint(x: bounds.midX+CGFloat(delta_x), y: bounds.midY + CGFloat(delta_y))
                    let result = self.raycast(from: point, allowing: .estimatedPlane, alignment: .any)
                    if result.first != nil{
                        //正方形射線範圍顯示
//                        addDot(position: result.first!.worldTransform.Position(), name: "point_\(delta_x)_\(delta_y)")
                        print("point_\(delta_x)_\(delta_y): \(result.first!.worldTransform.Position())")
                        y_List.append(result.first!.worldTransform.Position().y)
                    }
                }
            }
            
            if point1 == nil {
                point1 = target
                addDot(position: point1!, name: "point1")
                print("DEBUG: First Point Build")
                average_after_1 = deleteOutlier(array: y_List)
                print("\(average_after_1)")
                return true
            }
            else if point2 == nil {
                point2 = target
                addDot(position: point2!, name: "point2")
                print("DEBUG: Second Point Build")
                average_after_2 = deleteOutlier(array: y_List)
                print("\(average_after_2)")
                return true
            }
        }
        print("DEBUG: Fall to hit")
        return false
    }
    
    func safeAndCalculate() -> Float {
        if point1 != nil && point2 != nil{
            //calculate
//            let height = calculateDistance(point1!, point2!)
            let height = abs(average_after_1 - average_after_2)
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
            average_after_1 = -1
            p1.removeFromParent()
            point1 = nil
            print("DEBUG: Reset point1.")
            return "Choose first point"
        }
        else
        {
            guard let p2 = self.scene.findEntity(named: "point2") else {print("cant find point2")
                return "Cant find point2" }
            average_after_2 = -1
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
        average_after_1 = -1
        average_after_2 = -1
        p1.removeFromParent()
        p2.removeFromParent()
        point1 = nil
        point2 = nil
        print("DEBUG: Reset ALL Points.")
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
    
    func deleteOutlier(array: [Float]) -> Float{
        var List: [Float] = array
        let std = self.std(array: List)
        let average = self.average(array: List)
        for (i,y) in List.enumerated(){
            if abs(y - average) > 3*std{
                List.remove(at: i)
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
