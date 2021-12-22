//
//  FreezerRackLayoutService.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/29/21.
//


import SwiftUI
import SwiftyJSON
import Alamofire
import Foundation

class FreezerRackLayoutService: ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @Published var freezer_racks : [RackItemModel] = [RackItemModel]()
    
    @AppStorage(AppStorageNames.stored_freezer_rack_layout.rawValue) var stored_freezer_rack_layout : [RackItemModel] = [RackItemModel]()
  
    // Loading Screen...
    @Published var isLoading = false
    //
    //Need a func to fetch just the inbox out
    //Fetch all freezers
    //https://metadata.spatialmsk.dev/api/freezer_inventory/freezer/"
    
    
    
    func FetchLayoutForTargetFreezer(_freezer_id : String){
     
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/rack/?freezer=\(_freezer_id)")!,timeoutInterval: Double.infinity)
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
            var rackLocals = [RackItemModel]()
            
            
            
            for (_, rack) in jsonArray["results"] {
                
                let rackLocal = RackItemModel()
                
                if (rack["id"].int != nil){
                    rackLocal.id =  rack["id"].intValue
                }
                
                if (rack["created_by"].string != nil){
                    rackLocal.created_by =  rack["created_by"].stringValue
                }
                
                if (rack["created_datetime"].string != nil){
                    rackLocal.created_datetime =  rack["created_datetime"].stringValue
                }
                
                //set this based on the person's color preferences
                if (rack["css_background_color"].string != nil){
                    rackLocal.css_background_color =  rack["css_background_color"].stringValue
                }
                else{
                    rackLocal.css_background_color = "orange"
                }
                
                
                if (rack["css_text_color"].string != nil){
                    rackLocal.css_text_color =  rack["css_text_color"].stringValue
                }
                else{
                    rackLocal.css_text_color = "white"
                }
                
                if (rack["created_by"].string != nil){
                    rackLocal.created_by =  rack["created_by"].stringValue
                }
                
                if (rack["freezer_rack_column_end"].int != nil){
                    rackLocal.freezer_rack_column_end =  rack["freezer_rack_column_end"].intValue
                }
                
                if (rack["freezer_rack_column_start"].int != nil){
                    rackLocal.freezer_rack_column_start =  rack["freezer_rack_column_start"].intValue
                }
                
                if (rack["freezer_rack_row_start"].int != nil){
                    rackLocal.freezer_rack_row_start =  rack["freezer_rack_row_start"].intValue
                }
                
                if (rack["freezer_rack_row_end"].int != nil){
                    rackLocal.freezer_rack_row_end =  rack["freezer_rack_row_end"].intValue
                }
                if (rack["freezer_rack_depth_end"].int != nil){
                    rackLocal.freezer_rack_depth_end =  rack["freezer_rack_depth_end"].intValue
                }
                
                if (rack["freezer_rack_depth_start"].int != nil){
                    rackLocal.freezer_rack_depth_start =  rack["freezer_rack_depth_start"].intValue
                }
                
                if (rack["freezer_rack_label"].string != nil){
                    rackLocal.freezer_rack_label =  rack["freezer_rack_label"].stringValue
                }
                if (rack["freezer"].string != nil){
                    rackLocal.freezer =  rack["freezer"].stringValue
                }
                
                
                rackLocals.append(rackLocal)
            }
            
            //try appending the remaining items 
            
            
            
            
            DispatchQueue.main.async {
                //put the update to the properties on the main thread because that where it lives
                //MARK: Add count
              
                self.stored_freezer_rack_layout = rackLocals //results from the db
                
                self.freezer_racks = rackLocals
                //finished loading data so the observabke object can be updated to hide the spinner
                // self.quotes = quoteLocals
                //MARK: store the appstoreage data
                //self.Stored_Rental_Contracts = rentalContractLocals
                
                self.isLoading = false
                
            }
        }
        
        
    }
    
    
    
    
    
}



