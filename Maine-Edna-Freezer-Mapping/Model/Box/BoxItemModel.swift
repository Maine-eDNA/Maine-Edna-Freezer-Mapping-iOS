//
//  BoxItemModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import Foundation
import SwiftUI


class BoxItemModel: Encodable,Decodable, Identifiable {
    
    var id : Int = 0
    var freezer_rack : String = ""
    var freezer_box_label : String = ""
    var freezer_box_label_slug : String = ""
    var freezer_box_column : Int = 0
    var freezer_box_row : Int = 0
    var freezer_box_depth : Int = 0
    var freezer_box_max_column : Int = 0
    var freezer_box_max_row : Int = 0

    var created_by : String = ""
    var created_datetime : String = ""
    var modified_datetime : String = ""

}
