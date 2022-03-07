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

struct DashboardView: View {
    //need to fetch the system colors
    
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
    @State var show_loading_spinner = false
    
    //TODO: make it a environment object
    @ObservedObject var user_css_core_data_service = UserCssThemeCoreDataManagement()
    
    
    
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                if self.todo_list_service.stored_return_meta_data.count < 1{
                    Image("not_found_06").resizable().frame(width: 400, height: 400, alignment: .center)
                }
                else{
                    //to get it grouped i will have to have a header with the category and rows belonging to the category
                    List{
                        if let todoes = self.todo_list_service.freezer_return_metas.results{
                            ForEach(todoes, id: \.id){ meta in
                      /*  ForEach(Array(self.todo_list_service.freezer_return_metas.results/*freezer_meta_grouped.keys*/), id: \.self){
                            key in*/
                            
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
                                    /* HStack{
                                     
                                     Text("by").font(.caption)
                                     Text("\(meta.created_by)").font(.body).bold()
                                     Spacer()
                                     }*/
                                    if let created_date_time = meta.createdDatetime{
                                    HStack{
                                        
                                        //String(convertDateFormat(inputDate: meta.created_datetime))
                                        Text("date ").font(.caption)
                                        Text("\(created_date_time.convertDateFormat(withFormat: created_date_time).formatted(.dateTime))").font(.body).bold()
                                        Spacer()
                                    }
                                    
                                }
                                    /* HStack{
                                     Text("metadata entered").font(.caption)
                                     Text("\(meta.freezer_return_metadata_entered)").font(.body)
                                     }*/
                                }
                          /*  Section(header: Text("metadata entered \(key)")){
                                ForEach(self.todo_list_service.freezer_meta_grouped[key] ?? [], id: \.freezer_log){
                                    meta in
                                    NavigationLink(destination: SampleInvenActivLogView(sample_detail: .constant(InventorySampleModel()), need_target_sample: true,freezer_log_slug: meta.freezer_log)){
                                        
                                        VStack(alignment: .leading){
                                            //Text("\(meta.freezer_return_notes)").font(.title3)//.fontWeight(.medium)
                                            HStack{
                                                Text("Return").font(.title3).bold()
                                                ForEach(meta.return_actions, id: \.self){ action in
                                                    Text("\(action)").padding(1)
                                                }
                                            }
                                            
                                            /* HStack{
                                             
                                             Text("by").font(.caption)
                                             Text("\(meta.created_by)").font(.body).bold()
                                             Spacer()
                                             }*/
                                            HStack{
                                                
                                                //String(convertDateFormat(inputDate: meta.created_datetime))
                                                Text("date ").font(.caption)
                                                Text("\(meta.created_datetime.convertDateFormat(withFormat: meta.created_datetime).formatted(.dateTime))").font(.body).bold()
                                                Spacer()
                                            }
                                            /* HStack{
                                             Text("metadata entered").font(.caption)
                                             Text("\(meta.freezer_return_metadata_entered)").font(.body)
                                             }*/
                                        }
                                    }
                                }
                            }*/
                        }
                        
                    }
                    }.listStyle(PlainListStyle())
                }
            }.toast(isPresenting: $show_loading_spinner){
                
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
                    self.show_loading_spinner = true
                    
                }
                
                //print("COunt: \(store_logged_in_user_profile[0].email)")
                
                if store_logged_in_user_profile.count < 1{
                    //update the user profile
                    self.user_management_service.FetchCurrentlyLoggedInUser()
                    
                }
                //fetch user profile
                
                self.todo_list_service.FetchInventoryReturnMetadata(_created_by: self.store_email_address){
                    response in
                    
                    self.show_loading_spinner = false
                    
                    //give message after loading is finished
                    
                    print("Response is: \(response)")
                    self.responseMsg = response.serverMessage
                    self.showResponseMsg = true
                    self.isErrorMsg = response.isError
                    
                    if(!self.isErrorMsg){
                        //Do something if no error occurred
                        
                    }
                    
                }
                
                /*
                 @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_default_css : [DefaultCssModel] = [DefaultCssModel]()
                 @AppStorage(AppStorageNames.store_default_css.rawValue)  var store_user_default_css : [UserCssModel] = [UserCssModel]()
                 */
                //fetch the default css if user css is less than one
                
                self.LoadUserCss()
                
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
    }
}




//date extension

extension String {

    /*func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }*/
    
    
    func convertDateFormat(withFormat inputDate: String) -> Date {

        let isoDate = inputDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: isoDate)
       
        if let target_date = date{
            print("date: \(target_date)")
            
            return target_date
            
        }
        else{
            return Date()
        }
    }
}

extension Date {

    func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
