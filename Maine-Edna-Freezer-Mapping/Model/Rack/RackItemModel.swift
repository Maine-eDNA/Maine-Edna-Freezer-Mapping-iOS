//
//  RackItemModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/29/21.
//

import Foundation
import SwiftUI


struct RackItemResultsModel: Codable {
    var links: RackItemLinks?
    var count: Int?
    var results: [RackItemModel]?
}


// MARK: - Links
struct RackItemLinks: Codable {
    var next, previous: JSONNull?
}



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
    
    
    init(id : Int, freezer_rack_label : String,freezer_rack_label_slug : String, is_suggested_rack_position : Bool  ){
        self.id = 0
        self.freezer_rack_label = freezer_rack_label
        self.freezer_rack_label_slug = freezer_rack_label_slug
        self.freezer_rack_column_start = 0
        self.freezer_rack_column_end = 0
        self.freezer_rack_row_start = 0
        self.freezer_rack_row_end = 0
        self.freezer_rack_depth_start = 0
        self.freezer_rack_depth_end = 0
        //freezer = FreezerProfileModel()
        self.freezer = ""
        self.created_by = ""
        self.created_datetime = ""
        self.modified_datetime = ""
        self.is_suggested_rack_position = is_suggested_rack_position
    }
    //stats version
    
    init(id : Int, freezer_rack_label : String,freezer_rack_label_slug : String, is_suggested_rack_position : Bool,number_of_boxes_in_use : Int, box_capacity_of_rack : Int  ){
        self.id = 0
        self.freezer_rack_label = freezer_rack_label
        self.freezer_rack_label_slug = freezer_rack_label_slug
        self.freezer_rack_column_start = 0
        self.freezer_rack_column_end = 0
        self.freezer_rack_row_start = 0
        self.freezer_rack_row_end = 0
        self.freezer_rack_depth_start = 0
        self.freezer_rack_depth_end = 0
        //freezer = FreezerProfileModel()
        self.freezer = ""
        self.created_by = ""
        self.created_datetime = ""
        self.modified_datetime = ""
        self.is_suggested_rack_position = is_suggested_rack_position
        self.number_of_boxes_in_use = number_of_boxes_in_use
        self.box_capacity_of_rack = box_capacity_of_rack
        
    }
    
    var id: Int
    
    var freezer_rack_label, freezer_rack_label_slug: String
    var freezer_rack_column_start, freezer_rack_column_end, freezer_rack_row_start, freezer_rack_row_end: Int
    var freezer_rack_depth_start, freezer_rack_depth_end: Int
    var is_suggested_rack_position : Bool = false
   // var freezer: FreezerProfileModel?
    var freezer : String?
    var created_by, created_datetime, modified_datetime: String?
    
    //not included in the API call (commuted in runtime)
    var number_of_boxes_in_use : Int = 0
    var box_capacity_of_rack : Int = 0
    
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



