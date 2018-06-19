//
//  Variables.swift
//  FaceVision
//
//  Created by Louis on 05/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import Foundation

class Variables{
    
   var checkIfPopupAppears:Bool
   public var VariablesInstance = Variables(checkIfPopupAppears: false)
    
    init(checkIfPopupAppears:Bool){
        self.checkIfPopupAppears = checkIfPopupAppears
    }
}
