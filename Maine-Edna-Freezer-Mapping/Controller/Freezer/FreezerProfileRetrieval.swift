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
    @Published public var stored_freezers : [FreezerProfileModel] = []
    var cancellables = Set<AnyCancellable>()
    // Loading Screen...
    @Published var isLoading = false
    
    @ObservedObject var freezer_core_model = FreezerCoreDataManagement()
    
    
    init(){
        FetchAllAvailableFreezers(){
            response in
            
            print(response)
        }
        
        
    }
    
    func FetchAllAvailableFreezers(completion: @escaping (ServerMessageModel) -> Void){
        
        
        
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
                    self?.stored_freezers = freezers //group this
                    
                    //if more records exist in the server compared to locally then rewirte the data
                    //if  freezers > self?.freezer_core_model.freezer_entities.count then add records
                    
                    
                    //Extract this method start
                    //add to background later
                  //  Task{
                        //do in background
                    if let server_freezer_count = self?.stored_freezers.count, let core_data_freezer_count = self?.freezer_core_model.freezer_entities.count{
                    if server_freezer_count > core_data_freezer_count
                    {
                        //translate from FreezerProfileModel to CoreData
                        if let server_freezers = self?.stored_freezers {
                            for freezer in server_freezers{
                                if let freezer_translated =  self?.freezer_core_model.translateFreezerModelToEntity(_freezerDetail: freezer){
                                    
                                    //save this in CoreData
                                    self?.freezer_core_model.createNewTodoItem(_freezerDetail: freezer_translated)
                                    
                                }
                            }
                        }
                    }
                    
                }
                 //   }
                    self?.freezer_core_model.fetchAllFreezers()
                    //Extract this method end
                    
                    
                    
                    let errorDetail = ServerMessageModel()
                    errorDetail.serverMessage = String(describing: "Freezers Found")
                    errorDetail.isError = false
                    
                    completion(errorDetail)
                    
                }
            }
            .store(in: &cancellables)
        
        
        
    }
    
    
    
    
    
}



