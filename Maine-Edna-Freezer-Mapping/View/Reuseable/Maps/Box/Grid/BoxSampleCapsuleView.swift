//
//  BoxSampleCapsuleView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/29/21.
//

import SwiftUI

struct BoxSampleCapsuleView: View {
    @Binding var background_color : String
    @Binding var sample_code : String
    @Binding var sample_type_code : String
    @Binding var foreground_color : String
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        
        ZStack{
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
                //.background(Color(wordName: single_lvl_rack_color) ?? Color.orange)
                .background(Circle().foregroundColor(Color(wordName: background_color) ?? Color.orange))
                .frame(width: width, height: height)
                
            
            Circle()
              //  .fill(Color(wordName: single_lvl_rack_color) ?? Color.orange, stroke: StrokeStyle(lineWidth:1, dash:2))
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: width * 0.85, height: height * 0.85)
                //.strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor(Color(wordName: background_color) ?? Color.orange))
            VStack{
                Text("\(sample_type_code.capitalized)").font(.caption2).foregroundColor(Color(wordName: foreground_color)).bold()
                Text("\(sample_code)").font(.system(size: 9)).foregroundColor(Color(wordName: foreground_color)).bold()
            }
        }
     
    }
}

struct BoxSampleCapsuleView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSampleCapsuleView(background_color: .constant("orange"), sample_code: .constant("0002"),sample_type_code: .constant("F"), foreground_color: .constant("white"))
    }
}


struct BoxSampleCapsuleColorView: View {
    @Binding var background_color : Color
    @Binding var sample_code : String
    @Binding var sample_type_code : String
    @Binding var foreground_color : Color
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    
    var body: some View {
        
        ZStack{
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
                //.background(Color(wordName: single_lvl_rack_color) ?? Color.orange)
                .background(Circle().foregroundColor(background_color ?? Color.orange))
                .frame(width: width, height: height)
                
            
            Circle()
              //  .fill(Color(wordName: single_lvl_rack_color) ?? Color.orange, stroke: StrokeStyle(lineWidth:1, dash:2))
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: width * 0.85, height: height * 0.85)
                //.strokeBorder(Color.blue,lineWidth: 4)
                .background(Circle().foregroundColor( background_color ?? Color.orange))
            VStack{
                Text("\(sample_type_code.capitalized)").font(.caption2).foregroundColor(foreground_color).bold()
                Text("\(sample_code)").font(.system(size: 9)).foregroundColor(foreground_color).bold()
            }
        }
     
    }
}
