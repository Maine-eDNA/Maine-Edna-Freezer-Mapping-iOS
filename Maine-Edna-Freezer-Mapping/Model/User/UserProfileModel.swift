//
//  UserProfileModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/9/21.
//


import Foundation

class UserProfileModel: Encodable,Decodable, Identifiable {

    var id : Int = 0
    var email : String = ""
    var first_name : String = ""
    var last_name : String = ""
    var phone_number : String = ""
    var agol_username : String = ""
    var profile_image : String = ""
    var expiration_date : String = ""
    var password : String = ""
    var is_staff : Bool = false
    var is_active : Bool = false
    var date_joined : String = ""
    var groups : [UserRoleGroupModel] = [UserRoleGroupModel]()

}
