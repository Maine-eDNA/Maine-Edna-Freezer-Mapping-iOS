//
//  ContentView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 11/22/21.
//

import SwiftUI
/*
 TODO this week
 
 Change the mode options to ve "Adding", "Returning", "Moving" to "Add", "Remove", "Move"
 Melissa Kimble to Everyone (3:13 PM)
 Change "Moving" to "Transfer Box"
 */
/*
 Scenario where you have a 100 Samples and need to add the samples to a box and have a overflow of 20 samples
 scenario to create a new freezer -> rack -> box -> adding the samples from a csv, manually or camera scanning
 Scenario to return 5 samples to the freezer (samples were once filters and have been extracted and be returned
 
 Scenario have a picklist of all the samples you want to move from a particular
 freezer to a destination freezer
 
 when barcode is pasted into the field auto add to the list (for barcode scanner and pasting)
 
 Need a screen that allows the user to take the barcodes using the barcode scanner and auto add it to the list
 
 when in add mode need to allow the user to scan example the 50 barcodes then ask the user what freezer they would like to add the samples to. It will automatically select a rack, box or boxes that can store these samples it will then highlight and suggest the boxes and spots to add each sample to (step by step mode or overview mode which shows all the positions in the map view)
 */
struct ContentView: View {
    @AppStorage(AppStorageNames.login_status.rawValue) var logged = false
    //Screenshot should be from the tablet view and should be 300 dpi resolution
       //THe Mapping
        //shows in freezer detail
       // FreezerMapView().frame(width: nil, height: nil, alignment: .center)
    @ObservedObject var todo_list_service : FreezerCheckOutLogRetrieval = FreezerCheckOutLogRetrieval()
       
    @StateObject private var vm =  DashboardViewModel()
        
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
                        .navigationViewStyle(StackNavigationViewStyle())
                        .environmentObject(vm)
                            .tabItem {
                                VStack{
                                    Image(systemName: "house")
                                    Text("Dashboard")
                                }
                        }.tag(0)
                        .badge(self.todo_list_service.stored_return_meta_data.count)
                     
                  
                    
                    AllFreezersView(vm: FreezerViewModel())
                            .tabItem {
                                VStack{
                                    Image(systemName: "note")
                                    Text("Freezer")
                                }
                        }.tag(1)
                        .navigationViewStyle(StackNavigationViewStyle())
                    
                    CartView(freezer_profile: FreezerProfileModel(), target_freezer: FreezerProfileModel())
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
