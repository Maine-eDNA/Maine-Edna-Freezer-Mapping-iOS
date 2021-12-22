//
//  FreezerCreation.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/4/21.
//


import SwiftUI
import SwiftyJSON
import Alamofire

class FreezerCreation: ObservableObject {
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
  
    // Loading Screen...
    @Published var isLoading = false
    //
    


    func CreateNewFreezer(_freezerDetail : FreezerProfileModel,completion: @escaping (ServerMessageModel) -> Void) -> Void
    {
  
        print("Token: \(self.edna_freezer_token)")
        ///
        let request : String = ServerConnectionUrls.productionUrl.rawValue + "api/freezer_inventory/freezer/"
        let headers: HTTPHeaders = [
           // "x-auth-token": temp_token, //re-enable
            "Authorization":  "Token \(self.edna_freezer_token)",
            "Accept": "application/json"
        ]
        
        AF.request(request ,
                   method: .post,
                   parameters: _freezerDetail,
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
            else if response.response?.statusCode == 200{
                //completion("Record Successfully Saved")
                
                if let errorMsg = response.data{
                    let jsonMsg = String(data: errorMsg,encoding: String.Encoding.utf8)
                    let errorDetail = ServerMessageModel()
                    errorDetail.serverMessage = String(describing: jsonMsg!)
                    errorDetail.isError = false
                    
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

