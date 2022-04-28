//
//  DashboardViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/18/22.
//

import Foundation
import Foundation
import Combine
import SwiftUI


class DashboardViewModel : ObservableObject{
    
    @Published var metaDataResults : [FreezerInventoryReturnMetaDataResults] = []
    @Published var isLoading : Bool = false
    
    private let freezerCheckOutDataService = FreezerCheckOutLogRetrieval()
    private var cancellables = Set<AnyCancellable>()
    
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    
    
    init(){
        addSubscribers()
    }
    
    func reloadData(){
        freezerCheckOutDataService.FetchInventoryReturnMetadata(_created_by: self.store_email_address)
    }
    
    func addSubscribers(){
        
        freezerCheckOutDataService.$freezer_return_metas
            .sink { [weak self] returnedMetaData in
                
                self?.metaDataResults = returnedMetaData
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    
}
