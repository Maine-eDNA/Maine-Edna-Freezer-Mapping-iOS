//
//  SuggestedRackGridItemView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 2/10/22.
//

import SwiftUI



struct SuggestedRackGridItemView: View {
    @Binding var inner_rack_rect_color : String
    @Binding var outline_color : String
    @Binding var rack_label : String
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        ZStack{
          
        HStack{
            Rectangle()
                .rotation(.degrees(45), anchor: .bottomLeading)
                .scale(sqrt(2), anchor: .bottomLeading)
                .frame(width: width, height: height)
                .background(Color(wordName: outline_color))
                .foregroundColor(Color(wordName: outline_color))
                .clipped()
        }.border(.secondary, width: 2)
            HStack{
                Rectangle()
                    .rotation(.degrees(45), anchor: .bottomLeading)
                    .scale(sqrt(2), anchor: .bottomLeading)
                    .frame(width: width * 0.75, height: width * 0.75)
                    .background(Color(wordName: inner_rack_rect_color))
                    .foregroundColor(Color(wordName: inner_rack_rect_color))
                    .clipped()
            }.border(.secondary, width: 2)
            
            Text(!rack_label.isEmpty ? rack_label.suffix(4) : "N/A").font(.system(size: 9)).foregroundColor(.white).bold()
    }
    }
}

struct SuggestedRackGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestedRackGridItemView(inner_rack_rect_color: .constant("orange"), outline_color: .constant("yellow"), rack_label: .constant("Esg2021"))
    }
}

