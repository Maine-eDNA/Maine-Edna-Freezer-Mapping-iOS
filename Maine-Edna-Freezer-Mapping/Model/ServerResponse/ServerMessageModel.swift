//
//  ServerMessageModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/4/21.
//


import Foundation

class ServerMessageModel: Encodable,Decodable, Identifiable {
    
    init(){
        self.serverMessage = ""
        self.isLoadMsg = false
        self.isLoading = false
        self.isError = false
    }
    
    init(serverMessage : String, isError : Bool ){
        self.serverMessage = serverMessage
        self.isError = isError
    }
    
    var serverMessage : String = ""
    var isLoadMsg : Bool = false
    var isLoading : Bool = false
    var isError : Bool = false

}
