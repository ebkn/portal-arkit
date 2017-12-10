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
