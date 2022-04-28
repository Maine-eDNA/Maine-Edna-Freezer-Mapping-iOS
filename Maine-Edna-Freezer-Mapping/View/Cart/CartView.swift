//
//  CartView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/20/21.
//

import SwiftUI
import Combine
//import CSV as well
/*
 MARK: TODO List
 be able to add
 freezer
 rack
 box
 samples
 
 move samples by next week
 */
/*
 TODO this week
 
 Change the mode options to ve "Add", "Remove", "Transfer Box" to "Add", "Remove", "Move"
 Melissa Kimble to Everyone (3:13 PM)
 Change "Transfer Box" to "Transfer Box"
 */

#warning("Need to make the Adding Action work that suggests a freezer and rack,box and sample positions, give the user the ability to select a different position, if the spot is already taken, ask the user to select a new position for the existing sample to make it to a new position then put the new suggested sample into ht e position you had clicked. Can cancel the process")

#warning("Add the ability to add a CSV and read it into the app to do bulk activities")
struct CartView: View {
    
    /*
     TODO need to remove the character garbase from the scan
     */
    
    @State var show_barcode_scanner : Bool = false
    @State var target_barcodes : [String] = [String]()
    @State var current_barcode : String = ""//esg_e01_19w_0002"//remove after testin
    @State var show_barcode_scanner_btn : Bool = false
    
    @State var show_guided_steps : Bool = false
    @State var show_sample_detail : Bool = false
    
    @State private var selection : String = "Search"
    @State var actions = ["Add", "Remove", "Search", "Transfer Box"]
    
    @State private var entry_selection : String = "Scan"
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
    
    
    // @StateObject var search_results : FreezerQueriesViewModel = FreezerQueriesViewModel()
    
    @StateObject var target_query : GuidedSearchViewModel = GuidedSearchViewModel()
    
    
    
    //MARK: - New sessions to test the improved search
    @State var freezer_profile : FreezerProfileModel
    @ObservedObject var rack_layout_service : FreezerRackLayoutService = FreezerRackLayoutService()
    // @AppStorage(AppStorageNames.stored_freezer_rack_layout.rawValue) var stored_freezer_rack_layout : [RackItemModel] = [RackItemModel]()
    // @State var freezer_rack_layouts : RackItemVm
    @State var show_guided_rack_view : Bool = false
    
    @State var show_guided_map_view : Bool = false
    
    
    @State var show_guided_box_view : Bool = false
    
    
    
    
    //New
    //@ObservedObject var carty_query_manager = CartQueryDataService()
    @ObservedObject var cartQueryDataService = CartQueryDataService()
    @StateObject var vm : CartViewModel = CartViewModel()
    @State var show_cart_view_entry_form : Bool = true
    
    @State var target_freezer : FreezerProfileModel
    
    
    @StateObject var freezer_vm : FreezerViewModel = FreezerViewModel()
    @StateObject var rack_vm : FreezerRackViewModel = FreezerRackViewModel()
    
    
    @State var addDestinationFreezer : FreezerProfileModel = FreezerProfileModel()
    @State var showAddToFreezerOptions : Bool = true
    
    @State var showBulkAddToFreezerForm : Bool = false
    @State var targetAddToFreezerRack : RackItemModel = RackItemModel()
    @State var samplesToAddToBox : [InventoryLocationResult] = [InventoryLocationResult]()
    @State var showTargetRackToAdd : Bool = false
    
    @StateObject var box_vm : FreezerBoxViewModel = FreezerBoxViewModel()
    
    
    var body: some View {
        //make this into its own separate methos
        
        NavigationView{
            ZStack{
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading){
                        //Form here
                        if self.show_cart_view_entry_form{
                            cart_view_entry_form
                        }
                        
                        /*   HStack{
                         Button {
                         withAnimation(.easeInOut){
                         self.show_guided_map_view.toggle()
                         self.show_cart_view_entry_form.toggle()
                         }
                         } label: {
                         HStack{
                         Text("go back")
                         }.padding()
                         }
                         .background(Color.blue)
                         .foregroundColor(Color.white)
                         
                         }*/
                        // Text("\(self.rack_layout_service.freezer_racks.count)")
                        
                        
                        
                        
                        Spacer()
                    }
                    .navigationBarTitle("Cart")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }.background(
                
                
                NavigationLink(destination: InteractFreezerLayoutPreview(freezer_max_rows:   .constant(target_freezer.freezerCapacityRows ??  0), freezer_max_columns:   .constant(target_freezer.freezerCapacityColumns ?? 0), freezer_rack_layout: self.$vm.rack_layout, freezer_profile: target_freezer, show_guided_rack_view: self.$show_guided_rack_view, show_guided_map_view: self.$show_guided_map_view,inventoryLocations: self.vm.inventoryLocations,isInSearchMode: true),isActive: self.$show_guided_map_view,  label: {EmptyView()})
            )
            
            .background(
                
                
                NavigationLink(destination: RackProfileView(rack_profile: self.$targetAddToFreezerRack, freezer_profile: self.addDestinationFreezer, showNerdRackStats: false, isInSearchMode: true, inventoryLocations: self.samplesToAddToBox),isActive: self.$showTargetRackToAdd,  label: {EmptyView()})
            )
            
            /*
             
             NavigationLink(destination: RegistryItemDetail(registry: self.$currentRegistryItem),isActive: self.$showWeddingRegistryItem,  label: {EmptyView()})
             */
            
            /*
             if /*self.show_guided_map_view &&*/ self.vm.inventoryLocations.count > 0{
             if let freezer = self.vm.currentFreezerProfile{
             InteractFreezerLayoutPreview(freezer_max_rows:   .constant(freezer.freezerCapacityRows ??  0), freezer_max_columns:   .constant(freezer.freezerCapacityColumns ?? 0), freezer_rack_layout: self.$vm.rack_layout, freezer_profile: freezer, show_guided_rack_view: self.$show_guided_rack_view, show_guided_map_view: self.$show_guided_map_view,inventoryLocations: self.vm.inventoryLocations,isInSearchMode: true)//is in search mode
             
             
             }
             }
             if self.show_guided_rack_view{
             withAnimation(.easeInOut) {
             VStack(alignment: .leading){
             
             
             suggest_rack_layout
             }
             }
             }
             else if show_guided_box_view
             {
             suggest_rack_box_layout
             }
             */
            
        }
        .onAppear{
            
        }
    }
    
    
    
    //TODO: - Will need a Background thread to do this eventually
    func FindingAndGroupSampleInList(_barcodes : [String]){
        
        //get the barcodes
        //place this in a loop (check if we could get a bulk qery to return all the results grouped?)
        if _barcodes.count > 1{
            let commaSeparatedBarcodes = _barcodes.joined(separator: ",")
            
            //let commaSeparatedBarcodesLowercase = commaSeparatedBarcodes.lowercased()
            self.vm.FetchInventoryLocation(_sample_barcodes: commaSeparatedBarcodes)
        }
        else{
            if let single_barcode = _barcodes.first{
                self.vm.FetchSingleInventoryLocation(_sample_barcode: single_barcode,_isAddToListMode: true)
            }
        }
        
        //MARK: - Grouping Records by Freezer -> Rack -> Box - End
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
            CartView(freezer_profile: freezer_profile, target_freezer: FreezerProfileModel())
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
    
    private var selectfreezersection : some View{
        Section{
            
            VStack(alignment: .leading){
                Text(addDestinationFreezer.freezerLabel ?? "")
                HStack{
                    Text("Please select your freezer")
                    
                    
                    if !showAddToFreezerOptions{
                        withAnimation {
                            Button(action: {
                                //show the list
                                self.showAddToFreezerOptions = true
                            }, label: {
                                HStack{
                                    Text("Change Destination")
                                        .fontWeight(.medium)
                                        .font(.caption2)
                                        .foregroundColor(Color.theme.secondaryText)
                                        .padding()
                                        .border(Color.theme.secondaryText, width: 2)
                                }
                            })
                        }
                    }
                    
                }
                if showAddToFreezerOptions{
                    withAnimation {
                        List{
                            // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
                            
                            ForEach(self.freezer_vm.allFreezers, id: \.id) { freezer in
                                //change to use on tap instead
                                //change this out later have a method to finds all the racks in a freezer then get all the boxes in the target racks
                                //destination TargetBoxToMoveView with all boxes in the target freezer
                                
                                //Freezer cards
                                
                                FreezerProfileCardView(freezer_profile: freezer)
                                    .background(.clear)
                                    .onTapGesture {
                                        addDestinationFreezer = freezer
                                        
                                        withAnimation {
                                            //hide the list
                                            self.showAddToFreezerOptions = false
                                            
                                            //show the option to
                                            self.showBulkAddToFreezerForm = true
                                        }
                                    }
                                
                                
                            }
                            
                        }.listStyle(PlainListStyle())
                            .frame(width: UIScreen.main.bounds.width * 0.90, height: 300)
                    }
                }
                
                //the scene to enter bulk samples and add them to the target freezer
                if self.showBulkAddToFreezerForm{
                    withAnimation {
                        add_to_freezer_barcode_query_section
                    }
                }
            }
            
        }
        
    }
    
    private var add_to_freezer_barcode_query_section : some View{
        VStack{
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
            }
            
            VStack(alignment: .leading){
                
                Button(action: {
                    //find the racks and boxes that is available
                    //get all racks within target freezer
                    //MARK: Let user know no rack layout was found, need to give the user the abilbilty to specify the freezer layout (quick menu to create new layout without leaving the screen)
                    //clear the old list
                    withAnimation {
                        self.rack_vm.freezer_racks_with_stat.removeAll()
                    }
                    
                    rack_vm.FindRackLayoutByFreezerLabel(_freezer_label: addDestinationFreezer.freezerLabel ?? "")
                    
                }, label: {
                    Text("Suggest Freezer Placement")
                        .padding()
                        .foregroundColor(.white)
                }).background(Color.teal)
                
                //show suggested racks here and the capacity of each rack
                Text("Available Racks")
                if self.rack_vm.freezer_racks.count > 0{
                    List{
                        ForEach(self.rack_vm.freezer_racks_with_stat, id: \.id){ rack in
#warning("NEXT TODO")
                            //MARK: Need to show the rack capacity (how many boxes in the rack , how many of the boxes are not full (have space and amount of spaces)
                            //MARK: Need a method that get the following information compile it into the list which has all the reporting information below
                            //Get rack info /api/freezer_inventory/rack/
                            //Get boxes in rack https://metadata.spatialmsk.dev/api/freezer_inventory/box/
                            //get information about samples in each box /api/freezer_inventory/inventory/{id}/
                            
                            //MARK: Refractor this so that its reusable
                            VStack(alignment: .leading){
                                Text(rack.freezer_rack_label).font(.subheadline).foregroundColor(Color.primary).bold()
                                
                                
                                HStack(spacing: 10){
                                    //Number of boxes in this rack at max capacity
                                    
                                    HStack{
                                        Text("Box Capacity:").font(.caption).foregroundColor(Color.theme.secondaryText)
                                        Text("\(rack.box_capacity_of_rack)").font(.subheadline).foregroundColor(Color.primary).bold()
                                    }
                                    
                                    //need to know how many boxes are found within this rack
                                    HStack{
                                        Text("Boxes in Use:").font(.caption).foregroundColor(Color.theme.secondaryText)
                                        Text("\(rack.number_of_boxes_in_use)").font(.subheadline).foregroundColor(Color.primary).bold()
                                    }
                                    
                                    HStack{
                                        Text("Empty Boxes:").font(.caption).foregroundColor(Color.theme.secondaryText)
                                        Text("\(calulateEmptyBoxes(rack: rack))").font(.subheadline).foregroundColor(Color.primary).bold()
                                    }
                              
                                }
                            }
                            
                            .background(Color.clear)
                            .onTapGesture {
                                //go to another screen which shows the items inside the rack and the suggested box
                                //MARK: Must click a rack, to get the full stats like how many spaces are left in each Box (example 55%)
#warning("TODO after the above")
                                /*
                                 
                                 MARK: populate the following
                                 @State var  : RackItemModel = RackItemModel()
                                 @State var samplesToAddToBox : [InventoryLocationResult] = [InventoryLocationResult]()
                                 
                                 */
                                #warning("TODO and need to start story the constants locally")
                                //MARK: Note that on the rack level I would like to show the capacity of each box (how much of each is full, example 10/15 spaces are occupied)
                                self.targetAddToFreezerRack = rack
                                
                                
                                self.showTargetRackToAdd.toggle()
                            }
                            
                        }
                    }.frame(width: UIScreen.main.bounds.width * 0.90, height: 300)
                    
                }
                else{
                    Text("No Layout was found, would you like to add a new Layout for \(addDestinationFreezer.freezerLabel ?? "")")
                }
            }
            
        }.padding(.horizontal,9)
    }
    
    
  
    ///Finding the number of empty boxes
    func calulateEmptyBoxes(rack : RackItemModel) -> Int{
        return (rack.box_capacity_of_rack - rack.number_of_boxes_in_use)
    }
    
    //the query form
    
    private var cart_view_entry_form : some View{
        //MARK: Use Geometric reader
        VStack(alignment: .center){
#warning("Can switch between Barcode or CSV to do the bulk search, add or return")
            
            
            MenuStyleClicker(selection: self.$entry_selection, actions: self.$entry_modes, label: "Entry Mode",label_action: self.$entry_selection).frame(width: 200)
            
            
            
            MenuStyleClicker(selection: self.$selection, actions: self.$actions,label: "Action",label_action: self.$selection).frame(width: 200)
            
            Section{
                if selection == "Transfer Box"{
                    //  GeometryReader { geometry in
                    Section{
                        withAnimation(.easeInOut){
                            
                            VStack{
                                
                                moving_box_section
                                    .frame(width: UIScreen.main.bounds.size.width * 0.90, height: 600)
                                
                            }
                        }
                        
                    }
                    //    }
                    
                    .padding()
                    
                }
                else if selection == "Add"{
                    withAnimation {
                        selectfreezersection
                    }
                }
                else{
                    barcode_query_section
                }
            }.padding()
            
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
                                HStack{
                                    Text("\(barcode)")
                                    if self.show_guided_steps{
                                        withAnimation(.easeInOut){
                                            Image(systemName: (self.vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode}) != nil) ? "checkmark.circle" : "xmark.circle")
                                                .foregroundColor(((self.vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode})) != nil) ? Color.green : Color.red)
                                        }
                                        
                                    }
                                    
                                }
                                .swipeActions(edge: .leading){
                                    Button(action: {
                                        
                                        
                                        
                                        vm.FetchSingleInventoryLocation(_sample_barcode: barcode,_isAddToListMode: false)
                                        
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
                            }.listStyle(.plain)
                            
                        }.animation(.spring(), value: 2)
                            .padding(.horizontal,10)
                    }
                    
                }.frame(height: 200)
                
            }
            
            Button(action: {
                //actions todo
                //show guided tour
                self.show_guided_steps = true//.toggle()
                self.FindingAndGroupSampleInList(_barcodes: self.target_barcodes)
                
            }, label: {
                HStack{
                    Text("Find all (\(self.target_barcodes.count)) Samples" )
                }.padding()
            }).background(Color.green)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .opacity(self.target_barcodes.count > 0 ? 1 : 0.5)
                .disabled(self.target_barcodes.count > 0 ? false : true)
            
            //Text("  \(self.selection)")
            //show_guided_steps and the mode
            // CartResultsView(show_guided_steps: self.$show_guided_steps, selection: self.selection, inventory_location_results: self.$carty_query_manager.inventory_location_results)
            cart_results_view_section
            
            
            
            
            
            
        }.sheet(isPresented: self.$show_sample_detail){
            /* VStack{
             #warning("Design a screen that shows the details about the target sample as to where to find it ")
             Text("Target Barcode details")
             Text(vm.inventoryLocation.freezerBox?.freezer_box_label ?? "")
             }*/
            ResultsPreviewView(inventoryLocation: $vm.inventoryLocation)
        }
        
    }
    
    private var moving_box_section : some View{
        
        VStack(alignment: .leading,spacing: 10){
            //Current Freezer
            Text("Current Freezer").foregroundColor(Color.primary).font(.title3).bold()
            Text("What is the current freezer the box is being moved from").font(.subheadline).foregroundColor(Color.theme.secondaryText)
            
            //Show a list of all the freezers
            
            Section{
                //freezer list
                freezer_list_section
                
                
            }
            //What box
            
            
            //What is the Destination Freezer
            
            
            //What is the Destination Freezer Rack
            
        }
    }
    
    private var freezer_list_section : some View{
        List{
            // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
            
            ForEach(self.freezer_vm.allFreezers, id: \.id) { freezer in
                //change to use on tap instead
                //change this out later have a method to finds all the racks in a freezer then get all the boxes in the target racks
                //destination TargetBoxToMoveView with all boxes in the target freezer
                NavigationLink(destination: TargetBoxToMoveView(all_rack_boxes: $all_stored_rack_boxes_in_system)) {
                    //Freezer cards
                    
                    FreezerProfileCardView(freezer_profile: freezer)
                    
                }
            }
            
        }.listStyle(PlainListStyle())
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
                            //add the view to make it clickable
                            ForEach(self.vm.inventoryLocations, id: \.id){ query in
                                //NavigationLink(destination: EmptyView() /*GuidedSearchSampleView(target_sample_query: query)*/){
                                SearchFreezerListSection(query: .constant(query))
                                // .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                                
                                    .onTapGesture {
                                        //clear the list and old data
                                        
                                        self.vm.rack_layout.removeAll()
                                        self.vm.currentFreezerProfile = FreezerProfileModel()
                                        
                                        //MARK: fetch the freezer layout
                                        //get freezer label
                                        //MARK: Extract into own method start
                                        if let box = query.freezerBox{
                                            if let rack = box.freezer_rack{
                                                //
                                                
                                                if let freezer = rack.freezer{
                                                    //set the current freezer profile
                                                    self.vm.currentFreezerProfile = freezer
                                                    
                                                    if let freezerLabel = freezer.freezerLabel{
                                                        //set the current freezer label so that the related records can be found
                                                        
                                                        self.vm.LoadFreezerRackLayout(freezerLabel: freezerLabel)
                                                        
                                                    }
                                                    
                                                    self.target_freezer = freezer
                                                    
                                                }
                                            }
                                            
                                        }
                                        
                                        //MARK: Extract into own method end
                                        
                                        // #warning("Show the Map")
                                        self.show_guided_map_view.toggle()
                                        //hide this section
                                        // self.show_cart_view_entry_form = false
                                        
                                        
                                    }
                                
                                //} 0.644
                            }
                        }
                        .listStyle(.plain)
                        .frame(width: UIScreen.main.bounds.size.width - 10, height: 300, alignment: .center)
                        .padding(.horizontal,10)
                    }
                }
            }
            else if self.show_guided_steps && self.selection == "Add"
            {
                withAnimation{
                    Text("Adding Mode Guided View")
                }
            }
            else if self.show_guided_steps && self.selection == "Remove"
            {
                withAnimation{
                    Text("Returning Mode Guided View")
                }
            }
        }
    }
    // }
    
}


struct SearchFreezerListSection : View{
    @Binding var query : InventoryLocationResult
    var body : some View{
        HStack{
            
            if let box = query.freezerBox{
                if let rack = box.freezer_rack{
                    //
                    
                    if let freezer = rack.freezer{
                        Text(" \(freezer.freezerLabel ?? "")").font(.subheadline).foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            
        }
        .font(.subheadline)
        .background(Color.theme.background)
    }
}

