///
///  RootViewController.swift
///  AR_StarterTemplate
///
///  Created by Eric M. Baumel on 8/17/18.
///  Copyright © 2018 Softcode Systems, LLC. All rights reserved.
///

import UIKit
import SceneKit
import ARKit

class RootViewController: UIViewController {
  
  // MARK: - Properties
  
  var trackingStatus: String = ""
  
  // MARK: - Outlets
  
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var startButton: UIButton!
  
  // MARK: - Actions
  @IBAction func startButtonPressed(_ sender: Any) {
    print("Start Button Pressed.")
  }
  
  // MARK: - View Management
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initSceneView()
    initScene()
    configureARSession()
    statusLabel.text = NSLocalizedString("Starting App!", comment: "")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    print("DidReceiveMemoryWarning()")
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  // MARK: - Initialization
  
  func initSceneView() {
    // Set the view's delegate
    sceneView.delegate = self
    // Show statistics such as fps and timing information
    sceneView.showsStatistics = true
    // Debug options - Remove for Production
    sceneView.debugOptions = [
      ARSCNDebugOptions.showFeaturePoints,
      ARSCNDebugOptions.showWorldOrigin,
      ARSCNDebugOptions.showBoundingBoxes,
      ARSCNDebugOptions.showWireframe
    ]
  }
  
  func initScene() {
    
  }
  
  func configureARSession() {
    guard ARWorldTrackingConfiguration.isSupported else {
      print("ARKit is not available on this device.")
      return
    }
    
    let configuration = ARWorldTrackingConfiguration()
    configuration.worldAlignment = .gravity // or .gravityAndHeading
    configuration.providesAudioData = false
    // configuration.isLightEstimationEnabled = true
    sceneView.session.run(configuration)
  }
  
}

// MARK: - ARSCNViewDelegate

extension RootViewController: ARSCNViewDelegate {
  
  // MARK: - Scene Kit Management
  
  // MARK: - Session State Management
  
  func session(_ session: ARSession,
               cameraDidChangeTrackingState camera: ARCamera) {
    switch camera.trackingState {
      case .notAvailable:
        trackingStatus = NSLocalizedString("Tracking: Not available!", comment: "")
      case .normal:
        trackingStatus = NSLocalizedString("Tracking Normally!", comment: "")
      case .limited(let reason):
        switch reason {
          case .excessiveMotion:
            trackingStatus = NSLocalizedString("Tracking: Limited due to insufficient motion!", comment: "")
          case .insufficientFeatures:
            trackingStatus = NSLocalizedString("Tracking: Limited due to insufficent features!", comment: "")
          case .initializing:
            trackingStatus = NSLocalizedString("Tracking: Initializing...", comment: "")
          case .relocalizing:
            trackingStatus = NSLocalizedString("Tracking: Relocalizing...", comment: "")
      }
    }
  }
  
  // MARK: - Session Error Management
  
  func session(_ session: ARSession, didFailWithError error: Error) {
    // Present an error message to the user
    trackingStatus = NSLocalizedString("AR Session Failed: \(error.localizedDescription)", comment: "")
    // resetTracking()
  }
  
  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay
    trackingStatus = NSLocalizedString("AR Session Was Interrupted!", comment: "")
  }
  
  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required
    trackingStatus = NSLocalizedString("AR Session Interruption Ended", comment: "")
    // resetTracking()
  }
  
  // MARK: - Plane Management
  

  /*
   // Override to create and configure nodes for anchors added to the view's session.
   func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
   let node = SCNNode()
   
   return node
   }
   */

  
}
