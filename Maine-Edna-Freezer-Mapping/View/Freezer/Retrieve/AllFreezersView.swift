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
    
    @StateObject var vm : FreezerViewModel
    //fetch from local only sync the data from server
    @ObservedObject var freezer_profile_core_data = FreezerCoreDataManagement()
    @State var target_freezer : FreezerProfileModel
    @State var show_freezer_detail : Bool = false
    //@AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
    @State private var searchText = ""
    var searchResults: [FreezerProfileModel] {
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
    
    @State var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var phoneColumnGrid = [GridItem(.flexible())]
    
    var body: some View {
        NavigationView{
            
            
            ZStack{
                if self.searchResults.count < 1{
                    Image("empty_box").resizable().frame(width: 400, height: 400, alignment: .center)
                }
                else{
                    ScrollView(showsIndicators: false){
                        // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
                        LazyVGrid(columns: (UIDevice.current.userInterfaceIdiom == .phone ? phoneColumnGrid : threeColumnGrid ),spacing: 20) {
                        ForEach(self.searchResults, id: \.id) { freezer in
                            
                           //FreezerVisualView
                                //Freezer cards
                                FreezerVisualView(freezerProfile: .constant(freezer))
                                   // .frame(width: 200, height: 200)
                                /*FreezerProfileCardView(freezer_profile: freezer)    */
                                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                                .listRowBackground(Color.theme.background)
                                .onTapGesture {
                                    //set the target
                                    self.target_freezer = freezer
                                    
                                    withAnimation {
                                        self.show_freezer_detail.toggle()
                                    }
                                }
                                
                          
                        }
                        }
                    }//.listStyle(PlainListStyle())
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
                        #warning("Need to handle this using the viewmodel and displaying errors as well")
                        //fetching the freezer by the freezer_id example 1
                        self.vm.reloadFreezerData()
                    }
                    Spacer()
                    
                    
                    
                    
                    
                    
                }
            }.toast(isPresenting: $vm.isLoading){
                
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
            .background(
                NavigationLink(destination: FreezerDetailView(freezer_profile: target_freezer), isActive: self.$show_freezer_detail,label: {EmptyView()})
           )
            .background(
               NavigationLink(destination: CreateFreezerProfileView(show_new_screen: self.$show_create_freezer).navigationViewStyle(.stack), isActive: self.$show_create_freezer,label: {EmptyView()})
           )
            
            .navigationBarTitle(Text("Freezers (\(self.vm.allFreezers.count))"))
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
                        }
                    })
            )
            
            
            
        }
        
        .onAppear{
  
        }
    }
    
}

struct AllFreezersView_Previews: PreviewProvider {
    static var previews: some View {
        AllFreezersView(vm: FreezerViewModel(), target_freezer: FreezerProfileModel())
    }
}


//MARK: NEXT Refractor the freezer list so it can be called anywhere
