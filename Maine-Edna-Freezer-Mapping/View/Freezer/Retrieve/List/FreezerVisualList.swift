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
    
    @Binding var selectMode : String
    
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
    
    @State var currentColor : String = "blue"
    
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
                        ForEach(/*self.searchResults*/freezerList, id: \.id) { freezer in
                            
                           //FreezerVisualView
                                //Freezer cards
                           /* RoundedRectangle(cornerRadius: 10)
                                .rotation(.degrees(45), anchor: .bottomLeading)
                                .scale(sqrt(2), anchor: .bottomLeading)
                                .frame(width: 300, height: 150 * 0.15)
                                .background(self.target_freezer.id == freezer.id ? Color.red : Color.blue)
                                .foregroundColor(self.target_freezer.id == freezer.id ? Color.red : Color.blue)
                                .clipped()*/
                            FreezerVisualView(freezerProfile: .constant(freezer),target_freezer: $target_freezer)
                                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                                .listRowBackground(Color.theme.background)
                                .onTapGesture {
                                    //set the target
                                    self.target_freezer = freezer
                                    
                                    print("Selection: \(selectMode)")
                                    if selectMode == "Remove"{
                                        //highlight this freezer
                                        print("Highlight This area")
                                        
                                        //self.currentColor = "green"
                                       // freezer.setBoxColor(newColor: "green")
                                        //freezer.boxColor = "green"
                                        
                                        
                                    }
                                    else{
                                        //self.currentColor = "blue"
                                       // freezer.setBoxColor(newColor: "blue")
                                    }
                                    
                                    
                                    
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
