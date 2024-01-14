//
//  CellController.swift
//  CompositionalLayoutSwift
//
//  Created by Khristoffer Julio on 1/14/24.
//

import Foundation

class CellController: Hashable {
    let id: UUID
    let name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}
