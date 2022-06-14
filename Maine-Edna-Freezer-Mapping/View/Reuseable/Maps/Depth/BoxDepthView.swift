//
//  BoxDepthView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 5/9/22.
//

import SwiftUI

struct BoxDepthView: View {
    
      let columns = [
          GridItem(.adaptive(minimum: 100))
      ]
  
      @Binding  var freezer_box_max_rows : Int
      @Binding var background_color : String
      
      var body: some View {
          
          GridStack(rows: freezer_box_max_rows, columns: 1) { row, col in
              
              BoxDepthRow(background_color: $background_color)
             
           }
       }
}

struct BoxDepthView_Previews: PreviewProvider {
    static var previews: some View {
        BoxDepthView(freezer_box_max_rows: .constant(0), background_color: .constant("blue"))
    }
}


struct BoxDepthRow: View {
    @Binding var background_color : String

    
    @State var width : CGFloat = 150
    @State var height : CGFloat = 25
    
    var body: some View {
        HStack{
            Rectangle()
                .rotation(.degrees(45), anchor: .bottomLeading)
                .scale(sqrt(2), anchor: .bottomLeading)
                .frame(width: width, height: height)
                .background(Color(wordName: background_color))
                .foregroundColor(Color(wordName: background_color))
                .clipped()
        }.border(.secondary, width: 2)
            .shadow(color: (Color(wordName: background_color) ?? Color.gray).opacity(0.25) , radius: 10, x: 10, y: 10)
    }
}
