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
import Combine

class FreezerRackLayoutService: ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @Published var freezer_racks : [RackItemModel] = []
    
    @AppStorage(AppStorageNames.stored_freezer_rack_layout.rawValue) var stored_freezer_rack_layout : [RackItemModel] = [RackItemModel]()
    
    @AppStorage(AppStorageNames.stored_freezer_racks_in_system.rawValue) var stored_freezer_racks_in_system : [RackItemModel] = [RackItemModel]()
    var cancellables = Set<AnyCancellable>()
    
    
    
    // Loading Screen...
    @Published var isLoading = false
    //
    
    init(){
        FetchAllRacksInSystem()
    }
    
    //Need a func to fetch just the inbox out
    //Fetch all Racks in System
    func FetchAllRacksInSystem(){
        
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/rack/")!,timeoutInterval: Double.infinity)
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
                
                var rackLocal = RackItemModel()
                
                if (rack["id"].int != nil){
                    rackLocal.id =  rack["id"].intValue
                }
                
                if (rack["created_by"].string != nil){
                    rackLocal.created_by =  rack["created_by"].stringValue
                }
                
                if (rack["created_datetime"].string != nil){
                    rackLocal.created_datetime =  rack["created_datetime"].stringValue
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
                
                if (rack["freezer_rack_label_slug"].string != nil){
                    rackLocal.freezer_rack_label_slug =  rack["freezer_rack_label_slug"].stringValue
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
                
                self.stored_freezer_racks_in_system = rackLocals //results from the db
                
                
                self.isLoading = false
                
            }
        }
        
        
    }
    
    
    
    func FetchRackLayoutForTargetFreezer(freezer_label : String){
        
        
        
        if let url =  URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/rack/?freezer=\(freezer_label)"){
            var request = URLRequest(url: url,timeoutInterval: Double.infinity)
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
                .decode(type: RackItemResultsModel.self, decoder: JSONDecoder())
                .sink { (completion) in
                    print("Completion: \(completion)")
                } receiveValue: { [weak self] (returnedRacks) in
                    if let racks = returnedRacks.results{
                        
                        
                        //return type [RackItemModel]
                        
                        self?.freezer_racks = racks //group this
                        
                        
                        
                    }
                }
                .store(in: &cancellables)
            
            
            
        }
        
        
    }
    
    
    func FetchRackLayoutForTargetFreezer(freezer_label : String,completion: @escaping ([RackItemModel] ) -> Void){
        
        
        
        if let url =  URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/rack/?freezer=\(freezer_label)"){
            var request = URLRequest(url: url,timeoutInterval: Double.infinity)
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
                .decode(type: RackItemResultsModel.self, decoder: JSONDecoder())
                .sink { (completion) in
                    print("Completion: \(completion)")
                } receiveValue: { [weak self] (returnedRacks) in
                    if let racks = returnedRacks.results{
                        
                        
                        //return type [RackItemModel]
                        
                        self?.freezer_racks = racks //group this
                        
                        completion(racks)
                        
                    }
                }
                .store(in: &cancellables)
            
            
            
        }
        
        
    }
    
    
}
