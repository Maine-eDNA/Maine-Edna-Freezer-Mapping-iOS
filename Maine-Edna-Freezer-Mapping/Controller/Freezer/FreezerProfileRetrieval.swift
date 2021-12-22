//
//  FreezerProfileRetrieval.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/3/21.
//

import SwiftUI
import SwiftyJSON
import Alamofire
import Foundation

class FreezerProfileRetrieval : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
  
    // Loading Screen...
    @Published var isLoading = false
    //
    //Need a func to fetch just the inbox out
    //Fetch all freezers
    //https://metadata.spatialmsk.dev/api/freezer_inventory/freezer/"
    
    
    
    func FetchAllAvailableFreezers(){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/freezer/")!,timeoutInterval: Double.infinity)
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
            var freezerLocals = [FreezerProfileModel]()
            
            
            
            for (_, freezer) in jsonArray["results"] {
                
                let freezerLocal = FreezerProfileModel()
                
                if (freezer["id"].int != nil){
                    freezerLocal.id =  freezer["id"].intValue
                }
                
                if (freezer["created_by"].string != nil){
                    freezerLocal.created_by =  freezer["created_by"].stringValue
                }
                
                if (freezer["created_datetime"].string != nil){
                    freezerLocal.created_datetime =  freezer["created_datetime"].stringValue
                }
                
        
                if (freezer["freezer_date"].string != nil){
                    freezerLocal.freezer_date =  freezer["freezer_date"].stringValue
                }
                
                if (freezer["freezer_label"].string != nil){
                    freezerLocal.freezer_label =  freezer["freezer_label"].stringValue
                }
             

                if (freezer["freezer_depth"].int != nil){
                    freezerLocal.freezer_depth =  freezer["freezer_depth"].intValue
                }
                
                if (freezer["freezer_length"].int != nil){
                    freezerLocal.freezer_length =  freezer["freezer_length"].intValue
                }
                
                if (freezer["freezer_width"].int != nil){
                    freezerLocal.freezer_width =  freezer["freezer_width"].intValue
                }
                
                
                if (freezer["freezer_dimension_units"].string != nil){
                    freezerLocal.freezer_dimension_units =  freezer["freezer_dimension_units"].stringValue
                }
                
                if (freezer["freezer_max_columns"].int != nil){
                    freezerLocal.freezer_max_columns =  freezer["freezer_max_columns"].intValue
                }
                
                if (freezer["freezer_max_rows"].int != nil){
                    freezerLocal.freezer_max_rows =  freezer["freezer_max_rows"].intValue
                }
                
                if (freezer["freezer_max_depth"].int != nil){
                    freezerLocal.freezer_max_depth =  freezer["freezer_max_depth"].intValue
                }
                
          
                
                
                freezerLocals.append(freezerLocal)
            }
            
            
            
            
            
            
            DispatchQueue.main.async {
                //put the update to the properties on the main thread because that where it lives
                //MARK: Add count
              
                self.stored_freezers = freezerLocals //results from the db
                //finished loading data so the observabke object can be updated to hide the spinner
                // self.quotes = quoteLocals
                //MARK: store the appstoreage data
                //self.Stored_Rental_Contracts = rentalContractLocals
                
                self.isLoading = false
                
            }
        }
        
        
    }
    
    
    
    
    
}



