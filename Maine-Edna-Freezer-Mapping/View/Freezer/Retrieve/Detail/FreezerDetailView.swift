//
//  FreezerDetailView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/5/21.
//

import SwiftUI
import AlertToast

class FreezerDeletionViewModel : ObservableObject{
    let freezerDeleteService = FreezerDelete()
    //properties to update the UI
    @Published var showResponseMsg : Bool = false
    @Published var isErrorMsg : Bool = false
    @Published var responseMsg : String = ""
    
    
    func deleteFreezer(_freezerId: String,completion: @escaping (ServerMessageModel) -> Void){
        #warning("should be an update method")
        freezerDeleteService.DeleteFreezer(_freezerId: _freezerId){
            response in
            
            //MARK: send the results to the UI
            print("Response is: \(response)")
            self.responseMsg = response.serverMessage
            self.showResponseMsg = true
            self.isErrorMsg = response.isError
           
            completion(response)
            
        }
    }
}


struct FreezerDetailView: View {
    
    @State var show_freezer_detail : Bool = false
    @State var freezer_profile : FreezerProfileModel
    //  @ObservedObject var rack_layout_service : FreezerRackLayoutService = FreezerRackLayoutService()
    // @AppStorage(AppStorageNames.stored_freezer_rack_layout.rawValue) var stored_freezer_rack_layout : [RackItemModel] = [RackItemModel]()
    //@State var vm : RackItemVm //= [RactItemVm]()
    
    //conditional renders
    @State var show_create_new_rack : Bool = false
    @State var show_view_freezer_detail: Bool = false
    
    //Need to add bulk adding by using the camera
    //Manual Scanning
    
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    
    //MARK: the empty rack location properties
    @State var rack_position_row : Int = 0
    @State var rack_position_column: Int = 0
    
    
    //TODO: make it a environment object
    @ObservedObject var user_css_core_data_service = UserCssThemeCoreDataManagement()
    
    @StateObject private var vm : FreezerRackViewModel = FreezerRackViewModel()
    
    
    var body: some View {
      //  ZStack{
            
         /*   VStack(alignment: .leading){
              
                if self.vm.freezer_racks.count > 0{
                    withAnimation(.spring()){
                        Section{
                            Label("Top-Down View", systemImage: "eye").font(.caption)
                            
                            //MARK: Search Mode is the default when getting the freezer detail
                            FreezerMapView(freezer_rack_layout: self.$vm.freezer_racks, freezer_profile: freezer_profile, show_create_new_rack: $show_create_new_rack, rack_position_row: $rack_position_row,rack_position_column: $rack_position_column, selectMode: .constant("Search")).transition(.move(edge: .top)).animation(.spring(), value: 0.1).zIndex(1)
                                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.95, alignment: .center)
                          
                            
                        }
                    }
                }
                else{
                    withAnimation(.spring()){
                        Section{
                            //Text(String(self.freezer_rack_layouts.count))
                            Image("not_found_06").resizable().frame(width: 400, height: 400, alignment: .center)
                        }
                    }
                }
                
           
                
            }*/
        ScrollView {
                 VStack(alignment: .leading) {
                     if self.vm.freezer_racks.count > 0 {
                         withAnimation(.spring()) {
                             Section {
                                 Label("Top-Down View", systemImage: "eye").font(.caption)
                                 
                                 FreezerMapView(
                                     freezer_rack_layout: self.$vm.freezer_racks,
                                     freezer_profile: freezer_profile,
                                     show_create_new_rack: $show_create_new_rack,
                                     rack_position_row: $rack_position_row,
                                     rack_position_column: $rack_position_column,
                                     selectMode: .constant("Search")
                                 )
                                 .transition(.move(edge: .top))
                                 .animation(.spring(), value: 0.1)
                                 .zIndex(1)
                             }
                         }
                     } else {
                         withAnimation(.spring()) {
                             Section {
                                 Image("not_found_06")
                                     .resizable()
                                     .scaledToFit()
                                     .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                             }
                         }
                     }
                 }
                 .padding()
             }
            
            
            .toast(isPresenting: $showResponseMsg){
                if self.isErrorMsg{
                    return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.responseMsg )")
                }
                else{
                    return AlertToast(type: .regular, title: "Response", subTitle: "\(self.responseMsg )")
                }
            }
            .toast(isPresenting: $vm.isLoading){
                
                AlertToast(type: .loading, title: "Response", subTitle: "Loading..")
                
            }
            
            //show_create_new_rack
            
            
            
            
            
            
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
                } .font(.caption)
                    .foregroundColor(Color.primary)
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                    .background(
                        
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.accent,lineWidth: 1)
                    )
            })
            )
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
                    } .font(.caption)
                        .foregroundColor(Color.primary)
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        .background(
                            
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.theme.accent,lineWidth: 1)
                        )
                }).customHalfSheet(showHalfSheet: self.$show_freezer_detail){
                    //Show the Create Freezer Profile
                    
                    VStack(alignment: .leading){
                        Spacer().frame(height: 30)
                        
                        FreezerProfileInfoView(freezerProfile: $freezer_profile)
                    }
                   
                    
                }
                
            )
            
            
            ///Navigation Bar end
            
            .onAppear{
                //Show Loading Animation
                
                
                //fetching the freezer by the freezer_id example 1
                self.vm.FindRackLayoutByFreezerLabel(_freezer_label: String(self.$freezer_profile.freezerLabel.wrappedValue ?? ""))
                //Convert to return error from the view model
                /*{
                 response in
                 
                 self.show_loading_spinner = false
                 
                 //give message after loading is finished
                 
                 
                 // self.isErrorMsg = response.isError
                 
                 
                 if response.count == 0{
                 self.responseMsg = "No Data have been found."
                 self.showResponseMsg = true
                 }
                 else if response.count > 0{
                 print("Response is: \(response)")
                 self.responseMsg = "Rack Layout Loaded"
                 self.showResponseMsg = true
                 print(self.freezer_profile.freezerLabel ?? "")
                 self.freezer_rack_layouts.rack_layout = response
                 
                 print("Rack Count: \(self.$freezer_rack_layouts.rack_layout.count)")
                 
                 //freezeer specs
                 
                 print("\(self.freezer_profile.freezerCapacityRows) \(self.freezer_profile.freezerCapacityColumns)")
                 }
                 /*  if(!self.isErrorMsg){
                  //Do something if no error occurred
                  
                  }*/
                 
                 }*/
            }
            
       // }
        .background(
            //MARK: Need to send the Rack Location accross
            NavigationLink(destination:   CreateNewRackView(freezer_detail: freezer_profile, show_create_new_rack:  self.$show_create_new_rack,rack_position_row: $rack_position_row,rack_position_column: $rack_position_column), isActive: self.$show_create_new_rack,label: {EmptyView()})
        )
    }
}

struct FreezerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        //dummy data
        /* var freezer_rack_layouts : RackItemVm = RackItemVm()
         
         var rack_1 = RackItemModel()
         //  rack_1.css_text_color = "white"
         //  rack_1.css_background_color = "orange"
         rack_1.freezer_rack_label = "Rk_R1_C2"
         rack_1.freezer_rack_row_start = 1
         rack_1.freezer_rack_row_end = 1
         rack_1.freezer_rack_depth_start = 1
         rack_1.freezer_rack_depth_end = 10
         rack_1.freezer_rack_column_start = 1
         rack_1.freezer_rack_column_end = 1
         
         freezer_rack_layouts.rack_layout.append(rack_1)
         
         var rack_2 = RackItemModel()
         // rack_2.css_text_color = "white"
         //rack_2.css_background_color = "orange"
         rack_2.freezer_rack_label = "Rk_R2_C2"
         rack_2.freezer_rack_row_start = 2
         rack_2.freezer_rack_row_end = 2
         rack_2.freezer_rack_depth_start = 2
         rack_2.freezer_rack_depth_end = 10
         rack_2.freezer_rack_column_start = 2
         rack_2.freezer_rack_column_end = 2
         
         freezer_rack_layouts.rack_layout.append(rack_2)
         */
        var freezer_profile = FreezerProfileModel()
        freezer_profile.freezerLabel = "Test Freezer 1"
        freezer_profile.freezerDepth = "10"
        freezer_profile.freezerLength = "110"
        freezer_profile.freezerCapacityColumns = 10
        freezer_profile.freezerCapacityRows = 10
        freezer_profile.freezerRoomName = "Murray 313"
        
        // return FreezerDetailView(freezer_profile: freezer_profile, freezer_rack_layouts: .constant(freezer_rack_layouts))
        
        return Group{
            ForEach(ColorScheme.allCases, id: \.self, content:  FreezerDetailView(freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
                .previewDisplayName("iPhone 13").preferredColorScheme)
            
            ForEach(ColorScheme.allCases, id: \.self, content:  FreezerDetailView(freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
                .previewDisplayName("iPhone 13 Pro Max").preferredColorScheme)
            ForEach(ColorScheme.allCases, id: \.self, content:  FreezerDetailView(freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)").preferredColorScheme)
            
            ForEach(ColorScheme.allCases, id: \.self, content:  FreezerDetailView(freezer_profile: freezer_profile)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)").preferredColorScheme)
            .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
