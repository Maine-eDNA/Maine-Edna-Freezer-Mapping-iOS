//
//  EditUserColorThemeView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 1/24/22.
//

import SwiftUI

struct EditUserColorThemeView: View {
    //use the same view for each color type
    @Binding  var in_use_background_color : String
    @Binding var in_use_text_color : String
    
    @Binding var empty_background_color : String
    @Binding var empty_text_color : String
    @Binding var freezer_part_name : String
    
    @State var in_use_background_color_c = Color.blue
    @State var in_use_text_color_c = Color.white
    
    @State var empty_background_color_c = Color.gray
    @State var empty_text_color_c = Color.white
    
    //TODO: Make the color change here store to the local and server Database
    //TODO: on save i should convert the color back into string
    var body: some View {
        VStack(alignment: .leading){
            //  ScrollView(showsIndicators: false){
            Text("For \(self.freezer_part_name)").font(.title).bold()
            
            if self.freezer_part_name == "Inventory"{
                withAnimation(.spring()){
                    //reusable start
                    CapsuleColorSettingView(in_use_background_color: $in_use_background_color, in_use_text_color: $in_use_text_color, empty_background_color: $empty_background_color, empty_text_color: $empty_text_color, freezer_part_name: $freezer_part_name,in_use_background_color_c: $in_use_background_color_c,in_use_text_color_c: $in_use_text_color_c,empty_background_color_c: $empty_background_color_c,empty_text_color_c: $empty_text_color_c)
                    //reuseable end
                }
            }
            else if self.freezer_part_name == "Box"{
                withAnimation(.spring()){
                    //reusable start
                    FreezerBoxColorSettingView(in_use_background_color: $in_use_background_color, in_use_text_color: $in_use_text_color, empty_background_color: $empty_background_color, empty_text_color: $empty_text_color, freezer_part_name: $freezer_part_name,in_use_background_color_c: $in_use_background_color_c,in_use_text_color_c: $in_use_text_color_c,empty_background_color_c: $empty_background_color_c,empty_text_color_c: $empty_text_color_c)
                    //reuseable end
                }
            }
            //  }
            Spacer()
        }.padding()
        
            .onAppear(){
                print("Descriptive Description \(self.in_use_background_color_c.description)")
                //Capsule
                //set the colors
                if !self.in_use_background_color.isEmpty{
                    in_use_background_color_c = Color(wordName: in_use_background_color)!
                }
                
                if !self.in_use_text_color.isEmpty{
                    in_use_text_color_c = Color(wordName: in_use_text_color)!
                }
                
                if !self.empty_background_color.isEmpty{
                    print("\(empty_background_color)")
                    empty_background_color_c = Color(wordName: empty_background_color)!
                }
                
                if !self.empty_text_color.isEmpty{
                    empty_text_color_c = Color(wordName: empty_text_color)!
                }
                
                //Box
                
                
            }
    }
}

struct EditUserColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserColorThemeView(in_use_background_color: .constant("orange"), in_use_text_color: .constant("white"), empty_background_color: .constant("gray"), empty_text_color: .constant("white"), freezer_part_name: .constant("Inventory"))
    }
}


struct ColorRectangle : View{
    @Binding var color : Color
    
    var body: some View{
        Rectangle().fill(color ?? Color.orange).frame(width: 50,height: 50).border(.secondary, width: 1)
    }
}



struct CapsuleColorSettingView : View{
    
    @Binding  var in_use_background_color : String
    @Binding var in_use_text_color : String
    
    @Binding var empty_background_color : String
    @Binding var empty_text_color : String
    @Binding var freezer_part_name : String
    
    @Binding var in_use_background_color_c : Color
    @Binding var in_use_text_color_c : Color
    
    @Binding var empty_background_color_c : Color
    @Binding var empty_text_color_c : Color
    
    var body: some View{
        
        VStack(alignment: .leading){
            Section(header: Text("In-Use Colors").font(.title3).bold()) {
                
                VStack(alignment: .leading){

                    VStack(alignment: .leading){
                        HStack{
                            VStack(alignment: .leading){
                                Section(header: Text("Background").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $in_use_background_color_c)
                                        ColorRectangle(color: $in_use_background_color_c)
                                        
                                    }.frame(width: 100)//.background(Color.red)
                                }
                         
                                Section(header: Text("Text Color").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $in_use_text_color_c)
                                    ColorRectangle(color: $in_use_text_color_c)
                                    }.frame(width: 100)
                                }
                            }
                            Spacer().frame(width: UIScreen.main.bounds.width * 0.40)
                            VStack(alignment: .center){
                                Text("Preview").font(.subheadline).bold()
                                BoxSampleCapsuleColorView(background_color: $in_use_background_color_c,sample_code: .constant(String( "0001")),sample_type_code: .constant(String( "F")), foreground_color: $in_use_text_color_c,width: 100,height: 100)
                            }
                        }
                        
                    }

                }
                
                
                
            }
            Section(header: Text("Empty Colors").font(.title3).bold()) {
                VStack(alignment: .leading){

                    VStack(alignment: .leading){
                        HStack{
                            VStack(alignment: .leading){
                                Section(header: Text("Background").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $empty_background_color_c)
                                        ColorRectangle(color: $empty_background_color_c)
                                        
                                    }.frame(width: 100)
                                }
                         
                                Section(header: Text("Text Color").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $empty_text_color_c)
                                    ColorRectangle(color: $empty_text_color_c)
                                    }.frame(width: 100)
                                }
                            }
                            Spacer().frame(width: UIScreen.main.bounds.width * 0.40)
                            VStack(alignment: .center){
                                Text("Preview").font(.subheadline).bold()
                                BoxSampleCapsuleColorView(background_color: $empty_background_color_c,sample_code: .constant(String( "0001")),sample_type_code: .constant(String( "F")), foreground_color: $empty_text_color_c,width: 100,height: 100)
                            }
                        }
                        
                    }

                }
            }
        }
    }
}




struct FreezerBoxColorSettingView : View{
    
    @Binding  var in_use_background_color : String
    @Binding var in_use_text_color : String
    
    @Binding var empty_background_color : String
    @Binding var empty_text_color : String
    @Binding var freezer_part_name : String
    
    @Binding var in_use_background_color_c : Color
    @Binding var in_use_text_color_c : Color
    
    @Binding var empty_background_color_c : Color
    @Binding var empty_text_color_c : Color
    
    var body: some View{
        
        VStack(alignment: .leading){
            Section(header: Text("In-Use Colors").font(.title3).bold()) {
                
                VStack(alignment: .leading){

                    VStack(alignment: .leading){
                        HStack{
                            VStack(alignment: .leading){
                                Section(header: Text("Background").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $in_use_background_color_c)
                                        ColorRectangle(color: $in_use_background_color_c)
                                        
                                    }.frame(width: 100)//.background(Color.red)
                                }
                         
                                Section(header: Text("Text Color").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $in_use_text_color_c)
                                    ColorRectangle(color: $in_use_text_color_c)
                                    }.frame(width: 100)
                                }
                            }
                            Spacer().frame(width: UIScreen.main.bounds.width * 0.30)
                            VStack(alignment: .center){
                                Text("Preview").font(.subheadline).bold()
                                BoxEmptyItemColorSettingCard(box_color: $in_use_background_color_c, box_text_color: $in_use_text_color_c,  height: 100, width:150, freezer_box_row: 0, freezer_box_column: 0, freezer_rack: "")
                               
                                
                            }
                        }
                        
                    }

                }
                
                
                
            }
            Section(header: Text("Empty Colors").font(.title3).bold()) {
                VStack(alignment: .leading){
              
                    VStack(alignment: .leading){
                        HStack{
                            VStack(alignment: .leading){
                                Section(header: Text("Background").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $empty_background_color_c)
                                        ColorRectangle(color: $empty_background_color_c)
                                        
                                    }.frame(width: 100)
                                }
                         
                                Section(header: Text("Text Color").font(.subheadline).bold()) {
                                    HStack(spacing: 10){
                                        ColorPicker("", selection: $empty_text_color_c)
                                    ColorRectangle(color: $empty_text_color_c)
                                    }.frame(width: 100)
                                }
                            }
                            Spacer().frame(width: UIScreen.main.bounds.width * 0.30)
                            VStack(alignment: .center){
                                Text("Preview").font(.subheadline).bold()
                                BoxEmptyItemColorSettingCard(box_color: $empty_background_color_c, box_text_color: $empty_text_color_c,  height: 100, width:150, freezer_box_row: 0, freezer_box_column: 0, freezer_rack: "")
                               
                                
                            }
                        }
                        
                    }

                }
            }
            
            .navigationTitle("Box Color Theme")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}
