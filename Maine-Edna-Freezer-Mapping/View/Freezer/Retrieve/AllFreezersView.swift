//
//  AllFreezersView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/2/21.
//

import SwiftUI
import AlertToast


//MARK: Freezer List will come from Coredata, in the background it will check to see if a new freezer exist
struct AllFreezersView: View {
    
   
    //fetch from local only sync the data from server
    @ObservedObject var freezer_profile_core_data = FreezerCoreDataManagement()
    @State var target_freezer : FreezerProfileModel
    @State var show_freezer_detail : Bool = false
    //@AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
 
    
    //conditional rendering logic
    @State var show_create_freezer : Bool = false
    @State private var animationAmount = 1.0
    
    
    @State var searchText : String = ""
    @State var freezer_count : Int = 0
    
    ///Search filter here to make the list more flexible in its applications
    @StateObject var vm : FreezerViewModel = FreezerViewModel()
    /*var searchResults: [FreezerProfileModel] {
        if !self.vm.allFreezers.isEmpty{
            if searchText.isEmpty {
                return self.vm.allFreezers
            } else {
                return self.vm.allFreezers.filter { $0.freezerLabel!.contains(searchText) }
            }
            
                
            }
        else{
            return [FreezerProfileModel]()
        }
    }*/
    
    
    var body: some View {
        NavigationView{
            
            
            FreezerVisualList(searchText: $searchText, target_freezer: $target_freezer,show_freezer_detail: $show_freezer_detail, freezerList: $vm.allFreezers)
               /* .refreshable {
                    
                    //Show Loading Animation
                    withAnimation(.spring()){
                        self.vm.show_loading_spinner = true
                        
                    }
                
                    //fetching the freezer by the freezer_id example 1
                    self.vm.reloadFreezerData()
                }*/
                .toast(isPresenting: $vm.isLoading){
                    
                    AlertToast(type: .loading, title: "Response", subTitle: "Loading..")
                    
                }
                .toast(isPresenting: $vm.showResponseMsg){
                    if self.vm.isErrorMsg{
                        return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.vm.responseMsg )")
                    }
                    else{
                        return AlertToast(type: .regular, title: "Response", subTitle: "\(self.vm.responseMsg )")
                    }
                }
            .background(
                NavigationLink(destination: FreezerDetailView(freezer_profile: target_freezer), isActive: self.$show_freezer_detail,label: {EmptyView()})
           )
            .background(
               NavigationLink(destination: CreateFreezerProfileView(show_new_screen: self.$show_create_freezer).navigationViewStyle(.stack), isActive: self.$show_create_freezer,label: {EmptyView()})
           )
            
            .navigationBarTitle(Text("Freezers"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        //open a modal or form to add new freezer
                        withAnimation {
                            self.show_create_freezer.toggle()
                        }
                        
                    }, label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("Freezer").font(.caption)
                        }.roundButtonStyle()
                    })
            )
            
            
            
        }
        
        .onAppear{
  
        }
    }
    
}

struct AllFreezersView_Previews: PreviewProvider {
    static var previews: some View {
        AllFreezersView(target_freezer: FreezerProfileModel())
    }
}

