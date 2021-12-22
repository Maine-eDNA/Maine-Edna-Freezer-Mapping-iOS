//
//  RackProfileView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

struct RackProfileView: View {
    
    var rack_profile : RackItemModel
    var freezer_profile : FreezerProfileModel
    @State var showNerdRackStats : Bool = false
    @ObservedObject var box_service = FreezerBoxRetrieval()
    
    var body: some View {
      //  NavigationView{
            
            VStack(alignment: .leading){
                HStack{
                    Text("Freezer").font(.title3).bold()
                    Text("\(freezer_profile.freezer_label)").font(.subheadline)
                    
                }
                HStack{
                    Text("Rack").font(.title3).bold()
                    Text("\(rack_profile.freezer_rack_label)").font(.subheadline)
                    
                }
                HStack{
                    Toggle("Nerd Stats", isOn: $showNerdRackStats)
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
                Section{
                    Text("Boxes in Freezer").font(.title3).bold()//hightlighted
                    RackCrossSectView(rack_profile: self.rack_profile, rack_boxes: self.$box_service.stored_rack_boxes, freezer_profile: .constant(self.freezer_profile))
                    
                }
                
                Spacer()
            }.padding()
            
                .onAppear{
                    self.box_service.FetchAllRackBoxesByRackId(_rack_id: String(self.rack_profile.id))
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
        freezer_profile.freezer_label = "Test Freezer"
        
        return Group {
            RackProfileView(rack_profile: rack_profile,freezer_profile: freezer_profile)
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            RackProfileView(rack_profile: rack_profile,freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            RackProfileView(rack_profile: rack_profile,freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
    }
}
