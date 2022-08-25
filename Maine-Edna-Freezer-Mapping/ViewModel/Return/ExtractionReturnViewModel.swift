//
//  ExtractionReturnViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/12/22.
//


import Foundation
import Combine
import SwiftUI


class ExtractionReturnViewModel : ObservableObject{
    
   
    @Published var isLoading : Bool = false
    

    private var cancellables = Set<AnyCancellable>()
    
    private let freezerExtractionReturnDataService = ReturnExtractionDataService()
   
    //properties to update the UI
    @Published var showResponseMsg : Bool = false
    @Published var isErrorMsg : Bool = false
    @Published var responseMsg : String = ""
    
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers(){
        
        //the freezer section
      /*  freezerInventoryRetrievalDataService.$all_box_samples
            .sink {[weak self] (returnedSamples) in
                
                if returnedSamples.count > 0{
                    self?.all_box_samples = returnedSamples
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
       */
        
    }
    
    #warning("Need to call on UI")
  ///Permanently Remove use Put method to update status to perm_removed
    func PermanentlyRemoveExtraction(_freezerInventory : FreezerInventoryPutModel,completion: @escaping (ServerMessageModel) -> Void){
        freezerExtractionReturnDataService.PermanentlyRemoveExtraction(_freezerInventory: _freezerInventory) { response in
            
            //need to update the UI that one has been added, so that the progress can be updated
            
            self.responseMsg = response.serverMessage
            self.showResponseMsg = true
            self.isErrorMsg = response.isError
            
            completion(response)
        }
    }
    
}


