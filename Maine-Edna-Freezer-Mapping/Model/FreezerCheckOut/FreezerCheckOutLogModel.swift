//
//  FreezerCheckOutLogModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//


import Foundation
import SwiftUI


class FreezerCheckOutLogModel: Encodable,Decodable, Identifiable {
    
    var id : Int = 0
    var freezer_inventory : String = ""
    var freezer_log_action : String = ""
    var freezer_checkout_datetime : String = ""
    var freezer_return_datetime : String = ""
    var freezer_perm_removal_datetime : String = ""
    var freezer_return_vol_taken : String = ""
    
    var freezer_return_vol_units : String = ""
    var freezer_log_notes : String = ""
    #warning("Use Codeable")
    var freezer_log_slug : String = ""
    var created_by : String = ""
    var created_datetime : String = ""
    var modified_datetime : String = ""


}


