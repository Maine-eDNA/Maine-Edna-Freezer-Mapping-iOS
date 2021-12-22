//
//  RackCrossSectView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

struct RackCrossSectView: View {
    
    var rack_profile : RackItemModel
    @Binding var rack_boxes : [BoxItemModel]
    @Binding var freezer_profile : FreezerProfileModel
    
    var body: some View {
        VStack{
            List{
                ForEach(self.$rack_boxes,id: \.id){ box in
                    
                    NavigationLink(destination: FreezerInventoryView(box_detail: box, freezer_profile: self.$freezer_profile)){
                        BoxItemCard(rack_box: box)
                    }
                }
                
                
                
            }
         
        }
    }
}

struct BoxItemCard : View{
    @Binding var rack_box : BoxItemModel
    
    var body : some View{
        HStack{
            Text("\(rack_box.freezer_box_label)").font(.title3).padding().frame(maxWidth: .infinity,maxHeight: .infinity)
        }.background(Color(wordName: "blue"))//set the color based on the status of the box empty, half full and full (not available)
            .foregroundColor(.white)
            .padding()//set by system theme colors
    }
}

struct RackCrossSectView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        var rack_profile : RackItemModel = RackItemModel()
        var rack_boxes : [BoxItemModel] = [BoxItemModel]()
        let box = BoxItemModel()
        box.id = 1
        box.freezer_box_label = "rack_1_1_box_1"
        box.freezer_box_max_row = 10
        box.freezer_box_max_column = 10 //row x col equal max capacity
        rack_boxes.append(box)
        
        
        let box2 = BoxItemModel()
        box2.id = 2
        box2.freezer_box_label = "rack_1_1_box_2"
        box2.freezer_box_max_row = 10
        box2.freezer_box_max_column = 10 //row x col equal max capacity
        rack_boxes.append(box2)
        
        
        rack_profile.freezer_rack_depth_end = 1
        rack_profile.freezer_rack_depth_start = 1
        rack_profile.freezer_rack_column_start = 1
        rack_profile.created_by = "keijaoh.campbell@maine.edu"
        rack_profile.freezer = "Freezer_Test_1"
        rack_profile.freezer_rack_label = "Freezer_Test_1_Rack_1"
        
        
        return Group {
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()))
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
    }
}


