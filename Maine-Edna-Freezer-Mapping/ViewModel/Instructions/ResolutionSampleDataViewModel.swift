//
//  ResolutionSampleDataViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/22/22.
//

//


import Foundation
import Combine
import SwiftUI


class ResolutionSampleDataViewModel : ObservableObject{
    
    let sample_check_out_log_service : FreezerCheckOutLogRetrieval = FreezerCheckOutLogRetrieval()
    @Published var sampleLogs : [FreezerCheckOutLogModel] = [FreezerCheckOutLogModel]()
    
    private var cancellables = Set<AnyCancellable>()

    
    //MARK: Todo add the saved barcodes to the Coredata Db
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers(){
        
        sample_check_out_log_service.$sampleLogs
            .sink {[weak self] (returnedLogs) in
                
               
                    self?.sampleLogs = returnedLogs
                
                
            }
            .store(in: &cancellables)
    }
    
    func loadSampleLogs(freezerInventorySlug : String){
        
        self.sample_check_out_log_service.FetchAllRackBoxesFilterByFreezerLogSlug(_freezer_log_slug: freezerInventorySlug){
            response in
            
            print("Response: \(response)")
        }
         
    }
    
}

