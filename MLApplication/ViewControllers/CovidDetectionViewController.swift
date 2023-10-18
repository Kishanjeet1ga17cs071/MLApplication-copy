//
//  CovidDetectionViewController.swift
//  MLApplication
//
//  Created by Kishanjeet, Kishanjeet on 19/10/23.
//

import UIKit
import CoreML
class CovidDetectionViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate  {
    @IBOutlet var headerLabel: UILabel!
    
    @IBOutlet var imageCovidReport: UIImageView!
    @IBOutlet var predictedValueLabel: UILabel!
    @IBOutlet var predictedSecondValueLabel: UILabel!
    @IBOutlet var predictedThirdValueLabel: UILabel!
    var model:CovidReportClassifier!
    override func viewDidLoad() {
        super.viewDidLoad()
        predictedValueLabel.isHidden = true
        predictedSecondValueLabel.isHidden = true
        predictedThirdValueLabel.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        model = CovidReportClassifier()
    }
    
    @IBAction func selectFile(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
       // indicatorActivity.isHidden = false
            //  indicatorActivity.startAnimating()
        predictedValueLabel.isHidden = false
        predictedSecondValueLabel.isHidden = false
        predictedThirdValueLabel.isHidden = false
        predictedValueLabel.text = "Analyzing Image..."
        guard let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage") ] as? UIImage else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 224, height: 224), true, 2.0)
        // UIGraphicsBeginImageContextWithOptions(CGSize(width: 299, height: 299), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 224, height: 224))
        //image.draw(in: CGRect(x: 0, y: 0, width: 299, height: 299))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        imageCovidReport.image = newImage
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        print(prediction.classLabelProbs)
//        switch(prediction.classLabel){
//        case "Covid":
//            predictedValueLabel.text = "\(prediction.classLabel) Detected."
//        case "Viral Pneumonia":
//            predictedValueLabel.text = "\(prediction.classLabel) Detected."
//              
//        default:
//            predictedValueLabel.text = "\(prediction.classLabel)."
//        }
        var i = 0
        
        
        
        
        predictedValueLabel.text = "Normal" + " =   " + (prediction.classLabelProbs["Normal"]! * 100).description + " %"
        
        predictedSecondValueLabel.text = "Covid" + " =   " + (prediction.classLabelProbs["Covid"]! * 100).description + " %"
        
        predictedThirdValueLabel.text = "Viral Pneumonia" + " =   " + (prediction.classLabelProbs["Viral Pneumonia"]! * 100).description + " %"
        
    }
    

}
