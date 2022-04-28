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
import Combine

class FreezerBoxRetrieval : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @AppStorage(AppStorageNames.stored_rack_boxes.rawValue) var stored_rack_boxes : [BoxItemModel] = [BoxItemModel]()
    
    @AppStorage(AppStorageNames.all_stored_rack_boxes_in_system.rawValue) var all_stored_rack_boxes_in_system : [BoxItemModel] = [BoxItemModel]()
  
    // Loading Screen...
    @Published var isLoading = false
    //
    var cancellables = Set<AnyCancellable>()
    
    @Published var all_filter_rack_boxes : [BoxItemModel] = []
    
   
    //Fetch all boxes
    func FetchAllRackBoxesInSystem(){
    
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/box/")!,timeoutInterval: Double.infinity)
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
                
                var freezer_rack_box_local = BoxItemModel()
                
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
          
                if (box["freezer_box_capacity_column"].int != nil){
                    freezer_rack_box_local.freezer_box_capacity_column =  box["freezer_box_capacity_column"].intValue
                }
                if (box["freezer_box_capacity_row"].int != nil){
                    freezer_rack_box_local.freezer_box_capacity_row =  box["freezer_box_capacity_row"].intValue
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
              
                self.all_stored_rack_boxes_in_system = freezer_rack_box_locals //results from the db
            
                self.isLoading = false
                
            }
        }
        
        
    }
    
    
    ///Uses completion to return results
    func FetchAllRackBoxesByRackId(_rack_id : String,completion: @escaping ([BoxItemModel] ) -> Void){
        //start
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/box/?freezer_rack=\(_rack_id)")!,timeoutInterval: Double.infinity)
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
            .decode(type: BoxItemResultsModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedBoxResults) in
                
                print(returnedBoxResults)
                //need to sort the data
                if let results = returnedBoxResults.results {
                    self?.all_filter_rack_boxes = results
                    
                        //return it to the Other method
                    completion(results)
                }
           
            }
            .store(in: &cancellables)
        
        
        
        //end
        
        
    }
    

    ///no completion to return results just combine
    func FetchAllRackBoxesByRackId(_rack_id : String){
        //start
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/box/?freezer_rack=\(_rack_id)")!,timeoutInterval: Double.infinity)
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
            .decode(type: BoxItemResultsModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedBoxResults) in
                
                print(returnedBoxResults)
                //need to sort the data
                if let results = returnedBoxResults.results {
                    self?.all_filter_rack_boxes = results
                    
                   
                }
           
            }
            .store(in: &cancellables)
        
        
        
        //end
        
        
    }
    
}
