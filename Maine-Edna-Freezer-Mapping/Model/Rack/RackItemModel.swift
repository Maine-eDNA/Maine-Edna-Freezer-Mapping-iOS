//
//  RackItemModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/29/21.
//

import Foundation
import SwiftUI


class RackItemModel: Encodable,Decodable, Identifiable {
    
    var id : Int = 0
    var created_by : String = ""
    var created_datetime : String = ""
    var freezer_rack_column_end : Int = 0
    var freezer_rack_column_start : Int = 0
    var freezer_rack_depth_end : Int = 0
    var freezer_rack_depth_start : Int = 0
    var freezer_rack_label : String = ""
    var freezer_rack_row_end : Int = 0
    var freezer_rack_row_start : Int = 0
    var css_background_color : String = ""
    var css_text_color : String = ""
    var freezer : String = ""

}

