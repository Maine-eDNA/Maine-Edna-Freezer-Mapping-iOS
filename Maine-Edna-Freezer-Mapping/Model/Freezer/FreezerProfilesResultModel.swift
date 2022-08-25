//
//  FreezerProfileModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/3/21.
//

import Foundation
import SwiftUI
import Combine



struct FreezerProfilesResultModel: Codable {
    var links: Links?
    var count: Int?
    var results: [FreezerProfileModel]?
}



// MARK: - Result
struct FreezerProfileModel: Identifiable, Codable, Equatable {
    
    init(){
        self.id = 0
        self.freezerLength = ""
        self.freezerWidth = ""
        self.freezerLabel = ""
        self.freezerLabelSlug = ""
        self.freezerRoomName = ""
        self.freezerDepth = ""
        self.freezerDimensionUnits = ""
        
        self.freezerCapacityColumns = 0
        self.freezerCapacityRows = 0
        self.freezerCapacityDepth = 0
        self.freezerRatedTemp = 0
        
        self.freezerRatedTempUnits = ""
        self.createdBy = ""
        self.createdDatetime = ""
        self.modifiedDatetime = ""
    }
    
    init(id : Int,freezerLength : String?,freezerWidth : String?,freezerLabel : String,freezerLabelSlug : String?,freezerRoomName : String?,freezerDepth : String?,freezerDimensionUnits : String?,freezerRatedTempUnits : String?,createdBy : String?,createdDatetime : String?,modifiedDatetime : String?, freezerCapacityColumns : Int?,freezerCapacityRows : Int?,freezerCapacityDepth : Int?,freezerRatedTemp : Int?){
        
        self.id = 0
        self.freezerLength = ""
        self.freezerWidth = ""
        self.freezerLabel = ""
        self.freezerLabelSlug = ""
        self.freezerRoomName = ""
        self.freezerDepth = ""
        self.freezerDimensionUnits = ""
        
        self.freezerCapacityColumns = 0
        self.freezerCapacityRows = 0
        self.freezerCapacityDepth = 0
        self.freezerRatedTemp = 0
        
        self.freezerRatedTempUnits = ""
        self.createdBy = ""
        self.createdDatetime = ""
        self.modifiedDatetime = ""
    }
    
    var id: Int?
    var freezerLength, freezerWidth : String?
    var freezerLabel : String
    var freezerLabelSlug, freezerRoomName, freezerDepth: String?
    var freezerDimensionUnits: String?
    var freezerCapacityColumns, freezerCapacityRows, freezerCapacityDepth, freezerRatedTemp: Int?
    var freezerRatedTempUnits, createdBy, createdDatetime, modifiedDatetime: String?
    
    //not on the API

   
  /*  mutating func setBoxColor(newColor : String){
        self.boxColor = newColor     
    }*/
    let objectWillChange = PassthroughSubject < Void,Never > ()
    
    var boxColor : String = "blue" {
        willSet {
            self.objectWillChange.send()
        }
    }
    
  
    
    static func == (lhs: FreezerProfileModel, rhs: FreezerProfileModel) -> Bool {
        lhs.id == rhs.id
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case freezerLabel = "freezer_label"
        case freezerLabelSlug = "freezer_label_slug"
        case freezerRoomName = "freezer_room_name"
        case freezerDepth = "freezer_depth"
        case freezerLength = "freezer_length"
        case freezerWidth = "freezer_width"
        case freezerDimensionUnits = "freezer_dimension_units"
        case freezerCapacityColumns = "freezer_capacity_columns"
        case freezerCapacityRows = "freezer_capacity_rows"
        case freezerCapacityDepth = "freezer_capacity_depth"
        case freezerRatedTemp = "freezer_rated_temp"
        case freezerRatedTempUnits = "freezer_rated_temp_units"
        case createdBy = "created_by"
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
    }
}

/*
 class FreezerProfileModel: Encodable,Decodable, Identifiable {
 
 init(){
 
 }
 
 init(id : Int,freezer_date: String,freezer_label : String,freezer_depth : Int,freezer_length : Int,freezer_dimension_units : String,
 freezer_max_columns : Int,freezer_max_rows : Int,freezer_max_depth : Int,created_by : String,created_datetime : String,
 freezer_rated_temp : String,freezer_rated_temp_units : String ,freezer_label_slug : String,freezer_room_name : String, freezer_width : Int){
 self.id = id
 self.freezer_date = freezer_date
 self.freezer_label = freezer_label
 self.freezer_depth = freezer_depth
 self.freezer_length = freezer_length
 self.freezer_width = freezer_width
 self.freezer_dimension_units = freezer_dimension_units
 self.freezer_max_columns = freezer_max_columns
 self.freezer_max_rows = freezer_max_rows
 self.freezer_max_depth = freezer_max_depth
 self.created_by =  created_by
 self.created_datetime = created_datetime
 
 self.freezer_rated_temp = freezer_rated_temp
 self.freezer_rated_temp_units = freezer_rated_temp_units
 self.freezer_room_name = freezer_room_name
 
 self.freezer_label_slug = freezer_label_slug
 }
 
 var id : Int = 0
 var freezer_date : String = ""
 var freezer_label : String = ""
 var freezer_depth : Int = 0
 var freezer_length : Int = 0
 var freezer_width : Int = 0
 var freezer_dimension_units : String = ""
 var freezer_max_columns : Int = 0
 var freezer_max_rows : Int = 0
 var freezer_max_depth : Int = 0
 var created_by : String = ""
 var created_datetime : String = ""
 
 var freezer_rated_temp : String = ""
 var freezer_rated_temp_units : String = ""
 var freezer_room_name : String = ""
 
 #warning("Need to add to Codable and ignore")
 //Need to add to Codable and ignore
 var freezer_label_slug : String = ""
 
 }
 
 */
