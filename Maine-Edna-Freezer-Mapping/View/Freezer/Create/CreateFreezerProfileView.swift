//
//  CreateFreezerProfileView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/3/21.
//

import SwiftUI
//MARK: WHen creating the profile size show it graphically showing it in the size of boxes (width) boxes (heigth) to get the freezer dimensions
//show it graphically as you click an additional box show an animation of the space that will be occupired
struct CreateFreezerProfileView: View {
    @Binding var show_new_screen : Bool
    
    //Form values
    @State var freezer_label : String = ""
    @State var freezer_length : String = ""
    @State var freezer_width : String = ""
    
    
    
    
    //Freezer Rows and Columns
    @State private var freezer_max_rows = 0
    @State private var freezer_max_columns = 0
    @State private var freezer_depth = 0
    
    
    @State var freezer_row_col: [Int] = []
    
    @State var show_freezer_preview : Bool = false
    @State var show_freezer_depth_preview : Bool = false
    @FocusState var isInputActive: Bool
    
    @ObservedObject var freezer_profile_service : FreezerCreation = FreezerCreation()
    
    @State var showResponseMsg : Bool = false
    @State var isError : Bool = false
    
    //measurement unit picker
    var measure_units = ["feet", "inches"] //get this from the server
    @State private var selected_unit_id : Int = 0

    
    var body: some View {
        //suggest Names (based on what is available or a particular convention)
        NavigationView{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
   
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
                    
                    TextFieldLabelCombo(textValue: self.$freezer_length, label: "Freezer Length", placeHolder: "Enter a Freezer Length", iconValue: "number",keyboardType: .decimalPad)
                        .focused($isInputActive)
                    
                    TextFieldLabelCombo(textValue: self.$freezer_width, label: "Freezer Width", placeHolder: "Enter a Freezer Width", iconValue: "number",keyboardType: .decimalPad)
                        .focused($isInputActive)
                    
                    //picker section start
                    VStack{
                        DropdownPicker(title: "Choose a unit", placeholder: "Freezer Measurement Unit", selection: self.$selected_unit_id, options: self.measure_units)
                           
                    
                    }
                    
                   
                    //picker section end
                    
                    
                    //Dynamic grid based start
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
                    
                    //Show the preview of how the freezer layout will look
                    //
                    VStack{
                        Section{
                            Toggle("Show Freezer Preview", isOn: $show_freezer_preview)
                        }
                        if self.show_freezer_preview{
                            withAnimation(.spring()){
                                FreezerLayoutPreview(freezer_max_rows: self.$freezer_max_rows, freezer_max_columns: self.$freezer_max_columns,selected_row: .constant(0), selected_column: .constant(0), show_freezer_grid_layout: .constant(false))
                            }
                            
                        }
                    }
                    //Depth section -- show how it looks when you say depth of 2
                    
                    //Show the preview of how the freezer depth will look
                    //
                    VStack{
                        Stepper("Max Freezer Depth (Boxes)", onIncrement: {
                            freezer_depth += 1
                        
                            
                        }, onDecrement: {
                            freezer_depth -= 1
                            
                            
                        })
                        
                        Text("Freezer Depth \(freezer_depth)")
                        
                        Section{
                            Toggle("Show Freezer  Depth Preview", isOn: $show_freezer_depth_preview)
                        }
                        if self.show_freezer_depth_preview{
                            withAnimation(.spring()){
                                FreezerDepthPreview(freezer_max_rows: self.$freezer_depth)
                            }
                            
                        }
                    }
                    //Depth section -- show how it looks when you say depth of 2
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            //send the freezer to the server
                            let freezer_profile = FreezerProfileModel()
                          
                            freezer_profile.freezer_label = self.freezer_label
                            freezer_profile.freezer_max_depth = self.freezer_depth
                            freezer_profile.freezer_max_rows = self.freezer_max_rows
                            freezer_profile.freezer_max_columns = self.freezer_max_columns
                            freezer_profile.freezer_depth = self.freezer_depth
                            freezer_profile.freezer_dimension_units = self.measure_units[selected_unit_id]//Need to
                            if let width = Int(self.freezer_length),let freezer_deploy = Int(self.freezer_length)
                            {
                                freezer_profile.freezer_width = width
                                freezer_profile.freezer_length = freezer_deploy
                                
                            }
                            
                            Task{
                                do{
                                    let response =  try await    self.freezer_profile_service.CreateNewFreezer(_freezerDetail: freezer_profile){
                                        response in
                                        print("Response is: \(response.serverMessage)")
                                        //self.showResponseMsg = response.serverMessage
                                        self.showResponseMsg = true
                                        self.isError = response.isError
                                        //go back to the previous screen
                                        if !self.isError{
                                           // self.presentationMode.wrappedValue.dismiss()
                                            
                                            self.show_new_screen.toggle()
                                        }
                                    }
                                    
                                    
                                }
                                catch{
                                    //  AlertToast(type: .error(Color.red), title: "Error: \(error.localizedDescription)")
                                    print("Error: \(error.localizedDescription)")
                                }
                                
                            }
                            
                        }) {
                            HStack{
                                Text("Add Freezer").font(.title2).bold()
                            }.padding()
                        }.tint(Color.green)
                            .foregroundColor(.white)
                            .buttonStyle(.borderedProminent)
                            .controlSize(.regular)
                          
                        
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text("All Available Freezers"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    
                    Button {
                        self.show_new_screen.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.secondary)
                            .font(.title)
                            .padding(10)
                    }
                
            )
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

struct CreateFreezerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CreateFreezerProfileView(show_new_screen: .constant(false))
    }
}
