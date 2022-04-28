//
//  FreezerProfileRetrieval.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/3/21.
//

import SwiftUI
import Combine

class FreezerProfileRetrieval : ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    // @AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
    @Published public var allFreezers : [FreezerProfileModel] = []
    var cancellables = Set<AnyCancellable>()
    // Loading Screen...
    @Published var isLoading = false
    
    @ObservedObject var freezer_core_model = FreezerCoreDataManagement()
    
    
    init(){
        FetchAllAvailableFreezers()
        
        
    }
    
    func FetchAllAvailableFreezers(){
        
        
        
        var request = URLRequest(url: URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/freezer_inventory/freezer/")!,timeoutInterval: Double.infinity)
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
            .decode(type: FreezerProfilesResultModel.self, decoder: JSONDecoder())
            .sink { (completion) in
                print("Completion: \(completion)")
            } receiveValue: { [weak self] (returnedFreezers) in
                if let freezers = returnedFreezers.results{
                    
#warning("Need a record syncing func to check that the record doesnt exist, add the new item and update the item if it already exist (all variables except Id is updated)")
                    self?.allFreezers = freezers //group this
                    
                 
                    
                }
            }
            .store(in: &cancellables)
        
        
        
    }
    
    
    
    
    
}



