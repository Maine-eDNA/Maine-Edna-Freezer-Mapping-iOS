//
//  FreezerCheckOutLogRetrieval.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//

import SwiftUI
import SwiftyJSON
import Alamofire
import Foundation
import Combine

class FreezerCheckOutLogRetrieval : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    
    @AppStorage(AppStorageNames.stored_box_sample_logs.rawValue) var stored_box_sample_logs : [FreezerCheckOutLogModel] = [FreezerCheckOutLogModel]()
    
    @AppStorage(AppStorageNames.stored_return_meta_data.rawValue) var stored_return_meta_data : [FreezerInventoryReturnMetaDataModel] = [FreezerInventoryReturnMetaDataModel]()
  
    @Published var freezer_meta_grouped = [String : [FreezerInventoryReturnMetaDataModel]]()
    
    // Loading Screen...
    @Published var isLoading = false
    //
    //Need a func to fetch just the inbox out
    //Fetch all freezers
    //https://metadata.spatialmsk.dev/api/freezer_inventory/freezer/"
    
    var cancellables = Set<AnyCancellable>()
    @Published var freezer_return_meta_data = FreezerInventoryReturnMetaDataModel()
    
    
    //new
    @Published var freezer_return_metas : [FreezerInventoryReturnMetaDataResults] = []
    
    @Published var sampleLogs : [FreezerCheckOutLogModel] = [FreezerCheckOutLogModel]()
    
    
    init(){
        
        FetchInventoryReturnMetadata(_created_by: self.store_email_address )
            
       
    }
    
    /*
     Right now you have one section, just have two sections in Dashboard

     2:55
     One section for freezer_return_metadata_entered=no
     2:55
     and one section for freezer_return_metadata_entered=yes


     */
    
    
    
    //Need to group them after
    //meta  /api/freezer_inventory/return_metadata/
    func FetchInventoryReturnMetadata(_created_by : String){
       // var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/return_metadata/")!,timeoutInterval: Double.infinity)
      //  guard let url = URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/return_metadata/") else{ return }
        //freezer_return_metas
      
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/return_metadata/?created_by=\(_created_by)")!,timeoutInterval: Double.infinity)
        request.addValue("Token \(self.edna_freezer_token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
       
        //request
        URLSession.shared.dataTaskPublisher(for: request)//(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                
                
                guard let response = response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else{
                          throw URLError(URLError.badServerResponse)
                      }
                return data
            }
            .decode(type: FreezerInventoryReturnMetaDataModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedMetaData) in
                //need to sort the data
                if let results = returnedMetaData.results {
                    self?.freezer_return_metas = results
                }
           
            }
            .store(in: &cancellables)
        
    }
    
    
    
    
    
    func FetchAllSampleCheckOutLog(_inventory_id : String){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/log/?freezer_inventory=\(_inventory_id)")!,timeoutInterval: Double.infinity)
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
            var box_sample_log_locals = [FreezerCheckOutLogModel]()
            
            
            
            for (_, sample_log) in jsonArray["results"] {
                
                let box_sample_log_local = FreezerCheckOutLogModel()
                
                if (sample_log["id"].int != nil){
                    box_sample_log_local.id =  sample_log["id"].intValue
                }
                if (sample_log["freezer_return_metadata_entered"].string != nil){
                  //  box_sample_log_local.re =  sample_log["freezer_return_metadata_entered"].stringValue
                }
                
                if (sample_log["freezer_inventory"].string != nil){
                    box_sample_log_local.freezer_inventory =  sample_log["freezer_inventory"].stringValue
                }
                //may need to change this to a [string]
                if (sample_log["freezer_log_action"].string != nil){
                    box_sample_log_local.freezer_log_action =  sample_log["freezer_log_action"].stringValue
                }
      
                if (sample_log["freezer_log_notes"].string != nil){
                    box_sample_log_local.freezer_log_notes =  sample_log["freezer_log_notes"].stringValue
                }
                
                if (sample_log["freezer_log_slug"].string != nil){
                    box_sample_log_local.freezer_log_slug =  sample_log["freezer_log_slug"].stringValue
                }
                if (sample_log["created_by"].string != nil){
                    box_sample_log_local.created_by =  sample_log["created_by"].stringValue
                }
                if (sample_log["created_datetime"].string != nil){
                    box_sample_log_local.created_datetime =  sample_log["created_datetime"].stringValue
                }
                if (sample_log["modified_datetime"].string != nil){
                    box_sample_log_local.modified_datetime =  sample_log["modified_datetime"].stringValue
                }
                
                
                box_sample_log_locals.append(box_sample_log_local)
            }
            
            
            
            
            
            
            DispatchQueue.main.async {
                //MARK: Add count
              
                self.stored_box_sample_logs = box_sample_log_locals //results from the db
                
                self.isLoading = false
                
            }
        }
        
        
    }
    

    
    
    //1. fetch all logs from
//https://metadata.spatialmsk.dev/api/freezer_inventory/log/
    ///filter by freezer_log_slug then get the freezer_inventory from one of the result to get the sample profile
    ///post filter after fetching all records because the freezer_log_slug filter by end point doesnt work
    func FetchAllRackBoxesFilterByFreezerLogSlug(_freezer_log_slug : String,completion: @escaping (String) -> Void){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/log/")!,timeoutInterval: Double.infinity)
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
            var box_sample_log_locals = [FreezerCheckOutLogModel]()
            
            
            
            for (_, sample_log) in jsonArray["results"] {
                
                let box_sample_log_local = FreezerCheckOutLogModel()
                
                if (sample_log["id"].int != nil){
                    box_sample_log_local.id =  sample_log["id"].intValue
                }
                
                if (sample_log["freezer_inventory"].string != nil){
                    box_sample_log_local.freezer_inventory =  sample_log["freezer_inventory"].stringValue
                }
                //may need to change this to a [string]
                if (sample_log["freezer_log_action"].string != nil){
                    box_sample_log_local.freezer_log_action =  sample_log["freezer_log_action"].stringValue
                }
      
                if (sample_log["freezer_log_notes"].string != nil){
                    box_sample_log_local.freezer_log_notes =  sample_log["freezer_log_notes"].stringValue
                }
                
                if (sample_log["freezer_log_slug"].string != nil){
                    box_sample_log_local.freezer_log_slug =  sample_log["freezer_log_slug"].stringValue
                }
                if (sample_log["created_by"].string != nil){
                    box_sample_log_local.created_by =  sample_log["created_by"].stringValue
                }
                if (sample_log["created_datetime"].string != nil){
                    box_sample_log_local.created_datetime =  sample_log["created_datetime"].stringValue
                }
                if (sample_log["modified_datetime"].string != nil){
                    box_sample_log_local.modified_datetime =  sample_log["modified_datetime"].stringValue
                }
         
                
                box_sample_log_locals.append(box_sample_log_local)
            }
            
            
            
            
            
            
            DispatchQueue.main.async {
                //MARK: if stored_box_sample_logs isnt empty clear it since new data is needed
                if self.stored_box_sample_logs.count > 0{
                    self.stored_box_sample_logs.removeAll()
                }
              
                //MARK: - Filtering to show result by the freezer_log_slug
                self.stored_box_sample_logs = box_sample_log_locals.filter{log in return log.freezer_log_slug == _freezer_log_slug} //results from the db
                
                self.sampleLogs = self.stored_box_sample_logs
                
                //MARK: - if stored_box_sample_logs found results take the freezer_inventory from the first result and use it to populate the sample header on the Exisiting Sample Detail
                //return the id
                if let target_freezer_inventory = self.stored_box_sample_logs.first
                {
                    completion(target_freezer_inventory.freezer_inventory)
                }
                
                self.isLoading = false
                
            }
        }
        
        
        
    }
    
    
}

