//
//  BoxEmptyItemColorSettingCard.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/21/22.
//

import SwiftUI

struct BoxEmptyItemColorSettingCard : View
{
    //@Binding var rack_box : BoxItemModel
    @Binding var box_color : Color
    @Binding var box_text_color : Color
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300
    @State var freezer_box_row : Int = 0
    @State var freezer_box_column : Int  = 0
    @State var freezer_rack_depth : Int = 0
    @State var freezer_rack : String = "test"
    
    
    var body : some View{
        VStack(alignment: .center){
            
            Section{
                ZStack{
                    HStack{
                        Rectangle()
                            .rotation(.degrees(45), anchor: .bottomLeading)
                        // .scale(sqrt(2), anchor: .bottomLeading)
                            .frame(width: width, height: height)
                            .background( box_color)
                            .foregroundColor( box_color)
                            .clipped()
                    }.border(.black, width: 2)
                    VStack(alignment: .leading){
                        HStack(alignment: .top){
                            
                            Spacer().frame(width: 140,height: 10)
                            Text(freezer_rack).foregroundColor( box_text_color).font(.caption).bold()
                            //
                        }
                        HStack{
                            Text("Empty").foregroundColor( box_text_color).font(.title).bold()
                            
                        }
                        HStack{
                            VStack(alignment: .leading){
                                Text("Position").foregroundColor(box_text_color).font(.callout)//.bold()
                                
                                HStack{
                                    Text("Depth ").foregroundColor( box_text_color).font(.callout).bold()
                                    Text("\(freezer_rack_depth ?? 0)").foregroundColor( box_text_color).font(.callout)
                                    
                                    Text("Row ").foregroundColor(box_text_color).font(.callout).bold()
                                    Text("\(freezer_box_row)").foregroundColor(box_text_color).font(.callout)
                                    
                                    
                                    Text("Column ").foregroundColor( box_text_color).font(.callout).bold()
                                    Text("\(freezer_box_column)").foregroundColor( box_text_color).font(.callout)
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
                        .background(box_color)
                        .foregroundColor(box_color)
                        .clipped()
                }.border(.black, width: 2)
                    .padding(.top, -10)
                
                
            }
            
            
            
        }
    }
}

