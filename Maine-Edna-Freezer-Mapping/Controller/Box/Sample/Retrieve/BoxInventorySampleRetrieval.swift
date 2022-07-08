//
//  BoxInventorySampleRetrieval.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//

import SwiftUI
import SwiftyJSON
import Alamofire
import Combine

class BoxInventorySampleRetrieval : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @Published var all_box_samples : [InventorySampleModel] = []
    

    //@AppStorage(AppStorageNames.stored_box_samples.rawValue) var stored_box_samples : [InventorySampleModel] = [InventorySampleModel]()
    @AppStorage(AppStorageNames.all_unfiltered_stored_box_samples.rawValue) var all_unfiltered_stored_box_samples : [InventorySampleModel] = [InventorySampleModel]()
  
    // Loading Screen...
    @Published var isLoading = false
    
    var cancellables = Set<AnyCancellable>()
    
    //
    //Need a func to fetch just the inbox out
    //Fetch all freezers
    //https://metadata.spatialmsk.dev/api/freezer_inventory/freezer/"
    
    ///Fetch All Inventory Samples to be used to find target samples
    ///api/freezer_inventory/inventory/
    func FetchAllInventorySamplesInSystem(){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory/?freezer_inventory_status=in")!,timeoutInterval: Double.infinity)
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
            var freezer_box_sample_locals = [InventorySampleModel]()
            
            
            
            for (_, sample) in jsonArray["results"] {
                
                let freezer_box_sample_local = InventorySampleModel()
                
                if (sample["id"].int != nil){
                    freezer_box_sample_local.id =  sample["id"].intValue
                }
                
                if (sample["freezer_box"].string != nil){
                    freezer_box_sample_local.freezer_box =  sample["freezer_box"].stringValue
                }
                
                if (sample["sample_barcode"].string != nil){
                    freezer_box_sample_local.sample_barcode =  sample["sample_barcode"].stringValue
                }
                
                if (sample["freezer_inventory_slug"].string != nil){
                    freezer_box_sample_local.freezer_inventory_slug =  sample["freezer_inventory_slug"].stringValue
                }
                
                if (sample["freezer_inventory_type"].string != nil){
                    freezer_box_sample_local.freezer_inventory_type =  sample["freezer_inventory_type"].stringValue
                }
                
                if (sample["freezer_inventory_status"].string != nil){
                    freezer_box_sample_local.freezer_inventory_status =  sample["freezer_inventory_status"].stringValue
                }
                
                if (sample["freezer_inventory_column"].int != nil){
                    freezer_box_sample_local.freezer_inventory_column =  sample["freezer_inventory_column"].intValue
                }
                if (sample["freezer_inventory_row"].int != nil){
                    freezer_box_sample_local.freezer_inventory_row =  sample["freezer_inventory_row"].intValue
                }
                
                
                if (sample["created_by"].string != nil){
                    freezer_box_sample_local.created_by =  sample["created_by"].stringValue
                }
                
                if (sample["created_datetime"].string != nil){
                    freezer_box_sample_local.created_datetime =  sample["created_datetime"].stringValue
                }
                
                if (sample["modified_datetime"].string != nil){
                    freezer_box_sample_local.modified_datetime =  sample["modified_datetime"].stringValue
                }
                
                freezer_box_sample_locals.append(freezer_box_sample_local)
            }
            
            
            
            
            
            //remains in the background
            DispatchQueue.main.async {
               
                //MARK:filter the results by _freezer_inventory_slug
                //check that atleast one was found
                if freezer_box_sample_locals.count > 0{
                    
                    self.all_unfiltered_stored_box_samples.removeAll()
                    
                    self.all_unfiltered_stored_box_samples = freezer_box_sample_locals
                    
                }
             
                
            }
        }
        
        
    }
    
    //TODO: convert to combine
    ///will use combine and wont wait on the results, it will use publishers and subscribers to update the UI
    func FetchAllSamplesInBox(_box_id : String){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory/?box=\(_box_id)&freezer_inventory_status=in")!,timeoutInterval: Double.infinity)
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
            var freezer_box_sample_locals = [InventorySampleModel]()
            
            
            
            for (_, sample) in jsonArray["results"] {
                
                let freezer_box_sample_local = InventorySampleModel()
                
                if (sample["id"].int != nil){
                    freezer_box_sample_local.id =  sample["id"].intValue
                }
                
                if (sample["freezer_box"].string != nil){
                    freezer_box_sample_local.freezer_box =  sample["freezer_box"].stringValue
                }
                
                if (sample["sample_barcode"].string != nil){
                    freezer_box_sample_local.sample_barcode =  sample["sample_barcode"].stringValue
                }
                
                if (sample["freezer_inventory_slug"].string != nil){
                    freezer_box_sample_local.freezer_inventory_slug =  sample["freezer_inventory_slug"].stringValue
                }
                
                if (sample["freezer_inventory_type"].string != nil){
                    freezer_box_sample_local.freezer_inventory_type =  sample["freezer_inventory_type"].stringValue
                }
                
                if (sample["freezer_inventory_status"].string != nil){
                    freezer_box_sample_local.freezer_inventory_status =  sample["freezer_inventory_status"].stringValue
                }
                
                if (sample["freezer_inventory_column"].int != nil){
                    freezer_box_sample_local.freezer_inventory_column =  sample["freezer_inventory_column"].intValue
                }
                if (sample["freezer_inventory_row"].int != nil){
                    freezer_box_sample_local.freezer_inventory_row =  sample["freezer_inventory_row"].intValue
                }
                
                
                if (sample["created_by"].string != nil){
                    freezer_box_sample_local.created_by =  sample["created_by"].stringValue
                }
                
                if (sample["created_datetime"].string != nil){
                    freezer_box_sample_local.created_datetime =  sample["created_datetime"].stringValue
                }
                
                if (sample["modified_datetime"].string != nil){
                    freezer_box_sample_local.modified_datetime =  sample["modified_datetime"].stringValue
                }
                
                freezer_box_sample_locals.append(freezer_box_sample_local)
            }
            
            
            
            
            
            
            DispatchQueue.main.async {
                //put the update to the properties on the main thread because that where it lives
                //MARK: Add count
              
                self.all_box_samples = freezer_box_sample_locals //results from the db
                //finished loading data so the observabke object can be updated to hide the spinner
                // self.quotes = quoteLocals
                //MARK: store the appstoreage data
                //self.Stored_Rental_Contracts = rentalContractLocals
                
                self.isLoading = false
                
            }
        }
        
        
    }
    ///has a completion handler so that the UI waits on the results
    func FetchAllSamplesInBox(_box_id : String,completion: @escaping ([InventorySampleModel] ) -> Void){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory/?box=\(_box_id)&freezer_inventory_status=in")!,timeoutInterval: Double.infinity)
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
            var freezer_box_sample_locals = [InventorySampleModel]()
            
            
            
            for (_, sample) in jsonArray["results"] {
                
                let freezer_box_sample_local = InventorySampleModel()
                
                if (sample["id"].int != nil){
                    freezer_box_sample_local.id =  sample["id"].intValue
                }
                
                if (sample["freezer_box"].string != nil){
                    freezer_box_sample_local.freezer_box =  sample["freezer_box"].stringValue
                }
                
                if (sample["sample_barcode"].string != nil){
                    freezer_box_sample_local.sample_barcode =  sample["sample_barcode"].stringValue
                }
                
                if (sample["freezer_inventory_slug"].string != nil){
                    freezer_box_sample_local.freezer_inventory_slug =  sample["freezer_inventory_slug"].stringValue
                }
                
                if (sample["freezer_inventory_type"].string != nil){
                    freezer_box_sample_local.freezer_inventory_type =  sample["freezer_inventory_type"].stringValue
                }
                
                if (sample["freezer_inventory_status"].string != nil){
                    freezer_box_sample_local.freezer_inventory_status =  sample["freezer_inventory_status"].stringValue
                }
                
                if (sample["freezer_inventory_column"].int != nil){
                    freezer_box_sample_local.freezer_inventory_column =  sample["freezer_inventory_column"].intValue
                }
                if (sample["freezer_inventory_row"].int != nil){
                    freezer_box_sample_local.freezer_inventory_row =  sample["freezer_inventory_row"].intValue
                }
                
                
                if (sample["created_by"].string != nil){
                    freezer_box_sample_local.created_by =  sample["created_by"].stringValue
                }
                
                if (sample["created_datetime"].string != nil){
                    freezer_box_sample_local.created_datetime =  sample["created_datetime"].stringValue
                }
                
                if (sample["modified_datetime"].string != nil){
                    freezer_box_sample_local.modified_datetime =  sample["modified_datetime"].stringValue
                }
                
                freezer_box_sample_locals.append(freezer_box_sample_local)
            }
            
            
            
            
            
            
            DispatchQueue.main.async {
                //put the update to the properties on the main thread because that where it lives
                //MARK: Add count
              
                self.all_box_samples = freezer_box_sample_locals //results from the db
                
                completion(freezer_box_sample_locals)
                
                
                self.isLoading = false
                
            }
        }
        
        
    }
    
    
    ///fetch all the inventory and post filter the results where the freezer_inventory_slug matches the param _freezer_inventory_slug for samples that has a status of in
    
    
    func FetchInventorySamplesFilterInByInventorySlug(_freezer_inventory_slug : String,completion: @escaping (InventorySampleModel) -> Void){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory/?freezer_inventory_status=in")!,timeoutInterval: Double.infinity)
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
            var freezer_box_sample_locals = [InventorySampleModel]()
            
            
            
            for (_, sample) in jsonArray["results"] {
                
                let freezer_box_sample_local = InventorySampleModel()
                
                if (sample["id"].int != nil){
                    freezer_box_sample_local.id =  sample["id"].intValue
                }
                
                if (sample["freezer_box"].string != nil){
                    freezer_box_sample_local.freezer_box =  sample["freezer_box"].stringValue
                }
                
                if (sample["sample_barcode"].string != nil){
                    freezer_box_sample_local.sample_barcode =  sample["sample_barcode"].stringValue
                }
                
                if (sample["freezer_inventory_slug"].string != nil){
                    freezer_box_sample_local.freezer_inventory_slug =  sample["freezer_inventory_slug"].stringValue
                }
                
                if (sample["freezer_inventory_type"].string != nil){
                    freezer_box_sample_local.freezer_inventory_type =  sample["freezer_inventory_type"].stringValue
                }
                
                if (sample["freezer_inventory_status"].string != nil){
                    freezer_box_sample_local.freezer_inventory_status =  sample["freezer_inventory_status"].stringValue
                }
                
                if (sample["freezer_inventory_column"].int != nil){
                    freezer_box_sample_local.freezer_inventory_column =  sample["freezer_inventory_column"].intValue
                }
                if (sample["freezer_inventory_row"].int != nil){
                    freezer_box_sample_local.freezer_inventory_row =  sample["freezer_inventory_row"].intValue
                }
                
                
                if (sample["created_by"].string != nil){
                    freezer_box_sample_local.created_by =  sample["created_by"].stringValue
                }
                
                if (sample["created_datetime"].string != nil){
                    freezer_box_sample_local.created_datetime =  sample["created_datetime"].stringValue
                }
                
                if (sample["modified_datetime"].string != nil){
                    freezer_box_sample_local.modified_datetime =  sample["modified_datetime"].stringValue
                }
                
                freezer_box_sample_locals.append(freezer_box_sample_local)
            }
            
            
            
            
            
            
            DispatchQueue.main.async {
               
                //MARK:filter the results by _freezer_inventory_slug
                //check that atleast one was found
                if freezer_box_sample_locals.count > 0{
                //MARK: - Filtering to show result by the freezer_log_slug
                    let box_sample : InventorySampleModel = freezer_box_sample_locals.filter{log in return log.freezer_inventory_slug == _freezer_inventory_slug}.first!//results from the db
                    
                    //return in completion handler
                    completion(box_sample)
                    
                }
               // self.stored_box_samples = freezer_box_sample_locals //results from the db
                //finished loading data so the observabke object can be updated to hide the spinner
                // self.quotes = quoteLocals
                //MARK: store the appstoreage data
                //self.Stored_Rental_Contracts = rentalContractLocals
                
                self.isLoading = false
                
            }
        }
        
        
    }
    
    //https://metadata.spatialmsk.dev/api/freezer_inventory/inventory/?freezer_box=test_freezer_1_test_rack3_test_box3
    
    func FetchAllInventoryFromFreezerBox(freezer_box_slug : String) async{
        
        
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory/?freezer_box=\(freezer_box_slug)")!,timeoutInterval: Double.infinity)
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
            .decode(type: InventorySampleModelHeader.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedInventory) in
                if let inventories = returnedInventory.results{
                    
                    //go back on the main thread
                  /*  await MainActor.run(body:{
                        self?.all_box_samples = inventories
                    })
*/
                    
                    
                    self?.all_box_samples = inventories
                    
                }
            }
            .store(in: &cancellables)
        
        
        
    }
    
    
    
    
}

