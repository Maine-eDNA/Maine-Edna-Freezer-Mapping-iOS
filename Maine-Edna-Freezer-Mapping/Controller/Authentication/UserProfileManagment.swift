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
    
    
    
    
}
