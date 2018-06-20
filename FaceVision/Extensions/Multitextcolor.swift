//
//  Multitextcolor.swift
//  FaceVision
//
//  Created by louis on 20/06/2018.
//  Copyright © 2018 Legout. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}
