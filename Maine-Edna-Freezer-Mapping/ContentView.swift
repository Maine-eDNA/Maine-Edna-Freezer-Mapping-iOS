//
//  ContentView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/22/21.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(AppStorageNames.login_status.rawValue) var logged = false
 
       //THe Mapping
        //shows in freezer detail
       // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
    @ObservedObject var todo_list_service : FreezerCheckOutLogRetrieval = FreezerCheckOutLogRetrieval()
       
        
        var body: some View {
            
            if logged{
                TabView{
               
                   /* CreatePropertyDetailsView(imageURLs: imageUrlsTest)
                        .tabItem {
                            VStack{
                                Image(systemName: "list.bullet")
                                Text("Additional Prop")
                            }
                        }.tag(0)*///should be in the properties management
                 //orientation.isPortrait && UIDevice.current.userInterfaceIdiom == .pad
                    //MyPropertiesView(searchText: "")
                    DashboardView()
                            .tabItem {
                                VStack{
                                    Image(systemName: "house")
                                    Text("Dashboard")
                                }
                        }.tag(0)
                        .badge(self.todo_list_service.stored_return_meta_data.count)
                        .navigationViewStyle(StackNavigationViewStyle())
                  
                    
                    AllFreezersView()
                            .tabItem {
                                VStack{
                                    Image(systemName: "square")
                                    Text("Freezer")
                                }
                        }.tag(1)
                        .navigationViewStyle(StackNavigationViewStyle())
                    
                    CartView()
                        .tabItem {
                            VStack{
                                Image(systemName: "cart")
                                Text("Cart")
                            }
                    }.tag(2)
                        .navigationViewStyle(StackNavigationViewStyle())
                    MenuView()
                        .tabItem {
                            VStack{
                                Image(systemName: "gear")
                                Text("Menu")
                            }
                    }.tag(2)
                        .navigationViewStyle(StackNavigationViewStyle())
                    
                }//.phoneOnlyStackNavigationView()
            }
            else{
                LoginView().navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
