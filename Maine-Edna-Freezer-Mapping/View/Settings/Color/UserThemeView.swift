//
//  UserThemeView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 1/24/22.
//

import SwiftUI

struct UserThemeView: View {
    
    @AppStorage(AppStorageNames.store_logged_in_user_profile.rawValue)  var store_logged_in_user_profile : [UserProfileModel] = [UserProfileModel]()
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    @ObservedObject var user_management_service : UserProfileManagment = UserProfileManagment()
    @ObservedObject var convert_service : ClassConverter = ClassConverter()
    //default css
    //if user css doesnt exist create one for this user
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_user_default_css : [UserCssModel] = [UserCssModel]()
    
    @State var target_user_css : UserCssModel = UserCssModel()
    
    var body: some View {
    
        VStack(alignment: .leading){
            List{
            /*
             @Published var  : String = ""
             @Published var  : String = ""
             
             @Published var  : String = ""
             @Published var  : String = ""
             */
            Section("Freezer") {
                NavigationLink(destination: EditUserColorThemeView(in_use_background_color:  self.$target_user_css.freezer_inuse_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_css_text_color, freezer_part_name: .constant("Freezer"))){
                    InUseEmptyColorCardView(in_use_background_color:  self.$target_user_css.freezer_inuse_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_css_text_color)
                    
                }
            }
            
            Section("Rack") {
                NavigationLink(destination: EditUserColorThemeView(in_use_background_color:  self.$target_user_css.freezer_inuse_rack_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_rack_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_rack_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_rack_css_text_color,freezer_part_name: .constant("Rack"))){
                    InUseEmptyColorCardView(in_use_background_color:  self.$target_user_css.freezer_inuse_rack_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_rack_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_rack_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_rack_css_text_color)
                    
                }
            }
            
            Section("Box") {
                NavigationLink(destination: EditUserColorThemeView(in_use_background_color:  self.$target_user_css.freezer_inuse_box_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_box_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_box_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_box_css_text_color,freezer_part_name: .constant("Box"))){
                    InUseEmptyColorCardView(in_use_background_color:  self.$target_user_css.freezer_inuse_box_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_box_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_box_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_box_css_text_color)
                    
                }
            }
            
            Section("Inventory") {
                NavigationLink(destination: EditUserColorThemeView(in_use_background_color:  self.$target_user_css.freezer_inuse_inventory_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_inventory_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_inventory_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_inventory_css_text_color,freezer_part_name: .constant("Inventory"))){
                    InUseEmptyColorCardView(in_use_background_color:  self.$target_user_css.freezer_inuse_inventory_css_background_color,in_use_text_color:  self.$target_user_css.freezer_inuse_inventory_css_text_color,empty_background_color: self.$target_user_css.freezer_empty_inventory_css_background_color,empty_text_color: self.$target_user_css.freezer_empty_inventory_css_text_color)
                    
                }
            }
            
        }
            
        }
        .onAppear{
            self.LoadUserCss()
            
            print("Default Css Count \(self.store_default_css.count)")
            print("User Default Css Count \(self.store_user_default_css.count)")
            
        
            
        }
        .navigationTitle("User Theme")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    //functions
    func LoadUserCss(){
        if self.store_user_default_css.count < 1{
            //get the store_default_css then store the result in store_user_default_css
            
            Task{
                do{
                    let response =  try await
                    self.user_management_service.FetchDefaultCss(){
                        response in
                        print("Response is: \(response)")
                        let user_css_profile : UserCssModel = self.convert_service.DefaultCssToUserCss(_user_email: self.store_email_address, _default_css: response)
                        
                        
                        //set target variable
                       
                        self.target_user_css = user_css_profile
                     
                        
                        //create user css
                        self.user_management_service.CreateNewUserCSS(_userCssDetail: user_css_profile){
                            user_css_response in
                            print("Response is: \(user_css_response)")
                            //once response get the user css profile
                            self.user_management_service.FetchUserCss(){
                                resp_user_css_profile in
                                
                                
                                self.target_user_css = resp_user_css_profile
                            }
                            
                        }
                        
                      
                    }
                    
                }
                
                
                
                catch{
                    //  AlertToast(type: .error(Color.red), title: "Error: \(error.localizedDescription)")
                    print("Error: \(error.localizedDescription)")
                }
                
            }
            //store_user_default_css
            
        }
        else{
            //fetch the the user css model
            
            self.user_management_service.FetchUserCss(){
                resp_user_css_profile in
                
                
                self.target_user_css = resp_user_css_profile
            }
            
            
            
        }
    }
}

struct UserThemeView_Previews: PreviewProvider {
    static var previews: some View {
        UserThemeView()
    }
}


struct ColorSchemeBlock : View{
    @Binding var color : String
    @Binding var label_text : String
    
    @State var width : CGFloat = 50
    @State var height : CGFloat = 50
    var body: some View{
        VStack{
            Text("\(label_text)").font(.caption2).foregroundColor(.secondary)
        HStack{
            Rectangle()
                .rotation(.degrees(45), anchor: .bottomLeading)
                .scale(sqrt(2), anchor: .bottomLeading)
                .frame(width: width, height: height)
                .background(Color(wordName: color))
                .foregroundColor(Color(wordName: color))
                .clipped()
        }.border(.secondary, width: 2)
    }
        
    }
}

class ColorSchemaVm : ObservableObject{
    
    private var color_scehma : ColorSchemaModel
    
    init(color_schema : ColorSchemaModel){
        self.color_scehma = color_schema
    }
}

class ColorSchemaModel: Encodable {

   var in_use_background_color : String = ""
   var in_use_text_color : String = ""
    
   var empty_background_color : String = ""
    var empty_text_color : String = ""

}


struct InUseEmptyColorCardView : View{
    
  //  @Binding var color_vm : ColorSchemaVm
    @Binding  var in_use_background_color : String
    @Binding var in_use_text_color : String
     
    @Binding var empty_background_color : String
    @Binding var empty_text_color : String
    
    var body: some View{
        HStack(spacing: 30){
            VStack{
                Text("In-Use").font(.body).bold()
                HStack(spacing: 10){
                    ColorSchemeBlock(color: .constant(self.in_use_background_color),label_text: .constant("Background"))
                    
                    ColorSchemeBlock(color: .constant(self.in_use_text_color),label_text: .constant("Text Color"))
                }
            }
            
            VStack{
                Text("Empty").font(.body).bold()
                HStack(spacing: 10){
                    ColorSchemeBlock(color: .constant(self.empty_background_color),label_text: .constant("Background"))
                    
                    ColorSchemeBlock(color: .constant(self.empty_text_color),label_text: .constant("Text Color"))
                }
            }
        }
    }
}
