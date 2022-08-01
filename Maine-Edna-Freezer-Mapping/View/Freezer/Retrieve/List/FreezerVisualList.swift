//
//  FreezerVisualList.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/11/22.
//

import SwiftUI

struct FreezerVisualList : View{
    
    
    //properties
    @State var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var phoneColumnGrid = [GridItem(.flexible())]
    
    @Binding var searchText : String
    
    @Binding var target_freezer : FreezerProfileModel
    
    @Binding var show_freezer_detail : Bool
    
    @Binding var freezerList : [FreezerProfileModel]
    #warning("Bug -> Someone is removing an active search controller while its search bar is visible. The UI probably looks terrible. Search controller being removed:")
    var searchResults: [FreezerProfileModel] {
        if !self.freezerList.isEmpty{
            if searchText.isEmpty {
                return self.freezerList
            } else {
                
                return self.freezerList.filter { $0.freezerLabel.contains(searchText) }
            }
            
                
            }
        else{
            return self.freezerList
        }
    }
    
    @StateObject var vm : FreezerViewModel = FreezerViewModel()
    
    var body: some View{
        
        Section{
            ZStack{
                if self.searchResults.count < 1{
                    VStack(alignment: .center){
                        Button {
                            self.refreshList()
                        } label: {
                            HStack{
                                Image(systemName: "arrow.clockwise")
                                Text("List")
                            }.roundButtonStyle()
                        }

                        Image("empty_box").resizable().frame(width: 400, height: 400, alignment: .center)
                    }
                }
                else{
                    ScrollView(showsIndicators: false){
                        // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
                        LazyVGrid(columns: (UIDevice.current.userInterfaceIdiom == .phone ? phoneColumnGrid : threeColumnGrid ),spacing: 20) {
                        ForEach(self.searchResults, id: \.id) { freezer in
                            
                           //FreezerVisualView
                                //Freezer cards
                                FreezerVisualView(freezerProfile: .constant(freezer))
                                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                                .listRowBackground(Color.theme.background)
                                .onTapGesture {
                                    //set the target
                                    self.target_freezer = freezer
                                    
                                    withAnimation {
                                        self.show_freezer_detail = true
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
             
                        self.refreshList()
                    }
                    Spacer()
                    
     
                }
            }
        }
    }
}

extension FreezerVisualList{
    
    func refreshList(){
        //Show Loading Animation
        withAnimation(.spring()){
            self.vm.show_loading_spinner = true
            
        }
    
        //fetching the freezer by the freezer_id example 1
        self.vm.reloadFreezerData()
    }
}
