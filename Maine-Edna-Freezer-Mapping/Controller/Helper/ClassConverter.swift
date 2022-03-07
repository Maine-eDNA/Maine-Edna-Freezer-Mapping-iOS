//
//  ClassConverter.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/30/21.
//

import SwiftUI
import Foundation

class ClassConverter : ObservableObject {
    
    ///Default CSS to User Css Converter
    
    func DefaultCssToUserCss(_user_email : String,_default_css : DefaultCssModel) -> UserCssModel
    {
        let user_css = UserCssModel()
        
        user_css.user = _user_email
        user_css.custom_css_label = "user_css_" + UUID().uuidString//_user_email.replacingOccurrences(of: "@", with: "") + "_user_css"
        user_css.css_selected_text_color = _default_css.css_selected_text_color
        user_css.default_css_label = _default_css.default_css_label
        user_css.css_selected_background_color = _default_css.css_selected_background_color
        user_css.freezer_empty_box_css_background_color = _default_css.freezer_empty_box_css_background_color
        user_css.freezer_empty_css_background_color = _default_css.freezer_empty_css_background_color
        user_css.freezer_empty_box_css_text_color = _default_css.freezer_empty_box_css_text_color
        user_css.freezer_empty_inventory_css_text_color = _default_css.freezer_empty_inventory_css_text_color
        user_css.freezer_empty_inventory_css_background_color = _default_css.freezer_empty_inventory_css_background_color
        user_css.freezer_empty_rack_css_background_color = _default_css.freezer_empty_rack_css_background_color
        user_css.freezer_empty_css_text_color = _default_css.freezer_empty_css_text_color
        user_css.freezer_empty_rack_css_text_color = _default_css.freezer_empty_rack_css_text_color
        user_css.freezer_inuse_box_css_background_color = _default_css.freezer_inuse_box_css_background_color
        user_css.freezer_inuse_box_css_text_color = _default_css.freezer_inuse_box_css_text_color
        user_css.freezer_inuse_css_background_color = _default_css.freezer_inuse_css_background_color
        user_css.freezer_inuse_css_text_color = _default_css.freezer_inuse_css_text_color
        user_css.freezer_inuse_inventory_css_background_color = _default_css.freezer_inuse_inventory_css_background_color
        user_css.freezer_inuse_inventory_css_text_color = _default_css.freezer_inuse_inventory_css_text_color
        user_css.freezer_inuse_rack_css_background_color = _default_css.freezer_inuse_rack_css_background_color
        user_css.freezer_inuse_rack_css_text_color = _default_css.freezer_inuse_rack_css_text_color

        

        return user_css
        
    }
    
    
    
}
