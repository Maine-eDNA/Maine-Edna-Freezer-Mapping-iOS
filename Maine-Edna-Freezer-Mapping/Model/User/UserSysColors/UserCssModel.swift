//
//  UserCssModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/30/21.
//

import Foundation

class UserCssModel: Encodable,Decodable, Identifiable {

    var id : Int = 0
    var custom_css_label : String = ""
    ///User Email Address
    var user : String = ""
    var default_css_label : String = ""
    var css_selected_background_color : String = ""
    var css_selected_text_color : String = ""
    var freezer_empty_css_background_color : String = ""
    var freezer_empty_css_text_color : String = ""
    var freezer_inuse_css_background_color : String = ""
    var freezer_inuse_css_text_color : String = ""
    var freezer_empty_rack_css_background_color : String = ""
    var freezer_empty_rack_css_text_color : String = ""
    
    var freezer_inuse_rack_css_background_color : String = ""
    var freezer_inuse_rack_css_text_color : String = ""
    var freezer_empty_box_css_background_color : String = ""
    var freezer_empty_box_css_text_color : String = ""
    var freezer_inuse_box_css_background_color : String = ""
    var freezer_inuse_box_css_text_color : String = ""
    var freezer_empty_inventory_css_background_color : String = ""
    var freezer_empty_inventory_css_text_color : String = ""
    var freezer_inuse_inventory_css_background_color : String = ""
    var freezer_inuse_inventory_css_text_color : String = ""
    var created_by : String = ""
    var created_datetime : String = ""
    var modified_datetime : String = ""

}
