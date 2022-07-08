//
//  BarcodeViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import Foundation
import Combine
import SwiftUI


class BarcodeViewModel : ObservableObject{
    
    @Published var barcodes : [BarcodeResult] = []
    @Published var isLoading : Bool = false
    
    private let barcodeDataService = BarcodeDataService()
    private var cancellables = Set<AnyCancellable>()

    
    //MARK: Todo add the saved barcodes to the Coredata Db
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers(){
        
        //the freezer section
        barcodeDataService.$barcodes
            .sink {[weak self] (returnedBarcodes) in
                
                if returnedBarcodes.count > 0{
                    self?.barcodes = returnedBarcodes
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)
        
    }
    
    func reloadBarcodeData(){
        barcodeDataService.FetchAllBarcodesInSystem()
    }
    
}

