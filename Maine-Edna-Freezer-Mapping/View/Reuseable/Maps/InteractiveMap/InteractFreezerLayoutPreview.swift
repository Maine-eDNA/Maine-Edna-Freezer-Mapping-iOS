//
//  InteractFreezerLayoutPreview.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/5/21.
//

import SwiftUI

struct InteractFreezerLayoutPreview: View {
    //need to show the empty spots by pre-populating it and with the positions
    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]
    @State var showSampleDetail : Bool = false
    @Binding  var freezer_max_rows : Int
    @Binding  var freezer_max_columns: Int
    var stored_freezer_rack_layout : [RackItemModel]
    @State var freezer_profile : FreezerProfileModel
    @State var current_label : String = ""
    //conditional renders
    @State var show_create_new_rack : Bool = false
    //TODO: - need to get the system colors
    
    var body: some View {
        
        ScrollView{
            InteractiveGridStack(rows: freezer_max_rows, columns: freezer_max_columns,racks: self.stored_freezer_rack_layout) { row, col,content  in
                NavigationLink(destination: RackProfileView(rack_profile: content,freezer_profile: self.freezer_profile)){
                    HStack{
                        
                        Text("\(row) \(col) \(content.freezer_rack_label)").foregroundColor(Color.white)
                        
                    }.padding().background(Color.orange)
                }
                
            }
        }
        /*ForEach(self.stored_freezer_rack_layout, id: \.id) { item in
         
         InteractiveGridStack(rows: freezer_max_rows, columns: freezer_max_columns,label: item.freezer_rack_label) { row, col,content  in
         //much be unique else its empty
         if item.freezer_rack_label != current_label{
         
         NavigationLink(destination: RackProfileView(rack_profile: item,freezer_profile: self.freezer_profile)){
         HStack{
         
         Text("\(row) \(col) \(item.freezer_rack_label)").foregroundColor(Color.white)
         
         }.padding().background(Color.orange)
         }.onAppear(){
         
         current_label = item.freezer_rack_label
         print("Called \(current_label)")
         }
         }
         else if item.freezer_rack_label == current_label{
         NavigationLink(destination:  CreateNewRackView(freezer_detail: self.freezer_profile,selected_row: row, selected_col: col, show_create_new_rack: $show_create_new_rack)){
         HStack{
         
         Text("\(row) \(col) Empty").foregroundColor(Color.white)
         
         }.padding().background(Color.gray)
         .onAppear(){
         
         current_label = item.freezer_rack_label
         print("Called \(current_label)")
         }
         }
         }
         
         /*HStack{
          //Text("A").foregroundColor(Color.white)
          Text("te").foregroundColor(Color.white)
          
          }.padding(10).background(Color.orange)//.frame(width: 80, height: 80)
          */
         /*
          
          
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
          */
         
         }
         
         }*/
    }
}

struct InteractFreezerLayoutPreview_Previews: PreviewProvider {
    static var previews: some View {
        InteractFreezerLayoutPreview(freezer_max_rows: .constant(0), freezer_max_columns: .constant(0), stored_freezer_rack_layout: [RackItemModel](), freezer_profile: FreezerProfileModel())
        
    }
}


struct InteractiveGridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let racks : [RackItemModel]
    let content: (Int, Int,RackItemModel) -> Content
    
    var body: some View {
        VStack {
            // ForEach(racks, id: .\id){
        
                
                ForEach(0 ..< rows, id: \.self) { row in
                    HStack {
                        ForEach(0 ..< columns, id: \.self) { column in
                            ForEach(racks, id: \.freezer_rack_label) {
                                rack in
                            content(row, column,rack)
                        }
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, racks: [RackItemModel], @ViewBuilder content: @escaping (Int, Int,RackItemModel) -> Content) {
        self.rows = rows
        self.columns = columns
        self.racks = racks
        
        self.content = content
    }
}
