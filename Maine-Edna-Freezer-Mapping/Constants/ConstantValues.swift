//
//  ConstantValues.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/29/21.
//

import Foundation


enum ServerConnectionUrls: String {
    case productionUrl = "https://metadata.spatialmsk.dev/"

}

enum AppStorageNames : String{
    case stored_user_id = "stored_user_id"
    case stored_password = "stored_password"
    case store_email_address = "store_email_address"
    case edna_freezer_token = "edna_freezer_token"
    case stored_freezer_rack_layout = "stored_freezer_rack_layout"
    case stored_freezers = "stored_freezers"
    case login_status = "login_status"
    case stored_user_profile_pic_url = "stored_user_profile_pic_url"
    case stored_user_name = "stored_user_name"
    case stored_rack_boxes = "stored_rack_boxes"
    case stored_box_samples = "stored_box_samples"
    case stored_box_sample_logs = "stored_box_sample_logs"
    case stored_return_meta_data = "stored_return_meta_data"
    case store_logged_in_user_profile = "store_logged_in_user_profile"
    case store_default_css = "store_default_css"
    case all_unfiltered_stored_box_samples = "all_unfiltered_stored_box_samples"
    case all_found_box_samples = "all_found_box_samples"
    case stored_freezer_racks_in_system = "stored_freezer_racks_in_system"
    case all_stored_rack_boxes_in_system = "all_stored_rack_boxes_in_system"
    
    case store_sample_batches = "store_sample_batches"
    
}


//letters of the alphabet start
let alphabet : [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
//letters of the alphabet end
