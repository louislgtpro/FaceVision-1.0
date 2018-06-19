//
//  ImageViewController.swift
//  FaceVision
//
//  Created by Louis Legout.
//  Copyright © 2018 Legout Louis. All rights reserved.
//

import UIKit
import Vision

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var image: UIImage!
    var firstview: UIView!
    var countdownTimer: Timer!
    var totalTime = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InitializeLoading()
        addBackgroundImage(name: "backgroundimagecontroller.png")
        imageView.image = image
        
        closeButton.layer.cornerRadius = 7
        closeButton.layer.borderWidth = 2
        startButton.layer.cornerRadius = 7
        startButton.layer.borderWidth = 2
    }
    
    func addBackgroundImage(name: String){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: name)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    @IBAction func StartLoading(_ sender: Any){
        StartLoadingIndicator()
    }
    
    @IBAction func StopLoading(_ sender: Any){
        StopLoadingIndicator()
    }
    
    func StartLoadingIndicator(){
        self.view.addSubview(firstview)
    }
    
    func StopLoadingIndicator(){
        self.firstview.removeFromSuperview()
    }
    
    func InitializeLoading(){
        firstview = UIView(frame: CGRect(x: 0, y:0, width: 250, height: 50))
        firstview.backgroundColor = UIColor.white
        firstview.layer.cornerRadius = 10
        
        let wait = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width: 50, height: 50))
        wait.color = UIColor.black
        wait.hidesWhenStopped = false
        wait.startAnimating()
        
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        text.text = "Veuillez patienter..."
        
        firstview.addSubview(wait)
        firstview.addSubview(text)
        firstview.center = self.view.center
        firstview.tag = 1000
    }
    
    @IBAction func process(_ sender: UIButton){
        var orientation:Int32 = 0
        
        switch image.imageOrientation {
        case .up:
            orientation = 1
        case .right:
            orientation = 6
        case .down:
            orientation = 3
        case .left:
            orientation = 8
        default:
            orientation = 1
        }
        
        if image.imageOrientation.rawValue == 0{
            let alert = UIAlertController(title: "Erreur", message: "Une erreur est survenue, seul les visages sont compatibles et reconnaissables par FaceVision, ne vous inquiétez pas on travaille sur d'autres possibilités...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        // vision
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceFeatures)
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: CGImagePropertyOrientation(rawValue: UInt32(orientation))! ,options: [:])
        
        do {
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            let alert = UIAlertController(title: "Erreur", message: "Une erreur est survenue, seul les visages sont compatibles et reconnaissables par FaceVision, ne vous inquiétez pas on travaille sur d'autres possibilités...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            print(error, "An error occured")
        }
    }
    
    func handleFaceFeatures(request: VNRequest, errror: Error?) {
        guard let observations = request.results as? [VNFaceObservation]else{
            let alert = UIAlertController(title: "Erreur", message: "Une erreur est survenue, seul les visages sont compatibles et reconnaissables par FaceVision, ne vous inquiétez pas on travaille sur d'autres possibilités...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            fatalError("unexpected result type!")
        }
        
        for face in observations {
            addFaceLandmarksToImage(face)
        }
    }
    
    func addFaceLandmarksToImage(_ face: VNFaceObservation) {
        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        // draw the image
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // draw the face rect
        let w = face.boundingBox.size.width * image.size.width
        let h = face.boundingBox.size.height * image.size.height
        let x = face.boundingBox.origin.x * image.size.width
        let y = face.boundingBox.origin.y * image.size.height
        let faceRect = CGRect(x: x, y: y, width: w, height: h)
        context?.saveGState()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(6.0)
        context?.addRect(faceRect)
        context?.drawPath(using: .stroke)
        context?.restoreGState()
        
        // face contour
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.faceContour {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // outer lips
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.outerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // inner lips
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.innerLips {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // left eye
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // right eye
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEye {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // left pupil
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // right pupil
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightPupil {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // left eyebrow
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.leftEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // right eyebrow
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.rightEyebrow {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // nose
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.nose {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.closePath()
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // nose crest
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.noseCrest {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        // median line
        context?.saveGState()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        if let landmark = face.landmarks?.medianLine {
            for i in 0...landmark.pointCount - 1 { // last point is 0,0
                let point = landmark.normalizedPoints[i]
                if i == 0 {
                    context?.move(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                } else {
                    context?.addLine(to: CGPoint(x: x + CGFloat(point.x) * w, y: y + CGFloat(point.y) * h))
                }
            }
        }
        context?.setLineWidth(8.0)
        context?.drawPath(using: .stroke)
        context?.saveGState()
        
        
        
        // get the final image
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = finalImage
        
    }
}
