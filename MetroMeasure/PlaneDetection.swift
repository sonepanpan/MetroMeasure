////
////  PlaneDetection.swift
////  MetroMeasure
////
////  Created by 潘婷蓁 on 2021/11/2.
////
//
//import Foundation
//import UIKit
//import SceneKit
//import ARKit
//import SwiftUI
//
//
//struct PlaneDetection: UIViewControllerRepresentable{
//    func makeUIViewController(context: Context) -> ViewController {
//        let detect = ViewController()
//        return detect
//    }
//
//    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
//
//    }
//
//}
//
//class ViewController: UIViewController, ARSCNViewDelegate {
//
//    @IBOutlet weak var sceneView: ARSCNView!
//    private let metalDevice: MTLDevice? = MTLCreateSystemDefaultDevice()
//    private var currPlaneId: Int = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Set the view's delegate
//        sceneView.delegate = self
//
//        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//        sceneView.debugOptions = [
//            ARSCNDebugOptions.showFeaturePoints,
//            ARSCNDebugOptions.showWorldOrigin
//        ]
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        configuration.planeDetection = [.horizontal, .vertical]
//
//        // Run the view's session
//        sceneView.session.run(configuration)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Pause the view's session
//        sceneView.session.pause()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Release any cached data, images, etc that aren't in use.
//    }
//
//    // MARK: - ARSCNViewDelegate
//
///*
//    // Override to create and configure nodes for anchors added to the view's session.
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        let node = SCNNode()
//
//        return node
//    }
//*/
//
//    func createPlaneNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
//        let scenePlaneGeometry = ARSCNPlaneGeometry(device: metalDevice!)
//        scenePlaneGeometry?.update(from: planeAnchor.geometry)
//        let planeNode = SCNNode(geometry: scenePlaneGeometry)
//        planeNode.name = "\(currPlaneId)"
//        planeNode.opacity = 0.25
//        if planeAnchor.alignment == .horizontal {
//            planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
//        } else {
//            planeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//        }
//        currPlaneId += 1
//        return planeNode
//    }
//
//    // Runs whenever a new ARAnchor (a real-world location with position and orientation) is added to the SCNScene
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        // only care about detected planes (i.e. `ARPlaneAnchor`s)
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        let planeNode = createPlaneNode(planeAnchor: planeAnchor)
//        node.addChildNode(planeNode)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        // only care about detected planes (i.e. `ARPlaneAnchor`s)
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        print("Updating plane anchor")
//        node.enumerateChildNodes { (childNode, _) in
//            childNode.removeFromParentNode()
//        }
//        let planeNode = createPlaneNode(planeAnchor: planeAnchor)
//        node.addChildNode(planeNode)
//
////        let planeNode = node.childNode(withName: node.name!, recursively: false)
////        let g = planeNode?.geometry as? ARSCNPlaneGeometry
////        g?.update(from: planeAnchor.geometry)
////        planeNode?.geometry = g
////        node.addChildNode(planeNode!)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
//        guard let _ = anchor as? ARPlaneAnchor else { return }
//        print("Removing plane anchor")
//        node.enumerateChildNodes { (childNode, _) in
//            childNode.removeFromParentNode()
//        }
//    }
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        // Present an error message to the user
//
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay
//
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        // Reset tracking and/or remove existing anchors if consistent tracking is required
//
//    }
//}
