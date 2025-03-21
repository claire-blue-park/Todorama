//
//  Cell+.swift
//  Todorama
//
//  Created by Claire on 3/21/25.
//

import UIKit

protocol Identifier {
    static var identifier: String { get }
}

extension UICollectionViewCell: Identifier {
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: Identifier {
    static var identifier: String {
        return String(describing: self)
    }
    
}
