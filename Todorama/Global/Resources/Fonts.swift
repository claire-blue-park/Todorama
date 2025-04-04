//
//  Fonts.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import UIKit

enum Fonts {
    static let titleColor = UIColor.tdWhite
    static let textColor = UIColor.tdGray

    static var navTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    
    static var countFont: UIFont {
        return UIFont.systemFont(ofSize: 28, weight: .medium)
    }
    
    static var sectionTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    static var dramaTitleFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    static var textFont: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    static var accessoryFont: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .regular)
    }
}
