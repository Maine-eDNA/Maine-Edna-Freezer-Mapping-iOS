//
//  BoxCartFormView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI

///Shows the box available for a target rack in the Cart view for Remove, Search, Transfer etc
///When the box is clicked it goes into the box and shows all the samples where the add, remove, search process will be complete
///If is the transfer process it will allow the user to click to see in a box (to see what is in it) and from the box level click transfer, then select the target freezer -> rack
///the box should be transfered to
///SHOWS THE RACK CROSS Sectional view of the boxses are stored in the map
struct BoxCartFormView : View{
    
    /*@Binding var rack_profile : RackItemModel
    @Binding var addToRackMode : Bool
    @Binding var rack_position_row : Int
    @Binding var rack_position_column: Int
    
   
    @Binding var showRackProfile : Bool
   
    
    
    
    @Binding var isInSearchMode : Bool*/
    @StateObject var util_vm : UtilitiesCartFormViewModel = UtilitiesCartFormViewModel()
    @Binding var freezer_rack_label_slug : String //= "test_freezer_1_test_rack3"
    
    @Binding var target_rack : RackItemModel
    @Binding var freezer_profile : FreezerProfileModel
    
    @Binding var inventoryLocations : [InventorySampleModel]
    
    @State var is_in_select_mode : Bool = true
    
    @Binding var selectMode : String
    
    var body: some View{
        //Need to exclude or include 1 to 3 (so the start to end includes 1, 2 and 3) instead of just including 2
        //Text("Box Available Form")
        VStack{
            Text("Test \(freezer_rack_label_slug) or \(target_rack.freezer_rack_label)")
            main_section
        }
        
        
    }
}

extension BoxCartFormView{
    
    
    private var main_section : some View{
        
        /*
         MARK: Whats needed to run RackProfileView
         RackProfileView(rack_profile: $target_rack,freezer_profile: self.freezer_profile,isInSearchMode: self.isInSearchMode, inventoryLocations: self.inventoryLocations, addToRackMode: .constant(false))
         */
        
        Section{
            RackProfileView(rack_profile: $target_rack,freezer_profile: self.freezer_profile,isInSearchMode: self.util_vm.isInSearchMode, inventoryLocations: self.inventoryLocations, addToRackMode: $util_vm.addToRackMode, freezer_rack_label_slug: $freezer_rack_label_slug, is_in_select_mode: $is_in_select_mode, selectMode: $selectMode)
                //.frame(width: 400)
            
        }
        
    }
    
}
