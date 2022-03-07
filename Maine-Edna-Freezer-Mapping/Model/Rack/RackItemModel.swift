//
//  RackItemModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/29/21.
//

import Foundation
import SwiftUI


// MARK: - FreezerRack
struct RackItemModel: Codable {
    init(){
        id = 0
        freezer_rack_label = ""
        freezer_rack_label_slug = ""
        freezer_rack_column_start = 0
        freezer_rack_column_end = 0
        freezer_rack_row_start = 0
        freezer_rack_row_end = 0
        freezer_rack_depth_start = 0
        freezer_rack_depth_end = 0
        //freezer = FreezerProfileModel()
        freezer = ""
        created_by = ""
        created_datetime = ""
        modified_datetime = ""
       // is_suggested_rack_position = false
    }
    
    var id: Int
    
    var freezer_rack_label, freezer_rack_label_slug: String
    var freezer_rack_column_start, freezer_rack_column_end, freezer_rack_row_start, freezer_rack_row_end: Int
    var freezer_rack_depth_start, freezer_rack_depth_end: Int
    var is_suggested_rack_position : Bool = false
   // var freezer: FreezerProfileModel?
    var freezer : String?
    var created_by, created_datetime, modified_datetime: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case freezer_rack_label = "freezer_rack_label"
        case freezer_rack_label_slug = "freezer_rack_label_slug"
        case freezer_rack_column_start = "freezer_rack_column_start"
        case freezer_rack_column_end = "freezer_rack_column_end"
        case freezer_rack_row_start = "freezer_rack_row_start"
        case freezer_rack_row_end = "freezer_rack_row_end"
        case freezer_rack_depth_start = "freezer_rack_depth_start"
        case freezer_rack_depth_end = "freezer_rack_depth_end"
        case freezer
        case created_by = "created_by"
        case created_datetime = "created_datetime"
        case modified_datetime = "modified_datetime"
    }
}


class RackItemVm : ObservableObject{
    
    @Published var rack_layout : [RackItemModel] = [RackItemModel]()
}
