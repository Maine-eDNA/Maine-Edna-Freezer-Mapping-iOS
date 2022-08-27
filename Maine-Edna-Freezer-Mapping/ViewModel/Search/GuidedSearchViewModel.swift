//
//  GuidedSearchViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/27/22.
//

import Foundation

class GuidedSearchViewModel : ObservableObject{
    @Published var unique_freezers : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    @Published var unique_racks : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    @Published var unique_boxes : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    
    @Published var samples : [FreezerQueryViewModel] = [FreezerQueryViewModel]()
    
}
