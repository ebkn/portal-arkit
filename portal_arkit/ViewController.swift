//
//  ViewController.swift
//  portal_arkit
//
//  Created by Ebinuma Kenichi on 2017/12/10.
//  Copyright © 2017年 kenichi ebinuma. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
  @IBOutlet weak var sceneView: ARSCNView!
  let configuration = ARWorldTrackingConfiguration()
  @IBOutlet weak var planeDetected: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    self.configuration.planeDetection = .horizontal
    self.sceneView.session.run(configuration)
    self.sceneView.delegate = self
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    guard let sceneView = sender.view as? ARSCNView else {return}
    let touchLocation = sender.location(in: sceneView)
    let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
    if !hitTestResult.isEmpty {
      addPortal(hitTestResult: hitTestResult.first!)
    } else {
      
    }
  }
  
  func addPortal(hitTestResult: ARHitTestResult) {
    let portalScene = SCNScene(named: "Portal.scnassets/Portal.scn")
    let portalNode = portalScene?.rootNode.childNode(withName: "Portal", recursively: false)
    let transform = hitTestResult.worldTransform
    let planeXposition = transform.columns.3.x
    let planeYposition = transform.columns.3.y
    let planeZposition = transform.columns.3.z
    portalNode?.position = SCNVector3(planeXposition, planeYposition, planeZposition)
    self.sceneView.scene.rootNode.addChildNode(portalNode!)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else {return}
    DispatchQueue.main.async {
      self.planeDetected.isHidden = false
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      self.planeDetected.isHidden = true
    }
  }
}
