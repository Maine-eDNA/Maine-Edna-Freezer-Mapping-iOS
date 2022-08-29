//
//  CartViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/28/22.
//


import Foundation
import Foundation
import Combine
import SwiftUI


class CartViewModel : ObservableObject{
#warning("Work here next to populate the Cart view to show where to find the products, and add new items to the freezer -> rack -> box (also replace samples that exist in a position that the user wants to add the sample")
    @Published var cartQueryDataService = CartQueryDataService()
    @Published var currentFreezerProfile : FreezerProfileModel = FreezerProfileModel()
    /*  @Published var metaDataResults : [FreezerInventoryReturnMetaDataResults] = []
     @Published var isLoading : Bool = false
     
     private let freezerCheckOutDataService = FreezerCheckOutLogRetrieval()
     
     
     @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
     */
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var rack_layout : [RackItemModel] = [RackItemModel]()
    @Published var freezer_profile = FreezerProfileModel()
    @Published var rack_boxes : [BoxItemModel] = [BoxItemModel]()
    @Published var inventoryLocations : [InventoryLocationResult] = []
    @Published public var inventoryLocation : InventoryLocationResult = InventoryLocationResult()
    
    //other view models
    @ObservedObject private var freezer_rack_vm : FreezerRackViewModel = FreezerRackViewModel()
    
    //properties to update the UI
    @Published var showResponseMsg : Bool = false
    @Published var isErrorMsg : Bool = false
    @Published var responseMsg : String = ""
    
    init(){
        addSubscribers()
    }
    
    func reloadData(){
        // freezerCheckOutDataService.FetchInventoryReturnMetadata(_created_by: self.store_email_address)
    }
    
    func addSubscribers(){
        
        //show list of results from the freezer here that shows the rack layout, for the target freezer that has been selected
        //MARK: Get the freezer rack layout for all the freezers in the list (freezer in list returned from the query)
        
        //May have to be a nested call
        //MARK: Source of truth list to populate the other sub listes
        cartQueryDataService.$inventory_location_results
            .sink { [weak self] returnedInventoryLocations in
                
                self?.inventoryLocations = returnedInventoryLocations
                
                
                // self?.isLoading = false
            }
            .store(in: &cancellables)
        
        //single result
        cartQueryDataService.$inventory_location_result
            .sink { [weak self] returnedInventoryLocation in
                
                self?.inventoryLocation = returnedInventoryLocation
                
                
                // self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
        //fetching freezer rack layouts
        self.freezer_rack_vm.$freezer_racks
            .combineLatest(cartQueryDataService.$inventory_location_results)
            .sink { [weak self] returnedResults in
                
                //add the target racks to the rack list in the
                //get the list from self?.inventoryLocations
                //0 is the racks
                //1 is the inventory location
                var fullRackList : [RackItemModel] = returnedResults.0
                let inventoryLocations = returnedResults.1
                //return all
                for location in inventoryLocations.filter( {$0.freezerBox?.freezer_rack?.freezer?.freezerLabel == self?.currentFreezerProfile.freezerLabel}) {
                    
                    // location.contains(where: {$0.freezerBox?.freezer_rack?.freezer?.freezerLabel == self?.currentFreezerProfile.freezerLabel})?.freezerBox?.freezer_rack
                    print("Target Barcode: \(location.sampleBarcode)")
                    if let target_rack = location.freezerBox?.freezer_rack{
                        
                        
                        //Transform this into RackItemModel start
                        var rackItem = RackItemModel()
                        
                        
                        rackItem.freezer_rack_label = target_rack.freezer_rack_label
                        rackItem.created_by = target_rack.created_by
                        
                        rackItem.freezer_rack_column_end = target_rack.freezer_rack_column_end
                        
                        rackItem.freezer_rack_column_start = target_rack.freezer_rack_column_start
                        rackItem.created_datetime = target_rack.created_datetime
                        rackItem.freezer_rack_depth_end = target_rack.freezer_rack_depth_end
                        rackItem.freezer_rack_depth_start = target_rack.freezer_rack_depth_start
                        rackItem.freezer_rack_label_slug = target_rack.freezer_rack_label_slug
                        
                        rackItem.freezer_rack_row_end = target_rack.freezer_rack_row_end
                        rackItem.freezer_rack_row_start = target_rack.freezer_rack_row_start
                        rackItem.modified_datetime = target_rack.modified_datetime
                        rackItem.is_suggested_rack_position = true
                        
                        //Transform this into RackItemModel end
                       // fullRackList.append(rackItem)
                        self?.rack_layout.append(rackItem)
                        
                    }
                }
                
                //check to ensure the current position isnt already taken which the priority is the suggested rack
                for other_rack in fullRackList{
                    if ((self?.rack_layout.first(where: {$0.freezer_rack_column_start == other_rack.freezer_rack_column_start && $0.freezer_rack_column_end == other_rack.freezer_rack_column_end
                        && $0.freezer_rack_row_start == other_rack.freezer_rack_row_start && $0.freezer_rack_row_end == other_rack.freezer_rack_row_end
                    })) != nil){
                        //dont add because it already exist
                    }
                    else{
                        self?.rack_layout.append(other_rack)
                    }
                }
                
                
               // self?.rack_layout = fullRackList
                //MARK: Need to merge the results with the suggested rack locations to highlight
                // self?.isLoading = false
                
            }
            .store(in: &cancellables)
    }
    
    ///takes a list of barcodes and returns multiple results
    func FetchInventoryLocation(_sample_barcodes: String){
        //get the rack layout for all the freezers in this list
        self.cartQueryDataService.FetchInventoryLocation(_sample_barcodes: _sample_barcodes)
    }
    
    func FetchInventoryLocation(_sample_barcodes: String,completion: @escaping ([InventoryLocationResult]) -> Void){
        //get the rack layout for all the freezers in this list
        self.cartQueryDataService.FetchInventoryLocation(_sample_barcodes: _sample_barcodes){
            response in
            completion(response)
        }
    }
  
    ///takes a single barcode and return its location details
    func FetchSingleInventoryLocation(_sample_barcode: String,_isAddToListMode: Bool = false){
        
        
        //get the rack layout for all the freezers in this list
        self.cartQueryDataService.FetchSingleInventoryLocation(_sample_barcode: _sample_barcode, _isAddToListMode: _isAddToListMode)
    }
    
    ///Called when a freezer is clicked
    func LoadFreezerRackLayout(freezerLabel : String){
        
        //get the freezer rack layout based on the freezer
        self.freezer_rack_vm.FindRackLayoutByFreezerLabel(_freezer_label: freezerLabel)
        
        
    }
    
    func removeDuplicateFreezerLabels(freezers: [FreezerQueryViewModel]) -> [FreezerQueryViewModel] {
        var uniqueFreezers = [FreezerQueryViewModel]()
        for freezer in freezers {
            if !uniqueFreezers.contains(where: {$0.freezer_label == freezer.freezer_label }) {
                uniqueFreezers.append(freezer)
            }
        }
        return uniqueFreezers
    }
    
    func removeDuplicateRackLabels(racks: [FreezerQueryViewModel]) -> [FreezerQueryViewModel] {
        var uniqueRacks = [FreezerQueryViewModel]()
        for rack in racks {
            if !uniqueRacks.contains(where: {$0.freezer_rack_label == rack.freezer_rack_label }) {
                uniqueRacks.append(rack)
            }
        }
        return uniqueRacks
    }
    
    func removeDuplicateBoxLabels(boxes: [FreezerQueryViewModel]) -> [FreezerQueryViewModel] {
        var uniqueBoxes = [FreezerQueryViewModel]()
        for box in boxes {
            if !uniqueBoxes.contains(where: {$0.freezer_box_label == box.freezer_box_label }) {
                uniqueBoxes.append(box)
            }
        }
        return uniqueBoxes
    }
    
    
    
}

