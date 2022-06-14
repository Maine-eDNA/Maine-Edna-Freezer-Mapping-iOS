//
//  FreezerBoxDepthView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 5/23/22.
//

import Foundation
import SwiftUI


struct FreezerBoxDepthView : View
{
    @Binding var rack_box : BoxItemModel
    @State var box_color : String = "gray"
    @State var box_text_color : String = "white"
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300
    @State var freezer_box_row : Int = 0
    @State var freezer_box_column : Int  = 0
    @State var freezer_rack : String = "test"
    
    //If multiple rows, show a dropdown to select which row they would like row 1 or row 2 (if more than 1 row exist)
    //Row 1 -> Row one segment only
    //Row 2 -> Row two segment only
    var body : some View{
        VStack(alignment: .leading, spacing: 0){
            
            //  boxsection
            //     .rotationEffect(.degrees(0))
            //MARK: Front stacked view
            /*  boxsection
             .rotationEffect(.degrees(5))
             boxsection
             .rotationEffect(.degrees(5))
             .padding(.top,10)
             boxsection
             .rotationEffect(.degrees(5))
             .padding(.top,20)
             boxsection
             .rotationEffect(.degrees(5))
             .padding(.top,30)*/
            //Depth
            VStack(alignment: .leading){
                Text("Front").font(.title).bold()
                //depth
                ForEach(1 ..< 3, id: \.self) { j in
                    HStack(){
                        
                        ZStack{
                            ForEach(1 ..< 6, id: \.self) { i in
                                
                                boxsection
                                    .opacity(0.15 * CGFloat(i))
                                    .rotationEffect(.degrees(180),anchor: .bottomTrailing)
                                //         .padding(.top,10 * CGFloat(i))
                            }
                        }
                    }
                }
            }
            Spacer(minLength: 1)
            //MARK: Size stacked view
            //Depth
            VStack(alignment: .leading){
                //depth
                ForEach(1 ..< 2, id: \.self) { j in
                    HStack(){
                        
                        ZStack{
                            ForEach(1 ..< 6, id: \.self) { i in
                                
                                boxsection
                                    .opacity(0.15 * CGFloat(i))
                                    .rotationEffect(.degrees(170),anchor: .bottomTrailing)
                                    .padding(.top,10 * CGFloat(i))
                            }
                        }
                    }
                }
                //Spacer()
            }.background(Color.clear)
            
            
            VStack(){
                //Depth
                VStack(alignment: .leading){
                    Text("Side").font(.title).bold()
                    //depth
                    ForEach(1 ..< 3, id: \.self) { j in
                        HStack(spacing: 1){
                            //row
                            ForEach(1 ..< 6, id: \.self) { i in
                                
                                ZStack{
                                    
                                    Rectangle()
                                        .background(Color(wordName: box_color))
                                        .foregroundColor(Color(wordName: box_color))
                                        .frame(width: 60, height: height)
                                    
                                    VStack(alignment: .leading){
                                        
                                        
                                        
                                        Text("R\(i)").foregroundColor(Color(wordName: box_text_color)).font(.caption).bold()
                                        //
                                        
                                    }
                                }
                                // .padding(.top,10 * CGFloat(i))
                                /*boxsection
                                 .rotationEffect(.degrees(170),anchor: .bottomTrailing)
                                 .padding(.top,10 * CGFloat(i))
                                 }*/
                            }
                            
                            //Spacer(minLength: 10)
                        }
                    }
                }
                //.background(Color.red)
                
            }
            
            
            HStack(){
                //Depth
                VStack(alignment: .leading){
                    Text("Top").font(.title).bold()
                    //depth
                   
                    ForEach(1 ..< 3, id: \.self) { row in
                        HStack(spacing: 1){
                            //row
                            Text("A")
                            ForEach(1 ..< 6, id: \.self) { col in
                                VStack{
                                    if row == 1{
                                        //first row
                                        Text("1")
                                    }
                                ZStack{
                                    
                                    Rectangle()
                                        .background(Color(wordName: box_color))
                                        .foregroundColor(Color(wordName: box_color))
                                        .frame(width: 60, height: 60)
                                    
                                    VStack(alignment: .leading){
                                        
                                        
                                        
                                        Text("R\(col)").foregroundColor(Color(wordName: box_text_color)).font(.caption).bold()
                                        //
                                        
                                    }
                                }
                                
                                    if row == 2{
                                        //second to last row (n-1)
                                        Text("1")
                                    }
                            }
                                // .padding(.top,10 * CGFloat(i))
                                /*boxsection
                                 .rotationEffect(.degrees(170),anchor: .bottomTrailing)
                                 .padding(.top,10 * CGFloat(i))
                                 }*/
                            }
                            
                            //Spacer(minLength: 10)
                        }
                    }
                }
                //.background(Color.red)
                
            }
        }
    }
}

struct FreezerBoxDepthView_Previews: PreviewProvider {
    static var previews: some View {
        var box = BoxItemModel()
        box.id = 1
        box.freezer_box_label = "rack_1_1_box_1"
        box.freezer_box_capacity_row = 10
        box.freezer_box_capacity_column = 10 //row x col equal max capacity
        box.freezer_rack = "Test_Freezer_Rack_1"
        
        return Group {
            
            FreezerBoxDepthView(rack_box: .constant(box))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            FreezerBoxDepthView(rack_box: .constant(box))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            
            FreezerBoxDepthView(rack_box: .constant(box))
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            
        }
    }
    
    
}


extension FreezerBoxDepthView{
    
    private  var boxsection : some View{
        Section{
            ZStack{
                VStack(alignment: .leading){
                    HStack{
                        Rectangle()
                            .rotation(.degrees(45), anchor: .bottomLeading)
                            .scale(sqrt(2), anchor: .bottomLeading)
                            .frame(width: width * 0.90, height: height * 0.15)
                            .background(Color(wordName: box_color))
                            .foregroundColor(Color(wordName: box_color))
                            .clipped()
                    }     .padding(.leading,15)
                    HStack{
                        Rectangle()
                            .rotation(.degrees(45), anchor: .bottomLeading)
                        // .scale(sqrt(2), anchor: .bottomLeading)
                            .frame(width: width, height: height)
                            .background(Color(wordName: box_color))
                            .foregroundColor(Color(wordName: box_color))
                            .clipped()
                    }.border(.black, width: 2)
                        .border(.black, width: 2)
                        .padding(.top, -10)
                    
                }
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
                                Text("Row ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                Text("\(freezer_box_row)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                                Text("Column ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                Text("\(freezer_box_column)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
                            }
                            
                        }
                        
                    }
                    
                    
                    
                    
                }.rotationEffect(.degrees(180))
            }
            
            
            
            /*  HStack{
             Rectangle()
             .rotation(.degrees(45), anchor: .bottomLeading)
             .scale(sqrt(2), anchor: .bottomLeading)
             .frame(width: width * 0.90, height: height * 0.15)
             .background(Color(wordName: box_color))
             .foregroundColor(Color(wordName: box_color))
             .clipped()
             }.border(.black, width: 2)
             .padding(.top, -10)*/
            
            
        }
    }
}
