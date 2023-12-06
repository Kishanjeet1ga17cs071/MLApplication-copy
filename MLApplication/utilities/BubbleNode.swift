//
//  BubbleNode.swift
//  MLApplication
//
//  Created by Kishanjeet, Kishanjeet on 30/10/23.
//

import SceneKit
import ARKit
class BubbleNode: SCNNode {
    static let name = String(describing: BubbleNode.self)
    
    let bubbleDepth: CGFloat = 0.1
    let hiddenGeometry = SCNSphere(radius: 0.15)
    let k : String = "checking"
    init(text: String) {
        super.init()
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        
        // BUBBLE-TEXT
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
        let font = UIFont(name: "Futura", size: 0.15)
        bubble.font = font
        bubble.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        bubble.firstMaterial?.diffuse.contents = UIColor.orange
        bubble.firstMaterial?.specular.contents = UIColor.white
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "TestImage")
//        bubble.materials = [material]
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness // setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(bubbleDepth)
        
        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation((maxBound.x - minBound.x) / 2,
                                                     minBound.y,
                                                     Float(bubbleDepth) / 2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
        
        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        let sphereNode = SCNNode(geometry: sphere)
      ////
        
        
        let searchNode = SCNNode(geometry: hiddenGeometry)
        searchNode.name = Self.name
        searchNode.eulerAngles.x = -90
        searchNode.geometry?.materials.first?.transparency = 0
        
        // BOX NODE
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
   
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: text)
        box.materials = [material]
        let boxNode = SCNNode(geometry: box)
        
       
        var cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 15, y: 15, z: 30)
        
        
        
        
        let ballScene = SCNScene(named: "converse_obj.scn")
        ballScene?.accessibilityFrame.size = CGSize(width: 0.02, height: 0.02)
        var ballNode = SCNNode()
       // ballNode.position = SCNVector3(x: 0, y: 0, z: 0)
        ballNode.scale = SCNVector3(0.05, 0.05, 0.05)
        
        
        ballNode = ballScene!.rootNode
       
        
        
        // BUBBLE PARENT NODE
        addChildNode(bubbleNode)
        addChildNode(sphereNode)
        addChildNode(searchNode)
        
        //
       // addChildNode(boxNode)
        addChildNode(cameraNode)
        addChildNode(ballNode)
      
        
        
        bubbleNode.constraints = [billboardConstraint]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
