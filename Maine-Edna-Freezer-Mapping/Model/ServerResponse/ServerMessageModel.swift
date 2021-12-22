//
//  ServerMessageModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/4/21.
//


import Foundation

class ServerMessageModel: Encodable,Decodable, Identifiable {
    
    var serverMessage : String = ""
    var isLoadMsg : Bool = false
    var isLoading : Bool = false
    var isError : Bool = false

}
