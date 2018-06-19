//
//  LegalAcceptViewController.swift
//  FaceVision
//
//  Created by louis on 14/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import UIKit

class LegalAcceptViewController: UIViewController{
    
    let isTermsAccepted = UserDefaults.standard.bool(forKey: "isTermsAccepted")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //Buttons funcs
    @IBAction func acceptTermsButton(_ sender: UIButton) {
        self.acceptTermsPopupValidation()
    }
}
