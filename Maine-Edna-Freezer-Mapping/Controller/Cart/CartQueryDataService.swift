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
    var cancellables = Set<AnyCancellable>()
    
    func FetchInventoryLocation(_sample_barcode : String,completion: @escaping (ServerMessageModel) -> Void){
        
        
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/inventory_location/?sample_barcode=\(_sample_barcode)")!,timeoutInterval: Double.infinity)
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
            .decode(type: InventoryLocationModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedResults) in
              //  if let inventoryLocations = returnedResults.results{
                    
                    #warning("NOTE since it returns only one (if it returns bulk later then update this)")
                    if let latest_location = returnedResults.results.first {

                        self?.inventory_location_results.append(latest_location) //group this
                    }
             
                    
                    let errorDetail = ServerMessageModel()
                    errorDetail.serverMessage = String(describing: "\(_sample_barcode) Found")
                    errorDetail.isError = false
                    
                    completion(errorDetail)
                    
              //  }
            }
            .store(in: &cancellables)
        
        
        
    }
    
    
    
}
