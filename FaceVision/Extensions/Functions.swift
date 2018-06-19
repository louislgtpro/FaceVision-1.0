//
//  BackgroundImage.swift
//  FaceVision
//
//  Created by louis on 15/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import UIKit

class Functions{
    
    public func addBackgroundImage(name: String, view: UIViewController){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: name)
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        view.view.insertSubview(backgroundImage, at: 0)
    }
}
