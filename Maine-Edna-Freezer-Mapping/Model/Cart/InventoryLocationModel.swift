//
//  InventoryLocationModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 3/7/22.
//
//TODO: DO the Search and Add Option
import Foundation

struct InventoryLocationModel: Codable {
    var links: InventoryLocationLinks?
    var count: Int?
    var results: [InventoryLocationResult]
}

// MARK: - Links
struct InventoryLocationLinks: Codable {
    var next, previous: JSONNull?
}

// MARK: - Result
struct InventoryLocationResult: Codable {
    
    init(){
        
        self.id = 0
        self.freezerLabel = ""
        self.freezerRoomName = ""
        
        self.sampleBarcode = ""
        self.freezerInventorySlug = ""
        self.freezerInventoryType = ""
        self.freezerInventoryStatus = ""
        self.freezerInventoryColumn = 0
        self.freezerInventoryRow = 0
        self.freezerBox = BoxModel()
        self.createdBy = ""
        self.createdDatetime = ""
        self.modifiedDatetime = ""
        
        self.isHighlighed = false
        
        
    }
    
    
    init(id : Int,freezerLabel : String, freezerRoomName : String,sampleBarcode : String, freezerInventorySlug : String, freezerInventoryType : String, freezerInventoryStatus : String,
         freezerInventoryColumn : Int, freezerInventoryRow : Int, freezerBox : BoxModel, createdBy : String, createdDatetime : String, modifiedDatetime : String, isHighlighed : Bool ){
       
        self.id = id
        
        self.freezerLabel = freezerLabel
        self.freezerRoomName = freezerRoomName
        self.freezerInventoryRow = freezerInventoryRow
        self.freezerInventoryColumn = freezerInventoryColumn
        
        self.sampleBarcode = sampleBarcode
        self.freezerInventorySlug = freezerInventorySlug
        self.freezerInventoryType = freezerInventoryType
        self.freezerInventoryStatus = freezerInventoryStatus
        self.freezerInventoryColumn = freezerInventoryColumn
        self.freezerInventoryRow = freezerInventoryRow
        self.freezerBox = freezerBox
        self.createdBy = createdBy
        self.createdDatetime = createdDatetime
        self.modifiedDatetime = modifiedDatetime
        
        self.isHighlighed = isHighlighed
        
        
    }
    
    
    var id: Int?
    var sampleBarcode, freezerInventorySlug, freezerInventoryType, freezerInventoryStatus: String?
    var freezerInventoryColumn, freezerInventoryRow: Int?
    var freezerBox: BoxModel?
    var createdBy, createdDatetime, modifiedDatetime: String?
    var isHighlighed : Bool = false
    
    var freezerLabel : String = ""
    var freezerRoomName : String = ""
  
    
    
    
    enum CodingKeys: String, CodingKey {
            case id
            case sampleBarcode = "sample_barcode"
            case freezerInventorySlug = "freezer_inventory_slug"
            case freezerInventoryType = "freezer_inventory_type"
            case freezerInventoryStatus = "freezer_inventory_status"
            case freezerInventoryColumn = "freezer_inventory_column"
            case freezerInventoryRow = "freezer_inventory_row"
            case freezerBox = "freezer_box"
            case createdBy = "created_by"
            case createdDatetime = "created_datetime"
            case modifiedDatetime = "modified_datetime"
            case freezerRoomName
            case freezerLabel
        
        }
}


struct BoxModel: Codable {
    var id: Int?
    var freezer_box_label, freezer_box_label_slug: String?
    var freezer_box_column, freezer_box_row, freezer_box_depth, freezer_box_capacity_column: Int?
    var freezer_box_capacity_row: Int?
    var freezer_rack: RackModel?
    var created_by, created_datetime, modified_datetime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case freezer_box_label = "freezer_box_label"
        case freezer_box_label_slug = "freezer_box_label_slug"
        case freezer_box_column = "freezer_box_column"
        case freezer_box_row = "freezer_box_row"
        case freezer_box_depth = "freezer_box_depth"
        case freezer_box_capacity_column = "freezer_box_capacity_column"
        case freezer_box_capacity_row = "freezer_box_capacity_row"
        case freezer_rack = "freezer_rack"
        case created_by = "created_by"
        case created_datetime = "created_datetime"
        case modified_datetime = "modified_datetime"
    }
}


// MARK: - FreezerRack
struct RackModel: Codable {
    
    init(freezer_rack_label : String){
        self.id = 0
        self.freezer_rack_label = freezer_rack_label
        self.freezer_rack_label_slug = ""
        self.freezer_rack_column_start = 0
        self.freezer_rack_column_end = 0
        self.freezer_rack_row_start = 0
        self.freezer_rack_row_end = 0
        self.freezer_rack_depth_start = 0
        self.freezer_rack_depth_end = 0
        self.freezer = FreezerProfileModel()
        //freezer = ""
        self.created_by = ""
        self.created_datetime = ""
        self.modified_datetime = ""
        
    }
    
    init(){
        id = 0
        freezer_rack_label = ""
        freezer_rack_label_slug = ""
        freezer_rack_column_start = 0
        freezer_rack_column_end = 0
        freezer_rack_row_start = 0
        freezer_rack_row_end = 0
        freezer_rack_depth_start = 0
        freezer_rack_depth_end = 0
        freezer = FreezerProfileModel()
        //freezer = ""
        created_by = ""
        created_datetime = ""
        modified_datetime = ""
    }
    
    var id: Int
    
    var freezer_rack_label, freezer_rack_label_slug: String
    var freezer_rack_column_start, freezer_rack_column_end, freezer_rack_row_start, freezer_rack_row_end: Int
    var freezer_rack_depth_start, freezer_rack_depth_end: Int
    var freezer: FreezerProfileModel?
   // var freezer : String?
    var created_by, created_datetime, modified_datetime: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case freezer_rack_label = "freezer_rack_label"
        case freezer_rack_label_slug = "freezer_rack_label_slug"
        case freezer_rack_column_start = "freezer_rack_column_start"
        case freezer_rack_column_end = "freezer_rack_column_end"
        case freezer_rack_row_start = "freezer_rack_row_start"
        case freezer_rack_row_end = "freezer_rack_row_end"
        case freezer_rack_depth_start = "freezer_rack_depth_start"
        case freezer_rack_depth_end = "freezer_rack_depth_end"
        case freezer
        case created_by = "created_by"
        case created_datetime = "created_datetime"
        case modified_datetime = "modified_datetime"
    }
}
