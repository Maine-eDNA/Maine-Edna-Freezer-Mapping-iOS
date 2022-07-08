//
//  BarcodeModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import Foundation
import SwiftUI
//Need a view model as well to handle having all the barcodes



// MARK: - BarcodeModel
struct BarcodeModel : Codable{
    var links: BarcodeLinks?
    var count: Int?
    var results: [BarcodeResult]?
}

// MARK: - Links
struct BarcodeLinks : Codable {
    var next, previous: String?
}

// MARK: - Result
struct BarcodeResult : Identifiable, Codable {
    
    var id = UUID()
    
    var sampleBarcodeID : String 
    var sampleLabelRequest, barcodeSlug, siteID: String?
    var sampleYear: Int?
    var sampleMaterial, sampleType, purpose, inFreezer: String?
    var createdBy, createdDatetime, modifiedDatetime: String?
    
    static func == (lhs: BarcodeResult, rhs: BarcodeResult) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case sampleBarcodeID = "sample_barcode_id"
        case sampleLabelRequest = "sample_label_request"
        case barcodeSlug = "barcode_slug"
        case siteID = "site_id"
        case sampleYear = "sample_year"
        
        case sampleMaterial = "sample_material"
        case sampleType = "sample_type"
        case purpose = "purpose"
        case inFreezer = "in_freezer"
        case createdBy = "created_by"
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
        
    }
    
}
