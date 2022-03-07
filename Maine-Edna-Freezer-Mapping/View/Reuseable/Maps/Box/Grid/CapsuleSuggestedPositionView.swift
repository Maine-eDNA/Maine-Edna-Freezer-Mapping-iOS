//
//  CapsuleSuggestedPositionView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 2/1/22.
//

import SwiftUI

struct CapsuleSuggestedPositionView: View {
    
    @Binding var single_lvl_rack_color : String
    @Binding var sample_code : String
    @Binding var sample_type_code : String
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        
        ZStack{
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
                //.background(Color(wordName: single_lvl_rack_color) ?? Color.orange)
                .background(Circle().foregroundColor(Color(wordName: "yellow") ?? Color.orange))
                .frame(width: width, height: height)
                
            
            Circle()
              //  .fill(Color(wordName: single_lvl_rack_color) ?? Color.orange, stroke: StrokeStyle(lineWidth:1, dash:2))
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: width * 0.85, height: height * 0.85)
                //.strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor(Color(wordName: single_lvl_rack_color) ?? Color.orange))
            VStack{
                Text("\(sample_type_code.capitalized)").font(.caption2).foregroundColor(.white).bold()
                Text("\(sample_code)").font(.system(size: 9)).foregroundColor(.white).bold()
            }
        }
    }
}

struct CapsuleSuggestedPositionView_Previews: PreviewProvider {
    
    static var previews: some View {
        CapsuleSuggestedPositionView(single_lvl_rack_color: .constant("orange"), sample_code: .constant("0002"),sample_type_code: .constant("F"))
    }
}
