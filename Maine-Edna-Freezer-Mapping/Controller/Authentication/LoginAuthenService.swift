//
//  LoginAuthenService.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/9/21.
//

import SwiftUI
import LocalAuthentication
import SwiftyJSON
import Alamofire
//explore store kit to get the in app payment options

//NEED TO do the registration
class LoginAuthenService : ObservableObject {
    //TUTOR MODEL need to add to separate class
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    
    // For Alerts..
    @Published var alert = false
    @Published var alertMsg = ""
    
    // User Data....
    @ObservedObject var user_management_service : UserProfileManagment = UserProfileManagment()

    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    @AppStorage(AppStorageNames.stored_password.rawValue)  var stored_password = ""
    
    @AppStorage(AppStorageNames.stored_user_id.rawValue)  var stored_user_id : Int = 0
    
    @AppStorage(AppStorageNames.login_status.rawValue) var logged = false
    @Published var store_Info = false
    
    // Loading Screen...
    @Published var isLoading = false
    
    // Getting BioMetricType....
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""
    
    func getBioMetricStatus()->Bool{
        
        let scanner = LAContext()
        if email != "" && email == store_email_address && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none){
            
            return true
        }
        
        return false
    }
    
 
    
    // authenticate User...
    
    func authenticateUser(){
        
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(email)") { (status, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            // Settig User Password And Logging IN...
            DispatchQueue.main.async {
                self.password = self.stored_password
                self.loginUserAccount(){_ in
                    
                }
            }
        }
    }
    
    // Verifying User...
    
    func loginUserAccount(completion: @escaping (ServerMessageModel) -> Void){
   
        
        self.isLoading = false
        //withAnimation{self.logged = true}
        let accountCredentials : UserProfileModel =  UserProfileModel()
        accountCredentials.email = email.lowercased()
        accountCredentials.password = password
        
        print("Email \(email.lowercased()) Code \(password)")
        //Login through Firebase
        let requestUrl : String = ServerConnectionUrls.productionUrl.rawValue + "rest-auth/login/"
        
        AF.request(requestUrl,
                   method: .post,
                   parameters: accountCredentials,
                   encoder: JSONParameterEncoder.default).response { response in
            //debugPrint(response)
            print("Response: \(response.result)")
            //Check for errors, if error then abort and return
            if response.response?.statusCode == 400{
                print("Error 400")
                if let errorMsg = response.data{
                    let jsonMsg = String(data: errorMsg,encoding: String.Encoding.utf8)
                    print("Check Msg: \(jsonMsg)")
                    let errorDetail = ServerMessageModel()
                    errorDetail.serverMessage = String(describing: jsonMsg!)
                    errorDetail.isError = true
                    
                    completion(errorDetail)
                }
                
            }
            //Successful
            //go to the home page after setting the settings
            self.isLoading = false
            
            //MARK: to store the jwt
                
                //fetch and store the landlord info here
                let jsonArray = JSON(response.value as Any??)
                debugPrint(jsonArray)
                
                
                if jsonArray["key"].string != nil{
                   
                    self.edna_freezer_token = jsonArray["key"].stringValue
                }
            
                if jsonArray["id"].int != nil{
                   
                    self.stored_user_id = jsonArray["id"].intValue
                }
                
                //withAnimation{self.logged = true}
                if response.response?.statusCode == 400{
                    if let errorMsg = response.data{
                        let jsonMsg = String(data: errorMsg,encoding: String.Encoding.utf8)
                        let errorDetail = ServerMessageModel()
                        errorDetail.serverMessage = String(describing: jsonMsg!)
                        errorDetail.isError = true
                        
                        completion(errorDetail)
                    }
                    
                }
                else if response.response?.statusCode == 200{
                    //logged in successfully
                    
                    if let errorMsg = response.data{
                        let jsonMsg = String(data: errorMsg,encoding: String.Encoding.utf8)
                        let errorDetail = ServerMessageModel()
                        errorDetail.serverMessage = String("Logged in Successfully")
                        errorDetail.isError = false
                        
                        //log user in
                        self.logged = true
                        //set login email
                        self.store_email_address = self.email.lowercased()
                        //fetch current user profile
                        if !self.store_email_address.isEmpty{
                            self.user_management_service.FetchCurrentlyLoggedInUser()
                        }
                        
                        completion(errorDetail)
                        
                     
                    }
                    
                   
                }
                else{
                    //completion("\(response.result)")
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
            
            
        
        
        
        
    
    
    
    //TODO
#warning( "reset user password by sending the the reset email to the email entered if it exist")
    func resetPassword(){
        
    }
    
    
}


