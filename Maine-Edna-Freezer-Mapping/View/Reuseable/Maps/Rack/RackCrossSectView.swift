//
//  RackCrossSectView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

struct RackCrossSectView: View {
    
    var rack_profile : RackItemModel
    @Binding var rack_boxes : [BoxItemModel]
    @Binding var freezer_profile : FreezerProfileModel
    
    //Css section
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_user_default_css : [UserCssModel] = [UserCssModel]()
    @State var user_css_settings : UserCssModel = UserCssModel()
    @ObservedObject var convert_service : ClassConverter = ClassConverter()
    
    //default css
    //if user css doesnt exist create one for this user
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    
    //New
    @Binding var show_guided_box_view : Bool
    @Binding var show_guided_rack_view : Bool
    
    
    
    var body: some View {
#warning("Required Validation when entering new box it must meet the validation rules below")
        //TODO: - Need to add validation to prevent user from adding a position outside of the scope of the box, rack or freezer ( min starting position max position the max or furthest space)
        
        /*
         Max Box Columns (Inventory) and Max Box Rows (Inventory) means the capacity of the Box 10 x 10 means 100 samples max
         
         So a Rack with 3 columns means a box can be in any of the 3 columns
         and a the rack has 5 Rows it means it can be in any of the rows
         so any of the row and column combination but must not fall outside of the range else show error
         */
        VStack{
            //Text("\(rack_profile.freezer_rack_row_start) \(rack_profile.freezer_rack_row_end)")
            //Text("\(rack_profile.freezer_rack_column_start) \(rack_profile.freezer_rack_column_end)")
            ForEach(rack_profile.freezer_rack_row_start ..< rack_profile.freezer_rack_row_end, id: \.self) { row in
                HStack {
                    ForEach(rack_profile.freezer_rack_column_start ..< rack_profile.freezer_rack_column_end, id: \.self) { column in
                        ForEach($rack_boxes, id: \.freezer_box_label) {
                            box in
                            
                            if box.is_suggested_box_position.wrappedValue{
                                NavigationLink(destination: FreezerInventoryView(box_detail: box, freezer_profile: self.$freezer_profile)){
                                    SuggestedBoxItemCard(box_color: "green", box_text_color: "white", freezer_box_row: row, freezer_box_column: column,freezer_rack: rack_profile.freezer_rack_label)
                                        .onTapGesture {
                                            
                                            self.show_guided_rack_view = false
                                            self.show_guided_box_view.toggle()
                                        }
                                }
                            }
                            else if box.freezer_box_column.wrappedValue == column && box.freezer_box_row.wrappedValue == row {
                                NavigationLink(destination: FreezerInventoryView(box_detail: box, freezer_profile: self.$freezer_profile)){
                                    BoxItemCard(rack_box: box)
                                    
                                }
                            }
                            else{
                                //Create new box: send the row and column the current box is in and the freezer info
                                NavigationLink(destination: CreateNewFreezerBoxView(row: .constant(row), column: .constant(column), freezer_profile: self.$freezer_profile,rack_profile: .constant(self.rack_profile))){
                                    BoxEmptyItemCard(freezer_box_row: row , freezer_box_column: column,freezer_rack: rack_profile.freezer_rack_label)
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            
            
            
            
            
        }
        .onAppear{
            //get user css profile
            if self.store_user_default_css.count > 0{
                user_css_settings = self.store_user_default_css.first!
            }
            else{
                //use the default values
                if self.store_default_css.count > 0{
                    user_css_settings = self.convert_service.DefaultCssToUserCss(_user_email: self.store_email_address, _default_css: self.store_default_css.first!)
                    print("User Settings from default Css Sample: \(user_css_settings.freezer_empty_box_css_background_color)")
                }
                
            }
            
            
            
        }
    }
}

///.background(Color(wordName: box_color))//set the color based on the status of the box empty, half full and full (not available)
struct BoxItemCard : View{
    @Binding var rack_box : BoxItemModel
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
                            Text("\(rack_box.freezer_rack ?? "")").foregroundColor(Color(wordName: box_text_color)).font(.caption).bold()
                            //
                        }
                        HStack{
                            Text("\(rack_box.freezer_box_label ?? "")").foregroundColor(Color(wordName: box_text_color)).font(.title).bold()
                            
                        }
                        HStack{
                            VStack(alignment: .leading){
                                Text("Position").foregroundColor(Color(wordName: box_text_color)).font(.callout)//.bold()
                                
                                HStack{
                                    Text("Row ").foregroundColor(Color(wordName: box_text_color)).font(.callout).bold()
                                    Text("\(rack_box.freezer_box_row ?? 0)").foregroundColor(Color(wordName: box_text_color)).font(.callout)
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
            
            BoxItemCard(rack_box: .constant(box))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            BoxItemCard(rack_box: .constant(box))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            
            BoxItemCard(rack_box: .constant(box))
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            
        }
    }
    
    
}


struct BoxEmptyItemCard : View
{
    //@Binding var rack_box : BoxItemModel
    @State var box_color : String = "gray"
    @State var box_text_color : String = "white"
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300
    @State var freezer_box_row : Int = 0
    @State var freezer_box_column : Int  = 0
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
                            Text("Empty").foregroundColor(Color(wordName: box_text_color)).font(.title).bold()
                            
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

struct SuggestedBoxItemCard : View
{
    @State var box_color : String = "gray"
    @State var box_text_color : String = "white"
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300
    @State var freezer_box_row : Int = 0
    @State var freezer_box_column : Int  = 0
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
                            Text("Empty").foregroundColor(Color(wordName: box_text_color)).font(.title).bold()
                            
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
                            Spacer()
                            VStack(alignment: .leading){
                                BoxSampleCapsuleColorView(background_color: .constant(.white), sample_code: .constant(""), sample_type_code: .constant(""), foreground_color: .constant(.primary)).padding()
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



struct RackCrossSectView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        var rack_profile : RackItemModel = RackItemModel()
        var rack_boxes : [BoxItemModel] = [BoxItemModel]()
        var box = BoxItemModel()
        box.id = 1
        box.freezer_box_label = "rack_1_1_box_1"
        box.freezer_box_capacity_row = 10
        box.freezer_box_capacity_column = 10 //row x col equal max capacity
        rack_boxes.append(box)
        
        
        var box2 = BoxItemModel()
        box2.id = 2
        box2.freezer_box_label = "rack_1_1_box_2"
        box2.freezer_box_capacity_row = 10
        box2.freezer_box_capacity_column = 10 //row x col equal max capacity
        rack_boxes.append(box2)
        
        
        rack_profile.freezer_rack_depth_end = 1
        rack_profile.freezer_rack_depth_start = 1
        rack_profile.freezer_rack_column_start = 1
        rack_profile.created_by = "keijaoh.campbell@maine.edu"
        rack_profile.freezer = "Freezer_Test_1"
        rack_profile.freezer_rack_label = "Freezer_Test_1_Rack_1"
        
        
        return Group {
            
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            
            RackCrossSectView(rack_profile: rack_profile, rack_boxes: .constant(rack_boxes), freezer_profile: .constant(FreezerProfileModel()),show_guided_box_view: .constant(false),show_guided_rack_view: .constant(false))
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            
        }
    }
}


struct BoxEmptyItemColorSettingCard : View
{
    //@Binding var rack_box : BoxItemModel
    @Binding var box_color : Color
    @Binding var box_text_color : Color
    @State var height : CGFloat = 150
    @State var width : CGFloat = 300
    @State var freezer_box_row : Int = 0
    @State var freezer_box_column : Int  = 0
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
