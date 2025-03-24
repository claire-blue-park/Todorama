//
//  SystemImages.swift
//  Todorama
//
//  Created by Claire on 3/20/25.
//

import UIKit

enum SystemImages {
    case star
    case plus
    case check
    case eye
    case pencil
    case heart
    
    enum tab {
        case houseICON
        case magnifICON
        case archiveICON

        var name: String {
            switch self {
            case .houseICON:
                "house"
            case .magnifICON:
                "magnifyingglass"
            case .archiveICON:
                "archivebox"
            }
        }
    }
    
    var name: String {
        switch self {
        case .star:
            "star.circle.fill"
        case .plus:
            "plus.circle.fill"
        case .check:
            "checkmark.circle.fill"
        case .eye:
            "eye.circle.fill"
        case .pencil:
            "square.and.pencil.circle.fill"
        case .heart:
            "heart.fill"
        }
    }
    
    var image: UIImage {
        UIImage(systemName: self.name) ?? UIImage(named: Strings.Global.empty.text)!
    }
    
    enum chevron {
        case left
        case right
        case up
        case down
        
        var name: String {
            switch self {
            case .left:
                "chevron.left"
            case .right:
                "chevron.right"
            case .up:
                "chevron.up"
            case .down:
                "chevron.down"
            }
        }
        
        var image: UIImage {
            UIImage(systemName: self.name) ?? UIImage(named: Strings.Global.empty.text)!
        }
    }
        
}
