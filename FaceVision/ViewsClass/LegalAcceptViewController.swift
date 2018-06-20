//
//  LegalAcceptViewController.swift
//  FaceVision
//
//  Created by louis on 14/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import UIKit
import Foundation

class LegalAcceptViewController: UIViewController{
    
    @IBOutlet weak var acceptButtonOutlet: UIButton!
    @IBOutlet weak var denyButtonOutlet: UIButton!
    
    let isTermsAccepted = UserDefaults.standard.bool(forKey: "isTermsAccepted")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add background parameters
        addBackgroundImage(name: "termsback.png")
        
        //Set buttons radius corners
        acceptButtonOutlet.layer.cornerRadius = 7
        acceptButtonOutlet.layer.borderWidth = 2
        denyButtonOutlet.layer.cornerRadius = 7
        denyButtonOutlet.layer.borderWidth = 2
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addBackgroundImage(name: String){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: name)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isTermsAccepted == true{
            performSegue(withIdentifier: "showPrincipalMenuSegue", sender: self)
        }
    }
    
    func acceptTermsPopupValidation(){
        let acceptTermsP = UIAlertController(title: "Conditions générales d'utilisation", message: "Êtes-vous sur de vouloir accepter les conditions générales d'utilisation ? Si vous acceptez vous admettez être d'accord avec nos conditions générales d'utilisation.", preferredStyle: .alert)
        acceptTermsP.addAction(UIAlertAction(title: "J'accepte et je continue", style: .cancel, handler: { (UIAlertAction) in
            UserDefaults.standard.set(true, forKey: "isTermsAccepted")
            self.performSegue(withIdentifier: "showPrincipalMenuSegue", sender: self)
        }))
        self.present(acceptTermsP, animated: true)
    }
    
    func denyTermsPopupValidation(){
        let denyTermsP = UIAlertController(title: "Conditions générales d'utilisation", message: "Êtes-vous sur de vouloir refuser les conditions générales d'utilisation ? Si vous les refusez, vous serez ejecté de l'application jusqu'à validation.", preferredStyle: .alert)
        denyTermsP.addAction(UIAlertAction(title: "Je refuse et je quitte l'application", style: .cancel, handler: { (UIAlertAction) in
            Foundation.exit(-1)
        }))
        self.present(denyTermsP, animated: true)
    }
    
    @IBAction func denyTermsButton(_ sender: UIButton) {
        self.denyTermsPopupValidation()
        
    }
    //Buttons funcs
    @IBAction func acceptTermsButton(_ sender: UIButton) {
        self.acceptTermsPopupValidation()
    }
}
