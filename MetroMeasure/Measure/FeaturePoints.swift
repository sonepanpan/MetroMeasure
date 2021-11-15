////
////  FeaturePoints.swift
////  MetroMeasure
////
////  Created by 潘婷蓁 on 2021/11/14.
////
//
//import UIKit
//import ARKit
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var sceneView: ARSCNView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        addBox()
//        addTapGestureToSceneView()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let configuration = ARWorldTrackingConfiguration()
//        sceneView.session.run(configuration)
//    }
//
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        sceneView.session.pause()
//    }
//
//    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
//
//        let boxNode = SCNNode()
//        boxNode.geometry = box
//        boxNode.position = SCNVector3(x, y, z)
//
//        sceneView.scene.rootNode.addChildNode(boxNode)
//    }
//
//    func addTapGestureToSceneView() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
//        sceneView.addGestureRecognizer(tapGestureRecognizer)
//    }
//
//    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
//        let tapLocation = recognizer.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(tapLocation)
//
//        guard let node = hitTestResults.first?.node else {
//            let point = CGPoint(x: 20, y:20)
//            let hitTestResultsWithFeaturePoints = sceneView.raycastQuery(from: point, allowing: .estimatedPlane, alignment: .any)
//            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
//                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
//                addBox(x: translation.x, y: translation.y, z: translation.z)
//            }
//
//            return
//        }
//
//        node.removeFromParentNode()
//    }
//}
//
//extension float4x4 {
//    var translation: SIMD3<Float> {
//        let translation = self.columns.3
//        return SIMD3<Float>(translation.x, translation.y, translation.z)
//    }
//}
//
