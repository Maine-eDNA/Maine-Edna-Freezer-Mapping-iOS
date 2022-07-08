//
//  InventoryStatusModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/6/22.
//

import Foundation

struct InventoryStatusModel: Codable {
    
    init(){
        choices = [String]()
    }
    
    var id = UUID()
    var choices : [String]
    
    enum CodingKeys: String, CodingKey {
        case choices
        
    }
}
