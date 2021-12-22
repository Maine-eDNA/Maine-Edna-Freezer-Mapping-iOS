//
//  FreezerDetailView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/5/21.
//

import SwiftUI

struct FreezerDetailView: View {
    
    @State var show_freezer_detail : Bool = false
    var freezer_profile : FreezerProfileModel
    @ObservedObject var rack_layout_service : FreezerRackLayoutService = FreezerRackLayoutService()
    @AppStorage(AppStorageNames.stored_freezer_rack_layout.rawValue) var stored_freezer_rack_layout : [RackItemModel] = [RackItemModel]()
    //conditional renders
    @State var show_create_new_rack : Bool = false
    @State var show_view_freezer_detail: Bool = false
    
    //Need to add bulk adding by using the camera
    //Manual Scanning
    
    var body: some View {
        ZStack{
            
            VStack(alignment: .leading){
                if !show_create_new_rack{
                    FreezerMapView(stored_freezer_rack_layout: stored_freezer_rack_layout, freezer_profile: freezer_profile).transition(.move(edge: .top)).animation(.spring(), value: 0.1).zIndex(1)
                }
                else if show_create_new_rack{
                    
                    CreateNewRackView(freezer_detail: self.freezer_profile,show_create_new_rack: $show_create_new_rack).transition(.move(edge: .top)).animation(.spring(), value: 0.1).zIndex(1)
                }
               
            }
            
            
            
            
            
            ///Navigation Bar start
            .navigationBarTitle("Freezer Detail")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    //Button 2
                                Button(action: {
                //open a modal or form to add new freezer
                
                
                withAnimation(.spring()) {
                    self.show_create_new_rack.toggle()
                }
                
            }, label: {
                HStack{
                    Image(systemName: "plus")
                    Text("Rack").font(.caption)
                }
            }).sheet(isPresented: self.$show_freezer_detail){
                //Show the Create Freezer Form
                //MARK: - Show all the Freezer Detail
                /*
                 CreateFreezerProfileView(show_new_screen: self.$show_create_freezer)
                 .animation(.spring(), value: animationAmount)
                 .interactiveDismissDisabled(true)*/
            })
            .navigationBarItems(
                trailing:
                    //Button 1
                Button(action: {
                    //open a modal or form to add new freezer
                    self.show_freezer_detail.toggle()
                    
                }, label: {
                    HStack{
                        Image(systemName: "questionmark.circle")
                        Text("Freezer").font(.caption)
                    }
                }).sheet(isPresented: self.$show_freezer_detail){
                    //Show the Create Freezer Form
                    //MARK: - Show all the Freezer Detail
                    /*
                     CreateFreezerProfileView(show_new_screen: self.$show_create_freezer)
                     .animation(.spring(), value: animationAmount)
                     .interactiveDismissDisabled(true)*/
                    VStack{
                        Text("Rows \(self.freezer_profile.freezer_max_rows)")
                        Text("Columns \(self.freezer_profile.freezer_max_rows)")
                        Spacer()
                    }
                }
                
            )
            
            
            ///Navigation Bar end
            
            .onAppear{
                
                //fetching the freezer by the freezer_id example 1
                self.rack_layout_service.FetchLayoutForTargetFreezer(_freezer_id: String(self.freezer_profile.id))
            }
            
        }
    }
}

struct FreezerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerDetailView(freezer_profile: FreezerProfileModel())
    }
}
