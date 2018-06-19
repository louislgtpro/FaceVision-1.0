//
//  SettingsViewController.swift
//  FaceVision
//
//  Created by Louis on 01/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController{
    
    
    @IBOutlet weak var SwitchVisageOutler: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Réglages"
        print("SettingsViewController has been loaded")
        addBackgroundImage(name: "mountain1.png")
    }
    
    func addBackgroundImage(name: String){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: name)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backSettingsButtonSegue", sender: self)
    }
    
    @IBAction func SwitchVisage(_ sender: UISwitch) {
        if SwitchVisageOutler.isEnabled == true{
            print("enable")
        }else{
            print("disable")
        }
    }
}
