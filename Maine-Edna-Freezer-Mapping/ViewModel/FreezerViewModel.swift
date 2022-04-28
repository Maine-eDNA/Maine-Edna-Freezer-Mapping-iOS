//
//  FreezerViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/19/22.
//

import Foundation
import Foundation
import Combine
import SwiftUI


class FreezerViewModel : ObservableObject{
    
    @Published var metaDataResults : [FreezerInventoryReturnMetaDataResults] = []
    @Published var isLoading : Bool = false
    
    private let freezerDataService = FreezerProfileRetrieval()
    private var cancellables = Set<AnyCancellable>()
    @Published public var allFreezers : [FreezerProfileModel] = []
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers(){
        
        //the freezer section
        freezerDataService.$allFreezers
            .sink {[weak self] (returnedFreezers) in
                
                if returnedFreezers.count > 0{
                    self?.allFreezers = returnedFreezers
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
        
    }
    
    func reloadFreezerData(){
        freezerDataService.FetchAllAvailableFreezers()
    }
    
}
