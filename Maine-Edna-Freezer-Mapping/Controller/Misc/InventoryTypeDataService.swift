//
//  InventoryTypeDataService.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/28/22.
//

import SwiftUI
import SwiftyJSON
import Alamofire
import Combine

class InventoryTypeDataService: ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @Published var inventoryType : InventoryTypeModel = InventoryTypeModel()
    
    var cancellables = Set<AnyCancellable>()
    
    
    
    // Loading Screen...
    @Published var isLoading = false
    //
    
    init(){
        FetchAllInvTypes()
    }
    
    
    
    
    
    func FetchAllInvTypes(){
        
        
        
        if let url =  URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/utility/choices_inv_types/"){
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
                .decode(type: InventoryTypeModel.self, decoder: JSONDecoder())
                .sink { (completion) in
                    print("Completion: \(completion)")
                } receiveValue: { [weak self] (returnedConstants) in
                        
                        self?.inventoryType = returnedConstants //group this
                        
                      
                        
                    
                }
                .store(in: &cancellables)
            
            
            
        }
        
        
    }
    
    
}

