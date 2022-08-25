//
//  ColorSetter.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/14/22.
//

import Foundation
import SwiftUI

class ColorSetter{

    @Environment(\.colorScheme) var colorScheme
    
#warning("Also color the samples based on their type: filter = blue, extraction = purple, sub-core = orange, pooled_lib = brown ")
    
    func setColorBasedOnSampleType(freezer_inventory_type : String) -> String
    {
        //green for target samples
        /*
         "choices": [
         "filter",
         "subcore",
         "extraction",
         "pooled_lib"
         ]
         */
        if freezer_inventory_type == "filter"{
            return "blue"
        }
        else if freezer_inventory_type == "subcore"{
            return "orange"
        }
        else if freezer_inventory_type == "extraction"{
            return "purple"
        }
        else if freezer_inventory_type == "pooled_lib"{
            return "brown"
        }
        else{
            return "mint"
        }
        
    }
    
    
    ///set the foreground color based on if the system is in light or dark mode
    ///for SAMPLE use only
    func setForegroundColor()-> String{
        return colorScheme == .dark ? "black" : "white"
    }
    
    ///set the foreground color based on if the system is in light or dark mode
    ///for TEXT use only
    func setTextForegroundColor()-> String{
        return colorScheme == .dark ? "white" : "black" 
    }
}
