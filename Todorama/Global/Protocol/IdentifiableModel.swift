//
//  IdentifiableModel.swift
//  Todorama
//
//  Created by 최정안 on 3/22/25.
//

import Foundation
import RealmSwift
protocol IdentifiableModel {
    var id: Int { get } // id를 공통적으로 갖도록 정의
}
protocol RealmFetchable: Object {
    var dramaId: Int { get }
}
