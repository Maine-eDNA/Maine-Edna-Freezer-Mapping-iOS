//
//  EmptyRackSlotView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/29/21.
//

import SwiftUI

struct EmptyRackSlotView: View {
    @Binding var empty_rack_color : String

    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        HStack{
            Rectangle()
                .rotation(.degrees(45), anchor: .bottomLeading)
                .scale(sqrt(2), anchor: .bottomLeading)
                .frame(width: width, height: height)
                .background(Color(wordName: empty_rack_color))
                .foregroundColor(Color(wordName: empty_rack_color))
                .clipped()
        }.border(.secondary, width: 2)
            .shadow(color: (Color(wordName: empty_rack_color) ?? Color.gray).opacity(0.50) , radius: 10, x: 10, y: 10)
        
        /*
         .shadow(color: Color.theme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
         */
    }
}

struct EmptyRackSlotView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRackSlotView(empty_rack_color: .constant("gray"))
    }
}
