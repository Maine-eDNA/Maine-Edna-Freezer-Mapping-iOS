//
//  FreezerInventoryReturnMetaDataModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//

import Foundation
import SwiftUI


//MARK: Model for fetching different from adding to the server



// MARK: - FreezerInventoryReturnMetaDataModel
struct FreezerInventoryReturnMetaDataModel: Codable {
    var links: Links?
    var count: Int?
    var results: [FreezerInventoryReturnMetaDataResults]?
}


// MARK: - Links
struct Links: Codable {
    var next, previous: JSONNull?
}


// MARK: - Result
struct FreezerInventoryReturnMetaDataResults: Identifiable, Codable {
    var id = UUID()
    
    
    var freezerReturnSlug, freezerReturnMetadataEntered: String?
    var freezerReturnActions: [String]?
    var freezerReturnVolTaken: String?
    var freezerReturnVolUnits, freezerReturnNotes: String?
    var freezerLog: String?//FreezerLog?
    var createdBy, createdDatetime, modifiedDatetime: String?
    
    static func == (lhs: FreezerInventoryReturnMetaDataResults, rhs: FreezerInventoryReturnMetaDataResults) -> Bool {
        lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case freezerReturnSlug = "freezer_return_slug"
        case freezerReturnMetadataEntered = "freezer_return_metadata_entered"
        case freezerReturnActions = "freezer_return_actions"
        case freezerReturnVolTaken = "freezer_return_vol_taken"
        case freezerReturnVolUnits = "freezer_return_vol_units"
        case freezerReturnNotes = "freezer_return_notes"
        case freezerLog = "freezer_log"
        case createdBy = "created_by"
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
    }
}


// MARK: - FreezerLog
struct FreezerLog: Codable {
    var id = UUID()
    var freezerLogAction, freezerLogNotes, freezerLogSlug: String?
    var freezerInventory: FreezerInventory?

    enum CodingKeys: String, CodingKey {
        //case id
        case freezerLogAction = "freezer_log_action"
        case freezerLogNotes = "freezer_log_notes"
        case freezerLogSlug = "freezer_log_slug"
        case freezerInventory = "freezer_inventory"
    }
}


// MARK: - FreezerInventory
struct FreezerInventory: Codable {
    
    var id: Int?
    var freezerBox, sampleBarcode, freezerInventorySlug, freezerInventoryType: String?
    var freezerInventoryStatus: String?
    var freezerInventoryColumn, freezerInventoryRow: Int?
    var createdBy, createdDatetime, modifiedDatetime: String?

    enum CodingKeys: String, CodingKey {
        case id
        case freezerBox = "freezer_box"
        case sampleBarcode = "sample_barcode"
        case freezerInventorySlug = "freezer_inventory_slug"
        case freezerInventoryType = "freezer_inventory_type"
        case freezerInventoryStatus = "freezer_inventory_status"
        case freezerInventoryColumn = "freezer_inventory_column"
        case freezerInventoryRow = "freezer_inventory_row"
        case createdBy = "created_by"
        case createdDatetime = "created_datetime"
        case modifiedDatetime = "modified_datetime"
    }
}

// MARK: - FreezerInventory
struct FreezerInventoryPutModel: Codable {
    
    var id: Int?
    var freezerBox, sampleBarcode/*, freezerInventorySlug*/, freezerInventoryType: String?
    var freezerInventoryStatus: String?
    var freezerInventoryColumn, freezerInventoryRow: Int?
   /* var createdBy, createdDatetime, modifiedDatetime: String?*/

    enum CodingKeys: String, CodingKey {
        case id
        case freezerBox = "freezer_box"
        case sampleBarcode = "sample_barcode"
        //case freezerInventorySlug = "freezer_inventory_slug"
        case freezerInventoryType = "freezer_inventory_type"
        case freezerInventoryStatus = "freezer_inventory_status"
        case freezerInventoryColumn = "freezer_inventory_column"
        case freezerInventoryRow = "freezer_inventory_row"
        //case createdBy = "created_by"
        //case createdDatetime = "created_datetime"
        //case modifiedDatetime = "modified_datetime"
    }
}

// JSONSchemaSupport.swift


// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
