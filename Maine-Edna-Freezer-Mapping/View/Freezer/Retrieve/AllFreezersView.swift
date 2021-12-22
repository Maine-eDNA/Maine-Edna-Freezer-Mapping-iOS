//
//  AllFreezersView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/2/21.
//

import SwiftUI

struct AllFreezersView: View {
    
    @ObservedObject var freezer_profile_service : FreezerProfileRetrieval = FreezerProfileRetrieval()
    
    @AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers : [FreezerProfileModel] = [FreezerProfileModel]()
    @State private var searchText = ""
    var searchResults: [FreezerProfileModel] {
          if searchText.isEmpty {
              return stored_freezers
          } else {
              return stored_freezers.filter { $0.freezer_label.contains(searchText) }
          }
      }
    
    //conditional rendering logic
    @State var show_create_freezer : Bool = false
    @State private var animationAmount = 1.0
    
    
    var body: some View {
        NavigationView{
            ZStack{
                
                List{
                    // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
                    
                    ForEach(self.searchResults, id: \.id) { freezer in
                        
                        NavigationLink(destination: FreezerDetailView(freezer_profile: freezer)) {
                            //Freezer cards
                            
                            FreezerProfileCardView(freezer_profile: freezer)
                          
                        }
                    }
                    
                }
                .searchable(text: $searchText){
                    ForEach(searchResults, id: \.id) { result in
                        Text("Are you looking for \(result.freezer_label) ?").searchCompletion(result.freezer_label)
                                }
                }
                .refreshable {
                    //fetching the freezer by the freezer_id example 1
                    self.freezer_profile_service.FetchAllAvailableFreezers()
                }
                Spacer()
                
                
             
                    
                        
             
            }
            
            .navigationBarTitle(Text("Freezers"))
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
            
            //fetching the freezer by the freezer_id example 1
            self.freezer_profile_service.FetchAllAvailableFreezers()
        }
    }
    
    
}

struct AllFreezersView_Previews: PreviewProvider {
    static var previews: some View {
        AllFreezersView()
    }
}
