//
//  AllFreezersView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/2/21.
//

import SwiftUI
import AlertToast
#warning("CONTINUE WORKING HERE TO MAKE IT WORK OFFLINE")

//MARK: Freezer List will come from Coredata, in the background it will check to see if a new freezer exist
struct AllFreezersView: View {
    
    @ObservedObject var freezer_profile_service : FreezerProfileRetrieval = FreezerProfileRetrieval()
    //fetch from local only sync the data from server
    @ObservedObject var freezer_profile_core_data = FreezerCoreDataManagement()
    
    
    //@AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
    @State private var searchText = ""
    var searchResults: [FreezerEntity] {
        if !self.freezer_profile_core_data.freezer_entities.isEmpty{
            if searchText.isEmpty {
                return self.freezer_profile_core_data.freezer_entities
            } else {
                return self.freezer_profile_core_data.freezer_entities.filter { $0.freezerLabel!.contains(searchText) }
            }
            
                
            }
        else{
            return [FreezerEntity]()
        }
    }
    
    //conditional rendering logic
    @State var show_create_freezer : Bool = false
    @State private var animationAmount = 1.0
    
    
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    //loading spinner
    @State var show_loading_spinner = false
    
    var body: some View {
        NavigationView{
            
            
            VStack{
                if self.searchResults.count < 1{
                    Image("empty_box").resizable().frame(width: 400, height: 400, alignment: .center)
                }
                else{
                    List{
                        // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
                        
                        ForEach(self.searchResults, id: \.id) { freezer in
                            
                            NavigationLink(destination: FreezerDetailView(freezer_profile: self.freezer_profile_core_data.translateFreezerEntityToModel(_freezerDetail: freezer), freezer_rack_layouts: RackItemVm())) {
                                //Freezer cards
                                
                                FreezerProfileCardView(freezer_profile: self.freezer_profile_core_data.translateFreezerEntityToModel(_freezerDetail: freezer))
                                
                            }
                        }
                        
                    }.listStyle(PlainListStyle())
                    .searchable(text: $searchText){
                        ForEach(searchResults, id: \.id) { result in
                            Text("Are you looking for \(result.freezerLabel ?? "") ?").searchCompletion(result.freezerLabel ?? "")
                        }
                    }
                    .refreshable {
                        
                        //Show Loading Animation
                        withAnimation(.spring()){
                            self.show_loading_spinner = true
                            
                        }
                        //fetching the freezer by the freezer_id example 1
                        self.freezer_profile_service.FetchAllAvailableFreezers(){
                            response in
                            
                            self.show_loading_spinner = false
                            
                            //give message after loading is finished
                            
                            print("Response is: \(response)")
                            self.responseMsg = response.serverMessage
                            self.showResponseMsg = true
                            self.isErrorMsg = response.isError
                            
                            if(!self.isErrorMsg){
                                //Do something if no error occurred
                                
                            }
                        }
                    }
                    Spacer()
                    
                    
                    
                    
                    
                    
                }
            }.toast(isPresenting: $show_loading_spinner){
                
                AlertToast(type: .loading, title: "Response", subTitle: "Loading..")
                
            }
            .toast(isPresenting: $showResponseMsg){
                if self.isErrorMsg{
                    return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.responseMsg )")
                }
                else{
                    return AlertToast(type: .regular, title: "Response", subTitle: "\(self.responseMsg )")
                }
            }
            
            .navigationBarTitle(Text("Freezers (\(self.freezer_profile_core_data.freezer_entities.count)"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        //open a modal or form to add new freezer
                        self.show_create_freezer.toggle()
                        
                    }, label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("Freezer").font(.caption)
                        }
                    }).sheet(isPresented: self.$show_create_freezer){
                        //Show the Create Freezer Form
                        
                        CreateFreezerProfileView(show_new_screen: self.$show_create_freezer)
                            .animation(.spring(), value: animationAmount)
                            .interactiveDismissDisabled(true)
                    }
            )
            
            
            
        }
        
        .onAppear{
            //Show Loading Animation
            withAnimation(.spring()){
                self.show_loading_spinner = true
                
            }
            
            //fetching the freezer by the freezer_id example 1
            self.freezer_profile_service.FetchAllAvailableFreezers(){
                response in
                
                self.show_loading_spinner = false
                
                //give message after loading is finished
                
                print("Response is: \(response)")
                self.responseMsg = response.serverMessage
                self.showResponseMsg = true
                self.isErrorMsg = response.isError
                
                if(!self.isErrorMsg){
                    //Do something if no error occurred
                    
                }
            }
        }
    }
    
}

struct AllFreezersView_Previews: PreviewProvider {
    static var previews: some View {
        AllFreezersView()
    }
}
