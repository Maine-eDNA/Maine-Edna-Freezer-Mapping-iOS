//
//  BarcodeDataService.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI
import SwiftyJSON
import Alamofire
import Combine

class BarcodeDataService: ObservableObject {
    
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""//set this when I create an account and login, which i need to do next
    
    @Published var barcodes : [BarcodeResult] = []
    
    var cancellables = Set<AnyCancellable>()
    
    
    
    // Loading Screen...
    @Published var isLoading = false
    //
    
    init(){
        FetchAllBarcodesInSystem()
    }
    
    
    
    
    
    func FetchAllBarcodesInSystem(){
        
        
        
        if let url =  URL(string: "\(ServerConnectionUrls.productionUrl.rawValue)api/sample_label/sample_barcode/"){
            var request = URLRequest(url: url,timeoutInterval: Double.infinity)
            request.addValue("Token \(self.edna_freezer_token)", forHTTPHeaderField: "Authorization")
            
            request.httpMethod = "GET"
            
            //request
            URLSession.shared.dataTaskPublisher(for: request)//(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap { (data, response) -> Data in
                    
                    
                    guard let response = response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode < 300 else{
                        throw URLError(URLError.badServerResponse)
                    }
                    return data
                }
                .decode(type: BarcodeModel.self, decoder: JSONDecoder())
                .sink { (completion) in
                    print("Completion: \(completion)")
                } receiveValue: { [weak self] (returnedBarcodes) in
                    if let barcodes = returnedBarcodes.results{
                        
                        
                        //return type [RackItemModel]
                        
                        self?.barcodes = barcodes //group this
                        
                      
                        
                    }
                }
                .store(in: &cancellables)
            
            
            
        }
        
        
    }
    
    
}
