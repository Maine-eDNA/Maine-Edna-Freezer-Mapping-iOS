//
//  FreezerLayoutPreview.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/4/21.
//

import SwiftUI

struct FreezerLayoutPreview: View {
  
    let columns = [
        GridItem(.adaptive(minimum: 130))
    ]
    @State var showSampleDetail : Bool = false
    @Binding  var freezer_max_rows : Int
    @Binding  var freezer_max_columns: Int
    
    @Binding  var selected_row : Int
    @Binding  var selected_column: Int
    
    @Binding var show_freezer_grid_layout : Bool
    var body: some View {
        
        GridStack(rows: freezer_max_rows, columns: freezer_max_columns) { row, col in
        
            Button(action: {
                print("Row \(row) Column \(col)")
                selected_row = row
                
                selected_column = col
                
                self.show_freezer_grid_layout.toggle()
            }, label: {
            
                
                
                SingleLevelRaciSlotItemView(single_lvl_rack_color: .constant("orange"))
           
            })
         }
     }
      
    //}
}

struct FreezerLayoutPreview_Previews: PreviewProvider {
    static var previews: some View {
        FreezerLayoutPreview(freezer_max_rows: .constant(0), freezer_max_columns: .constant(0),selected_row: .constant(0),selected_column: .constant(0), show_freezer_grid_layout: .constant(false))
    }
}


struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
