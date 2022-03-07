//
//  BoxItemModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import Foundation
import SwiftUI


// MARK: - FreezerBox
struct BoxItemModel: Codable {
    var id: Int?
    var freezer_box_label, freezer_box_label_slug: String?
    var freezer_box_column, freezer_box_row, freezer_box_depth, freezer_box_capacity_column: Int?
    var freezer_box_capacity_row: Int?
    var freezer_rack: String?
    var created_by, created_datetime, modified_datetime: String?
    var is_suggested_box_position : Bool = false
    enum CodingKeys: String, CodingKey {
        case id
        case freezer_box_label = "freezer_box_label"
        case freezer_box_label_slug = "freezer_box_label_slug"
        case freezer_box_column = "freezer_box_column"
        case freezer_box_row = "freezer_box_row"
        case freezer_box_depth = "freezer_box_depth"
        case freezer_box_capacity_column = "freezer_box_capacity_column"
        case freezer_box_capacity_row = "freezer_box_capacity_row"
        case freezer_rack = "freezer_rack"
        case created_by = "created_by"
        case created_datetime = "created_datetime"
        case modified_datetime = "modified_datetime"
    }
}
