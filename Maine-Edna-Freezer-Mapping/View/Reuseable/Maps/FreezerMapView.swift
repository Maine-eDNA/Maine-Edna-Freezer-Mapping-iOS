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
    
    
    @State var stored_freezer_rack_layout : [RackItemModel]
    
    @State var freezer_profile : FreezerProfileModel
    
    //conditional renders
    @State var show_create_new_rack : Bool = false
    
    
    var body: some View {
        //ScrollView(showsIndicators: false) {
     
            
          /*  VStack {
                
                ForEach(self.stored_freezer_rack_layout, id: \.id) { item in
                    //VStack{
                        
                        ForEach(0 ..< freezer_profile.freezer_max_rows, id: \.self) { row in
                            //if is belongs to a particular row
                            if row == item.freezer_rack_row_start
                            {
                                
                                
                                HStack {
                                    ForEach(0 ..< freezer_profile.freezer_max_columns, id: \.self) { column in
                                        
                                        if column == item.freezer_rack_column_start{
                                            NavigationLink(destination: RackProfileView(rack_profile: item,freezer_profile: self.freezer_profile)){
                                                HStack{
                                                    
                                                    Text("\(row) \(column) \(item.freezer_rack_label)").foregroundColor(Color.white)
                                                    
                                                }.padding().background(Color.orange)
                                            }
                                  
                                            
                                            
                                        }   else{
                                            //Empty
                                        
                                            
                                            NavigationLink(destination:  CreateNewRackView(freezer_detail: self.freezer_profile,show_create_new_rack: $show_create_new_rack,selected_row: row,selected_col: column)){
                                                HStack{
                                                    
                                                    Text("\(row) \(column) Empty").foregroundColor(Color.white)
                                                    
                                                }.padding().background(Color.gray)
                                            }
                                            
                                        }
                                        
                                    }
                                }
                            }
                       
                        }
                        
                   // }
                }
                
                // }
            }
        */
            
        InteractFreezerLayoutPreview(freezer_max_rows: $freezer_profile.freezer_max_rows, freezer_max_columns: $freezer_profile.freezer_max_columns,stored_freezer_rack_layout : stored_freezer_rack_layout,freezer_profile: freezer_profile)
            
            
        //}
        .frame(minHeight: 300,maxHeight: 500)
        
        
    }
}


struct FreezerMapView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerMapView(stored_freezer_rack_layout: [RackItemModel](), freezer_profile: FreezerProfileModel())
    }
}
