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
    
    
    #warning("If suggesting location use the following view")
    //CapsuleSuggestedPositionView
    
    var body: some View {
        
        ScrollView([.horizontal,.vertical],showsIndicators: false){
            //Experiment
           // Text("\(stored_rack_box_layout.freezer_box_max_column) \(stored_rack_box_layout.freezer_box_max_row)")
            InteractiveBoxGridStack(rows: $stored_rack_box_layout.freezer_box_capacity_row.wrappedValue ?? 0, columns: $stored_rack_box_layout.freezer_box_capacity_column.wrappedValue ?? 0,samples: self.stored_box_samples) { row, col,content  in
                NavigationLink(destination: SampleInvenActivLogView(sample_detail: .constant(content))){
                   // BoxSampleCapsuleView(single_lvl_rack_color: .constant("blue"))
                    if content.is_suggested_sample && content.freezer_inventory_row == row && content.freezer_inventory_column == col{
                        CapsuleSuggestedPositionView(single_lvl_rack_color: .constant("yellow"), sample_code:.constant(String(!content.sample_barcode.isEmpty ? content.sample_barcode.suffix(4) : "N/A")), sample_type_code: .constant(String(!content.freezer_inventory_type.isEmpty ? content.freezer_inventory_type.prefix(1) : "N/A")))
                            .onTapGesture {
                                //MARKL Do action
                            }
                    }
                   else if content.freezer_inventory_row == row && content.freezer_inventory_column == col{
                   
                        BoxSampleCapsuleView(background_color: .constant("blue"),sample_code: .constant(String(!content.sample_barcode.isEmpty ? content.sample_barcode.suffix(4) : "N/A")),sample_type_code: .constant(String(!content.freezer_inventory_type.isEmpty ? content.freezer_inventory_type.prefix(1) : "N/A")), foreground_color: .constant("white"),width: 50,height: 50)
                    }
                    else{
                        //MARK: - Empty sample box sample Section
                        //empty sample box sample color
                     
                        BoxSampleCapsuleView(background_color: .constant("gray"),sample_code: .constant(""),sample_type_code: .constant(""), foreground_color: .constant("white"),width: 50,height: 50)
                    }
            
                }.buttonStyle(PlainButtonStyle())  /*Remove Navigation Link blue tint*/
                
            }

            
            
        }
        
       /* ScrollView(showsIndicators: false) {
     
            
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
                                               /* HStack{
                                                    
                                                    Text(" \(item.sample_barcode)").foregroundColor(Color.white).font(.caption)
                                                    
                                                }.padding().background(Color.orange)
                                                    .clipShape(Circle())*/
                                                BoxSampleCapsuleView(single_lvl_rack_color: .constant("blue"), width: 50, height: 50)
                                            }
                                            
                                        }   else{
                                            //Empty
                                         
                                            //MARK: - Open the create new sample view
                                            NavigationLink(destination: EmptyView()){
                                               /* HStack{
                                                    //go to a screen to add a new sample at this location
                                                    Text("Empty").foregroundColor(Color.white)
                                                       
                                                }.padding().background(Color.gray)
                                                    .clipShape(Circle())*/
                                                BoxSampleCapsuleView(single_lvl_rack_color: .constant("gray"), width: 50, height: 50)
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
        .frame(minHeight: 300,maxHeight: 500)*/
        
        
    }
}

struct BoxSampleMapView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSampleMapView(stored_rack_box_layout: BoxItemModel(), stored_box_samples: [InventorySampleModel](), freezer_profile: FreezerProfileModel())
    }
}



struct InteractiveBoxGridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let samples : [InventorySampleModel]
    let content: (Int, Int,InventorySampleModel) -> Content
    
    var body: some View {
        VStack {
            // ForEach(racks, id: .\id){
            
            
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< columns, id: \.self) { column in
                        ForEach(samples, id: \.freezer_box) {
                            sample in
                            content(row, column,sample)
                        }
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, samples: [InventorySampleModel], @ViewBuilder content: @escaping (Int, Int,InventorySampleModel) -> Content) {
        self.rows = rows
        self.columns = columns
        self.samples = samples
        
        self.content = content
    }
}
