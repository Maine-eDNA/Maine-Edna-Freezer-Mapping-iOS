//
//  BoxEmptyItemCard.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/21/22.
//

import SwiftUI

struct BoxEmptyItemCard : View
{
    //@Binding var rack_box : BoxItemModel
    @State var box_color : String = "gray"
    @State var box_text_color : String = "white"
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300
    @State var freezer_box_row : Int = 0
    @State var freezer_box_column : Int  = 0
    @State var freezer_rack_depth : Int = 0
    @State var freezer_rack : String = "test"
    
    
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
                            Text(freezer_rack).foregroundColor(Color(wordName: box_text_color)).font(.caption).bold()
                            //
                        }
                        HStack{
                            Text("Empty").foregroundColor(Color(wordName: box_text_color)).font(.title3).bold().minimumScaleFactor(0.01)
                            
                        }
                        HStack{
                            VStack(alignment: .leading){
                                Text("Position").foregroundColor(Color(wordName: box_text_color)).font(.callout)//.bold()
                                
                                HStack{
                                    Text("Depth ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                    Text("\(freezer_rack_depth ?? 0)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                                    
                                    Text("Row ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                    Text("\(freezer_box_row)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                                    
                                    Text("Column ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                    Text("\(freezer_box_column)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                                }
                                
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
