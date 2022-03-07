//
//  CartView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/20/21.
//

import SwiftUI
import Combine
//import CSV as well

#warning("Do return for single result then do multiple")
struct CartView: View {
    @State var show_barcode_scanner : Bool = false
    @State var target_barcodes : [String] = [String]()
    @State var current_barcode : String = ""//esg_e01_19w_0002"//remove after testin
    @State var show_barcode_scanner_btn : Bool = false
    
    @State var show_guided_steps : Bool = false
    @State var show_sample_detail : Bool = false
    
    @State private var selection : String = "Search"
    @State var actions = ["Adding", "Returning", "Search"]
    
    @State private var entry_selection : String = "Search"
    @State var entry_modes = ["Scan", "CSV", "Manual"]
    
    @ObservedObject var box_sample_service : BoxInventorySampleRetrieval = BoxInventorySampleRetrieval()
    @ObservedObject var freezer_profile_service : FreezerProfileRetrieval = FreezerProfileRetrieval()
    @ObservedObject var freezer_rack_service : FreezerRackLayoutService = FreezerRackLayoutService()
    @ObservedObject var freezer_rack_boxes_service : FreezerBoxRetrieval = FreezerBoxRetrieval()
    
    //termpary for fast filter and searching
    @AppStorage(AppStorageNames.all_unfiltered_stored_box_samples.rawValue) var all_unfiltered_stored_box_samples : [InventorySampleModel] = [InventorySampleModel]()
    
    @State var current_target_sample : InventorySampleModel = InventorySampleModel()
    
    //MARK: - Reference Items
    //this is the list that will be used to group all the records by freezer, rack and box
    @AppStorage(AppStorageNames.all_found_box_samples.rawValue) var all_found_box_samples : [InventorySampleModel] = [InventorySampleModel]()
    @AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
    @AppStorage(AppStorageNames.stored_freezer_racks_in_system.rawValue) var stored_freezer_racks_in_system : [RackItemModel] = [RackItemModel]()
    @AppStorage(AppStorageNames.all_stored_rack_boxes_in_system.rawValue) var all_stored_rack_boxes_in_system : [BoxItemModel] = [BoxItemModel]()
    
    
    @StateObject var search_results : FreezerQueriesViewModel = FreezerQueriesViewModel()
    
    @StateObject var target_query : GuidedSearchViewModel = GuidedSearchViewModel()
    
    
    
    //MARK: - New sessions to test the improved search
    @State var freezer_profile : FreezerProfileModel
    @ObservedObject var rack_layout_service : FreezerRackLayoutService = FreezerRackLayoutService()
    // @AppStorage(AppStorageNames.stored_freezer_rack_layout.rawValue) var stored_freezer_rack_layout : [RackItemModel] = [RackItemModel]()
    @State var freezer_rack_layouts : RackItemVm
    @State var show_guided_rack_view : Bool = false
    
    @State var show_guided_map_view : Bool = false
    
    
    @State var show_guided_box_view : Bool = false
    
    //New
    @ObservedObject var carty_query_manager = CartQueryDataService()
    @State var show_cart_view_entry_form : Bool = true
    
  
    
    
    var body: some View {
        //make this into its own separate methos
        
        NavigationView{
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    //Form here
                    if self.show_cart_view_entry_form{
                        cart_view_entry_form
                    }
    
                    
                    Text("\(self.rack_layout_service.freezer_racks.count)")
                    if self.show_guided_map_view{
                        InteractFreezerLayoutPreview(freezer_max_rows: .constant(10), freezer_max_columns: .constant(10), stored_freezer_rack_layout: self.search_results.rack_layout, freezer_profile: self.search_results.freezer_profile, show_guided_rack_view: self.$show_guided_rack_view, show_guided_map_view: self.$show_guided_map_view)
                    }
                    if self.show_guided_rack_view{
                        withAnimation(.spring()) {
                            VStack(alignment: .leading){
                                
                                
                                suggest_rack_layout
                            }
                        }
                    }
                    else if show_guided_box_view
                    {
                        suggest_rack_box_layout
                    }
                    
                    
                    
                    Spacer()
                }
                .navigationBarTitle("Cart")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear{
            //Steps:
            
            //Get all records in database https://metadata.spatialmsk.dev/api/freezer_inventory/inventory/
            //Store them in a temp list
           /* self.box_sample_service.FetchAllInventorySamplesInSystem()
            
            //Fetch All Freezers if stored_freezers is empty or less than 1 stored
            if self.stored_freezers.count < 1{
                self.freezer_profile_service.FetchAllAvailableFreezers(){
                    
                    response in
                    
                    print("Response: \(response)")
                    //update the UI now that the network call is finished
                    
                }
            }*/
            
           /* //Fetch All Racks
            if self.stored_freezer_racks_in_system.count < 1{
                self.freezer_rack_service.FetchAllRacksInSystem()
            }
            //fetch all Boxes
            if self.all_stored_rack_boxes_in_system.count < 1{
                self.freezer_rack_boxes_service.FetchAllRackBoxesInSystem()
            }*/
            
            //as a barcode is added to the list search for the details of the record, where to find it etc
            
            
            
            //when final all is pressed, I should group them by freezer, rack, box
            
            
            //show the position of all the target samples for the freezer, rack and box selected
        }
    }
    
    //Function to keep text length in limits
    func limitText(_ current: String) {
        /* if self.current_barcode.count > upper {
         self.current_barcode = String(self.current_barcode.prefix(upper))
         }*/
        
        
    }
    
    //TODO: - Will need a Background thread to do this eventually
    func FindingAndGroupSampleInList(_barcodes : [String]){
  
        //get the barcodes
        //place this in a loop (check if we could get a bulk qery to return all the results grouped?)
        for barcode in _barcodes{
            self.carty_query_manager.FetchInventoryLocation(_sample_barcode: barcode) { response in
                
                
                print("Response \(response.serverMessage)")
            }
            
        }
        
        
        
        //MARK: - Grouping Records by Freezer -> Rack -> Box - End
    }
    
    func removeDuplicateFreezerLabels(freezers: [FreezerQueryViewModel]) -> [FreezerQueryViewModel] {
        var uniqueFreezers = [FreezerQueryViewModel]()
        for freezer in freezers {
            if !uniqueFreezers.contains(where: {$0.freezer_label == freezer.freezer_label }) {
                uniqueFreezers.append(freezer)
            }
        }
        return uniqueFreezers
    }
    
    func removeDuplicateRackLabels(racks: [FreezerQueryViewModel]) -> [FreezerQueryViewModel] {
        var uniqueRacks = [FreezerQueryViewModel]()
        for rack in racks {
            if !uniqueRacks.contains(where: {$0.freezer_rack_label == rack.freezer_rack_label }) {
                uniqueRacks.append(rack)
            }
        }
        return uniqueRacks
    }
    
    func removeDuplicateBoxLabels(boxes: [FreezerQueryViewModel]) -> [FreezerQueryViewModel] {
        var uniqueBoxes = [FreezerQueryViewModel]()
        for box in boxes {
            if !uniqueBoxes.contains(where: {$0.freezer_box_label == box.freezer_box_label }) {
                uniqueBoxes.append(box)
            }
        }
        return uniqueBoxes
    }
    
    func TranslateSampleData(_target : InventorySampleModel){
        self.current_target_sample.sample_barcode = _target.sample_barcode
        self.current_target_sample.created_datetime = _target.created_datetime
        self.current_target_sample.created_by = _target.created_by
        self.current_target_sample.freezer_box = _target.freezer_box
        self.current_target_sample.freezer_inventory_column = _target.freezer_inventory_column
        self.current_target_sample.freezer_inventory_row = _target.freezer_inventory_row
        
        self.current_target_sample.freezer_inventory_slug = _target.freezer_inventory_slug
        
        self.current_target_sample.freezer_inventory_type = _target.freezer_inventory_type
        self.current_target_sample.freezer_inventory_status = _target.freezer_inventory_status
        self.current_target_sample.modified_datetime = _target.modified_datetime
        
    }
    
}


struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        var freezer_rack_layouts : RackItemVm = RackItemVm()
        
        var rack_1 = RackItemModel()
        //  rack_1.css_text_color = "white"
        //  rack_1.css_background_color = "orange"
        rack_1.freezer_rack_label = "Rk_R1_C2"
        rack_1.freezer_rack_row_start = 1
        rack_1.freezer_rack_row_end = 1
        rack_1.freezer_rack_depth_start = 1
        rack_1.freezer_rack_depth_end = 10
        rack_1.freezer_rack_column_start = 1
        rack_1.freezer_rack_column_end = 1
        
        freezer_rack_layouts.rack_layout.append(rack_1)
        
        var rack_2 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_2.freezer_rack_label = "Rk_R2_C2"
        rack_2.freezer_rack_row_start = 2
        rack_2.freezer_rack_row_end = 2
        rack_2.freezer_rack_depth_start = 2
        rack_2.freezer_rack_depth_end = 10
        rack_2.freezer_rack_column_start = 2
        rack_2.freezer_rack_column_end = 2
        
        freezer_rack_layouts.rack_layout.append(rack_2)
        
        //suggested position
        var rack_3 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_3.is_suggested_rack_position = true
        rack_3.freezer_rack_label = "Rk_R2_C5"
        rack_3.freezer_rack_row_start = 0
        rack_3.freezer_rack_row_end = 0
        rack_3.freezer_rack_column_start = 0
        rack_3.freezer_rack_column_end = 0
        rack_3.freezer_rack_depth_start = 5
        rack_3.freezer_rack_depth_end = 10
        
        
        freezer_rack_layouts.rack_layout.append(rack_3)
        
        var rack_4 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_4.is_suggested_rack_position = true
        rack_4.freezer_rack_label = "Rk_R2_C4"
        rack_4.freezer_rack_row_start = 0
        rack_4.freezer_rack_row_end = 0
        rack_4.freezer_rack_column_start = 0
        rack_4.freezer_rack_column_end = 0
        rack_4.freezer_rack_depth_start = 5
        rack_4.freezer_rack_depth_end = 10
        
        freezer_rack_layouts.rack_layout.append(rack_4)
        
        var rack_5 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_5.is_suggested_rack_position = true
        rack_5.freezer_rack_label = "Rk_R2_C6"
        rack_5.freezer_rack_row_start = 4
        rack_5.freezer_rack_row_end = 4
        rack_5.freezer_rack_column_start = 0
        rack_5.freezer_rack_column_end = 0
        rack_5.freezer_rack_depth_start = 5
        rack_5.freezer_rack_depth_end = 10
        
        freezer_rack_layouts.rack_layout.append(rack_5)
        
        
        var freezer_profile = FreezerProfileModel()
        freezer_profile.freezerLabel = "Test Freezer 1"
        freezer_profile.freezerDepth = "10"
        freezer_profile.freezerLength = "110"
        freezer_profile.freezerCapacityColumns = 10
        freezer_profile.freezerCapacityRows = 10
        freezer_profile.freezerRoomName = "Murray 313"
        
        // return FreezerDetailView(freezer_profile: freezer_profile, freezer_rack_layouts: .constant(freezer_rack_layouts))
        
        /* return Group{
         ForEach(ColorScheme.allCases, id: \.self, content:  CartView(freezer_profile: freezer_profile, freezer_rack_layouts: freezer_rack_layouts)
         .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
         .previewDisplayName("iPhone 13").preferredColorScheme)
         
         ForEach(ColorScheme.allCases, id: \.self, content:  CartView(freezer_profile: freezer_profile, freezer_rack_layouts: freezer_rack_layouts)
         .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
         .previewDisplayName("iPhone 13 Pro Max").preferredColorScheme)
         ForEach(ColorScheme.allCases, id: \.self, content:  CartView(freezer_profile: freezer_profile, freezer_rack_layouts: freezer_rack_layouts)
         .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
         .previewDisplayName("iPad Air (4th generation)").preferredColorScheme)
         
         ForEach(ColorScheme.allCases, id: \.self, content:  CartView(freezer_profile: freezer_profile, freezer_rack_layouts: freezer_rack_layouts)
         .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
         .previewDisplayName("iPad Air (4th generation)").preferredColorScheme)
         .previewInterfaceOrientation(.landscapeLeft)
         }*/
        
        return Group{
            CartView(freezer_profile: freezer_profile, freezer_rack_layouts: freezer_rack_layouts)
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                .previewDisplayName("iPhone 13 Pro")//.preferredColorScheme()
            /*CartView(freezer_profile: freezer_profile, freezer_rack_layouts: freezer_rack_layouts)
             .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
             .previewDisplayName("iPhone 13 Pro Max")//.preferredColorScheme)
             
             CartView(freezer_profile: freezer_profile, freezer_rack_layouts: freezer_rack_layouts)
             .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
             .previewDisplayName("iPad Air (4th generation)")//.preferredColorScheme)
             .previewInterfaceOrientation(.landscapeLeft)*/
            
            
        }
    }
}

class GuidedSearchViewModel : ObservableObject{
    @Published var unique_freezers : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    @Published var unique_racks : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    @Published var unique_boxes : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    
    @Published var samples : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    
}

///Freezer Inquery View Model
//Model to store the current
class FreezerQueriesViewModel : ObservableObject{
    @Published var freezer_queries : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    
#warning("Dummy Data")
    //  var freezer_rack_layouts : RackItemVm = RackItemVm()
    @Published var current_rack_profile : RackItemModel = RackItemModel()
    @Published var rack_layout : [RackItemModel] = [RackItemModel]()
    @Published var freezer_profile = FreezerProfileModel()
    @Published var rack_boxes : [BoxItemModel] = [BoxItemModel]()
    @Published var current_rack_box : BoxItemModel = BoxItemModel()
    @Published var current_box_samples : [InventorySampleModel] = [InventorySampleModel]()
    
    init(){
        LoadDummyData()
    }
    
    func LoadDummyData(){
        //MARK: All the details needed to make this view work
        var rack_1 = RackItemModel()
        //  rack_1.css_text_color = "white"
        //  rack_1.css_background_color = "orange"
        rack_1.freezer_rack_label = "Rk_R1_C2"
        rack_1.freezer_rack_row_start = 1
        rack_1.freezer_rack_row_end = 1
        rack_1.freezer_rack_depth_start = 1
        rack_1.freezer_rack_depth_end = 10
        rack_1.freezer_rack_column_start = 1
        rack_1.freezer_rack_column_end = 1
        
        self.rack_layout.append(rack_1)
        
        var rack_2 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_2.freezer_rack_label = "Rk_R2_C2"
        rack_2.freezer_rack_row_start = 2
        rack_2.freezer_rack_row_end = 2
        rack_2.freezer_rack_depth_start = 2
        rack_2.freezer_rack_depth_end = 10
        rack_2.freezer_rack_column_start = 2
        rack_2.freezer_rack_column_end = 2
        
        self.rack_layout.append(rack_2)
        
        //suggested position
        var rack_3 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_3.is_suggested_rack_position = true
        rack_3.freezer_rack_label = "Rk_R2_C5"
        rack_3.freezer_rack_row_start = 0
        rack_3.freezer_rack_row_end = 0
        rack_3.freezer_rack_column_start = 0
        rack_3.freezer_rack_column_end = 0
        rack_3.freezer_rack_depth_start = 5
        rack_3.freezer_rack_depth_end = 10
        
        
        self.rack_layout.append(rack_3)
        
        var rack_4 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_4.is_suggested_rack_position = true
        rack_4.freezer_rack_label = "Rk_R2_C4"
        rack_4.freezer_rack_row_start = 0
        rack_4.freezer_rack_row_end = 0
        rack_4.freezer_rack_column_start = 0
        rack_4.freezer_rack_column_end = 0
        rack_4.freezer_rack_depth_start = 5
        rack_4.freezer_rack_depth_end = 10
        
        self.rack_layout.append(rack_4)
        
        var rack_5 = RackItemModel()
        // rack_2.css_text_color = "white"
        //rack_2.css_background_color = "orange"
        rack_5.is_suggested_rack_position = true
        rack_5.freezer_rack_label = "Rk_R2_C6"
        rack_5.freezer_rack_row_start = 4
        rack_5.freezer_rack_row_end = 4
        rack_5.freezer_rack_column_start = 0
        rack_5.freezer_rack_column_end = 0
        rack_5.freezer_rack_depth_start = 5
        rack_5.freezer_rack_depth_end = 10
        
        self.rack_layout.append(rack_5)
        
        
        var freezer = FreezerProfileModel()
        freezer.freezerLabel = "Test Freezer 1"
        freezer.freezerDepth = "10"
        freezer.freezerLength = "110"
        freezer.freezerCapacityColumns = 10
        freezer.freezerCapacityRows = 10
        freezer.freezerRoomName = "Murray 313"
        
        self.freezer_profile = freezer
        
        //current rack profile
        var cur_rack_profile : RackItemModel = RackItemModel()
        
        cur_rack_profile.freezer_rack_depth_end = 1
        cur_rack_profile.freezer_rack_depth_start = 1
        cur_rack_profile.freezer_rack_column_start = 0
        cur_rack_profile.freezer_rack_column_end = 1
        cur_rack_profile.freezer_rack_row_start = 1
        cur_rack_profile.freezer_rack_row_end = 5
        cur_rack_profile.created_by = "keijaoh.campbell@maine.edu"
        cur_rack_profile.freezer = "Freezer_Test_1"
        cur_rack_profile.freezer_rack_label = "Freezer_Test_1_Rack_1"
        
        self.current_rack_profile =  cur_rack_profile
        
        //rack details
        var box = BoxItemModel()
        box.id = 1
        box.freezer_box_label = "rack_1_1_box_1"
        box.freezer_box_capacity_row = 10
        box.freezer_box_capacity_column = 10 //row x col equal max capacity
        self.rack_boxes.append(box)
        
        
        var box2 = BoxItemModel()
        box2.id = 2
        box2.is_suggested_box_position = true
        box2.freezer_box_label = "rack_1_1_box_2"
        box2.freezer_box_capacity_row = 10
        box2.freezer_box_capacity_column = 10 //row x col equal max capacity
        self.rack_boxes.append(box2)
        
        
        //current box current_rack_box
        
        var curr_box = BoxItemModel()
        curr_box.id = 2
        //curr_box.is_suggested_box_position = true
        curr_box.freezer_box_label = "rack_1_1_box_2"
        curr_box.freezer_box_capacity_row = 10
        curr_box.freezer_box_capacity_column = 10 //row x col equal max capacity
        
        self.current_rack_box = curr_box
        
        
        //samples
        var sample = InventorySampleModel()
        sample.id = 1
        // sample.created_by = String(Date())
        sample.freezer_box = "rack_1_1_box_2"
        sample.freezer_inventory_column = 0
        sample.freezer_inventory_row = 0
        sample.freezer_inventory_status = "filter"
        sample.sample_barcode = "ESG_00023"
        sample.is_suggested_sample = true
        current_box_samples.append(sample)
        
        
        var sample2 = InventorySampleModel()
        sample2.id = 2
        // sample2.created_by = String(Date())
        sample2.freezer_box = "rack_1_1_box_2"
        sample2.freezer_inventory_column = 3
        sample2.freezer_inventory_row = 0
        sample2.freezer_inventory_status = "filter"
        sample2.sample_barcode = "ESG_00023"
        sample2.is_suggested_sample = true
        
        current_box_samples.append(sample2)
        
        var sample3 = InventorySampleModel()
        sample3.id = 3
        // sample3.created_by = String(Date())
        sample3.freezer_box = "rack_1_1_box_2"
        sample3.freezer_inventory_column = 6
        sample3.freezer_inventory_row = 0
        sample3.freezer_inventory_status = "filter"
        sample3.sample_barcode = "ESG_00023"
        sample3.is_suggested_sample = false
        
        current_box_samples.append(sample3)
        
    }
    
    
}

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





//Returning


//Adding appears here



//grouping extension


extension CartView{
    
    //the query form
    
    private var cart_view_entry_form : some View{
        VStack(alignment: .center){
#warning("Can switch between Barcode or CSV to do the bulk search, add or return")
            
            MenuStyleClicker(selection: self.$entry_selection, actions: self.$entry_modes, label: "Entry Mode").frame(width: 200)
            MenuStyleClicker(selection: self.$selection, actions: self.$actions).frame(width: 200)
            
            barcode_query_section
            
            // Text("View to bulk return samples and bulk find samples in the freezer")
            if self.target_barcodes.count > 0{
                VStack(alignment: .leading){
                    Section{
                        
                        #warning("MAKE REUSEABLE")
                        Section{
                            
                            Text("Target Barcodes").bold()
                            //Add swipe left to delete
                            //swipe right to get details about the target barcode (search the db to find data on it)
                            List( self.target_barcodes, id: \.self){barcode in
                                Text("\(barcode)")
                                    .swipeActions(edge: .leading){
                                        Button(action: {
                                            //clear temp container
                                            //  self.current_target_sample = InventorySampleModel() //deallocate object and reset it
                                            
                                            //will show the details of this item what ever was found
                                            //Capture the current value
                                            if let target = self.all_unfiltered_stored_box_samples.filter({sample in return sample.sample_barcode == barcode}).first{
                                                
                                                //Translator Func
                                                self.TranslateSampleData(_target: target)
                                                
                                            }
                                            else{
                                                self.current_target_sample.sample_barcode = "" //deallocate object and reset it
                                            }
                                            self.show_sample_detail.toggle()
                                        }, label:{
                                            HStack{
                                                Image(systemName: "info.circle")
                                                
                                            }
                                        }).tint(.blue)
                                        
                                        
                                        
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(action: {
                                            //remove from list
                                            if let target_code = self.target_barcodes.firstIndex(of: barcode)
                                            {
                                                print("Index \(target_code)")
                                                self.target_barcodes.remove(at: target_code)
                                            }
                                            //    let box_sample : InventorySampleModel = freezer_box_sample_locals.filter{log in return log.freezer_inventory_slug == _freezer_inventory_slug}.first!//results from the db
                                        }, label:{
                                            HStack{
                                                Image(systemName: "trash")
                                                
                                            }
                                        }).tint(.red)
                                        
                                    }
                            }
                            
                        }.animation(.spring(), value: 2)
                    }
                    
                }.frame(height: 200)
                
            }
            
            Button(action: {
                //actions todo
                //show guided tour
                self.show_guided_steps.toggle()
                self.FindingAndGroupSampleInList(_barcodes: self.target_barcodes)
                
            }, label: {
                HStack{
                    Text("Find all (\(self.target_barcodes.count)) Samples" )
                }.padding()
            }).background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10)
            
            
            //Text("  \(self.selection)")
            //show_guided_steps and the mode
           // CartResultsView(show_guided_steps: self.$show_guided_steps, selection: self.selection, inventory_location_results: self.$carty_query_manager.inventory_location_results)
            cart_results_view_section
            
            
            
            
            
            
        }.sheet(isPresented: self.$show_sample_detail){
            VStack(alignment: .leading){
                Text("Barcode: \(self.current_target_sample.sample_barcode)")
                if !self.current_target_sample.sample_barcode.isEmpty{
                    SampleHeaderView(sample_detail: self.$current_target_sample)
                    
                }
                else{
                    Text("No Data could be found on Sample")
                }
            }.padding()
        }
        
    }
    
    
    private var barcode_query_section : some View{
        
        HStack(alignment: .bottom){
            TextFieldLabelCombo(textValue: self.$current_barcode, label: "Barcode", placeHolder: "Enter barcode or press barcode button", iconValue: "number")
                .onReceive(Just(self.current_barcode)) { inputValue in
                    // With a little help from https://bit.ly/2W1Ljzp
                    if self.current_barcode.count > 1 {
                        self.show_barcode_scanner_btn = false
                    }
                    else{
                        show_barcode_scanner_btn = true
                    }
                }
            
            if show_barcode_scanner_btn{
                withAnimation{
                    VStack{
                        BarcodeScannerBtn(show_barcode_scanner: self.$show_barcode_scanner, target_barcodes: self.$target_barcodes, current_barcode: self.$current_barcode, show_barcode_scanner_btn: self.$show_barcode_scanner_btn)
                        
                        Spacer().frame(height: 16)
                    }
                }
            }
            else{
                withAnimation{
                    VStack{
                        Button(action: {
                            //add value to the list and clear field
                            self.target_barcodes.append(self.current_barcode)
                            
                            //clear field
                            self.current_barcode.removeAll()
                            
                        }, label: {
                            HStack{
                                Image(systemName: "plus")//.foregroundColor(.white).background(Color.blue)//.padding()
                                
                            }.padding().foregroundColor(Color.white)
                        })
                            .cornerRadius(10)
                            .background(Color.blue)
                        
                        Spacer().frame(height: 16)
                        
                    }
                }
            }
            
        }.padding(.horizontal,9)
    }
    
    
    
    //the Suggested Search Rack Layout
    private var suggest_rack_layout : some View{
        
        Section{
            Text("Show Rack Layout with guided view")
            Text("Freezer Profile: \(self.$search_results.freezer_profile.freezerLabel.wrappedValue ?? "")")
            Text("Rack Profile: \(self.$search_results.current_rack_profile.freezer_rack_label.wrappedValue ?? "")")
            Text("Box Count: \(self.search_results.rack_boxes.count)")
            
            ScrollView([.horizontal,.vertical],showsIndicators: false){
                RackCrossSectView(rack_profile: self.search_results.current_rack_profile, rack_boxes: self.$search_results.rack_boxes, freezer_profile: .constant(self.freezer_profile),show_guided_box_view: self.$show_guided_box_view, show_guided_rack_view: self.$show_guided_rack_view)
                // .frame(width: UIScreen.main.bounds.width) show_guided_rack_view
            }
        }
    }
    
    //
    
    private var suggest_rack_box_layout : some View{
        //box layout
        BoxSampleMapView(stored_rack_box_layout: self.search_results.current_rack_box, stored_box_samples: self.search_results.current_box_samples, freezer_profile: self.freezer_profile)
    }
    
    
    
    
   // struct CartResultsView : View{

       private var cart_results_view_section : some View{
            VStack{
                if !self.show_guided_steps {
                    Section{
                        // Text("\(String(self.show_guided_steps)) <-> \(self.selection )")
                        Image("empty_card").resizable().frame(width: 400, height: 400, alignment: .center)
                        
                    }
                }
                else if/* self.show_guided_steps &&*/ self.selection == "Search"
                {
                    withAnimation{
                        VStack{
                            Text("Search Mode Guided View")
                            //Find the records in the list by searching the db
                            //SHow the start of the freezers found
                           // Text("Guided Items Count \(self.queries.freezer_queries.count)")

                            //MARK: - CONTINUE HERE
                            Text("Freezers").font(.callout).bold()
                            List{
                                ForEach(self.carty_query_manager.inventory_location_results, id: \.id){ query in
                                    //NavigationLink(destination: EmptyView() /*GuidedSearchSampleView(target_sample_query: query)*/){
                                        HStack{
                                            if let box = query.freezerBox{
                                                if let rack = box.freezer_rack{
                                                //
                                                
                                                    if let freezer = rack.freezer{
                                                        Text(" \(freezer.freezerLabel ?? "")").font(.subheadline).foregroundColor(.secondary)
                                                    }
                                                }
                                            }
                                            
                                        }.onTapGesture {
                                           // #warning("Show the Map")
                                            self.show_guided_map_view.toggle()
                                            //hide this section
                                            self.show_cart_view_entry_form = false
                                            
                                            
                                        }
                                    //} 0.644
                                }
                            }.frame(width: UIScreen.main.bounds.size.width - 10, height: 300, alignment: .center)
                        }
                    }
                }
                else if self.show_guided_steps && self.selection == "Adding"
                {
                    withAnimation{
                        Text("Adding Mode Guided View")
                    }
                }
                else if self.show_guided_steps && self.selection == "Returning"
                {
                    withAnimation{
                        Text("Returning Mode Guided View")
                    }
                }
            }
        }
   // }
    
}
