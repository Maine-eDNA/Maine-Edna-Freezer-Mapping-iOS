//
//  DashboardView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/2/21.
//

import SwiftUI
import AlertToast
//add system colors
//half and half box when half full
//bulk add using Barcode and CSV
//Guided Tour
#warning("Need to monitor the amount of queries hitting the server per second on the cart view and map views")
struct DashboardView: View {
    //MARK: Clean up the screen
    
    @ObservedObject var todo_list_service : FreezerCheckOutLogRetrieval = FreezerCheckOutLogRetrieval()
    @AppStorage(AppStorageNames.store_logged_in_user_profile.rawValue)  var store_logged_in_user_profile : [UserProfileModel] = [UserProfileModel]()
    @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    @ObservedObject var user_management_service : UserProfileManagment = UserProfileManagment()
    @ObservedObject var convert_service : ClassConverter = ClassConverter()
    
    //default css
    //if user css doesnt exist create one for this user
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
    @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_user_default_css : [UserCssModel] = [UserCssModel]()
    
    
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    //loading spinner
    //@State var show_loading_spinner = false
    
    #warning("make it a environment object")
    //TODO: make it a environment object
    @ObservedObject var user_css_core_data_service = UserCssThemeCoreDataManagement()
    
    @EnvironmentObject private var vm : DashboardViewModel
    
    #warning("Format the screen to be more resuable using extensions etc")
    
    var body: some View {
        NavigationView{
            #warning("Add the detail view for this return meta data unique from SampleInvenActivLogView ")
            ZStack{
            VStack(alignment: .leading){
            /*
             
             SampleInvenActivLogView(sample_detail: .constant(InventorySampleModel()), need_target_sample: true,freezer_log_slug: meta.freezer_log))
             if self.todo_list_service.freezer_return_metas != nil{
                    Image("not_found_06").resizable().frame(width: 400, height: 400, alignment: .center)
                }
                else{*/
                    //to get it grouped i will have to have a header with the category and rows belonging to the category
                    List{
                  
                        returnMetaDataList
                        
               
                    }.listStyle(PlainListStyle())
                    .refreshable {
                        self.vm.reloadData()
                    }
              //  }
            }.toast(isPresenting: self.$vm.isLoading){
                
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
            
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear{
                
                //Show Loading Animation
                withAnimation(.spring()){
                    self.vm.isLoading = true
                    
                }
                
                //print("COunt: \(store_logged_in_user_profile[0].email)")
                
                if store_logged_in_user_profile.count < 1{
                    //update the user profile
                    self.user_management_service.FetchCurrentlyLoggedInUser()
                    
                }
                //fetch user profile
                
               // self.todo_list_service.FetchInventoryReturnMetadata(_created_by: self.store_email_address)
                /*
                 @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
                 @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_user_default_css : [UserCssModel] = [UserCssModel]()
                 */
                //fetch the default css if user css is less than one
                
                self.LoadUserCss()
                
            }
        }
        }
    }
    
    /*func convertDateFormat(inputDate: String) -> Date {

        let isoDate = inputDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: isoDate)
       
        if let target_date = date{
            print("date: \(target_date)")
            
            return target_date
            
        }
        else{
            return Date()
        }
    }*/
    
    func LoadUserCss(){
        if self.store_user_default_css.count < 1{
            //get the store_default_css then store the result in store_user_default_css
            
            Task{
                do{
                    let response =  try await
                    self.user_management_service.FetchDefaultCss(){
                        response in
                        print("Response is: \(response)")
                        let user_css_profile : UserCssModel = self.convert_service.DefaultCssToUserCss(_user_email: self.store_email_address, _default_css: response)
                        
                        //create user css
                        self.user_management_service.CreateNewUserCSS(_userCssDetail: user_css_profile){
                            user_css_response in
                            print("Response is: \(user_css_response)")
                            //once response get the user css profile
                            self.user_management_service.FetchUserCss(){
                                resp_user_css_profile in
                                
                                
                                self.store_user_default_css.append(resp_user_css_profile)
                                
                                //store in the core data database
                                self.user_css_core_data_service.createNewUserCssTheme(_userCssDetail: resp_user_css_profile)
                                
                            }
                            
                        }
                    }
                    
                }
                
                
                
                catch{
                    //  AlertToast(type: .error(Color.red), title: "Error: \(error.localizedDescription)")
                    print("Error: \(error.localizedDescription)")
                }
                
            }
            //store_user_default_css
            
        }
        else{
            //fetch the the user css model
            
            self.user_management_service.FetchUserCss(){
                resp_user_css_profile in
                
                
                self.store_user_default_css.append(resp_user_css_profile)
            }
        }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(dev.dashboardVM)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}




extension DashboardView{
    
    private var returnMetaDataList : some View{
        Section{
        ForEach(self.vm.metaDataResults){ meta in
   
            
                VStack(alignment: .leading){
                    //Text("\(meta.freezer_return_notes)").font(.title3)//.fontWeight(.medium)
                    HStack{
                        Text("Return").font(.title3).bold()
                        if let return_actions = meta.freezerReturnActions{
                        ForEach(return_actions, id: \.self){ action in
                            Text("\(action.uppercased())").padding(1)
                        }
                    }
                    }
           
                    if let created_date_time = meta.createdDatetime{
                    HStack{
                        
                        //String(convertDateFormat(inputDate: meta.created_datetime))
                        Text("date ").font(.caption)
                        Text("\(created_date_time/*.convertDateFormat(withFormat: created_date_time).formatted(.dateTime)*/)").font(.body).bold()
                        Spacer()
                    }
                    
                }
                     HStack{
                     Text("metadata entered").font(.caption)
                         Text("\(meta.freezerReturnMetadataEntered ?? "")").font(.body)
                     }

//freezer_inventory_slug
                }

        }
    }
    }
}

