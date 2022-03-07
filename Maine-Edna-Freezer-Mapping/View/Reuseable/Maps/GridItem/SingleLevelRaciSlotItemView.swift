//
//  SingleLevelRaciSlotItemView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/29/21.
//

import SwiftUI

struct SingleLevelRaciSlotItemView: View {
    @Binding var single_lvl_rack_color : String

    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        HStack{
            Rectangle()
                .rotation(.degrees(45), anchor: .bottomLeading)
                .scale(sqrt(2), anchor: .bottomLeading)
                .frame(width: width, height: height)
                .background(Color(wordName: single_lvl_rack_color))
                .foregroundColor(Color(wordName: single_lvl_rack_color))
                .clipped()
        }.border(.secondary, width: 2)
    }
}

struct SingleLevelRaciSlotItemView_Previews: PreviewProvider {
    static var previews: some View {
        SingleLevelRaciSlotItemView(single_lvl_rack_color: .constant("orange"))
    }
}
