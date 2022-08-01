//
//  InventorySampleModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import Foundation
import SwiftUI


struct InventorySampleModelHeader: Codable {
    var links: Links?
    var count: Int?
    var results: [InventorySampleModel]?
}


// MARK: - Links
struct InventorySampleModelLinks: Codable {
    var next, previous: JSONNull?
}



class InventorySampleModel: Encodable,Decodable, Identifiable, Hashable {
    
    init(){
        
    }
    
    init(id : Int,freezer_box : String,freezer_inventory_column : Int,freezer_inventory_row : Int, is_suggested_sample : Bool  ){
        self.id = 0
        self.freezer_box = ""
        self.freezer_inventory_column = 0
        self.freezer_inventory_row = 0
        self.is_suggested_sample = false
    }
    
    init(freezer_box : String,freezer_inventory_column : Int,freezer_inventory_row : Int, freezer_inventory_type : String,freezer_inventory_status : String, sample_barcode : String  ){

        self.freezer_box = freezer_box
        self.freezer_inventory_column = freezer_inventory_column
        self.freezer_inventory_row = freezer_inventory_row
        self.freezer_inventory_type = freezer_inventory_type
        self.freezer_inventory_status = freezer_inventory_status
        self.sample_barcode = sample_barcode
        
    }
    
    var id : Int = 0
    var freezer_box : String = ""
    var sample_barcode : String = ""
    var freezer_inventory_slug : String = ""
    var freezer_inventory_type : String = ""
    var freezer_inventory_status : String = ""
    var freezer_inventory_column : Int = 0
    var freezer_inventory_row : Int = 0


    var created_by : String = ""
    var created_datetime : String = ""
    var modified_datetime : String = ""
    
    var is_suggested_sample : Bool = false
    
    
    
    
    
    enum CodingKeys: String, CodingKey {
            case id
            case freezer_box
            case sample_barcode
            case freezer_inventory_slug
            case freezer_inventory_type
            case freezer_inventory_status
            case freezer_inventory_column
            case freezer_inventory_row
            case created_by
            case created_datetime
            case modified_datetime
         
        
        }
    
    //conform to hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: InventorySampleModel, rhs: InventorySampleModel) -> Bool {
        lhs.id == rhs.id
    }

}



///For Batch Samples
///
struct SampleBatchModel: Codable, Identifiable, Hashable {
   
    init(){
        self.batchName = ""
        self.samples = [InventorySampleModel]()
    }
    init(batchName : String, samples: [InventorySampleModel])
    {
        self.batchName = batchName
        self.samples = samples
    }
    
    var id = UUID()
    var batchName : String = ""
    var samples: [InventorySampleModel] = [InventorySampleModel]()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SampleBatchModel, rhs: SampleBatchModel) -> Bool {
        lhs.id == rhs.id
    }
    
}

