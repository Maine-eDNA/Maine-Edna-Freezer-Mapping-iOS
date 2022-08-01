//
//  BoxItemCard.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/21/22.
//

import SwiftUI


struct BoxItemCard : View{
    @Binding var rack_box : BoxItemModel
    @Binding var rack_depth : Int
    @Binding var rack_row : Int
    @State var box_color : String = "blue"
    @State var box_text_color : String = "white"
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300
    
    var body : some View{
        VStack{
            
            Section{
                ZStack{
                    HStack{
                        Rectangle()
                            .rotation(.degrees(45), anchor: .bottomLeading)
                        // .scale(sqrt(2), anchor: .bottomLeading)
                            .frame(width: width, height: height)
                            .background(Color(wordName: box_color))
                            .foregroundColor(Color(wordName: box_color))
                            .clipped()
                    }.border(.black, width: 2)
                    VStack(alignment: .leading){
                        HStack(alignment: .top){
                            
                            Spacer().frame(width: 140,height: 10)
                            Text("\(rack_box.freezer_rack ?? "")").foregroundColor(Color(wordName: box_text_color)).font(.caption2).bold().minimumScaleFactor(0.01)
                            //
                        }
                        HStack{
                            Text("\(rack_box.freezer_box_label ?? "")").foregroundColor(Color(wordName: box_text_color)).font(.subheadline).bold().minimumScaleFactor(0.01)
                            
                        }
                        HStack{
                            VStack(alignment: .leading){
                                Text("Position").foregroundColor(Color(wordName: box_text_color)).font(.callout)//.bold()
                                
                                HStack{
                                    Text("Depth ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                    Text("\(rack_depth)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                                    
                                    Text("Row ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                    Text("\(rack_row)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                                    
                                    
                                    
                                    Text("Column ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                    Text("\(rack_box.freezer_box_column ?? 0)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                                }
                                
                            }
                            VStack(alignment: .leading){
                                
                            }
                            
                            
                        }
                    }
                }
                
                
                
                HStack{
                    Rectangle()
                        .rotation(.degrees(45), anchor: .bottomLeading)
                        .scale(sqrt(2), anchor: .bottomLeading)
                        .frame(width: width * 0.90, height: height * 0.15)
                        .background(Color(wordName: box_color))
                        .foregroundColor(Color(wordName: box_color))
                        .clipped()
                }.border(.black, width: 2)
                    .padding(.top, -10)
                
                
            }
            
            
            
        }
    }
}

struct BoxItemCard_Previews: PreviewProvider {
    static var previews: some View {
        var box = BoxItemModel()
        box.id = 1
        box.freezer_box_label = "rack_1_1_box_1"
        box.freezer_box_capacity_row = 10
        box.freezer_box_capacity_column = 10 //row x col equal max capacity
        box.freezer_rack = "Test_Freezer_Rack_1"
        
        return Group {
            
            BoxItemCard(rack_box: .constant(box),rack_depth: .constant(0),rack_row: .constant(0))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            BoxItemCard(rack_box: .constant(box),rack_depth: .constant(0),rack_row: .constant(0))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            
            BoxItemCard(rack_box: .constant(box),rack_depth: .constant(0),rack_row: .constant(0))
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            
        }
    }
    
    
}

