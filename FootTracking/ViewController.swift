//
//  ViewController.swift
//  FootTracking
//
//  Created by Yang on 2020/07/07.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import UIKit
import CoreML
import ARKit
import Vision

class ViewController: UIViewController, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var currentBuffer: CVPixelBuffer?
    var previewView = UIImageView()
    
    let footDetector = FootDetector()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.delegate = self
        
        sceneView.session.run(configuration)
        
        view.addSubview(previewView)
        
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
            return
        }
        
        currentBuffer = frame.capturedImage
        
        startDetection()
    }
    
    private func startDetection() {
        guard let buffer = currentBuffer else { return }
        
        footDetector.performDetection(inputBuffer: buffer) { outputBuffer, _ in
            var previewImage: UIImage?
            
            defer {
                DispatchQueue.main.async {
                    self.previewView.image = previewImage
                    self.currentBuffer = nil
                }
            }
            
            guard let outBuffer = outputBuffer else {
                return
            }
            
            previewImage = UIImage(ciImage: CIImage(cvPixelBuffer: outBuffer))
        }
        
    }
}

