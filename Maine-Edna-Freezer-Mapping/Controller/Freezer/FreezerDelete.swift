//
//  FreezerDelete.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/22/22.
//

import SwiftUI
import SwiftyJSON
import Alamofire

class FreezerDelete : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""
    // Loading Screen...
    @Published var isLoading = false
    
    #warning("Should change to permanently removed")
    ///permanently removes freezer record from the database
    func DeleteFreezer(_freezerId : String,completion: @escaping (ServerMessageModel) -> Void) -> Void
    {
        
        print("Token: \(self.edna_freezer_token)")
        ///
        let request : String = ServerConnectionUrls.productionUrl.rawValue + "api/freezer_inventory/freezer/\(_freezerId)/"
        let headers: HTTPHeaders = [
            "Authorization":  "Token \(self.edna_freezer_token)",
            "Accept": "application/json"
        ]
        
        AF.request(request,method: .delete, headers: headers).responseString { response in
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
                    errorDetail.serverMessage = "Freezer Successfully Deleted"//String(describing: jsonMsg!)
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
