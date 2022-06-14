//
//  CreateFreezerProfileView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/3/21.
//

import SwiftUI
import AlertToast
//MARK: WHen creating the profile size show it graphically showing it in the size of boxes (width) boxes (heigth) to get the freezer dimensions
//show it graphically as you click an additional box show an animation of the space that will be occupired
struct CreateFreezerProfileView: View {
    
    @State var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State var phoneTwoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    
    
    @State var tabletTwoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var phoneOneColumnGrid = [GridItem(.flexible())]
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Binding var show_new_screen : Bool
    
    //Form values
    
    @State var freezer_label : String = ""
    //MARK: Turn this into a dropdownlist
    @State var freezer_room_name : String = ""
    @State var freezer_length : String = ""
    @State var freezer_width : String = ""
    @State var freezer_rated_temp : String = ""
    //fetch from the server
    @State var freezer_rated_temp_units : String = ""
    
    
    
    //Freezer Rows and Columns
    @State private var freezer_max_rows = 0
    @State private var freezer_max_columns = 0
    @State private var freezer_depth = 0
    
    
    @State var freezer_row_col: [Int] = []
    
    @State var show_freezer_preview : Bool = false
    @State var show_freezer_depth_preview : Bool = false
    @FocusState var isInputActive: Bool
    
    @ObservedObject var freezer_profile_service : FreezerCreation = FreezerCreation()
    
    //Response from Server message
    @State var showResponseMsg : Bool = false
    @State var isErrorMsg : Bool = false
    @State var responseMsg : String = ""
    
    //measurement unit picker
    var measure_units = ["feet"] //get this from the server
    @State private var selected_unit_id : Int = 0
#warning("Need to fetch the following constants from the API")
    //Rated Freezer Temperature Units
    var stored_freezer_rated_temp_units = ["fahrenheit", "celsius", "kelvin"] //get this from the server
    @State private var selected_rated_temp_unit_id : Int = 0
    
#warning("Add form validation to this form")
    var body: some View {
        //suggest Names (based on what is available or a particular convention)
        
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                Group{
                    freezernameandroomsection
                    //threeColumnGrid phoneTwoColumnGrid
                    freezerdimensionsection
                    
                    freezertemperatureratingsection
                    
                }
                
                
                
                
                freezercapacitysection
                
                Spacer()
                
            }
        }.padding()
            .navigationBarTitle(Text("Create New Freezer"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        createNewFreezerProfile()
                        
                    }) {
                        HStack{
                            Text("Save").font(.title3)
                        }.font(.caption)
                            .foregroundColor(Color.primary)
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                            .background(
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.theme.accent,lineWidth: 1)
                            )
                    }
                    
                }
            }
        
            .toast(isPresenting: $showResponseMsg){
                if self.isErrorMsg{
                    return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.responseMsg )")
                }
                else{
                    return AlertToast(type: .regular, title: "Response", subTitle: "\(self.responseMsg )")
                }
            }
    }
    
    func generate_grid_amt(){
        // freezer_row_col.removeAll()
        //
        // let total_items : Int = freezer_max_rows  * freezer_max_columns
        // if total_items > 0{
        //var arr2 = Array(0...(total_items - 1))
        //var filtered = arr2.removeLast()
        //freezer_row_col = arr2
        
        //}
    }
    
}




extension CreateFreezerProfileView{
    //MARK: form sections
    
    private var freezernameandroomsection : some View{
        Section{
            TextFieldLabelCombo(textValue: self.$freezer_label, label: "Freezer Label", placeHolder: "Enter a Freezer Asset Name", iconValue: "pencil")
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            isInputActive = false
                        }
                    }
                }
            //freezer_room_name
            TextFieldLabelCombo(textValue: self.$freezer_room_name, label: "Freezer Room", placeHolder: "Enter a Freezer Room Name", iconValue: "pencil")
                .focused($isInputActive)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("Done") {
                            isInputActive = false
                        }
                    }
                }
            
        }
    }
    private var freezerdimensionsection : some View{
        LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? threeColumnGrid : phoneTwoColumnGrid) {
            TextFieldLabelCombo(textValue: self.$freezer_length, label: "Freezer Length", placeHolder: "Enter a Freezer Length", iconValue: "number",keyboardType: .decimalPad)
                .focused($isInputActive)
            
            TextFieldLabelCombo(textValue: self.$freezer_width, label: "Freezer Width", placeHolder: "Enter a Freezer Width", iconValue: "number",keyboardType: .decimalPad)
                .focused($isInputActive)
            
            //picker section start
            VStack{
                DropdownPicker(title: "Choose a unit", placeholder: "Freezer Measurement Unit", selection: self.$selected_unit_id, options: self.measure_units)
                
                
            }
            
            
            //picker section end
            
        }
    }
    
    private var freezertemperatureratingsection : some View{
        LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? threeColumnGrid : phoneTwoColumnGrid) {
            TextFieldLabelCombo(textValue: self.$freezer_rated_temp, label: "Rated Freezer Temperature", placeHolder: "Enter the Rated Freezer Temperature", iconValue: "number",keyboardType: .decimalPad)
                .focused($isInputActive)
            
            VStack{
                DropdownPicker(title: "Choose a Rated Freezer Temperature Unit:", placeholder: "Rated Freezer Temperature Units", selection: self.$selected_rated_temp_unit_id, options: self.stored_freezer_rated_temp_units)
                
                
            }
        }
    }
    
    private var freezercapacitysection : some View{
        
        Section{
            Section(header: Text("Freezer Row Column Layout").bold().font(.title3).foregroundColor(Color.theme.secondaryText)){
                //Dynamic grid based start
                //two columns for tab and one column phone
                LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? tabletTwoColumnGrid : phoneOneColumnGrid) {
                    VStack(alignment: .leading){
                        VStack{
                            Stepper("Max Freezer Rows (Boxes)", onIncrement: {
                                freezer_max_rows += 1
                                
                                
                                self.generate_grid_amt()
                                
                            }, onDecrement: {
                                freezer_max_rows -= 1
                                self.generate_grid_amt()
                                
                            })
                            
                            Text("Freezer Rows \(freezer_max_rows)")
                        }
                        
                        VStack{
                            Stepper("Max Freezer Columns (Boxes)", onIncrement: {
                                freezer_max_columns += 1
                                self.generate_grid_amt()
                                
                            }, onDecrement: {
                                freezer_max_columns -= 1
                                
                                self.generate_grid_amt()
                            })
                            
                            Text("Freezer Columns \(freezer_max_columns)")
                        }
                        
                    }
                    withAnimation(.spring()){
                        FreezerLayoutPreview(freezer_max_rows: self.$freezer_max_rows, freezer_max_columns: self.$freezer_max_columns,selected_row: .constant(0), selected_column: .constant(0), show_freezer_grid_layout: .constant(false))
                    }
                    
                }
            }
            
            //Show the preview of how the freezer layout will look
            //
            
            //Depth section -- show how it looks when you say depth of 2
            
            //Show the preview of how the freezer depth will look
            //
            LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? tabletTwoColumnGrid : phoneOneColumnGrid) {
                VStack(alignment: .leading){
                    Stepper("Max Freezer Depth (Boxes)", onIncrement: {
                        freezer_depth += 1
                        
                        
                    }, onDecrement: {
                        freezer_depth -= 1
                        
                        
                    })
                    
                    Text("Freezer Depth \(freezer_depth)")
                }
                
                
                withAnimation(.spring()){
                    FreezerDepthPreview(freezer_max_rows: self.$freezer_depth)
                }
                
                
                
                
            }
            //Depth section -- show how it looks when you say depth of 2
        }
    }
    
    //MARK: functions section
    //put this in a view model
    func createNewFreezerProfile(){
        Task{
            do{
                
                //send the freezer to the server
                var freezer_profile = FreezerProfileModel()
                
                freezer_profile.freezerRoomName = self.freezer_room_name
                freezer_profile.freezerCapacityDepth = Int(self.freezer_depth)
                
                
                freezer_profile.freezerRatedTemp = Int(self.freezer_rated_temp) ?? 0
                freezer_profile.freezerRatedTempUnits = self.stored_freezer_rated_temp_units[self.selected_rated_temp_unit_id]
                
                freezer_profile.freezerLabel = self.freezer_label
                freezer_profile.freezerDepth = String( self.freezer_depth)
                freezer_profile.freezerCapacityRows = self.freezer_max_rows
                freezer_profile.freezerCapacityColumns = self.freezer_max_columns
                // freezer_profile.freezerDepth = self.freezer_depth
                freezer_profile.freezerDimensionUnits = self.measure_units[selected_unit_id]//Need to
                if let width = Int(self.freezer_length),let freezer_deploy = Int(self.freezer_length)
                {
                    freezer_profile.freezerWidth = String(width)
                    freezer_profile.freezerLength = String(freezer_deploy)
                    
                }
                //MARK: Need to update this to utilize the await more effectively
                
                let response =  try await self.freezer_profile_service.CreateNewFreezer(_freezerDetail: freezer_profile){
                    response in
                    print("Response is: \(response.serverMessage)")
                    self.responseMsg = response.serverMessage
                    self.showResponseMsg = true
                    self.isErrorMsg = response.isError
                    //go back to the previous screen
                    if !self.isErrorMsg{
                        //  self.presentationMode.wrappedValue.dismiss()
                        
                        self.show_new_screen.toggle()
                    }
                }
                
                
            }
            catch{
                //  AlertToast(type: .error(Color.red), title: "Error: \(error.localizedDescription)")
                print("Error: \(error.localizedDescription)")
            }
            
        }
    }
    
    //additional components and functions
}



struct CreateFreezerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        //  CreateFreezerProfileView(show_new_screen: .constant(false))
        //   .previewInterfaceOrientation(.landscapeLeft)
        
        ScreenPreview(screen:  CreateFreezerProfileView(show_new_screen: .constant(false)))
    }
}

