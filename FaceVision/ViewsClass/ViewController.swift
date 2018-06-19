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
    
    var image: UIImage!
    
    private var askUpdate = false
    private var countUpdateNeeded  = 2
    private var appBuildNumberLocal = 10
    private var checkIfTapNoUpdate = false
    
    let isBetaKeyCorrect = UserDefaults.standard.bool(forKey: "isBetaKeyCorrect")
    let popupBetaWelcomeClicked = UserDefaults.standard.bool(forKey: "popupBetaWelcomeClicked")
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
        
        InitializeLoading()
        addBackgroundImage(name: "background1.png")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callBackForActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callBackForBackgroundNotification), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Checks vars
        print (popupBetaWelcomeClicked)
        print (isBetaKeyCorrect)
        print("Version of the App : 1.0B ", appBuildNumber)
    }
    
    func InitLayersCornerRadius(){
    
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
        noInternetConnection.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(noInternetConnection, animated: true)
    }
    
    func noInternetConnectionAlert(){
        let noInternetConnection = UIAlertController(title: "Aucune connexion à internet", message: "Certaines fonctionnalités de l'application ne pourront pas être utilisées si vous n'êtes pas connecté à internet, il est préférable de s'y connecter pour assurer une meilleure stabilité en cas de crash.", preferredStyle: .alert)
        noInternetConnection.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(noInternetConnection, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isConnectedToNetwork() == false && isBetaKeyCorrect == true{
            self.noInternetConnectionAlert()
        }
        
        if isBetaKeyCorrect == false{
            if isConnectedToNetwork() == true{
                self.alertStart()
            }else{
                self.noInternetConnectionPopup()
            }
        }
        
        if majUpdateCorrectly == false{
            self.succefulUpdate()
        }
        
        if isBetaKeyCorrect == true && popupBetaWelcomeClicked == false{
            self.welcomeBetaPopup()
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
    
    func succefulUpdate(){
        let changeLogActual = UIAlertController(title: "Mise à jour installée !", message: "Une mise à jour a été installée avec succès, voici le contenu des nouveautés et modifications apportées à la mise à jour V1.0B \(appBuildNumber)\n\n  Modifications et nouveautés :\n\n- Amélioration du design intérieur\n- Amélioration de la propreté du code interne\n- Rapidité et fluidité en terme général amélioré\n- Corrections de bugs et ajout des CGU/Mentions légales\n", preferredStyle: .alert)
        changeLogActual.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
            UserDefaults.standard.set(true, forKey: "majUpdateCorrectly")
            
        }))
        self.present(changeLogActual, animated: true)
    }
    
    func welcomeBetaPopup(){
        let welcomeBeta = UIAlertController(title: "- Betamodus -", message: "Dag! En welkom in de beta-versie van de FaceVision-applicatie. Dank u voor uw deelname aan het bèta programma van de applicatie, als u problemen, bugs of crashes stuur ons alle informatie die u kon herstellen tijdens het probleem tegenkomt.", preferredStyle: .alert)
        
        welcomeBeta.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (UIAlertAction) in
            UserDefaults.standard.set(true, forKey: "popupBetaWelcomeClicked")
        }))
        
        self.present(welcomeBeta, animated: true)
    }
    
    func alertUpdateAvailable(){
        let alertUpdate = UIAlertController(title: "Une mise à jour est disponible", message: "Une mise à jour de l'application est disponible, voulez-vous la lancer maintenant ?\n\nVersion de la MAJ : 1.0B\(appBuildNumber)\nChangements : ", preferredStyle: .alert)
        alertUpdate.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (UIAlertAction) in
            self.StartLoadingIndicator()
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
        if countUpdateNeeded == 1 && checkIfTapNoUpdate == false{
            self.alertUpdateAvailable()
        }else{
            takePhotoChoose()
        }
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
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func StartLoading(_ sender: Any){
        StartLoadingIndicator()
    }
    
    @IBAction func StopLoading(_ sender: Any){
        StopLoadingIndicator()
    }
    
    func StartLoadingIndicator(){
        self.view.addSubview(firstView)
    }
    
    func StopLoadingIndicator(){
        self.view.removeFromSuperview()
    }
    
    func InitializeLoading(){
        firstView = UIView(frame: CGRect(x: 0, y:0, width: 250, height: 50))
        firstView.backgroundColor = UIColor.darkGray
        firstView.layer.cornerRadius = 10
        
        let wait = UIActivityIndicatorView(frame: CGRect(x:0, y:0, width: 50, height: 50))
        wait.color = UIColor.black
        wait.hidesWhenStopped = false
        wait.startAnimating()
        
        let text = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        text.text = "Veuillez patienter..."
        
        firstView.addSubview(wait)
        firstView.addSubview(text)
        firstView.center = self.view.center
        firstView.tag = 1000
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettingsSegue", sender: self)
    }
}

    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
