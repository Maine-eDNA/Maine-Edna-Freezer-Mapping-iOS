//
//  GuidedSearchSampleView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 2/14/22.
//

import Foundation
import SwiftUI

struct GuidedSearchSampleView : View{
    @Binding var target_sample_query : InventoryLocationResult

    
    @ObservedObject var rack_layout_service : FreezerRackLayoutService = FreezerRackLayoutService()
    var body: some View{
        VStack{
           // Text("Guided Search Mode For Freezer: \(target_sample_query.freezerBox?.freezerRack?.freezer?.freezerLabel ?? "Freezer Name")")
            //find all the racks in this freezer and highlight which racks the samples are found

           /* if let freezer = target_sample_query.freezerBox?.freezerRack?.freezer{
                FreezerMapView(showSampleDetail: false, stored_freezer_rack_layout:.constant( self.rack_layout_service.freezer_racks), freezer_profile: freezer, show_create_new_rack: false)
                
            }*/
            /*
             FreezerMapView(stored_freezer_rack_layout: self.rack_layout_service.freezer_racks, freezer_profile: freezer_profile).transition(.move(edge: .top)).animation(.spring(), value: 0.1).zIndex(1)
             */
        }
        .onAppear{
            /*print("Guide Freezer ID: \(self.target_freezer.freezerLabel ?? "")")
            //get the freezer layout (let user know)
            self.rack_layout_service.FetchLayoutForTargetFreezer(freezer_label: self.$target_freezer.freezerLabel.wrappedValue ?? ""){
                
                response in
                
                print("Response: \(response)")
                //update the UI now that the network call is finished
            }*/
        }
    }
}
