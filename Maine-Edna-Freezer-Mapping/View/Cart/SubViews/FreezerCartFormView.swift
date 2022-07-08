//
//  FreezerCartFormView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI
import AlertToast

///Shows the freezers available in the Cart view for Remove, Search, Transfer etc
struct FreezerCartFormView : View{
    
    @StateObject var vm : FreezerViewModel = FreezerViewModel()
    
    //MARK: show all the available Freezers based on a set of criterias
    var body: some View{
        VStack(alignment: .leading){
            //Text("Freezers Available Form")
            
            //add the Freezer List here
            //FreezerMapView().frame(width: nil, height: nil, alignment: .center)
            
            AllFreezersView(vm: vm, target_freezer: FreezerProfileModel())
        }.navigationViewStyle(.stack)
        .onAppear(){
            //fetch the freezer that example has available spaces etc
            //first get all to test it
            //
            
        }
    }
}
