//
//  SpotLightNode.swift
//  FootTracking
//
//  Created by Yang on 2020/07/07.
//  Copyright © 2020 Minestrone. All rights reserved.
//

import SceneKit

public class SpotLightNode: SCNNode {
    
    public override init() {
        super.init()
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let spotLight = SCNLight()
        
        spotLight.type = .directional
        spotLight.shadowMode = .deferred
        spotLight.castsShadow = true
        spotLight.shadowRadius = 100.0
        spotLight.shadowColor = UIColor(red: 0, green: 0, blue: 0,alpha: 0.2)
        
        light = spotLight
        
        eulerAngles = SCNVector3(-Float.pi / 2, 0, 0)
    }
}
