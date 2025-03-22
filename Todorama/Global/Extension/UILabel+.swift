//
//  UILabel+.swift
//  Todorama
//
//  Created by Claire on 3/21/25.
//

import UIKit

extension UILabel {
    
    func navTitleStyle() {
        font = Fonts.navTitleFont
        textColor = Fonts.titleColor
    }
    
    func sectionTitleStyle() {
        font = Fonts.sectionTitleFont
        textColor = Fonts.titleColor
    }
    
    func countStyle() {
        font = Fonts.countFont
        textColor = Fonts.textColor
    }
    
    func dramaTitleStyle() {
        font = Fonts.dramaTitleFont
        textColor = Fonts.titleColor
    }
    
    func textStyle() {
        font = Fonts.textFont
        textColor = Fonts.textColor
    }
    
    func accessoryStyle() {
        font = Fonts.accessoryFont
        textColor = Fonts.textColor
    }
    
}
