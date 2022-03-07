//
//  UserProfileView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 1/24/22.
//

import SwiftUI
import Kingfisher

struct UserProfileView: View {
    //get the images from envato elements
    
    
    @AppStorage(AppStorageNames.store_logged_in_user_profile.rawValue)  var store_logged_in_user_profile : [UserProfileModel] = [UserProfileModel]()
    
    @State var target_user_profile : UserProfileModel = UserProfileModel()
    
    //grid
    private var threeColumnGrid = [GridItem(.fixed(50)), GridItem(.fixed(50)), GridItem(.fixed(50))]
   
    
    var body: some View {
        VStack(alignment: .leading)
        {
           /* KFImage(URL(string: "shark-programmer"))
                .onSuccess { r in
                    // r: RetrieveImageResult
                    print("success: \(r)")
                }
                .onFailure { e in
                    // e: KingfisherError
                    print("failure: \(e)")
                }
                .placeholder {
                    // Placeholder while downloading.
                    
                    
                       
                }*/
            HStack(alignment: .center){
                Spacer()
                Image("shark-programmer")
                    .resizable()
                    .padding()
                    .scaledToFit()
                    .frame(width: 250,height: 250)
                    .border(.secondary, width: 1)
                Spacer()
            }
            //make it into a reuseable
            Section{
                HStack{
                    Text("\(self.target_user_profile.first_name)").font(.title3).bold()
                    Text("\(self.target_user_profile.last_name)").font(.title3).bold()
                }
                VStack(alignment: .leading){
                    Text("User Name").font(.title3)
                    Text("\(self.target_user_profile.agol_username)").font(.subheadline)
                }
                VStack(alignment: .leading){
                    Text("Phone Number").font(.title3)
                    Text("\(!self.target_user_profile.phone_number.isEmpty ? self.target_user_profile.phone_number : "N/A")").font(.subheadline)
                }
                VStack(alignment: .leading){
                    Text("Email Address").font(.title3)
                    Text("\(self.target_user_profile.email)").font(.subheadline)
                }
                VStack(alignment: .leading){
                    Text("Date Joined").font(.title3)
                    Text("\(self.target_user_profile.date_joined.convertDateFormat(withFormat: self.target_user_profile.date_joined).formatted(.dateTime))").font(.subheadline)
                }
                VStack(alignment: .leading){
                    Text("Group(s)").font(.title3)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: threeColumnGrid) {
                            // Display the item
                            ForEach(self.target_user_profile.groups){
                                group in
                                
                                RoleCapsuleView(capsule_text: .constant(group.name))
                            }
                            
                           
                        }
                    }
                }
            }
            Spacer()
            
                .navigationTitle("User Profile")
                .navigationBarTitleDisplayMode(.inline)
        }.padding()
        
        .onAppear{
            //get target_user_profile
            if let target_profile = self.store_logged_in_user_profile.first{
                self.target_user_profile = target_profile
            }
        }
        
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}


struct RoleCapsuleView : View{
    @Binding var capsule_text : String
    var body: some View{
        ZStack{
            Capsule().fill(Color.blue)//.frame(width: 90, height: 30)
                .frame(minWidth: 0, idealWidth: 90, maxWidth: 300, minHeight: 0, idealHeight: 90, maxHeight: 300)
            Text("\(capsule_text)").bold().foregroundColor(.white).padding(.all,5)
        }
    }
}
