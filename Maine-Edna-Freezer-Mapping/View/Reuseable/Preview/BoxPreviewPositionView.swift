//
//  BoxPreviewView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/29/22.
//

import SwiftUI


struct BoxPreviewPositionView : View{
    @Binding var column : Int
    @Binding var row : Int
    @Binding var rack_profile : RackItemModel
    
    var body: some View{
        VStack(alignment: .leading,spacing: 0){
            GeometryReader{
                reader in
                
                VStack(spacing: 1){
                    //Rectangle().foregroundColor(.blue)
                    VStack{
                        Text("Column").font(.subheadline).foregroundColor(.secondary)
                        Text("\(column)").font(.subheadline).foregroundColor(.primary).bold()
                        
                    }
                    HStack{
                        VStack{
                            Text("Row").font(.subheadline).foregroundColor(.secondary)
                            Text("\(row)").font(.subheadline).foregroundColor(.primary).bold()
                            
                        }
                        
                        //start
                        SuggestedBoxItemCard(box_color: "blue", box_text_color: "white", freezer_box_row: 0, freezer_box_column: 0,freezer_rack: rack_profile.freezer_rack_label)
                        
                        //end
                        
                    }
                    
                }
            }.frame(width: 200,height: 200)
        }
    }
}

