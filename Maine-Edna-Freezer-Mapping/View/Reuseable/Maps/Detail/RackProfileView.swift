//
//  RackProfileView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

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
    @State var inventoryLocations : [InventoryLocationResult] = []
    
    var body: some View {
        //TODO: - Show empty box spaces fo the available slots in the rack and show multi-level rack as well
      //  NavigationView{
            
            VStack(alignment: .leading){
                HStack{
                    Text("Freezer").font(.title3).bold()
                    Text("\(freezer_profile.freezerLabel ?? "")").font(.subheadline)
                    
                }
                HStack{
                    Text("Rack").font(.title3).bold()
                    Text("\(rack_profile.freezer_rack_label) Slug \(rack_profile.freezer_rack_label_slug)").font(.subheadline)
                    
                }
                HStack{
                    Toggle("More Details", isOn: $showNerdRackStats)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                if showNerdRackStats{
                    
                    withAnimation(.spring()){
                        Section{
                            HStack{
                                Text("Row Start: \(rack_profile.freezer_rack_row_start)")
                                Spacer()
                                Text("Row End: \(rack_profile.freezer_rack_row_end)")
                            }
                            HStack{
                                Text("Column Start: \(rack_profile.freezer_rack_column_start)")
                                Spacer()
                                Text("Column End: \(rack_profile.freezer_rack_column_end)")
                            }
                        }
                    }
                }
                if self.vm.all_filter_rack_boxes.count > 0{
                    withAnimation(.spring()){
                        Section{
                            Text("Boxes in Freezer").font(.title3).bold()//hightlighted
                            Label("Cross-Sectional View", systemImage: "eye").font(.caption)
                            
                            ScrollView([.horizontal,.vertical],showsIndicators: false){
                                RackCrossSectView(rack_profile: self.rack_profile, rack_boxes: self.$vm.all_filter_rack_boxes, freezer_profile: .constant(self.freezer_profile),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false),inventoryLocations: self.inventoryLocations,isInSearchMode: self.isInSearchMode)
                                
                         
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
                    if isInSearchMode{
                       //need to add the icon to the boxes in search
                        self.vm.isInSearchMode = true
                        //target list
                        
                        self.vm.FilterFreezerBoxesSearchMode(_rack_id: String(self.rack_profile.freezer_rack_label_slug),inventoryLocations: self.inventoryLocations)
                    }
                    else{
                        //add loading animation here
                        print("Rack Slug \(self.rack_profile.freezer_rack_label_slug)")
                        
                        self.vm.FilterFreezerBoxes(_rack_id: String(self.rack_profile.freezer_rack_label_slug))
                        
                    }
                }
                .navigationTitle("Rack Detail")
                .navigationBarTitleDisplayMode(.inline)
        //}
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
            RackProfileView(rack_profile: .constant(rack_profile),freezer_profile: freezer_profile)
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            RackProfileView(rack_profile: .constant(rack_profile),freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            RackProfileView(rack_profile: .constant(rack_profile),freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
    }
}
