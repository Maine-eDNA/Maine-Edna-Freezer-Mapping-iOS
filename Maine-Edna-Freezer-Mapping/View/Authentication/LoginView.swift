//
//  LoginView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/2/21.
//

import AlertToast
import SwiftUI
import LocalAuthentication


//MARK: Customers have the option to use the app in guess mode but they need an account to buy or save favourites etc, if they dont register and they try it will take them to a screen giving them the oportunity to sign up or sign in
struct LoginView: View {
    @StateObject var LoginModel = LoginAuthenService()
    // when first time user logged in via email store this for future biometric login....
    @AppStorage(AppStorageNames.store_email_address.rawValue) var store_email_address = ""
    @AppStorage(AppStorageNames.stored_password.rawValue) var stored_password = ""
    
    @AppStorage(AppStorageNames.stored_user_id.rawValue)  var stored_user_id : Int = 0
    
    @AppStorage(AppStorageNames.login_status.rawValue) var logged = false

    
    @State var startAnimate = false
    @State var showRegistration = false
    @State var showForgotPassword = false
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    
    //additional options
    @State var isShowingHomeWithoutLogin : Bool = false
    
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .center)
            {
                //NavigationLink(destination: HomeMainView(), isActive: $isShowingHomeWithoutLogin) { EmptyView() }
                
                
                VStack(alignment: .center, spacing: 12, content: {
                    
                    Text("Welcome to Maine eDNA")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    Text("Freezer Mapping App")
                        .foregroundColor(Color.secondary)
                })
                
                
                //}
                    .padding()
                    .padding(.leading,15)
                Spacer().frame(height: 60)
            
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                //.clipShape(Circle())
                //.overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .shadow(radius: 10)
                    .padding(.bottom, 50)
                
                //ScrollView(showsIndicators: false){
                
                // HStack{
                
                
                VStack(alignment: .leading){
                    TextFieldLabelNoAuto(textValue: $LoginModel.email, label: "Email Address", placeHolder: "Enter Email Address..", iconValue: "envelope")
                    SecuredTextFieldLabelCombo(textValue: $LoginModel.password, label: "Password", placeHolder: "Enter Password..", iconValue: "lock")
                    
                    
                    HStack(spacing: 15){
                        Spacer()
                        Button(action:{ //LoginModel.loginAdminUserAccount()
                            
                            Task{
                                do{
                                    let response =  try await
                                    LoginModel.loginUserAccount(){
                                        response in
                                        print("Response is: \(response)")
                                        self.responseMsg = response.serverMessage
                                        self.showResponseMsg = true
                                        self.isErrorMsg = response.isError
                                        //go back to the previous screen
                                        // self.presentationMode.wrappedValue.dismiss()
                                        
                                    }
                                    
                                }
                                
                                
                                
                                catch{
                                    //  AlertToast(type: .error(Color.red), title: "Error: \(error.localizedDescription)")
                                    print("Error: \(error.localizedDescription)")
                                }
                                
                            }
                        }
                               , label: {
                            Text("Login")
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 150)
                                .background(Color.green)
                            //.clipShape(Capsule())
                                .cornerRadius(10)
                        })
                            .opacity(LoginModel.email != "" && LoginModel.password != "" ? 1 : 0.5)
                            .disabled(LoginModel.email != "" && LoginModel.password != "" ? false : true)
                            .alert(isPresented: $LoginModel.alert, content: {
                                Alert(title: Text("Error").foregroundColor(.secondary), message: Text(LoginModel.alertMsg), dismissButton: .destructive(Text("Ok").foregroundColor(.secondary)))
                            })
                        
                        if LoginModel.getBioMetricStatus(){
                            
                            Button(action: LoginModel.authenticateUser, label: {
                                
                                // getting biometrictype...
                                Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color(UIColor.systemBackground))
                                    .clipShape(Circle())
                            })
                        }
                        Spacer()
                    }
                    .padding(.top)
                    // Forget Button...
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            //ForgotPasswordView
                            self.showForgotPassword.toggle()
                            
                        }, label: {
                            Text("Forgot password?")
                                .foregroundColor(.green)
                        })
                            .padding(.top,8)
                            .sheet(isPresented: $showForgotPassword) {
                                //ForgotPasswordView()
                                //MARK: Registration Screen
                            }
                        
                            .alert(isPresented: $LoginModel.store_Info, content: {
                                Alert(title: Text("Message"), message: Text("Store Information For Future Login Using BioMetric Authentication ???").foregroundColor(.secondary), primaryButton: .default(Text("Accept").foregroundColor(.secondary), action: {
                                    
                                    // storing Info For BioMetric...
                                    self.store_email_address = LoginModel.email
                                    self.stored_password = LoginModel.password
                                    
                                    withAnimation{self.logged = true}
                                    
                                }), secondaryButton: .cancel({
                                    // redirecting to Home
                                    withAnimation{self.logged = true}
                                }))
                            })
                        Spacer()
                    }
                    // SignUp...
                    
                    
          
                    
                }
                
                .navigationTitle("Login")
                .foregroundColor(.secondary)
                
            }.toast(isPresenting: $showResponseMsg){
                if self.isErrorMsg{
                    return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.responseMsg )")
                }
                else{
                    return AlertToast(type: .regular, title: "Response", subTitle: "\(self.responseMsg )")
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
            // .preferredColorScheme(.dark)
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            
            //.environment(\.colorScheme, .dark)
            LoginView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            LoginView()
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
        }
    }
}
