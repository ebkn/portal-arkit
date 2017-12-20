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
  @IBOutlet weak var firstPlaceButton: UIButton!
  @IBOutlet weak var secondPlaceButton: UIButton!
  @IBOutlet weak var thirdPlaceButton: UIButton!
  var placeSelected: Int = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // debug screen
    // self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    self.configuration.planeDetection = .horizontal
    self.sceneView.session.run(configuration)
    self.sceneView.delegate = self
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    
    firstPlaceButton.isSelected = true
    secondPlaceButton.backgroundColor = UIColor.clear
    thirdPlaceButton.backgroundColor = UIColor.clear
  }
  
  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    guard let sceneView = sender.view as? ARSCNView else {return}
    let touchLocation = sender.location(in: sceneView)
    let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
    if !hitTestResult.isEmpty {
      addPortal(hitTestResult: hitTestResult.first!)
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
    switch self.placeSelected {
    case 1:
      addWalls(portalNode: portalNode!, imageFolderName: "SanFrancisco4")
    case 2:
      addWalls(portalNode: portalNode!, imageFolderName: "Areskutan")
    case 3:
      addWalls(portalNode: portalNode!, imageFolderName: "Yokohama")
    default:
      addWalls(portalNode: portalNode!, imageFolderName: "SanFrancisco4")
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else {return}
    DispatchQueue.main.async {
      print("portal has not been visible")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      print("portal becomes visible")
    }
  }
  
  func addWalls(portalNode: SCNNode, imageFolderName: String) {
    self.addWall(nodeName: "roof", portalNode: portalNode, imageName: "\(imageFolderName)/posy")
    self.addWall(nodeName: "floor", portalNode: portalNode, imageName: "\(imageFolderName)/negy")
    self.addWall(nodeName: "backWall", portalNode: portalNode, imageName: "\(imageFolderName)/posz")
    self.addWall(nodeName: "sideWallA", portalNode: portalNode, imageName: "\(imageFolderName)/posx")
    self.addWall(nodeName: "sideWallB", portalNode: portalNode, imageName: "\(imageFolderName)/negx")
    self.addWall(nodeName: "sideDoorA", portalNode: portalNode, imageName: "\(imageFolderName)/negz")
    self.addWall(nodeName: "sideDoorB", portalNode: portalNode, imageName: "\(imageFolderName)/negz")
  }
  
  func addWall(nodeName: String, portalNode: SCNNode, imageName: String) {
    let child = portalNode.childNode(withName: nodeName, recursively: true)
    child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Portal.scnassets/\(imageName).jpg")
    child?.renderingOrder = 200
    if let mask = child?.childNode(withName: "mask", recursively: false) {
      mask.geometry?.firstMaterial?.transparency = 0.000001
    }
  }
  
  
  @IBAction func firstPlaceButtonTapped(_ sender: Any) {
    self.placeSelected = 1
    firstPlaceButton.isSelected = true
    secondPlaceButton.isSelected = false
    thirdPlaceButton.isSelected = false
    secondPlaceButton.backgroundColor = UIColor.clear
    thirdPlaceButton.backgroundColor = UIColor.clear
  }
  
  @IBAction func secondPlaceButtonTapped(_ sender: Any) {
    self.placeSelected = 2
    firstPlaceButton.isSelected = false
    secondPlaceButton.isSelected = true
    thirdPlaceButton.isSelected = false
    firstPlaceButton.backgroundColor = UIColor.clear
    thirdPlaceButton.backgroundColor = UIColor.clear
  }
  
  @IBAction func thirdPlaceButtonTapped(_ sender: Any) {
    self.placeSelected = 3
    firstPlaceButton.isSelected = false
    secondPlaceButton.isSelected = false
    thirdPlaceButton.isSelected = true
    firstPlaceButton.backgroundColor = UIColor.clear
    secondPlaceButton.backgroundColor = UIColor.clear
  }
}
