//
//  FeedbackViewController.swift
//  FaceVision
//
//  Created by louis on 26/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class FeedbackViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var sendbymailButton: UIButton!
    @IBOutlet weak var sendbydatabaseButton: UIButton!
    @IBOutlet weak var textField: UITextView!
    
    let appBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    @IBOutlet var viewOutlet: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage(name: "backgroundnoblur")
        
        self.hideKeyboardWhenTappedAround()
        
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
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            let textString:String = textField.text
            mail.mailComposeDelegate = self
            mail.setToRecipients(["feedback@facevision.be"])
            mail.setSubject("Feedback FaceVision V1.0B \(appBuildNumber)")
            mail.setMessageBody("<b>- Feedback FaceVision V1.0B \(appBuildNumber) -</b> \n\n \(textString)", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            mailFailure()
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
            mailSent()
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
            mailFailure()
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendbugbyMail(_ sender: UIButton) {
        if textField.text == ""{
            displaywhenEmpty()
        }else{
         sendEmail()
        }
    }
    
    func mailSent(){
        let alert = UIAlertController(title: "Mail envoyé avec succés !", message: "Votre mail a bien été envoyé, nous vous remercions de votre aide et nous vous recontaterons très prochainement !", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func mailFailure(){
        let alert = UIAlertController(title: "Echec de l'envoi du mail !", message: "Votre mail n'a pas pu être envoyé pour l'instant, veuillez réessayer ultérieurement...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func displaywhenEmpty(){
        let alert = UIAlertController(title: "Erreur", message: "Une erreur est survenue, vous ne pouvez pas envoyer de bug sans l'avoir détaillé...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func sendbyDatabaseButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Bientôt...", message: "Cette fonctionnalité est en cours de développement elle sera bientôt disponible... Soyez patient...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
