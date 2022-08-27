//
//  FreezerQueryViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/27/22.
//

import Foundation


//Freezer Inquery View Model
//Model to store the current


class FreezerQueryViewModel : ObservableObject{
    @Published var id = UUID()
    @Published var freezer_id : String = ""
    @Published var freezer_label : String = ""
    @Published var freezer_rack_label : String = ""
    @Published var freezer_box_label : String = ""
    
    //Rack Section
    //Rack Coordinates
    @Published var freezer_rack_column_end : Int = 0
    @Published var freezer_rack_column_start : Int = 0
    @Published var freezer_rack_depth_end : Int = 0
    @Published var freezer_rack_depth_start : Int = 0
    @Published var freezer_rack_row_end : Int = 0
    @Published var freezer_rack_row_start : Int = 0
    @Published var rack_css_background_color : String = ""
    @Published var rack_css_text_color : String = ""
    
    //Box Section
    
    @Published var freezer_box_label_slug : String = ""
    @Published var freezer_box_column : Int = 0
    @Published var freezer_box_row : Int = 0
    @Published var freezer_box_depth : Int = 0
    @Published var freezer_box_max_column : Int = 0
    @Published var freezer_box_max_row : Int = 0
    
}
