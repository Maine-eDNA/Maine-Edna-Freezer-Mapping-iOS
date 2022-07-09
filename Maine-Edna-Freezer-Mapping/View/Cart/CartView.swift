//
//  CartView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/20/21.
//

import SwiftUI
import Combine
import Kingfisher
import TabularData
#warning("This view will be deleted soon")
#warning("Update this view to look professional and workflow streamlined before continuing the logic and refractor the parts to make the code more readable")
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

//\000026eSG_E01_19w_0003
//Remove \000026

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
    
    
    @State var show_create_new_rack : Bool = false
    
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
    
    @State var boxSamples : [InventorySampleModel] = [InventorySampleModel]()
    @State var showTargetRackToAdd : Bool = false
    
    @StateObject var box_vm : FreezerBoxViewModel = FreezerBoxViewModel()
    
    @State var showTutorials : Bool = false
    @State var tutorialImage : String = "https://wwwcdn.cincopa.com/blogres/wp-content/uploads/2019/02/video-tutorial-image.jpg"
    
    //for ducment picker
    @State private var fileContent = ""
    @State private var showDocumentPicker = false
    
    @State private var csvUrl : String = ""
    
    //MARK: the empty rack location properties
    @State var rack_position_row : Int = 0
    @State var rack_position_column: Int = 0
    
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
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                //show the tutorial how to use the cart view
                                
                                withAnimation {
                                    self.showTutorials.toggle()
                                }
                            } label: {
                                HStack{
                                    Image(systemName: "questionmark.circle")
                                    
                                    Text("Tutorial")
                                    
                                }.modifier(RoundButtonStyle())
                            }
                            
                        }
                    }
                }
            }.background(
       
                NavigationLink(destination: InteractFreezerLayoutPreview(freezer_max_rows:   .constant(target_freezer.freezerCapacityRows ??  0), freezer_max_columns:   .constant(target_freezer.freezerCapacityColumns ?? 0), freezer_rack_layout: self.$vm.rack_layout, freezer_profile: target_freezer, show_create_new_rack: $show_create_new_rack, show_guided_rack_view: self.$show_guided_rack_view, show_guided_map_view: self.$show_guided_map_view,inventoryLocations: [InventorySampleModel](),isInSearchMode: true,freezer_width: .constant(UIScreen.main.bounds.width * 0.95),freezer_height: .constant(UIScreen.main.bounds.height * 0.95),rack_position_row: $rack_position_row,rack_position_column: $rack_position_column),isActive: self.$show_guided_map_view,  label: {EmptyView()})
            )
            
            .background(
                
                
                NavigationLink(destination: RackProfileView(rack_profile: self.$targetAddToFreezerRack, freezer_profile: self.addDestinationFreezer, showNerdRackStats: false, isInSearchMode: true, inventoryLocations: self.boxSamples,addToRackMode: self.$showTargetRackToAdd),isActive: self.$showTargetRackToAdd,  label: {EmptyView()})
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
        .sheet(isPresented: $showTutorials, content: {
            cartviewtutorialsection
        })
        
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
#warning("Need to show tutorial details when clicked to show text illustration and video on doing specific task")
    private var cartviewtutorialsection : some View{
        NavigationView{
            VStack(alignment: .leading){
                List{
                    // Text("Show Tutorials here in this list when clicked will show view and text")
                    
                    HStack{
                        
                        KFImage(URL(string: tutorialImage))
                            .onSuccess { r in
                                // r: RetrieveImageResult
                                print("success: \(r)")
                            }
                            .onFailure { e in
                                // e: KingfisherError
                                print("failure: \(e)")
                            }
                            .placeholder {
                                // Placeholder while downloading.
                                
                                KFImage(URL(string: tutorialImage))
                                    .resizable()
                                    .clipped()
                                    .cornerRadius(15)
                                    .frame(width: 100, height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                            }
                        //make reusable view modifier
                            .resizable()
                            .clipped()
                            .cornerRadius(15)
                            .frame(width: 100, height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                        
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack{
                                Text("camera scanner")
                                    .bold()
                                    .font(.caption)
                                    .padding()
                                    .textInputAutocapitalization(.words)
                                    .foregroundColor(Color.white)
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).background(Color.teal).cornerRadius(15).frame(maxHeight: 25) )
                                
                                
                                
                            }
                            
                            
                            Text("Using the Built in Camera for Barcode Scanning")
                                .foregroundColor(Color.primary)
                                .bold()
                                .font(.subheadline)
                            
                            
                            Spacer()
                        }
                    }
                    
                }.listStyle(.plain)
                    .navigationTitle("User Guides")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
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
                                    //.border(Color.theme.secondaryText, width: 2)
                                }.overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1))
                            })
                            // .background(Color.indigo.opacity(0.25))
                            
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
                //MARK: use this tutotial using combine framework https://www.youtube.com/watch?v=Q-1EDHXUunI&ab_channel=SwiftfulThinking
#warning("Use a custom subscriberr to detect changes and if it finds that the value p[asted has the target of \000026 remove it and add the result to the list and clear the textfield ")
                TextFieldLabelCombo(textValue: self.$current_barcode, label: "Barcode", placeHolder: "Enter barcode or press barcode button", iconValue: "number")
                    .onChange(of: self.current_barcode) {
                        print($0) // You can do anything due to the change here.
                        // self.autocomplete($0) // like this
                        if $0.contains("\000026"){
                            let newValue : String = $0.replacingOccurrences(of: "\000026", with: "")
                            //add to the list
                            target_barcodes.append(newValue)
                            
                            //clear the list
                            self.current_barcode = ""
                        }
                        
                    }
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
                    .cornerRadius(10)
                
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
                            AvailableRackListView(rack: .constant(rack))
                                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                                .listRowBackground(Color.theme.background)
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
                                    self.vm.inventoryLocations = samplesToAddToBox
                                    
                                    self.showTargetRackToAdd.toggle()
                                }
                            
                        }
                    }
                    .listStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: 300)
                    
                }
                else{
                    Text("No Layout was found, would you like to add a new Layout for \(addDestinationFreezer.freezerLabel ?? "")")
                }
            }
            
        }.padding(.horizontal,9)
    }
    
    
    
    
    
    //the query form
    
    private var cart_view_entry_form : some View{
        //MARK: Use Geometric reader
        VStack(alignment: .center){
#warning("Can switch between Barcode or CSV to do the bulk search, add or return")
            
            
            MenuStyleClicker(selection: self.$entry_selection, actions: self.$entry_modes, label: "Entry Mode",label_action: self.$entry_selection).frame(width: 200)
            
            
            
            MenuStyleClicker(selection: self.$selection, actions: self.$actions,label: "Action",label_action: self.$selection).frame(width: 200)
            
            targetbarcodessection
            
            Section{
                //MARK: Section to show the entry modes EXAMPLE THE ABILITY TO add bacodes manually or use a CSV or barcode score (physically or camera)
                if entry_selection == "CSV"{
                    Section{
                        csvuploadersection
                        
                    }
                }
                // ["Scan", "CSV", "Manual"]
                else if entry_selection == "Scan"{
                    Section{
                        withAnimation {
                            Text("Camera or Barcode Scanner Mode here")
                        }
                    }
                }
                else if entry_selection == "Manual"{
                    Section{
                        withAnimation {
                            Text("Manually entry, present a form to quickly type the barcodes and go to the next in the entry")
                        }
                    }
                }
                
            }
            
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
                    //MARK: Manual entry
                    barcode_query_section
                }
            }.padding()
            
            // Text("View to bulk return samples and bulk find samples in the freezer")
            
            
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
    
    private var csvuploadersection : some View{
        VStack{
            VStack{
                
                
                //  withAnimation {
                Text("CSV Uploader here")
                //MARK: Limitation: only via URL and pick the file from the device
                //MARK: use this link to get picker
                //MARK: https://stackoverflow.com/questions/65553282/select-file-or-directory-in-swiftui-in-an-appkit-app
                
                //test of picker
                /*
                 @State private var fileContent = ""
                 @State private var showDocumentPicker = false
                 */
                Text("Download CSV via URL")
                HStack{
                    TextFieldLabelCombo(textValue: $csvUrl, label: "CSV Url", placeHolder: "Enter URl to download CSV", iconValue: "file")
                    Button(action: {
                        //MARK: download the csv and extract the values  then add to the barcode list
                        importCsvViaUrl(url: self.csvUrl)
                        
                    }, label: {
                        HStack{
                            Text("Download")
                        }.roundButtonStyle()
                    })
                }
                
                Text("or")
                Text(fileContent ?? "No File Found").padding()
                
                Button {
                    showDocumentPicker = true
                } label: {
                    HStack{
                        Text("Import File").roundButtonStyle()
                    }
                }
                
                //   }
                
                
            }
            .sheet(isPresented: self.$showDocumentPicker) {
                DocumentPicker(fileContent: $fileContent)
            }
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
    
    private var targetbarcodessection : some View{
        
        Section{
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
        }
    }
    
    
    func importCsvViaUrl(url : String){
        
        do{
            /* let url : String = "https://firebasestorage.googleapis.com/v0/b/keijaoh-576a0.appspot.com/o/testcsv%2FSampleCSVFile_2kb.csv?alt=media&token=6243cbcf-32a8-4bf0-b176-148b8c3fe76e"*/
            let formattingOptions = FormattingOptions(maximumLineWidth: 250, maximumCellWidth: 15, maximumRowCount: 3, includesColumnTypes: false)
            let policies = try DataFrame(contentsOfCSVFile: URL(string: url)!, rows: 0..<5)
            
            print(policies.description(options: formattingOptions))
            
            #warning("Need to extract the data from the csv then display it in the list below (let it just be a list of barcodes")
            
            //Give it modes so that it can capture data from various types
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
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



struct AvailableRackListView : View{
    @Binding var rack : RackItemModel
    var body: some View{
        HStack(spacing: 0){
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
                    Spacer()
                }
                
            }}.background(Color.theme.background.opacity(0.001))
        
    }
    
    
    ///Finding the number of empty boxes
    func calulateEmptyBoxes(rack : RackItemModel) -> Int{
        return (rack.box_capacity_of_rack - rack.number_of_boxes_in_use)
    }
    
}


//Document picker section (Call UIKIT controller in SwiftUI)

struct DocumentPicker : UIViewControllerRepresentable{
    
    @Binding var fileContent : String
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller : UIDocumentPickerViewController
        if #available(iOS 14, *){
            controller = UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: true)
        }
        else{
            controller = UIDocumentPickerViewController(documentTypes: [String()], in: .import)
        }
        
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
}


class DocumentPickerCoordinator : NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate{
    
    @Binding var fileContent : String
    
    init(fileContent : Binding<String>){
        _fileContent = fileContent
    }
    
    func documentPicker(_ controller : UIDocumentPickerViewController, didPickDocumentsAt urls : [URL]){
        let fileURL = urls[0]
        
        do{
            fileContent = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch let error{
            print(error.localizedDescription)
        }
        
    }
    
}
