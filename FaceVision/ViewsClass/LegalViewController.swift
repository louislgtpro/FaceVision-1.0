//
//  LegalViewController.swift
//  FaceVision
//
//  Created by louis on 14/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController{
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackgroundImage(name: "backgroundterms2")
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
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backLegalSegue", sender: self)
    }
}
