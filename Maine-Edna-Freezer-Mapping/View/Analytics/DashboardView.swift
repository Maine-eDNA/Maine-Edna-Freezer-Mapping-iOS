//
//  DashboardView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/2/21.
//

import SwiftUI

struct DashboardView: View {
    //need to fetch the system colors
    
    @ObservedObject var todo_list_service : FreezerCheckOutLogRetrieval = FreezerCheckOutLogRetrieval()
    @AppStorage(AppStorageNames.store_logged_in_user_profile.rawValue)  var store_logged_in_user_profile : [UserProfileModel] = [UserProfileModel]()
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    @ObservedObject var user_management_service : UserProfileManagment = UserProfileManagment()
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                List{
                    ForEach(self.todo_list_service.stored_return_meta_data, id: \.freezer_log){
                        meta in
                        NavigationLink(destination: SampleInvenActivLogView(sample_detail: .constant(InventorySampleModel()), need_target_sample: true,freezer_log_slug: meta.freezer_log)){
                            
                            VStack(alignment: .leading){
                                Text("\(meta.freezer_return_notes)").font(.title3).fontWeight(.medium)
                                HStack{
                                    Text("Action").font(.title3).bold()
                                    ForEach(meta.return_actions, id: \.self){ action in
                                        Text("\(action)").padding(1)
                                    }
                                }
                                
                                HStack{
                                 
                                    Text("by").font(.caption)
                                    Text("\(meta.created_by)").font(.body).bold()
                                    Spacer()
                                }
                            }
                            
                        }
                    }
                    
                }
            }
            
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear{
                
                //print("COunt: \(store_logged_in_user_profile[0].email)")
                
                if store_logged_in_user_profile.count < 1{
                    //update the user profile
                    self.user_management_service.FetchCurrentlyLoggedInUser()
                    
                }
                //fetch user profile
                
                self.todo_list_service.FetchInventoryReturnMetadata(_created_by: self.store_email_address)
            }
        }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
