//
//  ReturnExtractionDataService.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/12/22.
//

import SwiftUI
import SwiftyJSON
import Alamofire

class ReturnExtractionDataService: ObservableObject {
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    
    // Loading Screen...
    @Published var isLoading = false
    //
    
    #warning("Check NOtion to for details on the errors and the params tried")
    ///sets the Inventory record to permanently removed
    ///NOTE:  must ensure that the inventory location is stored for the replacement Sample to inherit
    func PermanentlyRemoveExtraction(_freezerInventory : FreezerInventoryPutModel,completion: @escaping (ServerMessageModel) -> Void) -> Void
    {
        
        if let id = _freezerInventory.id{
            
            let request : String = ServerConnectionUrls.productionUrl.rawValue + "api/freezer_inventory/inventory/\(id)/"
            let headers: HTTPHeaders = [
                "Authorization":  "Token \(self.edna_freezer_token)",
                "Accept": "application/json"
            ]
            
            AF.request(request ,
                       method: .put,
                       parameters: _freezerInventory,
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
                        errorDetail.serverMessage = "Sample Permanently Removed"//String(describing: jsonMsg!)
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
    
    
}


