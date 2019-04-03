//
//  ViewController.swift
//  ML_APP
//
//  Created by IOSLevel-01 on 01/04/19.
//  Copyright © 2019 sjbit. All rights reserved.
//

import UIKit
import Vision
import CoreML
import AVFoundation

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVSpeechSynthesizerDelegate
{
    
    //Outlets declared for image and the output labels
    @IBOutlet weak var imageToBeClassified: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var confidence: UILabel!
    
    let cameraController = UIImagePickerController()
    var speechSynthesizer = AVSpeechSynthesizer()
    
    let resnet = Resnet50()
    var imagePicker = UIImagePickerController()
    
    //action declared for camera access
    @IBAction func Camera_access(_ sender: UIBarButtonItem)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: false, completion: nil)
            
            
        }
        else
        {
            let ac = UIAlertController(title:"alert", message:"camera not supported", preferredStyle:.alert)
            ac.addAction(UIAlertAction(title:"ok", style: .default, handler: nil))
            present(ac, animated: false, completion: nil)
            
        }
    }
    
    //action declaration for folder access
    @IBAction func Folder_access(_ sender: Any)
    {
        cameraController.sourceType = .photoLibrary
        cameraController.delegate = self
        self.present(cameraController, animated:false,completion: nil)
    }
    
    //kinda like main function
    override func viewDidLoad()
    {
        super.viewDidLoad()
        speechSynthesizer.delegate = self
        imagePicker.delegate = self
        
        if let imageSample = imageToBeClassified.image
        {
            process(inputImage:imageSample)
        }
    }
    
   //actual ML application for app,implemented using Resnet50 mlmodel
    func process(inputImage:UIImage)
    {
        if let model = try? VNCoreMLModel(for: self.resnet.model)
        {
            let request = VNCoreMLRequest(model: model) {(request, error) in
                if let resultArray = request.results as?
                    [VNClassificationObservation]
                {
                    for eachResult in resultArray{
                        print("UUID: \(eachResult.uuid)")
                        print("ID: \(eachResult.identifier) Confidence: \(eachResult.confidence)")
                    }
                
                self.descriptionLabel.text = resultArray.first?.identifier
                if let confidence = resultArray.first?.confidence
                {
                    self.confidence.text = String(confidence * 100)
                    let spokenText = "this looks like a \(self.descriptionLabel.text) and am(self.confidence.text) % sure"
                    self.synthesizeSpeech(fromString: spokenText)
                }
                self.confidence.text = String(Float((resultArray.first?.confidence)!))
             }
            print(error?.localizedDescription)
         }
        if let imageData = inputImage.pngData(){
            let handler = VNImageRequestHandler(data: imageData,options: [:])
            try? handler.perform([request])
        }
    }
}
    
    //function to select image from the gallery
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController,didFinishMediaWithInfo info: [UIImagePickerController.InfoKey:Any ])
    {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage]
              as? UIImage
        {
            self.imageToBeClassified.image = selectedImage
            process(inputImage: selectedImage)
        }
        picker.dismiss(animated: false, completion: nil)
    }
    
    
    //function to synthesise speech from app
    func synthesizeSpeech(fromString:String)
    {
        let speechUtterance = AVSpeechUtterance(string: fromString)
        speechSynthesizer.speak(speechUtterance)
        
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.imageToBeClassified.isUserInteractionEnabled = true
    }
}
