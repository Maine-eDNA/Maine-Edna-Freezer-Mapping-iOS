//
//  FreezerMapView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/29/21.
//

import SwiftUI
//reuseable for many screens

struct FreezerMapView: View {
    
    
    let data = (1...100).map { "\($0)" }
    
    let columns = [
        GridItem(.adaptive(minimum: 30,maximum: 80))
    ]
    @State var showSampleDetail : Bool = false
    
    
    @Binding var freezer_rack_layout : [RackItemModel]
    
    @State var freezer_profile : FreezerProfileModel
    
    //conditional renders
    @Binding var show_create_new_rack : Bool
    @State var show_guided_rack_view : Bool = false
    
    //MARK: the empty rack location properties
    @Binding var rack_position_row : Int
    @Binding var rack_position_column: Int
    
    @State var target_rack : RackItemModel = RackItemModel()
    
    @Binding var selectMode : String
    
  
    
    var body: some View {
        Section {
            InteractFreezerLayoutPreview(
                     freezer_max_rows: .constant($freezer_profile.freezerCapacityRows.wrappedValue ?? 0),
                     freezer_max_columns: .constant($freezer_profile.freezerCapacityColumns.wrappedValue ?? 0),
                     freezer_rack_layout: $freezer_rack_layout,
                     freezer_profile: freezer_profile,
                     show_create_new_rack: $show_create_new_rack,
                     show_guided_rack_view: self.$show_guided_rack_view,
                     show_guided_map_view: .constant(false),
                     rack_position_row: $rack_position_row,
                     rack_position_column: $rack_position_column,
                     target_rack: $target_rack,
                     selectMode: $selectMode
                 )
              }
    }
}


struct FreezerMapView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerMapView(freezer_rack_layout: .constant([RackItemModel]()), freezer_profile: FreezerProfileModel(), show_create_new_rack: .constant(false),rack_position_row: .constant(0),rack_position_column: .constant(0), selectMode: .constant(""))
    }
}
