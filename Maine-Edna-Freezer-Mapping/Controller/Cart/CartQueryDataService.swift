//
//  CartQueryDataService.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/7/22.
//

import Foundation
import SwiftUI
import Combine


class CartQueryDataService : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @Published public var inventory_location_results : [InventoryLocationResult] = []
    
    @Published public var inventory_location_result : InventoryLocationResult = InventoryLocationResult()
    var cancellables = Set<AnyCancellable>()
    
    func FetchInventoryLocation(_sample_barcodes : String){
        
        //https://metadata.spatialmsk.dev/api/freezer_inventory/inventory_location/?sample_barcode_list=esg_e01_19w_0001%2Cesg_e01_19w_0003
      //  var request = URLRequest(url: URL(string: "https://metadata.spatialmsk.dev/api/freezer_inventory/inventory_location/?sample_barcode_list=esg_e01_19w_0001,esg_e01_19w_0004")!,timeoutInterval: Double.infinity)
       
        if let url = URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory_location/?sample_barcode_list=\(_sample_barcodes)"){
        var request = URLRequest(url: url,timeoutInterval: Double.infinity);        request.addValue("Token \(self.edna_freezer_token)", forHTTPHeaderField: "Authorization")
        
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
            .decode(type: InventoryLocationModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedResults) in
              //  if let inventoryLocations = returnedResults.results{
                    
                    #warning("Need to update the rack, box and sample to be isHighlighted so that it shows up on the map")
                var processedResults : [InventoryLocationResult] = []
                print(returnedResults)
                //MARK: Other method start
                if returnedResults.results != nil
                {
                    var preProcessedResults = returnedResults.results
                    //set the rack as highlighted
                    
                    //preProcessedResults.first?.isHighlighed = true
                    for sample in preProcessedResults{
                        var processedResult = InventoryLocationResult()
                        processedResult = sample
                        processedResult.isHighlighed = true
                        //set the box
                        
                        //set the rack
                        
                        #warning("Check that the sample is there and shows that the isHighlighed is set")
                        processedResults.append(processedResult)
                    }
                    
                    
                }
                
                    //MARK: Other method end
                     
                    //MARK: Put the completion handler inside the view model to stop the is loading
             
                    self?.inventory_location_results = returnedResults.results  //group this
                    
              //  }
            }
            .store(in: &cancellables)
        
        }
        
    }
    
    ///isAddToListMode tells the app that it should add it to the inventory results list instead of a single variable when previewing a single sample
    func FetchSingleInventoryLocation(_sample_barcode : String, _isAddToListMode : Bool){
        
        //https://metadata.spatialmsk.dev/api/freezer_inventory/inventory_location/?sample_barcode_list=esg_e01_19w_0001%2Cesg_e01_19w_0003
      //  var request = URLRequest(url: URL(string: "https://metadata.spatialmsk.dev/api/freezer_inventory/inventory_location/?sample_barcode_list=esg_e01_19w_0001,esg_e01_19w_0004")!,timeoutInterval: Double.infinity)
       
        if let url = URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory_location/?sample_barcode=\("elp_e01_21w_0039")"){
        var request = URLRequest(url: url,timeoutInterval: Double.infinity);        request.addValue("Token \(self.edna_freezer_token)", forHTTPHeaderField: "Authorization")
        //https://metadata.spatialmsk.dev/api/freezer_inventory/inventory_location/?sample_barcode=elp_e01_21w_0039
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
            .decode(type: InventoryLocationModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedResults) in
              //  if let inventoryLocations = returnedResults.results{
                    
                    #warning("Need to update the rack, box and sample to be isHighlighted so that it shows up on the map")
                var processedResults : [InventoryLocationResult] = []
                print(returnedResults)
                //MARK: Other method start
                if returnedResults.results != nil
                {
                    if returnedResults.results.count < 1{
                        self?.inventory_location_result = InventoryLocationResult(id: 0,freezerLabel: "No Freezer Label Found",freezerRoomName: "No Room Found", sampleBarcode: "No Data Found", freezerInventorySlug: "No Data Found", freezerInventoryType: "No Data Found", freezerInventoryStatus: "No Data Found",freezerInventoryColumn: 0, freezerInventoryRow: 0, freezerBox: BoxModel(id: 0, freezer_box_label: "No Data Found", freezer_box_label_slug: "No Data Found"), createdBy: "No Data Found", createdDatetime: "",modifiedDatetime: "", isHighlighed: false)
                    }
                    
                    var preProcessedResults = returnedResults.results
                    //set the rack as highlighted
                    
                    //preProcessedResults.first?.isHighlighed = true
                    for sample in preProcessedResults{
                        var processedResult = InventoryLocationResult()
                        processedResult = sample
                        processedResult.isHighlighed = true
                        //set the box
                        
                        //set the rack
                        
                        #warning("Check that the sample is there and shows that the isHighlighed is set")
                        processedResults.append(processedResult)
                    }
                    
                    
                }
                
                    //MARK: Other method end
                     
                    //MARK: Put the completion handler inside the view model to stop the is loading
                if let inventory_result = returnedResults.results.first{
                    if !_isAddToListMode{
                    self?.inventory_location_result =  inventory_result
                    }
                    else if _isAddToListMode{
                        self?.inventory_location_results.append(inventory_result)
                    }
                    
                }
                    
              //  }
            }
            .store(in: &cancellables)
        
        }
        
    }
    
    
    
}
