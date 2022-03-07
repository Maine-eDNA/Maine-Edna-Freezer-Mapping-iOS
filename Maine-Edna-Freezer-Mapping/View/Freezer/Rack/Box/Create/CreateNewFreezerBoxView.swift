//
//  CreateNewFreezerBoxView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

//TODO: - When showing details of a rack show the option to add to add box to rack and show the current boxes found inside the rack (Top to bottom view =)

//TODO: - when creating new sample in the box let user be able to select from barcode dropdown list or scan bar code
//TODO: - for bulk sample adds let user be able to enter basic information and do bulk scans, which pre-populates with the info entered, so user just scans the barcodes
//TODO: - allow user to do bulk CSV import of samples in a particular format for a particular action (create blog post on this)
//TODO: - TODO list shows on the dashboard


struct CreateNewFreezerBoxView: View {
    
    @Binding var row : Int
    @Binding var column : Int
    @Binding var freezer_profile : FreezerProfileModel
    @Binding var rack_profile : RackItemModel
    
    var body: some View {
        VStack{
            Text("Create New Box View Coming Soon")
            Text("Will be in Freezer \($freezer_profile.freezerLabel.wrappedValue ?? "") Rack : \(rack_profile.freezer_rack_label) Row: \(row) Column: \(column)")
        }
    }
}

struct CreateNewFreezerBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewFreezerBoxView(row: .constant(1), column: .constant(1), freezer_profile: .constant(FreezerProfileModel()), rack_profile: .constant(RackItemModel()))
    }
}
