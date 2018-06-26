//
//  FeedbackViewController.swift
//  FaceVision
//
//  Created by louis on 26/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import Foundation
import UIKit

class FeedbackViewController: UIViewController{
    
    @IBOutlet weak var sendbymailButton: UIButton!
    @IBOutlet weak var sendbydatabaseButton: UIButton!
    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet var viewOutlet: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage(name: "backgroundnoblur")
        
        sendbymailButton.layer.cornerRadius = 7
        sendbymailButton.layer.borderWidth = 2
        sendbydatabaseButton.layer.cornerRadius = 7
        sendbydatabaseButton.layer.borderWidth = 2
    }
    
    func addBackgroundImage(name: String){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: name)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendbyDatabaseButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Bientôt...", message: "Cette fonctionnalité est en cours de développement elle sera bientôt disponible... Soyez patient...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
