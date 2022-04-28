//
//  FreezerRackViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/22/22.
//

import Foundation
import Foundation
import Combine
import SwiftUI


class FreezerRackViewModel : ObservableObject{
    
    @Published var freezer_racks : [RackItemModel] = []
    
    @Published var freezer_racks_with_stat : [RackItemModel] = []
    @Published var isLoading : Bool = false
    
    private let freezerRackDataService = FreezerRackLayoutService()
    private var cancellables = Set<AnyCancellable>()
    private let freezerBoxDataService = FreezerBoxRetrieval()
    
    @Published var box_vm : FreezerBoxViewModel = FreezerBoxViewModel()
    
    init(){
        addSubscribers()
        
        
    }
    
    
    func addSubscribers(){
        isLoading = true
        freezerRackDataService.$freezer_racks
            .sink { [weak self] returnedRacks in
                
                self?.freezer_racks = returnedRacks
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    func FindRackLayoutByFreezerLabel(_freezer_label : String){
        
        freezerRackDataService.FetchRackLayoutForTargetFreezer(freezer_label: _freezer_label){
            [weak self] returnedRacks in
            
            //combine the racks with the report data
            let racks = returnedRacks
           // var racks_with_stats : [RackItemModel] = []
            //iterate over the racks and add the stats to each
            
            for rack in racks{
             
                
                //do the calculation here
                self?.freezerBoxDataService.FetchAllRackBoxesByRackId(_rack_id: rack.freezer_rack_label_slug){
                    [weak self] returnedBoxes in
                    
                
                    //minus this from the capacity to get the number of empty boxes
                    //count the boxes
                   
                    
                    let box_in_use_count  = returnedBoxes.count
                    if box_in_use_count > 0{
                        
                        if let box_capacity = self?.numberOfBoxesInRack(rack: rack){
                        self?.freezer_racks_with_stat.append(RackItemModel(id: rack.id, freezer_rack_label: rack.freezer_rack_label, freezer_rack_label_slug: rack.freezer_rack_label_slug, is_suggested_rack_position: true,number_of_boxes_in_use: box_in_use_count, box_capacity_of_rack: box_capacity))
                   
                        }
                    }
                    
                 
                }
                
                
            }
            //print( self?.freezer_racks_with_stat.count)
            //returned results
          //  self?.freezer_racks_with_stat = racks_with_stats
        }
        
        //calculate the box available vs in use as well
        
    }
    
    
    ///Finding the rack capacity by getting the number or rows x column
    func numberOfBoxesInRack(rack : RackItemModel) -> Int
    {
        let numberOfBoxInRow = rack.freezer_rack_row_end
        let numberOfColumns = rack.freezer_rack_column_end - rack.freezer_rack_column_start
        
        return (numberOfColumns * numberOfBoxInRow)
    }
    
}
