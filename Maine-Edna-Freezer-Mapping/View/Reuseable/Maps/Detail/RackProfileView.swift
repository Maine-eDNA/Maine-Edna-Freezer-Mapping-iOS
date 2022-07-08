//
//  RackProfileView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI
//Kiosk mode is used when the app is place in the lab
struct RackProfileView: View {
    ///RackProfile is needed o make the server call to generate the results
    @Binding var rack_profile : RackItemModel
    var freezer_profile : FreezerProfileModel
    @State var showNerdRackStats : Bool = false
    //@ObservedObject var box_service = FreezerBoxRetrieval()
    @StateObject private var vm : FreezerBoxViewModel = FreezerBoxViewModel()
    
    ///Optional: only used when doing Cart View Querying to find the target boxes
    @State var isInSearchMode : Bool = false
    ///Used as a master list to show the records that need to be highlighted
    @State var inventoryLocations : [InventorySampleModel] = []
    
    
    //TODO: Must click a rack, to get the full stats like how many spaces are left in each Box (example 55%)
    //if true then i should show all the statistics for this rack in terms of statistics and box space (make that a norm)
    @Binding var addToRackMode : Bool
    
    //MARK: COLOR Blindess https://davidmathlogic.com/colorblind/#%23332288-%23117733-%2344AA99-%2388CCEE-%23DDCC77-%23CC6677-%23AA4499-%23882255
    //MARK: View Modes
    @State private var viewModeSelection : String = "Row 1"
    @State var viewModes : [String] = []// ["Row 1", "Row 2"]
    
    //Grid
    @State var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var phoneOneColumnGrid = [GridItem(.flexible())]
    
    @State var  numOfRackRows : Int = 0
    
    var body: some View {
        //TODO: - Show empty box spaces fo the available slots in the rack and show multi-level rack as well
        //  NavigationView{
        
        VStack(alignment: .leading){
            LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? phoneOneColumnGrid : phoneOneColumnGrid,alignment: .leading) {
                HStack{
                    Text("Freezer").font(.title3).bold()
                    Text("\(freezer_profile.freezerLabel ?? "")").font(.subheadline)
                    
                }
                HStack{
                    Text("Rack").font(.title3).bold()
                    Text("\(rack_profile.freezer_rack_label) Slug \(rack_profile.freezer_rack_label_slug)").font(.subheadline)
                    
                }
                VStack(alignment: .leading){
                    HStack{
                        Toggle("More Details", isOn: $showNerdRackStats)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    
                    if showNerdRackStats{
                        
                        withAnimation(.spring()){
                            //use columns
                            LazyHGrid(rows: UIDevice.current.userInterfaceIdiom == .pad ? phoneOneColumnGrid : phoneOneColumnGrid,spacing: 20) {
                                
                                VStack(alignment: .trailing){
                                    
                                    LabelTextValueHStack(label: .constant("Row Start:"), textValue: .constant(String(rack_profile.freezer_rack_row_start)))
                                    
                                    LabelTextValueHStack(label: .constant("Row End:"), textValue: .constant(String(rack_profile.freezer_rack_row_end)))
                                    
                                    LabelTextValueHStack(label: .constant("# of Rack Rows:"), textValue: .constant(String(findNumOfRackRows(rack_profile: rack_profile))))
                                    
                                }
                                VStack(alignment: .trailing){
                                    
                                    
                                    LabelTextValueHStack(label: .constant("Column Start:"), textValue: .constant(String(rack_profile.freezer_rack_column_start)))
                                    
                                    LabelTextValueHStack(label: .constant("Column End:"), textValue: .constant(String(rack_profile.freezer_rack_column_end)))
                                    
                                    LabelTextValueHStack(label: .constant("# of Rack Columns:"), textValue: .constant(String(findNumOfRackColumns(rack_profile: rack_profile))))
                                    
                                    
                                }
                                
                                VStack(alignment: .trailing){
                                    
                                    LabelTextValueHStack(label: .constant("Depth Start:"), textValue: .constant(String(rack_profile.freezer_rack_depth_start)))
                                    
                                    LabelTextValueHStack(label: .constant("Depth End:"), textValue: .constant(String(rack_profile.freezer_rack_depth_end)))
                                    
                                    LabelTextValueHStack(label: .constant("Depth Of:"), textValue: .constant(String(findNumOfRackDepth(rack_profile: rack_profile))))
                                    
                                }
                            }
                            
                            
                        }
                    }
                    
                    VStack(alignment: .center){
                        
                        //MARK: Check if the rack has more than 1 row -> rackprofile row start - end greater than one which means it has multiple
                        if findRackLength(rack_profile: rack_profile) > 1{
                            //show the control to select a row
                            //generate the selection based on the number of rows found
                            MenuStyleClicker(selection: self.$viewModeSelection, actions: self.$viewModes, label: "View Modes",label_action: self.$viewModeSelection)//.frame(width: 100).padding()
                            
                        }
                        
                    }
                }
                
            }
            
            if self.vm.all_filter_rack_boxes.count > 0{
                //MARK: Use the view section to show the rack items according to the view mode cross-section or top down
                withAnimation(.spring()){
                    Section{
                        Text(" Boxes in Freezer").font(.title3).bold()//hightlighted
                        Label("Cross-Sectional View", systemImage: "eye").font(.caption)
                        
                        VStack{
                            if numOfRackRows > 1{
                                Text("Show the control to select the row thats visible").bold()
                            }
                        }
                        
                        //get the current rack row index and add 1 to it since index start at 0
                        ScrollView([.horizontal,.vertical],showsIndicators: false){
                            RackCrossSectView(rack_profile: self.rack_profile, rack_boxes: self.$vm.all_filter_rack_boxes, freezer_profile: .constant(self.freezer_profile), current_rack_row: .constant(currentRackRow()),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false),inventoryLocations: self.inventoryLocations,isInSearchMode: self.isInSearchMode)
                            
                            
                            // .frame(width: UIScreen.main.bounds.width)
                        }//.frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            else{
                VStack{
                    Text("No Boxes Found In this Rack").bold().font(.title3).foregroundColor(.primary)
                    Image("not_found_06").resizable().frame(width: 400, height: 400, alignment: .center)
                }
            }
            Spacer()
        }.padding()
        
            .onAppear{
                print("Rack Label Slug: \(self.rack_profile.freezer_rack_label_slug)")
                if isInSearchMode && !addToRackMode{
                    //need to add the icon to the boxes in search
                    self.vm.isInSearchMode = true
                    //target list
                    
                    self.vm.FilterFreezerBoxesSearchMode(_rack_id: String(self.rack_profile.freezer_rack_label_slug),inventoryLocations: self.inventoryLocations)
                }
                else if isInSearchMode && addToRackMode{
                    //then this should show in addition to rack mode
                    print("Will be adding samples to Rack \(rack_profile.freezer_rack_label)")
                    //when click any box here it should be with the intention to add to it
                    self.vm.FilterFreezerBoxes(_freezer_rack_label_slug: String(self.rack_profile.freezer_rack_label_slug))
                    
                    
                    
                }
                else{
                    //add loading animation here
                    print("Rack Slug \(self.rack_profile.freezer_rack_label_slug)")
                    
                    self.vm.FilterFreezerBoxes(_freezer_rack_label_slug: String(self.rack_profile.freezer_rack_label_slug))
                    
                }
                
                generateRowSelectionList(rack_profile: rack_profile)
            }
            .navigationTitle("Rack Detail")
            .navigationBarTitleDisplayMode(.inline)
        //}
    }
}

extension RackProfileView{
    
    
    
    //function section
    func findRackLength(rack_profile : RackItemModel) -> Int{
        
        return (rack_profile.freezer_rack_row_end - rack_profile.freezer_rack_row_start)
    }
    
    func findNumOfRackRows(rack_profile : RackItemModel) -> Int{
        return (rack_profile.freezer_rack_row_end - rack_profile.freezer_rack_row_start)
    }
    
    func findNumOfRackColumns(rack_profile : RackItemModel) -> Int
    {
        return (rack_profile.freezer_rack_column_end - rack_profile.freezer_rack_column_start)
        
    }
    
    func findNumOfRackDepth(rack_profile : RackItemModel) -> Int{
        return (rack_profile.freezer_rack_depth_end - rack_profile.freezer_rack_depth_start)
    }
    
    ///Generate Selection Based On Row Start and End
    func generateRowSelectionList(rack_profile : RackItemModel){
#warning("Work on showing the different rows when more than one row exist and display Current row at the top of the rack Map")
        
        //MARK: 1. Next adding using the scanner (remove garabage and add to list)
        //MARK: 2. Bulk adding using CSV
        
        let totalRackRows = findRackLength(rack_profile: rack_profile)
        
        numOfRackRows = totalRackRows
        if totalRackRows > 0{
            for i in 1...totalRackRows{
                viewModes.append("Row \(i)")
            }
            
        }
        
    }
    
    func currentRackRow() -> Int
    {
        if let currentIndex = viewModes.firstIndex(where: {$0 == viewModeSelection}){
            let index : Int = currentIndex + 1
            
            return index
            
        }
        else{
            return 1
        }
        
        
    }
    
    
    
}


struct RackProfileView_Previews: PreviewProvider {
    static var previews: some View {
        var rack_profile : RackItemModel = RackItemModel()
        var freezer_profile : FreezerProfileModel = FreezerProfileModel()
        
        rack_profile.freezer_rack_depth_end = 1
        rack_profile.freezer_rack_depth_start = 1
        rack_profile.freezer_rack_column_start = 1
        rack_profile.created_by = "keijaoh.campbell@maine.edu"
        rack_profile.freezer = "Freezer_Test_1"
        rack_profile.freezer_rack_label = "Freezer_Test_1_Rack_1"
        freezer_profile.freezerLabel = "Test Freezer"
        
        return Group {
            /*RackProfileView(rack_profile: .constant(rack_profile),freezer_profile: freezer_profile, addToRackMode: .constant(false))
             // .preferredColorScheme(.dark)
             .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
             .previewDisplayName("iPad Air (4th generation)")
             //.environment(\.colorScheme, .dark)
             RackProfileView(rack_profile: .constant(rack_profile),freezer_profile: freezer_profile, addToRackMode: .constant(false))
             .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
             .previewDisplayName("iPhone 8")
             RackProfileView(rack_profile: .constant(rack_profile),freezer_profile: freezer_profile, addToRackMode: .constant(false))
             .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
             .previewDisplayName("iPhone XS Max")*/
            
            ScreenPreview(screen:   RackProfileView(rack_profile: .constant(rack_profile),freezer_profile: freezer_profile, addToRackMode: .constant(false)))
        }
    }
}




