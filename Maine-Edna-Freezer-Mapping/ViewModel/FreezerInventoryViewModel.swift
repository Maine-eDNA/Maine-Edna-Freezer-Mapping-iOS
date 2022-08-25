//
//  FreezerInventoryViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/31/22.
//



import Foundation
import Combine
import SwiftUI


class FreezerInventoryViewModel : ObservableObject{
    
    @Published var all_box_samples : [InventorySampleModel] = []
    @Published var isLoading : Bool = false
    
    private let freezerInventoryRetrievalDataService = BoxInventorySampleRetrieval()
    private var cancellables = Set<AnyCancellable>()
    
    private let freezerInventoryCreationDataService = BoxInventorySampleCreation()
   
    //properties to update the UI
    @Published var showResponseMsg : Bool = false
    @Published var isErrorMsg : Bool = false
    @Published var responseMsg : String = ""
    
    @Published var target_sample_detail : InventorySampleModel = InventorySampleModel()
    
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers(){
        
        //the freezer section
        freezerInventoryRetrievalDataService.$all_box_samples
            .sink {[weak self] (returnedSamples) in
                
                if returnedSamples.count > 0{
                    self?.all_box_samples = returnedSamples
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
        
    }
    
    
    ///Used when finding all samples within a box without any filtering
    func LoadFreezerInventoryData(box_detail : BoxItemModel){
        //MARK: Version that doesnt use completion handler to return results
        freezerInventoryRetrievalDataService.FetchAllSamplesInBox(_box_id: String(box_detail.id ?? 0))
    }
    
    ///Used when filtering to find a set of samples and would like to highlight them
    /*func LoadFreezerInventoryData(box_detail : BoxItemModel, inventoryLocations : [InventoryLocationModel] ){
        //MARK: Filter list by the locations data
        freezerInventoryRetrievalDataService.FetchAllSamplesInBox(_box_id: String(box_detail.id ?? 0)){
            samples in
            var filtered_box_samples : [InventorySampleModel] = []
            //will use inventoryLocations to highlight the targets and return the list to the UI
            
            for sample in samples{
                
                for inven_location in inventoryLocations.filter({$0.freezerBox?.id == box_detail.id}){
                   
                   //MARK: check the sample label and location (row and column) else show blanks
                    if sample.freezer_inventory_row == inven_location.freezerInventoryRow &&  sample.freezer_inventory_column == inven_location.freezerInventoryColumn
                        && sample.freezer_inventory_slug == inven_location.freezerInventorySlug{
                        self.all_box_samples.append( InventorySampleModel(id: sample.id, freezer_box: sample.freezer_box, freezer_inventory_column: sample.freezer_inventory_column, freezer_inventory_row: sample.freezer_inventory_row, is_suggested_sample: true))
                    }
                    else{
                        self.all_box_samples.append( InventorySampleModel(id: sample.id, freezer_box: sample.freezer_box, freezer_inventory_column: sample.freezer_inventory_column, freezer_inventory_row: sample.freezer_inventory_row, is_suggested_sample: false))
                    }
                }
             
            }
            
           // self.all_box_samples = filtered_box_samples
            
            
        }
    }*/
    
    func ReloadFreezerInventoryData(box_detail : BoxItemModel){
        freezerInventoryRetrievalDataService.FetchAllSamplesInBox(_box_id: String(box_detail.id ?? 0))
    }
    
    
    ///Create Inv Sample
    func createNewInvSample(_sampleDetail : InventorySampleModel,completion: @escaping (ServerMessageModel) -> Void){
        
        freezerInventoryCreationDataService.CreateInventorySample(_sampleDetail: _sampleDetail) { response in
            //Update the UI
            //MARK: send the results to the UI
            print("Response is: \(response)")
            self.responseMsg = response.serverMessage
            self.showResponseMsg = true
            self.isErrorMsg = response.isError
           
            completion(response)
        }
        
    }
    
    //FetchAllInventoryFromFreezerBox
    func fetchInventoryByBoxSlug(freezer_box_slug : String) async{
        await freezerInventoryRetrievalDataService.FetchAllInventoryFromFreezerBox(freezer_box_slug: freezer_box_slug)
    }
    
}

