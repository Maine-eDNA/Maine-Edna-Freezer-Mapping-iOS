//
//  FreezerBoxViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/22/22.
//


import Foundation
import Foundation
import Combine
import SwiftUI


class FreezerBoxViewModel : ObservableObject{
    
    @Published var all_filter_rack_boxes : [BoxItemModel] = []
    
    @Published var rack_boxes_for_report : [BoxItemModel] = []
    @Published var rack_boxes_occupied : Int = 0
    
    @Published var isLoading : Bool = false
    
    @Published var isInSearchMode : Bool = false
    
    private let freezerBoxDataService = FreezerBoxRetrieval()
    private var cancellables = Set<AnyCancellable>()
    @State var inventoryLocations : [InventoryLocationResult] = []
    
    init(){
        addSubscribers()
        
        
    }
    
    
    func addSubscribers(){
#warning("Need to test this to make sure the inventory locations are sent so that i can target the boxes the user needs to find")
        ///used to return results that doesnt need search mode or highlighting
        ///Run this only when i am not in search mode
        if (!self.isInSearchMode){
            freezerBoxDataService.$all_filter_rack_boxes
                .sink { [weak self] returnedRackBoxes in
                    
                    if returnedRackBoxes.count > 0{
                        self?.all_filter_rack_boxes = returnedRackBoxes
                        self?.isLoading = false
                    }
                    
                }
                .store(in: &cancellables)
        }
        
    }
    
    
    func FilterFreezerBoxesSearchMode(_rack_id : String, inventoryLocations :  [InventoryLocationResult]){
        
        let targetLocations = inventoryLocations.filter {$0.freezerBox?.freezer_rack?.freezer_rack_label_slug == _rack_id}
        if targetLocations.count > 0{
            freezerBoxDataService.FetchAllRackBoxesByRackId(_rack_id: _rack_id){
                rackBoxes in
                
                if (self.isInSearchMode){
                    //MARK:  mark as is suggested boxes if in the location list
                    
                    
                    var filteredBoxes : [BoxItemModel] = []
                    
                    
                    print("Number of Box Spaces: \( rackBoxes.count)")
                    print("Number of Records Found: \( targetLocations.count)")
                    
                    for target_box in rackBoxes{
                        
                        for inven_location in targetLocations{
                            
                            if let box = inven_location.freezerBox{
                                if box.freezer_box_row ==  target_box.freezer_box_row && box.freezer_box_column ==  target_box.freezer_box_column && box.freezer_box_label == target_box.freezer_box_label
                                {
                                    //if the row and column of box matches then it means that the box is the target
                                    
                                    //Translating the data from BoxModel to BoxItemModel
                                    let suggested_box = BoxItemModel(id: target_box.id, freezer_box_label: target_box.freezer_box_label, freezer_box_label_slug: target_box.freezer_box_label_slug, freezer_box_column: target_box.freezer_box_column, freezer_box_row: target_box.freezer_box_row, freezer_box_depth: target_box.freezer_box_depth, freezer_box_capacity_column: target_box.freezer_box_capacity_column, freezer_box_capacity_row: target_box.freezer_box_capacity_row, freezer_rack: target_box.freezer_rack, created_by: target_box.created_by, created_datetime: target_box.created_datetime, modified_datetime: target_box.modified_datetime, is_suggested_box_position: true)
                                    
                                    
                                    filteredBoxes.append(suggested_box)
                                    
                                    
                                }
                                else{
                                    //just add the box unedited since its not a target
                                    
                                    let converted_box = BoxItemModel(id: target_box.id, freezer_box_label: target_box.freezer_box_label, freezer_box_label_slug: target_box.freezer_box_label_slug, freezer_box_column: target_box.freezer_box_column, freezer_box_row: target_box.freezer_box_row, freezer_box_depth: target_box.freezer_box_depth, freezer_box_capacity_column: target_box.freezer_box_capacity_column, freezer_box_capacity_row: target_box.freezer_box_capacity_row, freezer_rack: target_box.freezer_rack, created_by: target_box.created_by, created_datetime: target_box.created_datetime, modified_datetime: target_box.modified_datetime, is_suggested_box_position: false)
                                    
                                    filteredBoxes.append(converted_box)
                                    
                                    
                                }
                                
                            }       else{
                                //just add the box unedited since its not a target
                                
                                let converted_box = BoxItemModel(id: target_box.id, freezer_box_label: target_box.freezer_box_label, freezer_box_label_slug: target_box.freezer_box_label_slug, freezer_box_column: target_box.freezer_box_column, freezer_box_row: target_box.freezer_box_row, freezer_box_depth: target_box.freezer_box_depth, freezer_box_capacity_column: target_box.freezer_box_capacity_column, freezer_box_capacity_row: target_box.freezer_box_capacity_row, freezer_rack: target_box.freezer_rack, created_by: target_box.created_by, created_datetime: target_box.created_datetime, modified_datetime: target_box.modified_datetime, is_suggested_box_position: false)
                                
                                filteredBoxes.append(converted_box)
                                
                                
                            }
                            /* */
                            
                        }
                        
                    }
                    self.all_filter_rack_boxes = filteredBoxes
                    self.isLoading = false
                    
                    
                }
            }
            //results here without combine
            //Add to own method start
            
        }
        //end
    }
    
    func FilterFreezerBoxes(_freezer_rack_label_slug : String){
   
        freezerBoxDataService.FetchAllRackBoxesByRackId(_rack_id: _freezer_rack_label_slug)
        
        //run the above but without the hightlight filtering
    }
    
    
    func findNumberOfBoxesInUse(rack: RackItemModel) -> Int{
        //find all the boxes in this rack, keep the data for other processing
        freezerBoxDataService.FetchAllRackBoxesByRackId(_rack_id: rack.freezer_rack_label){
            [weak self] returnedBoxes in
            
            self?.rack_boxes_for_report = returnedBoxes
            //minus this from the capacity to get the number of empty boxes
            //count the boxes
            let occupied_count = returnedBoxes.count
            
            self?.rack_boxes_occupied = occupied_count
           //return completion(occupied_count)
            
         
        }
     return rack_boxes_occupied
        
        
    }
    
    ///Used for converting models that are being used in search function
    func convertBoxModelToBoxItemModel(boxes : [BoxModel]) -> [BoxItemModel]
    {
        var convertedModel : [BoxItemModel] = []
        
        for box in boxes{
            convertedModel.append(BoxItemModel(id: box.id, freezer_box_label: box.freezer_box_label, freezer_box_label_slug: box.freezer_box_label_slug, freezer_box_column: box.freezer_box_column, freezer_box_row: box.freezer_box_row, freezer_box_depth: box.freezer_box_depth, freezer_box_capacity_column: box.freezer_box_capacity_column, freezer_box_capacity_row: box.freezer_box_capacity_row, freezer_rack: box.freezer_rack?.freezer_rack_label, created_by: box.created_by, created_datetime: box.created_datetime, modified_datetime: box.modified_datetime, is_suggested_box_position: true))
            
        }
        return convertedModel
        
    }
    
}

