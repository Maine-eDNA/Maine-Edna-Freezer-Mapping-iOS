//
//  UserProfileManagment.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//


import SwiftUI
import SwiftyJSON
import Alamofire
import Foundation

class UserProfileManagment : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @AppStorage(AppStorageNames.stored_box_sample_logs.rawValue) var stored_box_sample_logs : [FreezerCheckOutLogModel] = [FreezerCheckOutLogModel]()
    
    @AppStorage(AppStorageNames.stored_return_meta_data.rawValue) var stored_return_meta_data : [FreezerInventoryReturnMetaDataModel] = [FreezerInventoryReturnMetaDataModel]()
    
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    
    
    @AppStorage(AppStorageNames.store_logged_in_user_profile.rawValue)  var store_logged_in_user_profile : [UserProfileModel] = [UserProfileModel]()
    
    
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_user_default_css : [UserCssModel] = [UserCssModel]()
    
    
    // Loading Screen...
    @Published var isLoading = false
    
    func FetchCurrentlyLoggedInUser(){
        
        print("LoggedIn as : \(self.store_email_address)")
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/users/user/?email=\(self.store_email_address)")!,timeoutInterval: Double.infinity)
        request.addValue("Token \(self.edna_freezer_token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        print("Token : \(self.edna_freezer_token)")
        
        
        AF.request(request) .responseString { response in
            // print("Response String: \(response.value)")
        }
        .responseJSON { response in
            // print("Response JSON: \(response.value)")
            //converting the results to Json Array format with SwiftyJSON
            let jsonArray = JSON(response.value as Any??)
            
            print(jsonArray["results"])
            //get the values out of the dictionary (array retrieved)
            let user = UserProfileModel()
            let target_users = jsonArray["results"]
            
            if(target_users.count > 0){
                
                for(_, target_user) in jsonArray["results"]{
                    
                    
                    
                    if (target_user["id"].int != nil){
                        user.id =  target_user["id"].intValue
                    }
                    
                    if (target_user["email"].string != nil){
                        user.email =  target_user["email"].stringValue
                    }
                    if (target_user["agol_username"].string != nil){
                        user.agol_username =  target_user["agol_username"].stringValue
                    }
                    if (target_user["password"].string != nil){
                        user.password =  target_user["password"].stringValue
                    }
                    
                    if (target_user["expiration_date"].string != nil){
                        user.expiration_date =  target_user["expiration_date"].stringValue
                    }
                    
                    if (target_user["first_name"].string != nil){
                        user.first_name =  target_user["first_name"].stringValue
                    }
                    
                    if (target_user["last_name"].string != nil){
                        user.last_name =  target_user["last_name"].stringValue
                    }
                    
                    if (target_user["profile_image"].string != nil){
                        user.profile_image =  target_user["profile_image"].stringValue
                    }
                    else{
                        user.profile_image = "https://firebasestorage.googleapis.com/v0/b/keijaoh-576a0.appspot.com/o/defaultImages%2FNoImageFound.jpg1_.png?alt=media&token=75d79486-de11-4096-8b7d-d8b1945d71cf"
                    }
                    
                    if (target_user["phone_number"].string != nil){
                        user.phone_number =  target_user["phone_number"].stringValue
                    }
                    
                    if (target_user["is_staff"].bool != nil){
                        user.is_staff =  target_user["is_staff"].boolValue
                    }
                    
                    if (target_user["is_active"].bool != nil){
                        user.is_active =  target_user["is_active"].boolValue
                    }
                    
                    if (target_user["date_joined"].string != nil){
                        user.date_joined =  target_user["date_joined"].stringValue
                    }
                    
                    var groups : [UserRoleGroupModel] = [UserRoleGroupModel]()
                    
                    for(_,group_role) in target_user["groups"]{
                        
                        var group = UserRoleGroupModel()
                        
                        if (group_role["name"].string != nil){
                            group.name =  group_role["name"].stringValue
                        }
                        
                        groups.append(group)
                    }
                    
                    user.groups = groups
                    
                    
                }
            }
            
            
            
            
            
            DispatchQueue.main.async {
                
                if !user.email.isEmpty && !user.agol_username.isEmpty{
                    
                    //clear the old list before adding a new one
                    self.store_logged_in_user_profile.removeAll()
                    
                    self.store_logged_in_user_profile.append(user)
                    self.isLoading = false
                    
                }
                
            }
        }
        
        
    }
    
    // @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
    ///Fetch the Default CSS
    
    func FetchDefaultCss(completion: @escaping (DefaultCssModel) -> Void){
        
        print("LoggedIn as : \(self.store_email_address)")
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/utility/default_site_css/")!,timeoutInterval: Double.infinity)
        request.addValue("Token \(self.edna_freezer_token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        print("Token : \(self.edna_freezer_token)")
        
        
        AF.request(request) .responseString { response in
            // print("Response String: \(response.value)")
        }
        .responseJSON { response in
            // print("Response JSON: \(response.value)")
            //converting the results to Json Array format with SwiftyJSON
            let jsonArray = JSON(response.value as Any??)
            
            print(jsonArray["results"])
            //get the values out of the dictionary (array retrieved)
            let default_css = DefaultCssModel()
            
            let target_default_css = jsonArray["results"]
            
            
            if(target_default_css.count > 0){
                
                for(_, css) in jsonArray["results"]{
                    
                    
                    
                    if (css["id"].int != nil){
                        default_css.id =  css["id"].intValue
                    }
                    
                    if (css["created_by"].string != nil){
                        default_css.created_by =  css["created_by"].stringValue
                    }
                    if (css["created_datetime"].string != nil){
                        default_css.created_datetime =  css["created_datetime"].stringValue
                    }
                    
                    if (css["default_css_label"].string != nil){
                        default_css.default_css_label =  css["default_css_label"].stringValue
                    }
                    if (css["css_selected_background_color"].string != nil){
                        default_css.css_selected_background_color =  css["css_selected_background_color"].stringValue
                    }
                    if (css["css_selected_text_color"].string != nil){
                        default_css.css_selected_text_color =  css["css_selected_text_color"].stringValue
                    }
                    if (css["freezer_empty_css_background_color"].string != nil){
                        default_css.freezer_empty_css_background_color =  css["freezer_empty_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_css_text_color"].string != nil){
                        default_css.freezer_empty_css_text_color =  css["freezer_empty_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_css_background_color"].string != nil){
                        default_css.freezer_inuse_css_background_color =  css["freezer_inuse_css_background_color"].stringValue
                    }
                    if (css["freezer_inuse_css_text_color"].string != nil){
                        default_css.freezer_inuse_css_text_color =  css["freezer_inuse_css_text_color"].stringValue
                    }
                    if (css["freezer_empty_rack_css_background_color"].string != nil){
                        default_css.freezer_empty_rack_css_background_color =  css["freezer_empty_rack_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_rack_css_text_color"].string != nil){
                        default_css.freezer_empty_rack_css_text_color =  css["freezer_empty_rack_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_rack_css_background_color"].string != nil){
                        default_css.freezer_inuse_rack_css_background_color =  css["freezer_inuse_rack_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_box_css_background_color"].string != nil){
                        default_css.freezer_empty_box_css_background_color =  css["freezer_empty_box_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_box_css_text_color"].string != nil){
                        default_css.freezer_empty_box_css_text_color =  css["freezer_empty_box_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_box_css_background_color"].string != nil){
                        default_css.freezer_inuse_box_css_background_color =  css["freezer_inuse_box_css_background_color"].stringValue
                    }
                    if (css["freezer_inuse_box_css_text_color"].string != nil){
                        default_css.freezer_inuse_box_css_text_color =  css["freezer_inuse_box_css_text_color"].stringValue
                    }
                    
                    if (css["freezer_empty_inventory_css_background_color"].string != nil){
                        default_css.freezer_empty_inventory_css_background_color =  css["freezer_empty_inventory_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_inventory_css_text_color"].string != nil){
                        default_css.freezer_empty_inventory_css_text_color =  css["freezer_empty_inventory_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_inventory_css_background_color"].string != nil){
                        default_css.freezer_inuse_inventory_css_background_color =  css["freezer_inuse_inventory_css_background_color"].stringValue
                    }
                    if (css["freezer_inuse_inventory_css_text_color"].string != nil){
                        default_css.freezer_inuse_inventory_css_text_color =  css["freezer_inuse_inventory_css_text_color"].stringValue
                    }
                    if (css["created_by"].string != nil){
                        default_css.created_by =  css["created_by"].stringValue
                    }
                    if (css["created_datetime"].string != nil){
                        default_css.created_datetime =  css["created_datetime"].stringValue
                    }
                    if (css["modified_datetime"].string != nil){
                        default_css.modified_datetime =  css["modified_datetime"].stringValue
                    }
                    //freezer_inuse_rack_css_text_color
                    if (css["freezer_inuse_rack_css_text_color"].string != nil){
                        default_css.freezer_inuse_rack_css_text_color =  css["freezer_inuse_rack_css_text_color"].stringValue
                    }
                    
                    
                }
                
                //return the default_css to the ui
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    
                    
                    completion(default_css)
                    
                    
                    
                }
                
                
            }
            
            
            
            
            
            DispatchQueue.main.async {
                
                if !default_css.css_selected_text_color.isEmpty && !default_css.default_css_label.isEmpty{
                    
                    //clear the old list before adding a new one
                    self.store_default_css.removeAll()
                    
                    self.store_default_css.append(default_css)
                    self.isLoading = false
                    
                }
                
            }
        }
        
        
    }
    

    
    ///Fetch the User CSS
    
    func FetchUserCss(completion: @escaping (UserCssModel) -> Void){
        
        print("LoggedIn as : \(self.store_email_address)")
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/utility/default_site_css/")!,timeoutInterval: Double.infinity)
        request.addValue("Token \(self.edna_freezer_token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        print("Token : \(self.edna_freezer_token)")
        
        
        AF.request(request) .responseString { response in
            // print("Response String: \(response.value)")
        }
        .responseJSON { response in
            // print("Response JSON: \(response.value)")
            //converting the results to Json Array format with SwiftyJSON
            let jsonArray = JSON(response.value as Any??)
            
            print(jsonArray["results"])
            //get the values out of the dictionary (array retrieved)
            let default_css = UserCssModel()
            
            let target_default_css = jsonArray["results"]
            
            var all_user_css = [UserCssModel]()
            
            
            if(target_default_css.count > 0){
                
                for(_, css) in jsonArray["results"]{
                    
                    
                    
                    if (css["id"].int != nil){
                        default_css.id =  css["id"].intValue
                    }
                    
                    if (css["custom_css_label"].string != nil){
                        default_css.custom_css_label =  css["custom_css_label"].stringValue
                    }
                    //email address
                    if (css["user"].string != nil){
                        default_css.user =  css["user"].stringValue
                    }
                    
                    if (css["created_by"].string != nil){
                        default_css.created_by =  css["created_by"].stringValue
                    }
                    if (css["created_datetime"].string != nil){
                        default_css.created_datetime =  css["created_datetime"].stringValue
                    }
                    
                    if (css["default_css_label"].string != nil){
                        default_css.default_css_label =  css["default_css_label"].stringValue
                    }
                    if (css["css_selected_background_color"].string != nil){
                        default_css.css_selected_background_color =  css["css_selected_background_color"].stringValue
                    }
                    if (css["css_selected_text_color"].string != nil){
                        default_css.css_selected_text_color =  css["css_selected_text_color"].stringValue
                    }
                    if (css["freezer_empty_css_background_color"].string != nil){
                        default_css.freezer_empty_css_background_color =  css["freezer_empty_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_css_text_color"].string != nil){
                        default_css.freezer_empty_css_text_color =  css["freezer_empty_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_css_background_color"].string != nil){
                        default_css.freezer_inuse_css_background_color =  css["freezer_inuse_css_background_color"].stringValue
                    }
                    if (css["freezer_inuse_css_text_color"].string != nil){
                        default_css.freezer_inuse_css_text_color =  css["freezer_inuse_css_text_color"].stringValue
                    }
                    if (css["freezer_empty_rack_css_background_color"].string != nil){
                        default_css.freezer_empty_rack_css_background_color =  css["freezer_empty_rack_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_rack_css_text_color"].string != nil){
                        default_css.freezer_empty_rack_css_text_color =  css["freezer_empty_rack_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_rack_css_background_color"].string != nil){
                        default_css.freezer_inuse_rack_css_background_color =  css["freezer_inuse_rack_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_box_css_background_color"].string != nil){
                        default_css.freezer_empty_box_css_background_color =  css["freezer_empty_box_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_box_css_text_color"].string != nil){
                        default_css.freezer_empty_box_css_text_color =  css["freezer_empty_box_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_box_css_background_color"].string != nil){
                        default_css.freezer_inuse_box_css_background_color =  css["freezer_inuse_box_css_background_color"].stringValue
                    }
                    if (css["freezer_inuse_box_css_text_color"].string != nil){
                        default_css.freezer_inuse_box_css_text_color =  css["freezer_inuse_box_css_text_color"].stringValue
                    }
                    
                    if (css["freezer_empty_inventory_css_background_color"].string != nil){
                        default_css.freezer_empty_inventory_css_background_color =  css["freezer_empty_inventory_css_background_color"].stringValue
                    }
                    if (css["freezer_empty_inventory_css_text_color"].string != nil){
                        default_css.freezer_empty_inventory_css_text_color =  css["freezer_empty_inventory_css_text_color"].stringValue
                    }
                    if (css["freezer_inuse_inventory_css_background_color"].string != nil){
                        default_css.freezer_inuse_inventory_css_background_color =  css["freezer_inuse_inventory_css_background_color"].stringValue
                    }
                    if (css["freezer_inuse_inventory_css_text_color"].string != nil){
                        default_css.freezer_inuse_inventory_css_text_color =  css["freezer_inuse_inventory_css_text_color"].stringValue
                    }
                    if (css["created_by"].string != nil){
                        default_css.created_by =  css["created_by"].stringValue
                    }
                    if (css["created_datetime"].string != nil){
                        default_css.created_datetime =  css["created_datetime"].stringValue
                    }
                    if (css["modified_datetime"].string != nil){
                        default_css.modified_datetime =  css["modified_datetime"].stringValue
                    }
                    //freezer_inuse_rack_css_text_color
                    if (css["freezer_inuse_rack_css_text_color"].string != nil){
                        default_css.freezer_inuse_rack_css_text_color =  css["freezer_inuse_rack_css_text_color"].stringValue
                    }
                    
                    all_user_css.append(default_css)
                    
                }
                
                
                //return the default_css to the ui
                if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                    
                    if let target_css = all_user_css.first{
                        completion(target_css)
                        
                    }
                    
                    
                    
                }
            }
            
            
            
            
            
            DispatchQueue.main.async {
                //all_user_css filter by the logged in user
                var target_user_css = all_user_css.filter{css in return css.created_by == self.store_email_address}
                if target_user_css.count > 0{
                    //clear the old records
                    self.store_user_default_css.removeAll()
                    
                    target_user_css.append(target_user_css.first!)
                }
                
                
            }
        }
        
        
    }
    
    
    //Create User CSS
    
    func CreateNewUserCSS(_userCssDetail : UserCssModel,completion: @escaping (ServerMessageModel) -> Void) -> Void
    {
        
        print("Token: \(self.edna_freezer_token)")
        ///
        let request : String = ServerConnectionUrls.productionUrl.rawValue + "api/utility/custom_user_css/"
        let headers: HTTPHeaders = [
            // "x-auth-token": temp_token, //re-enable
            "Authorization":  "Token \(self.edna_freezer_token)",
            "Accept": "application/json"
        ]
        
        AF.request(request ,
                   method: .post,
                   parameters: _userCssDetail,
                   encoder: JSONParameterEncoder.default,
                   headers: headers
        ).response { response in
            debugPrint(response)
            //MARK: Need to show the results on the interface
            //MARK: try to trigger a data set to update
            print("\(response.result)")
            
            if response.response?.statusCode == 400{
                
                if let errorMsg = response.data{
                    let jsonMsg = String(data: errorMsg,encoding: String.Encoding.utf8)
                    let errorDetail = ServerMessageModel()
                    errorDetail.serverMessage = String(describing: jsonMsg!)
                    errorDetail.isError = true
                    
                    completion(errorDetail)
                }
                
            }
            else if response.response?.statusCode == 200 || response.response?.statusCode == 201{
                //completion("Record Successfully Saved")
                
                if let errorMsg = response.data{
                    let jsonMsg = String(data: errorMsg,encoding: String.Encoding.utf8)
                    let errorDetail = ServerMessageModel()
                    errorDetail.serverMessage = "User Css Successfully Saved"//String(describing: jsonMsg!)
                    errorDetail.isError = false
                    //can fetch user preference to store
                    completion(errorDetail)
                }
                
                
            }
            else{
                if let errorMsg = response.data{
                    let jsonMsg = String(data: errorMsg,encoding: String.Encoding.utf8)
                    let errorDetail = ServerMessageModel()
                    errorDetail.serverMessage = String(describing: jsonMsg!)
                    errorDetail.isError = true
                    
                    completion(errorDetail)
                }
                
            }
            
        }
        
    }
    
    
}
