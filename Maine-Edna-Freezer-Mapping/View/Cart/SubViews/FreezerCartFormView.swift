//
//  FreezerCartFormView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI
import AlertToast

///Shows the freezers available in the Cart view for Remove, Search, Transfer etc
///In search mode show all freezers in the system
///In Add mode show only freezers that are available (space)
struct FreezerCartFormView : View{
    
   
    
    //MARK: show all the available Freezers based on a set of criterias
    @State var searchText : String = ""
    @State var freezer_count : Int = 0
    #warning("NEXT when clicked it will take target_freezer go to the freezer layout -> a box -> select the samples you want to take -> Take from freezer button creates a batch (use local temp storage first to demo it)")
    @Binding var target_freezer : FreezerProfileModel
    @State var show_freezer_detail : Bool = false
    
    ///Search filter here to make the list more flexible in its applications
    ///meaning the list can be changed to return data based on the criteria
    @StateObject var vm : FreezerViewModel = FreezerViewModel()
    var searchResults: [FreezerProfileModel] {
        if !self.vm.allFreezers.isEmpty{
            if searchText.isEmpty {
                return self.vm.allFreezers
            } else {
                return self.vm.allFreezers.filter { $0.freezerLabel.contains(searchText) }
            }
            
                
            }
        else{
            return [FreezerProfileModel]()
        }
    }
    
    @State var showSearchCriteriaModal : Bool = false
    
    //check if this can come from the api
    @State var freezer_room_options : [String] =  ["All","Hitchner 209","Murray 313", "Murray 315"]
    @State var freezer_room_option_index : Int = 0
    
    @State var freezer_temp_rating_options : [String] =  ["All","-20","-80"]
    @State var freezer_temp_rating_option_index : Int = 0
    
    @Binding var selectMode : String
    
    var body: some View{
        ZStack{
        VStack(alignment: .leading){
            //Filter feature here
            freezer_search_criteria
                .padding(.top,5)
                .padding(.horizontal)
            
            FreezerVisualList(searchText: $searchText, target_freezer: $target_freezer,show_freezer_detail: $show_freezer_detail, freezerList:  $vm.allFreezers,selectMode: $selectMode)
            
            /*.refreshable {
             
             //Show Loading Animation
             withAnimation(.spring()){
             self.vm.show_loading_spinner = true
             
             }
             
             //fetching the freezer by the freezer_id example 1
             self.vm.reloadFreezerData()
             }*/
            //toast
                .toast(isPresenting: $vm.isLoading){
                    
                    AlertToast(type: .loading, title: "Response", subTitle: "Loading..")
                    
                }
                .toast(isPresenting: $vm.showResponseMsg){
                    if self.vm.isErrorMsg{
                        return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.vm.responseMsg )")
                    }
                    else{
                        return AlertToast(type: .regular, title: "Response", subTitle: "\(self.vm.responseMsg )")
                    }
                }
            Spacer()
            
        }
        }.background(NavigationLink(destination: SearchCriteriaModalView(freezer_room_options: $freezer_room_options, freezer_room_option_index: $freezer_room_option_index,freezer_temp_rating_options: $freezer_temp_rating_options,freezer_temp_rating_option_index: $freezer_temp_rating_option_index), isActive: $showSearchCriteriaModal, label: {EmptyView()}))
          /*  .background(
                NavigationLink(destination: FreezerDetailView(freezer_profile: target_freezer), isActive: self.$show_freezer_detail,label: {EmptyView()})
           )*/
        
        .navigationViewStyle(.stack)
        .onAppear(){
            //fetch the freezer that example has available spaces etc
            //first get all to test it
            //
            
        }
    }
}

extension FreezerCartFormView{
    
    private var freezer_search_criteria : some View{
        Section{
            HStack{
                Button {
                    //open the criteria modal
                    withAnimation {
                        self.showSearchCriteriaModal.toggle()
                    }
                } label: {
                    HStack{
                        Image(systemName: "slider.horizontal.3")
                        Text("Search Criteria")
                    }.roundButtonStyle()
                }

            }
        }
    }
    
}

struct FreezerCartFormView_Previews: PreviewProvider {
    static var previews: some View {
        FreezerCartFormView(target_freezer: .constant(dev.freezerProfile), selectMode: .constant(""))
            .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
            .previewDisplayName("iPhone 13")
        
        FreezerCartFormView(target_freezer: .constant(dev.freezerProfile), selectMode: .constant(""))
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
            .previewDisplayName("iPhone 13 Pro")
        
        FreezerCartFormView(target_freezer: .constant(dev.freezerProfile), selectMode: .constant(""))
            .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
            .previewDisplayName("iPad Air (4th generation)")
        
        

    }
}


struct SearchCriteriaModalView : View{
    
    @Binding var freezer_room_options : [String]
    @Binding var freezer_room_option_index : Int
    
    @Binding var freezer_temp_rating_options : [String]
    @Binding var freezer_temp_rating_option_index : Int
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View{
        VStack(alignment: .leading,spacing: 10){
            Text("Criteria").font(.subheadline).bold().foregroundColor(.secondary)
            
            MenuPickerStyleView(label_value: .constant("Room"), placeholder_value: .constant("Select Room Name Criteria"), picker_options: $freezer_room_options, picker_selection_index: $freezer_room_option_index,width: UIScreen.main.bounds.width * 0.485)
            
            MenuPickerStyleView(label_value: .constant("Freezer Temperature Rating"), placeholder_value: .constant("Select Freezer Temperature Criteria"), picker_options: $freezer_temp_rating_options, picker_selection_index: $freezer_temp_rating_option_index,width: UIScreen.main.bounds.width * 0.485)
            
            Button {
                //send the search criteria back to the freezer cart
                #warning("Need to update the method to filter the results by the search")
                //goback
                dismiss()
                
            } label: {
                HStack{
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }.roundButtonStyle()
            }.padding()

            Spacer()
        }
        .navigationTitle("Setting Search Criteria")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct MenuPickerStyleView: View {
    
    @Binding var label_value : String
    @Binding var placeholder_value : String
    @Binding var picker_options : [String]
    @Binding var picker_selection_index : Int
    @State var height : CGFloat = 55
    @State var width : CGFloat = 100
    var body: some View {
        VStack(alignment: .leading){
            Text(label_value).font(.callout).foregroundColor(.secondary).bold()
            Picker(selection: $picker_selection_index, label:
                    
                    Text(placeholder_value)//.padding()
                   
                   ,
                   content:{
                ForEach(0 ..< picker_options.count) {
                    
                    Text("\(self.picker_options[$0])").tag($0)
                    
                    
                }
            }
                   
            ) .frame(width: width, height: height)
                .font(.headline)
                .accentColor(Color.white)
               // .padding(.horizontal)
                .background(Color.secondary)
                .cornerRadius(10)
            //.shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
               
                .pickerStyle(MenuPickerStyle())
            //Spacer()
        }
    }
}
