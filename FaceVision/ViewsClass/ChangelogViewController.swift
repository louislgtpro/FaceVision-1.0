//
//  ChangelogViewController.swift
//  FaceVision
//
//  Created by Louis on 05/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import UIKit
import SystemConfiguration

class ChangelogViewController: UIViewController{
    
    @IBOutlet var firstView: UIView!
    @IBOutlet weak var backActionButton: UIButton!
    @IBOutlet weak var legalTermsButton: UIButton!
    @IBOutlet weak var changeLogButton: UIButton!
    @IBOutlet weak var majButton: UIButton!
    
    var CHANGELOG_ACTUAL = "- Amélioration des performances et corrections de bugs\n- Correction du problème des popups qui réaparraissait lors du premier démarrage\n- Amélioration légère du design intérieur"
    
    private var appVersionBundle = 13
    private var neededCountUpdate = 1
    private var secondsUpdate = 5
    
    let appBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ChangelogViewController has been loaded")
        addBackgroundImage(name: "backgroundphoto1.png")
        
        changeLogButton.layer.cornerRadius = 7
        changeLogButton.layer.borderWidth = 2
        legalTermsButton.layer.cornerRadius = 7
        legalTermsButton.layer.borderWidth = 2
        majButton.layer.cornerRadius = 7
        majButton.layer.borderWidth = 2

    }
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
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
    
    @IBAction func legalButton(_ sender: UIButton) {
        performSegue(withIdentifier: "legalPerformSegue", sender: self)
    }
    
    @IBAction func backActionButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backButtonSegue", sender: self)
    }
    
    @IBAction func majButtonAction(_ sender: UIButton) {
        let appBuildNumberInt: Int! = Int(self.appBuildNumber)
        if isConnectedToNetwork() == true{
            if appBuildNumberInt != appVersionBundle{
                let majPopup = UIAlertController(title: "Une mise à jour est disponible !", message: "Une mise à jour de l'application est disponible, voulez-vous la lancer maintenant ?\n\nVersion de la MAJ : 1.0B\(appBuildNumber)\nChangements : ", preferredStyle: .alert)
                majPopup.addAction(UIAlertAction(title: "Oui", style: .cancel, handler: { (UIAlertAction) in
                    
                }))
                self.present(majPopup, animated: true)
            }else{
                let noMajAvailable = UIAlertController(title: "Aucune mise à jour disponible", message: "Aucune mise à jour disponible n'a été trouvée, vous disposez actuellement de la dernière version disponible à ce jour (Version : 1.0B\(appBuildNumber)). Malgré tout, si vous êtes persuadé que une mise à jour est disponible plusieurs facteurs peuvent être raisons de cette erreur : \n\n- Assurez-vous d'être connecté à internet \n- Assurez-vous de toujours faire partie du programme bêta de FaceVision\n- Assurez-vous d'avoir la Bêta 10 installée au minimum\n\n Si l'erreur persiste après toute les vérifications ci-dessus, merci de nous contacter à problems@facevision.be", preferredStyle: .alert)
                noMajAvailable.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(noMajAvailable, animated: true)
            }
        }else{
            let noInternetConnection = UIAlertController(title: "Aucune connexion à internet", message: "Vous devez être connecté à internet afin de pouvoir lancer une recherche de mise à jour, merci de réessayer quand vous serez connecté à internet (2G, 3G, 4G (LTE), WiFi)", preferredStyle: .alert)
            noInternetConnection.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noInternetConnection, animated: true)
        }
    }
    
    func noInternetConnectionPopupChangelog(){
        let noInternetConnection = UIAlertController(title: "Aucune connexion à internet", message: "Vous devez être connecté à internet afin de pouvoir accéder au Changelog des versions et des Build. Merci de réessayer quand vous serez connecté à internet (2G, 3G, 4G (LTE), WiFi)", preferredStyle: .alert)
        noInternetConnection.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(noInternetConnection, animated: true)
    }
    
    func changeLogP(number: Int){
        if number == 0{
            self.changeLogBuildActual()
        }
        
        if number == 1{
            let changeLog1P = UIAlertController(title: "CHANGELOG V1.0 Build 1", message: "- Modifications et nouveautés -\n\n- Première version déployée", preferredStyle: .alert)
            changeLog1P.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(changeLog1P, animated: true)
        }
        
        if number == 2{
            let changeLog2P = UIAlertController(title: "CHANGELOG V1.0 Build 2", message: "- Modifications et nouveautés -\n\n-Amélioration des performances\n- Amélioration de la stabilité et correction de bugs\n- Ajout de la fonction réglages", preferredStyle: .alert)
            changeLog2P.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(changeLog2P, animated: true)
        }
        
        if number == 3{
            let changeLog3P = UIAlertController(title: "CHANGELOG V1.0 Build 3", message: "- Modifications et nouveautés -\n\n- Amélioration de la stabilité de manière générale\n- Correction de bugs mineurs\n- L'option de réglages a été supprimée et reviendra ultérieurement", preferredStyle: .alert)
            changeLog3P.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(changeLog3P, animated: true)
        }
        
        if number == 4{
            let changeLog4P = UIAlertController(title: "CHANGELOG V1.0 Build 4", message: "- Modifications et nouveautés -\n\n- Ajout d'un système de clé bêta afin d'accéder à l'application\n- Ajout de nombreux popups de préventions\n- Ajout du support de la Mise à jour à distance\n- Amélioration de stabilité et correction de bugs mineurs\n", preferredStyle: .alert)
            changeLog4P.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(changeLog4P, animated: true)
        }
    }
    
    func errorBuildNumber(){
        let errorBuildNumberP = UIAlertController(title: "Build number incorrect", message: "Le build number que vous avez entré n'est pas conforme ou n'est pas correct, assurez-vous d'avoir :\n\n- Choisi un nombre décimal\n- Choisi un nombre positif non nul\n- Choisi un nombre sans virgule ni caractères spéciaux", preferredStyle: .alert)
        errorBuildNumberP.addAction(UIAlertAction(title: "Réessayer", style: .cancel, handler: { (UIAlertAction) in
            self.changelogPopup()
        }))
        self.present(errorBuildNumberP, animated: true)
    }
    
    func changeLogBuildActual(){
        let changeLogActual = UIAlertController(title: "CHANGELOG V1.0 Build \(appBuildNumber)", message: "- Modifications et nouveautés -\n\n \(CHANGELOG_ACTUAL)", preferredStyle: .alert)
        changeLogActual.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(changeLogActual, animated: true)
    }
    
    func changelogPopup(){
        let changeLog1 = UIAlertController(title: "CHANGELOG", message: "Veuillez choisir la version pour laquelle vous souhaitez voir le changelog (0 = Changelog du build ou de la version actuelle)", preferredStyle: .alert)
        changeLog1.addAction(UIAlertAction (title: "Continuer", style: .default, handler: { (UIAlertAction) in
            
            let field = changeLog1.textFields?[0] as! UITextField
            let textfieldInt: Int! = Int(field.text!)
            let appBuildNumberInt: Int! = Int(self.appBuildNumber)
            
            if self.isConnectedToNetwork() == true{
                if (textfieldInt <= appBuildNumberInt && textfieldInt >= 0){
                    self.changeLogP(number: textfieldInt)
                }else{
                    self.errorBuildNumber()
                }
            }else{
                self.noInternetConnectionPopupChangelog()
            }
        }))
        
        changeLog1.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        changeLog1.addTextField { (textField) in
            textField.placeholder = "Numéro de Build de la version"
            changeLog1.textFields![0].keyboardType = UIKeyboardType.numberPad
        }
        self.present(changeLog1, animated: true, completion: nil)
    }
    
    @IBAction func changeLog1(_ sender: UIButton) {
        self.changelogPopup()
    }
    
}
