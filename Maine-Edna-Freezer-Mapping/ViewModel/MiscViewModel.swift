//
//  MiscViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/28/22.
//

import Foundation
import Combine
import SwiftUI


class MiscViewModel : ObservableObject{
    
    @Published var inventoryType : InventoryTypeModel = InventoryTypeModel()
    @Published var inventoryStatus : InventoryStatusModel = InventoryStatusModel()
    
    @Published var isLoading : Bool = false
    
    private let inventoryTypeDataService = InventoryTypeDataService()
    
    private let inventoryStatusDataService = InventoryStatusDataService()
    
    private var cancellables = Set<AnyCancellable>()

    
    //MARK: Todo add the saved barcodes to the Coredata Db
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers(){
        
        //the inventory type
        inventoryTypeDataService.$inventoryType
            .sink {[weak self] (returnedInvTypes) in
                
               
                    self?.inventoryType = returnedInvTypes
                    self?.isLoading = false
                
            }
            .store(in: &cancellables)
        
        //inventory status
        inventoryStatusDataService.$inventoryStatus
            .sink {[weak self] (returnedInvStatus) in
                
               
                    self?.inventoryStatus = returnedInvStatus
                    self?.isLoading = false
                
            }
            .store(in: &cancellables)
        
    }
    
    func reloadInventoryTypes(){
        inventoryTypeDataService.FetchAllInvTypes()
    }
    
}
