//
//  ViewController.swift
//  portal_arkit
//
//  Created by Ebinuma Kenichi on 2017/12/10.
//  Copyright © 2017年 kenichi ebinuma. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
  @IBOutlet weak var sceneView: ARSCNView!
  let configuration = ARWorldTrackingConfiguration()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    self.sceneView.session.run(configuration)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}
