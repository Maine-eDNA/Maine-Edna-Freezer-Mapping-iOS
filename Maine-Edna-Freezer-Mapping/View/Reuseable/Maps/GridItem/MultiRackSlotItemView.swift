//
//  MultiRackSlotItemView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/29/21.
//

import SwiftUI

struct MultiRackSlotItemView: View {
    @Binding var top_half_color : String
    @Binding var bottom_half_color : String
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        HStack{
            Rectangle()
                .rotation(.degrees(45), anchor: .bottomLeading)
                .scale(sqrt(2), anchor: .bottomLeading)
                .frame(width: width, height: height)
                .background(Color(wordName: top_half_color))
                .foregroundColor(Color(wordName: bottom_half_color))
                .clipped()
        }.border(.secondary, width: 2)
            .shadow(color: (Color(wordName: top_half_color) ?? Color.gray).opacity(0.25) , radius: 10, x: 10, y: 10)
    }
}

struct MultiRackSlotItemView_Previews: PreviewProvider {
    static var previews: some View {
        MultiRackSlotItemView(top_half_color: .constant("blue"), bottom_half_color: .constant("gray"))
    }
}
