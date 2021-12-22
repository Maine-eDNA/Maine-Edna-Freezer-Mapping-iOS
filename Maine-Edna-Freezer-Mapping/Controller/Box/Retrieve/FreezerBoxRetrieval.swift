//
//  FreezerBoxRetrieval.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI
import SwiftyJSON
import Alamofire
import Foundation

class FreezerBoxRetrieval : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @AppStorage(AppStorageNames.stored_rack_boxes.rawValue) var stored_rack_boxes : [BoxItemModel] = [BoxItemModel]()
  
    // Loading Screen...
    @Published var isLoading = false
    //
    //Need a func to fetch just the inbox out
    //Fetch all freezers
    //https://metadata.spatialmsk.dev/api/freezer_inventory/freezer/"
    
    
    
    func FetchAllRackBoxesByRackId(_rack_id : String){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/box/?freezer_rack=\(_rack_id)")!,timeoutInterval: Double.infinity)
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
            var freezer_rack_box_locals = [BoxItemModel]()
            
            
            
            for (_, box) in jsonArray["results"] {
                
                let freezer_rack_box_local = BoxItemModel()
                
                if (box["id"].int != nil){
                    freezer_rack_box_local.id =  box["id"].intValue
                }
                
                if (box["created_by"].string != nil){
                    freezer_rack_box_local.created_by =  box["created_by"].stringValue
                }
                
                if (box["freezer_box_label"].string != nil){
                    freezer_rack_box_local.freezer_box_label =  box["freezer_box_label"].stringValue
                }
                if (box["created_datetime"].string != nil){
                    freezer_rack_box_local.created_datetime =  box["created_datetime"].stringValue
                }
          
                if (box["freezer_box_max_column"].int != nil){
                    freezer_rack_box_local.freezer_box_max_column =  box["freezer_box_max_column"].intValue
                }
                if (box["freezer_box_max_row"].int != nil){
                    freezer_rack_box_local.freezer_box_max_row =  box["freezer_box_max_row"].intValue
                }
                if (box["freezer_box_column"].int != nil){
                    freezer_rack_box_local.freezer_box_column =  box["freezer_box_column"].intValue
                }
                if (box["freezer_box_depth"].int != nil){
                    freezer_rack_box_local.freezer_box_depth =  box["freezer_box_depth"].intValue
                }
                if (box["freezer_box_label_slug"].string != nil){
                    freezer_rack_box_local.freezer_box_label_slug =  box["freezer_box_label_slug"].stringValue
                }
                if (box["freezer_box_row"].int != nil){
                    freezer_rack_box_local.freezer_box_row =  box["freezer_box_row"].intValue
                }
                if (box["freezer_rack"].string != nil){
                    freezer_rack_box_local.freezer_rack =  box["freezer_rack"].stringValue
                }
                if (box["modified_datetime"].string != nil){
                    freezer_rack_box_local.modified_datetime =  box["modified_datetime"].stringValue
                }
                
                
                freezer_rack_box_locals.append(freezer_rack_box_local)
            }
            
            
            
            
            
            
            DispatchQueue.main.async {
                //put the update to the properties on the main thread because that where it lives
                //MARK: Add count
              
                self.stored_rack_boxes = freezer_rack_box_locals //results from the db
                //finished loading data so the observabke object can be updated to hide the spinner
                // self.quotes = quoteLocals
                //MARK: store the appstoreage data
                //self.Stored_Rental_Contracts = rentalContractLocals
                
                self.isLoading = false
                
            }
        }
        
        
    }
    

    
    
}
