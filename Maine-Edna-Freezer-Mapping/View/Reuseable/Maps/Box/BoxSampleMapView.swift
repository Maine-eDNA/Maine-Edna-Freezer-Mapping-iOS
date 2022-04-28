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
                    #warning("Test this to see why it is not showing the highlighted samples")
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
    
    //letters of the alphabet start
    let alphabet : [String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    //letters of the alphabet end
    
    var body: some View {
        VStack {
            // ForEach(racks, id: .\id){
            
            
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< columns, id: \.self) { column in
                        HStack{
                            
                            Text("\(( column == 0 ? String(alphabet[row]).uppercased() : "") )")
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal,column == 0 ? 10 : 0)
                            
                        }
                        
                        /*ForEach(samples, id: \.freezer_box) {
                            sample in
                            content(row, column,sample)
                        }*/
                        VStack(alignment: .leading){
                            Section{
                                if row == 0{
                                    HStack{
                                        Text("\(((column ) + 1) )")
                                            .font(.subheadline)
                                            .bold()
                                            .padding(.horizontal,5)
                                        
                                    }
                                }
                            }
                            Section{
                            //must be unique
                            if let sample = samples.first(where: {$0.freezer_inventory_column == column  && $0.freezer_inventory_row == row}){
                                content(row, column,sample)
                            }
                            else{
                                content(row, column,InventorySampleModel(id: 0,freezer_box: "",freezer_inventory_column: column, freezer_inventory_row: row, is_suggested_sample: false))//MARK: change this to be dynamic when it is suggested
                            }
                        }
                           //here
                            Section{
                                if row == (rows - 1){
                                    HStack{
                                        Text("\(((column ) + 1) )")
                                            .font(.subheadline)
                                            .bold()
                                            .padding(.horizontal,5)
                                        
                                    }
                                }
                            }
                            
                        }
                        HStack{
                            
                            Text("\(( column == (columns - 1) ? String(alphabet[row]).uppercased() : "") )")
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal,column == 9 ? 8 : 0)
                            
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
