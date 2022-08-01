//
//  MenuView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/2/21.
//

import SwiftUI

struct MenuView: View {
    //USERS withh staff tag are the only ones allowed to create new staff, update expiration date etc
    //Need to add the overflow feature that if a rack, or box is full find the nearest box or racks that can accommodate the excess boxes
    
    //TODO need to show the todo list when clicked show the log activity
   
    @AppStorage(AppStorageNames.login_status.rawValue) var logged = true
    @AppStorage(AppStorageNames.stored_password.rawValue) var stored_password = ""
    @AppStorage(AppStorageNames.store_email_address.rawValue) var store_email_address = ""
    @AppStorage(AppStorageNames.edna_freezer_token.rawValue) var edna_freezer_token = ""
    @AppStorage(AppStorageNames.stored_freezer_rack_layout.rawValue) var stored_freezer_rack_layout = ""
    @AppStorage(AppStorageNames.stored_freezers.rawValue) var stored_freezers = ""
    @AppStorage(AppStorageNames.store_logged_in_user_profile.rawValue)  var store_logged_in_user_profile : [UserProfileModel] = [UserProfileModel]()

    @AppStorage(AppStorageNames.stored_user_name.rawValue) var stored_user_name = ""
    @AppStorage(AppStorageNames.stored_user_profile_pic_url.rawValue) var stored_user_profile_pic_url = ""

    @State var current_user : UserProfileModel = UserProfileModel()
    
    @ObservedObject var todo_list_service : FreezerCheckOutLogRetrieval = FreezerCheckOutLogRetrieval()
    
    var body: some View {
        NavigationView{
           // Spacer().frame(height: 20)
            VStack{
                VStack{
           
                AsyncImage(url: URL(string: self.stored_user_profile_pic_url)) { image in
                    image
                        .resizable()
                        .padding()
                        .scaledToFit()
                        .frame(height: 100)
                        .overlay(
                               Circle()
                                   .stroke(Color.secondary, lineWidth: 2)
                           )
                        .transition(.slide)
                } placeholder: {
                    Image(systemName: "person")
                        .resizable()
                        .padding()
                        .scaledToFit()
                        .frame(height: 100)
                        .overlay(
                               Circle()
                                   .stroke(Color.secondary, lineWidth: 2)
                           )
                        .transition(.slide)
                }
                
                    
                
                Text("Hi \(self.current_user.first_name) \(self.current_user.last_name) !").font(.title)
                
            }
            List{
                
                Section(header: Text("Other Functions")){
                    
                    NavigationLink(destination: DashboardView(), label: {
                        HStack{
                            Image(systemName: "house")
                            Text("Dashboard")
                        }  //.badge(self.todo_list_service.stored_return_meta_data.count)
                    })
                    
                 
                    
                }
                
                //UserThemeView
                Section(header: Text("Settings")){
                    
                    NavigationLink(destination: UserProfileView(), label: {
                        HStack{
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    })
                    
                    NavigationLink(destination: UserThemeView(), label: {
                        HStack{
                            Image(systemName: "eyedropper.halffull")
                            Text("Color Preference")
                        }
                    })
                    
                }
                
               /*Section(header: Text("Rental")){
                    /* Button("Create New Store"){
                     //redirect to the new store view
                     self.showAddNewStoreModal.toggle()
                     }.sheet(isPresented: $showAddNewStoreModal, onDismiss: { print("In Add New Store onDismiss.") }) { AddNewStoreView(isAddAndFavStore: true, searchText: "") }*/
                    Button(action:{
                        print("Action Happens")
                    }){
                        HStack{
                            Image(systemName: "dollarsign.square")
                            Text("Subscription Payment")
                        }
                    }
                    Button(
                        
                        action:{
                            print("Action Happens")
                        }){
                        HStack{
                            Image(systemName: "doc.plaintext")
                            Text("Receipt Customization")
                        }
                    }
                    Button(
                        
                        action:{
                            print("Action Happens")
                           // self.showSignPad.toggle()
                        }){
                        HStack{
                            Image(systemName: "signature")
                            Text("Add Signature")
                        }
                    }
                    
                    Button(action:{
                        print("Action Happens")
                    }){
                        HStack{
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Past Rental Contracts")
                        }                    }
                    //RentalContactCreateView
                    //
                    
                    Button(action:{
                        print("Show all rent contracts ")
                       // self.showAllRentalContracts.toggle()
                    }){
                        HStack{
                            Image(systemName: "list.number")
                            Text("My Rental Contract Templates")
                        }
                        
                    }
                    
                    Button(action:{
                        print("Action Happens")
                    }){
                        HStack{
                            Image(systemName: "tray.and.arrow.down")
                            Text("Maintenance Requests")
                        }
                    }
                    
                }
                Section(header: Text("Feedback")){
                    
                    Button(action:{
                        print("Action Happens")
                    }){
                        HStack{
                            Image(systemName: "plus.message")
                            Text("Suggest Features")
                        }
                    }
                }*/
                Section(header: Text("Security")){
                    Button(
                        action:{
                            print("Action Happens")
                        }){
                        HStack{
                            Image(systemName: "key")
                            Text("Change Password")
                        }
                    }
                    
                    Button(
                        action:{
                            print("Action Happens")
                        }){
                        HStack{
                            Image(systemName: "person.fill.xmark")
                            Text("Delete Account")
                        }
                    }
                    
                    Button(action:{
                        self.edna_freezer_token = ""
                        self.stored_user_name = ""
                        self.edna_freezer_token = ""
                        self.stored_password = ""
                        self.store_logged_in_user_profile.removeAll()
                        self.store_email_address = ""
                        self.stored_freezer_rack_layout = ""
                        self.stored_freezers = ""
                        self.stored_user_profile_pic_url = ""
                        
                        //redirect back to the login screen
                        //self.viewRouter.currentPage = ViewSwitcherViewNames.login.rawValue
                        withAnimation{logged = false}
                        
                        
                        
                    }){
                        HStack{
                            Image(systemName: "lock")
                            Text("Sign Out")
                        }
                    }
                    
                }
                
            }
            
            Spacer()
        }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    
        
        .onAppear{
            if self.store_logged_in_user_profile.count > 0{
                self.current_user = self.store_logged_in_user_profile[0]
            }
        }
        
    }
    
    
        
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MenuView()
                // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            //.environment(\.colorScheme, .dark)
            MenuView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            MenuView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
        
    }
}
