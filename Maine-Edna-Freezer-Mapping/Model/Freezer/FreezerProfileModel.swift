//
//  FreezerProfileModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/3/21.
//

import Foundation
import SwiftUI


class FreezerProfileModel: Encodable,Decodable, Identifiable {
    
    var id : Int = 0
    var freezer_date : String = ""
    var freezer_label : String = ""
    var freezer_depth : Int = 0
    var freezer_length : Int = 0
    var freezer_width : Int = 0
    var freezer_dimension_units : String = ""
    var freezer_max_columns : Int = 0
    var freezer_max_rows : Int = 0
    var freezer_max_depth : Int = 0
    var created_by : String = ""
    var created_datetime : String = ""

}

