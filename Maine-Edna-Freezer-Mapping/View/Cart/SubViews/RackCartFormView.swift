//
//  RackCartFormView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI
//remove the freezer name pre-pended to the rack label
//map the coordinate to start at 1 example E5
//Need to exclude or include 1 to 3 (so the start to end includes 1, 2 and 3) instead of just including 2
///Shows the rack available for a target freezer in the Cart view for Remove, Search, Transfer etc
struct RackCartFormView : View{
   
    
    @State var show_freezer_detail : Bool = false

    
    //conditional renders
    @State var show_create_new_rack : Bool = false
    @State var show_view_freezer_detail: Bool = false
    
    //Need to add bulk adding by using the camera
    //Manual Scanning
    
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    
    //MARK: the empty rack location properties
    @State var rack_position_row : Int = 0
    @State var rack_position_column: Int = 0
   
    @State var show_guided_rack_view : Bool = false
    
    
    //TODO: make it a environment object
    @ObservedObject var user_css_core_data_service = UserCssThemeCoreDataManagement()
    
    @StateObject private var vm : FreezerRackViewModel = FreezerRackViewModel()
    
    @State var show_rack_box_view : Bool = false
    
    //MARK: Data shared with the box
    @Binding var freezer_rack_label_slug : String
    @Binding var target_rack : RackItemModel
    @Binding var freezer_profile : FreezerProfileModel
    
    @Binding var inventoryLocations : [InventorySampleModel]
    
    @Binding var selectMode : String
    
    @StateObject private var box_vm : FreezerBoxViewModel = FreezerBoxViewModel()
    
    var body: some View{
        ZStack{
        VStack{
           // Text("Target Freezer \(freezer_profile.freezerLabel)")
          Text("\(selectMode) Mode")

            //Text("Racks Available Form")
            //MARK: Need to load the rack layouts (check the Freezer Layout on Freezer Tab bar)
          //  if !show_rack_box_view{
                rack_layout_section
          //  }
           // else if show_rack_box_view{
                //box_section
           // }
            
            
            //FreezerDetailView(freezer_profile: target_freezer)
            //    .frame(width: 100,height: 100)
            //FreezerDetailView(freezer_profile: target_freezer)
            //.frame(width: 100,height: 100)
            Spacer()
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            withAnimation {
                                self.show_rack_box_view.toggle()
                            }
                        } label: {
                            HStack{
                                Text(show_rack_box_view ? "Show Freezer Layout" : "Show Box Detail")
                            }.roundButtonStyle()
                        }
                    }
                }
        .onAppear()
            {
                print("Freezer Label: \(self.freezer_profile.freezerLabel)")
                self.vm.FindRackLayoutByFreezerLabel(_freezer_label: self.freezer_profile.freezerLabel)
            }
        }
    }
    }
}

//when clicked it will go to the box then box sample

extension RackCartFormView{
    //Need to exclude or include 1 to 3 (so the start to end includes 1, 2 and 3) instead of just including 2
    private var rack_layout_section : some View{
        GuidedCartInteractFreezerLayout(freezer_max_rows: .constant($freezer_profile.freezerCapacityRows.wrappedValue ?? 0), freezer_max_columns: .constant($freezer_profile.freezerCapacityColumns.wrappedValue ?? 0),freezer_rack_layout : self.$vm.freezer_racks,freezer_profile: freezer_profile, show_create_new_rack: $show_create_new_rack, show_guided_rack_view: self.$show_guided_rack_view, show_guided_map_view: .constant(false),freezer_width: .constant(UIScreen.main.bounds.width * 0.95),freezer_height: .constant( UIScreen.main.bounds.height * 0.95),rack_position_row: $rack_position_row,rack_position_column: $rack_position_column, freezer_rack_label_slug: $freezer_rack_label_slug, show_rack_box_view: $show_rack_box_view, selectMode: $selectMode)
    }
    
    //put the box layout inside the same view to share logic easier

    
}


//MARK: Custom Rack Layout that when clicked populates the form and not navigate away

struct GuidedCartInteractFreezerLayout: View {
#warning("TODO TO MAKE THE COLOR DYNAMIC")
    //need to show the empty spots by pre-populating it and with the positions
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    @State var showSampleDetail : Bool = false
    @Binding  var freezer_max_rows : Int
    @Binding  var freezer_max_columns: Int
    @Binding var freezer_rack_layout : [RackItemModel]
    @State var freezer_profile : FreezerProfileModel
    @State var current_label : String = ""
    //conditional renders
    @Binding var show_create_new_rack : Bool
    //TODO: - need to get the system colors
    
    @State var max_capacity : Int = 0
    //TODO: - SHow when takes more than one row and col
    
    //Theme information
    //TODO: make it a environment object
    // @ObservedObject var user_css_core_data_service = UserCssThemeCoreDataManagement()
    
    @AppStorage(AppStorageNames.stored_user_id.rawValue)  var stored_user_id : Int = 0
    //TODO: updated model (may need to make this into a map settings model
#warning("updated model (may need to make this into a map settings model")
    @State var inner_rack_rect_color : String = "gray"
    @State var suggested_outline_slot_color : String = "yellow"
    
    @Binding var show_guided_rack_view : Bool
    
    @Binding var show_guided_map_view : Bool
    
    @State var showingAlert : Bool = false
    @State var alertMsg : String = ""
    @State var inventoryLocations : [InventorySampleModel] = []
    @State var isInSearchMode : Bool = false
    
    @Binding var freezer_width : CGFloat
    @Binding var freezer_height : CGFloat
    
    //MARK: the empty rack location properties
    @Binding var rack_position_row : Int
    @Binding var rack_position_column: Int
    
    @State var target_rack : RackItemModel = RackItemModel()
    @State var showRackProfile : Bool = false
    
    
    @State var isInCartUtilitiesForm : Bool = true
    
    @State var showRackFormProfile : Bool = false
    //MARK: Add the details in viewmodel
    @StateObject var util_vm : UtilitiesCartFormViewModel = UtilitiesCartFormViewModel()
    @StateObject var freezer_box_vm : FreezerBoxViewModel = FreezerBoxViewModel()
    
    @Binding var freezer_rack_label_slug : String
    
    @Binding var show_rack_box_view : Bool
    
    //MARK: required to switch the sample map into tap to add to list mode etc
    @State var is_in_select_mode : Bool = true
    @Binding var selectMode : String
    
    var body: some View {
        //TODO outline the map with the row labels and column outline
        
        ZStack{
            ScrollView([.horizontal, .vertical],showsIndicators: false){
                //Experiment
                //MARK: Show map only if them can be found
                // if let user_css = user_css_core_data_service.user_css_entity{
                if !show_rack_box_view{
                FreezerRackMap(freezer_max_rows: $freezer_max_rows, freezer_max_columns: $freezer_max_columns, freezer_rack_layout: $freezer_rack_layout, target_rack: $target_rack, inner_rack_rect_color: $inner_rack_rect_color, suggested_outline_slot_color: $suggested_outline_slot_color, rack_position_row: $rack_position_row, rack_position_column: $rack_position_column, show_create_new_rack: $show_create_new_rack, showRackProfile: $showRackProfile, showRackFormProfile: $showRackFormProfile, isInCartUtilitiesForm: $isInCartUtilitiesForm)
                    .onChange(of: showRackFormProfile) { newValue in
                        print("Clicked and changed to \(showRackFormProfile)")
                        self.setAndPopulateRackLayout()
                        
                    }
                
            }
                else if show_rack_box_view{
                    box_section
                }
            
        }
        
    }//.background(  NavigationLink(destination: RackProfileView(rack_profile: $target_rack,freezer_profile: self.freezer_profile,isInSearchMode: self.isInSearchMode, inventoryLocations: self.inventoryLocations, addToRackMode: .constant(false)),isActive: $showRackProfile,label: {EmptyView()}))
        
        .onAppear{
            //Get freezer layout
            self.max_capacity = (freezer_profile.freezerCapacityRows ?? 0) * (freezer_profile.freezerCapacityColumns ?? 0)
#warning("Need to fix this")
            //self.user_css_core_data_service.fetchTargetUserCssById(_userCssId: self.stored_user_id)
            if freezer_rack_layout.count > 0{
                print("Interaction \(freezer_rack_layout.first?.freezer_rack_label_slug)")
            }
        }
    }
}

extension GuidedCartInteractFreezerLayout{
    /*
     Data set should match this
     RackProfileView(rack_profile: $target_rack,freezer_profile: self.freezer_profile,isInSearchMode: self.isInSearchMode, inventoryLocations: self.inventoryLocations, addToRackMode: .constant(false))
     */
    //set the view model values to populate the rack box layout
    func setAndPopulateRackLayout(){
        //start
        #warning("Continue debugging next to get the boxes to show up in the cart")
        self.util_vm.rack_profile = target_rack
        
        self.util_vm.freezer_profile = self.freezer_profile
        self.util_vm.isInSearchMode = self.isInSearchMode
        self.util_vm.inventoryLocations = self.inventoryLocations
        self.util_vm.addToRackMode = false
        //fetch the layout of this target rack
        print("In form mode for rack: \(target_rack.freezer_rack_label_slug)")
        print("Rack Slug from VM: \(self.util_vm.rack_profile.freezer_rack_label_slug)")
        
        self.freezer_rack_label_slug = self.util_vm.rack_profile.freezer_rack_label_slug
        
        self.freezer_box_vm.FilterFreezerBoxes(_freezer_rack_label_slug: self.target_rack.freezer_rack_label_slug)
        
        //end
        print("Cart Util VM has been updated")
        self.show_rack_box_view = true
    }
    
    
    private var box_section : some View{
        Section{
            ScrollView([.horizontal,.vertical],showsIndicators: false){
                RackCrossSectView(rack_profile: self.target_rack, rack_boxes: self.$freezer_box_vm.all_filter_rack_boxes, freezer_profile: .constant(self.freezer_profile), current_rack_row: .constant(1),show_guided_box_view: .constant(true),show_guided_rack_view: .constant(false), in_guided_sample_mode: .constant(true), inventoryLocations: self.inventoryLocations,isInSearchMode: false,
                                  freezer_rack_label_slug: freezer_rack_label_slug,selectMode: $selectMode, is_in_select_mode: $is_in_select_mode)
                
                
                // .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
}
