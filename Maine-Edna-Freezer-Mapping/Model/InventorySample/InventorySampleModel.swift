//
//  InventorySampleModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import Foundation
import SwiftUI


class InventorySampleModel: Encodable,Decodable, Identifiable {
    
    init(){
        
    }
    
    init(id : Int,freezer_box : String,freezer_inventory_column : Int,freezer_inventory_row : Int, is_suggested_sample : Bool  ){
        self.id = 0
        self.freezer_box = ""
        self.freezer_inventory_column = 0
        self.freezer_inventory_row = 0
        self.is_suggested_sample = false
    }
    
    var id : Int = 0
    var freezer_box : String = ""
    var sample_barcode : String = ""
    #warning("Use Codeable")
    var freezer_inventory_slug : String = ""
    var freezer_inventory_type : String = ""
    var freezer_inventory_status : String = ""
    var freezer_inventory_column : Int = 0
    var freezer_inventory_row : Int = 0


    var created_by : String = ""
    var created_datetime : String = ""
    var modified_datetime : String = ""
    
    var is_suggested_sample : Bool = false

}

