//
//  ViewController.swift
//  FaceVision
//
//  Created by Louis Legout.
//  Copyright © 2018 Legout Louis. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var firstView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var versionText: UITextView!
    @IBOutlet weak var settingsPlusButton: UIButton!
    @IBOutlet weak var moreInformationPlusButton: UIButton!
    @IBOutlet weak var textVersionView: UITextView!
    @IBOutlet weak var textFaceVision: UILabel!
    
    var image: UIImage!
    
    private var askUpdate = false
    private var countUpdateNeeded  = 2
    private var appBuildNumberLocal = 13
    private var checkIfTapNoUpdate = false
    private var CHANGELOG_UPDATE = "- Amélioration des performances et corrections de bugs\n- Correction du problème des popups qui réaparraissait lors du premier démarrage\n- Amélioration légère du design intérieur"
    
    let isBetaKeyCorrect = UserDefaults.standard.bool(forKey: "isBetaKeyCorrect")
    let majUpdateCorrectly = UserDefaults.standard.bool(forKey: "majUpdateCorrectly")
    let appBuildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    override func viewDidLoad() {
        //Background image loader
        textVersionView.text = "Version : 1.0B \(appBuildNumber)"
        
        takePhotoButton.layer.cornerRadius = 7
        takePhotoButton.layer.borderWidth = 2
        moreInformationPlusButton.layer.cornerRadius = 7
        moreInformationPlusButton.layer.borderWidth = 2
        settingsPlusButton.layer.cornerRadius = 7
        settingsPlusButton.layer.borderWidth = 2
        
        //------------------------------------------------------
        //Colors
        let stringValue = "FaceVision"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "Face", withColor: UIColor.white)
        attributedString.setColorForText(textForAttribute: "Vision", withColor: UIColor.green)
        textFaceVision.font = UIFont.boldSystemFont(ofSize: 40)
        textFaceVision.attributedText = attributedString
        //------------------------------------------------------
        
        addBackgroundImage(name: "background1.png")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callBackForActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callBackForBackgroundNotification), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Checks vars
        print (isBetaKeyCorrect)
        print("Version of the App : 1.0B ", appBuildNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isBetaKeyCorrect == false{
            if isConnectedToNetwork() == true{
                self.alertStart()
            }else{
                self.noInternetConnectionPopup()
            }
        }
        if isConnectedToNetwork() == false{
            self.noInternetConnectionAlert()
        }
        
        if majUpdateCorrectly == false{
            self.succefulUpdate()
        }
    }
    
    @objc func callBackForBackgroundNotification(){
        if isBetaKeyCorrect == false{
            if isConnectedToNetwork() == true{
                self.alertStart()
            }else{
                self.noInternetConnectionPopup()
            }
        }
    }
    @objc func callBackForActiveNotification(){
        if isBetaKeyCorrect == false{
            if isConnectedToNetwork() == true{
                self.alertStart()
            }else{
                self.noInternetConnectionPopup()
            }
        }
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
    
    func noInternetConnectionPopup(){
        let noInternetConnection = UIAlertController(title: "Aucune connexion à internet", message: "Vous devez être connecté à internet afin de pouvoir entrer votre clé bêta. Merci de réessayer quand vous serez connecté à internet (2G, 3G, 4G (LTE), WiFi)", preferredStyle: .alert)
        noInternetConnection.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
            Foundation.exit(-1)
        }))
        self.present(noInternetConnection, animated: true)
    }
    
    func noInternetConnectionAlert(){
        let noInternetConnection = UIAlertController(title: "Aucune connexion à internet", message: "Certaines fonctionnalités de l'application ne pourront pas être utilisées si vous n'êtes pas connecté à internet, il est préférable de s'y connecter pour assurer une meilleure stabilité en cas de crash.", preferredStyle: .alert)
        noInternetConnection.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(noInternetConnection, animated: true)
    }
    
    func succefulUpdate(){
        let changeLogActual = UIAlertController(title: "Mise à jour installée !", message: "Une mise à jour a été installée avec succès, voici le contenu des nouveautés et modifications apportées à la mise à jour V1.0B \(appBuildNumber)\n\n  Modifications et nouveautés :\n\n\(CHANGELOG_UPDATE)", preferredStyle: .alert)
        changeLogActual.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
            UserDefaults.standard.set(true, forKey: "majUpdateCorrectly")
        }))
        self.present(changeLogActual, animated: true)
    }
    
    
    func alertUpdateAvailable(){
        let alertUpdate = UIAlertController(title: "Une mise à jour est disponible", message: "Une mise à jour de l'application est disponible, voulez-vous la lancer maintenant ?\n\nVersion de la MAJ : 1.0B\(appBuildNumber)\nChangements : ", preferredStyle: .alert)
        alertUpdate.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (UIAlertAction) in
        }))
        alertUpdate.addAction(UIAlertAction(title: "NON", style: .cancel, handler: { (UIAlertAction) in
            self.checkIfTapNoUpdate = true
            self.self.takePhotoChoose()
        }))
        
        super.present(alertUpdate, animated: true)
    }
    
    func alertStart(){
        let alertatstart = UIAlertController(title: "ATTENTION", message: "La version actuelle est une version bêta, de nombreux bug sont à déclarer, souhaitez-vous tout de même continuer ? (nécessite une clé bêta préalablement reçue par Mail)", preferredStyle: .alert)
        alertatstart.addAction(UIAlertAction(title: "OUI", style: .default, handler:{ (UIAlertAction) in
            self.askDevMail()
        }))
        alertatstart.addAction(UIAlertAction(title: "NON", style: .cancel, handler: { (UIAlertAction) in
            Foundation.exit(-1)
        }))
        self.present(alertatstart, animated: true)
    }
    
    func correctBetaKey(){
        let correctBetaPopup = UIAlertController(title: "Clé bêta valide", message: "La clé bêta que vous avez saisie est correcte, vous pouvez désormais accéder à l'application sans avoir besoin d'entrer à nouveau votre clé bêta", preferredStyle: .alert)
        let continueButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        correctBetaPopup.addAction(continueButton)
        self.present(correctBetaPopup, animated: true)
    }
    
    func incorrectBetaKey(){
        let incorrectBetaPopup = UIAlertController(title: "Clé bêta invalide", message: "La clé bêta que vous avez saisie est incorrecte, veuillez saisir une clé bêta correcte afin d'accéder à l'application, il se peut que la connection avec le serveur d'activation ai échoué, assurez-vous d'avoir :\n\n - Une connection à internet\n - Que l'application ai été téléchargée depuis la source officielle\n - Que votre clé bêta ai bien été payée ou que vous n'avez pas demandé de rembourssement", preferredStyle: .alert)
        incorrectBetaPopup.addAction(UIAlertAction(title: "Réessayer", style: .cancel, handler: { (UIAlertAction) in
            self.askDevMail()
        }))
        self.present(incorrectBetaPopup, animated: true)
    }
    
    func askDevMail(){
        let askDevMail = UIAlertController(title: "Entrez votre clé Bêta", message: "Une clé bêta permettant d'ouvrir l'application vous a été fournise par mail, entrez-là dès maintenant.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Annuler et sortir", style: .cancel) { (_) in
            Foundation.exit(-1)
        }
        
        let confirmAction = UIAlertAction(title: "Confirmer", style: .default) { (_) in
            let field = askDevMail.textFields?[0] as! UITextField
            if field.text == "ahfka7kajv8acoa9f"{
                UserDefaults.standard.set(true, forKey: "isBetaKeyCorrect")
                self.correctBetaKey()
            }else{
                self.incorrectBetaKey()
            }
        }
        askDevMail.addTextField { (textField) in
            textField.placeholder = "Clé bêta"
            textField.isSecureTextEntry = !textField.isSecureTextEntry
        }
        askDevMail.addAction(confirmAction)
        askDevMail.addAction(cancelAction)
        self.present(askDevMail, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeLogButton(_ sender: UIButton) {
        performSegue(withIdentifier: "changelogViewSegue", sender: self)
    }
    
    //Take a photo code
    @IBAction func takePhoto(_ sender: UIButton) {
        self.takePhotoChoose()
    }
    
    func takePhotoChoose(){
        let picker = UIImagePickerController()
        picker.delegate = self
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Appareil photo", style: .default, handler: {action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Pelicule", style: .default, handler: { action in
            picker.sourceType = .photoLibrary
            if UIDevice.current.userInterfaceIdiom == .pad {
                picker.modalPresentationStyle = .popover
                picker.popoverPresentationController?.sourceView = self.view
                picker.popoverPresentationController?.sourceRect = self.takePhotoButton.frame
            }
            self.present(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = takePhotoButton.frame
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        performSegue(withIdentifier: "showImageSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageSegue" {
            if let imageViewController = segue.destination as? ImageViewController {
                imageViewController.image = self.image
            }
        }
    }
    
    @IBAction func exit(unwindSegue: UIStoryboardSegue) {
        image = nil
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettingsSegue", sender: self)
    }
}

    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
