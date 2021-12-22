//
//  BoxSampleMapView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

struct BoxSampleMapView: View {
    
    let data = (1...100).map { "\($0)" }
    
    let columns = [
        GridItem(.adaptive(minimum: 20,maximum: 30))
    ]
    @State var showSampleDetail : Bool = false
    
    
    @State var stored_rack_box_layout : BoxItemModel
    //TODO: need to fetch the InventorySampleModel for target box
    @State var stored_box_samples : [InventorySampleModel]
    
    @State var freezer_profile : FreezerProfileModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
     
            
            VStack {
                
                ForEach(self.stored_box_samples, id: \.id) { item in
                    //VStack{
                        
                        ForEach(0 ..< stored_rack_box_layout.freezer_box_max_row, id: \.self) { row in
                            //if is belongs to a particular row
                            if row == item.freezer_inventory_row
                            {
                                
                                
                                HStack {
                                    ForEach(0 ..< stored_rack_box_layout.freezer_box_max_column, id: \.self) { column in
                                        
                                        if column == item.freezer_inventory_column{
                               
                                            
                                            NavigationLink(destination: SampleInvenActivLogView(sample_detail: .constant(item))){
                                                HStack{
                                                    
                                                    Text(" \(item.sample_barcode)").foregroundColor(Color.white).font(.caption)
                                                    
                                                }.padding().background(Color.orange)
                                                    .clipShape(Circle())
                                            }
                                            
                                        }   else{
                                            //Empty
                                         
                                            //MARK: - Open the create new sample view
                                            NavigationLink(destination: EmptyView()){
                                                HStack{
                                                    //go to a screen to add a new sample at this location
                                                    Text("Empty").foregroundColor(Color.white)
                                                       
                                                }.padding().background(Color.gray)
                                                    .clipShape(Circle())
                                            }
                                    
                                            
                                        }
                                        
                                    }
                                }
                            }
                            else{
                                //Empty
                            
                            }
                        }
                        
                   // }
                }
                
                // }
            }
            
            /*InteractFreezerLayoutPreview(freezer_max_rows: $freezer_profile.freezer_max_rows, freezer_max_columns: $freezer_profile.freezer_max_columns,stored_freezer_rack_layout : stored_freezer_rack_layout)*/
            
            
        }
        .frame(minHeight: 300,maxHeight: 500)
        
        
    }
}

struct BoxSampleMapView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSampleMapView(stored_rack_box_layout: BoxItemModel(), stored_box_samples: [InventorySampleModel](), freezer_profile: FreezerProfileModel())
    }
}
