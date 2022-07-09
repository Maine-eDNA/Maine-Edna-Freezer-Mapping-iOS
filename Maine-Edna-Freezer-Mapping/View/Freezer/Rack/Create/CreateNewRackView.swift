//
//  CreateNewRackView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/5/21.
//

import SwiftUI
import AlertToast


struct CreateNewRackView: View {
    @State var freezer_label : String = ""
    @State var freezer_detail : FreezerProfileModel
    @State var rack_label : String = ""
    @State var selected_row : Int = 0
    @State var selected_col : Int = 0
    
    @State var selected_row_end : Int = 0
    @State var selected_col_end : Int = 0
    
    //By default will be a single level
    @State var rack_depth_start : Int = 1
    @State var rack_depth_end : Int = 1
    
    
    
    @State var show_freezer_grid_layout : Bool = true
    
    @StateObject var rack_vm : FreezerRackViewModel = FreezerRackViewModel()
    
    @State var showResponseMsg : Bool = false
    @State var isError : Bool = false
    
    @Binding var show_create_new_rack : Bool
    
    //MARK: the empty rack location properties
    @Binding var rack_position_row : Int
    @Binding var rack_position_column: Int
    
    @Environment(\.dismiss) var dismiss
    
    //grids
    
    @State var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var phoneOneColumnGrid = [GridItem(.flexible())]
    
    var body: some View {
        
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                // Text("NEED TO FIX:{freezer:[Object with freezer_label_slug=Test_Freezer_1 does not exist. ")
                TextFieldLabelCombo(textValue: $freezer_label, label: "Freezer", placeHolder: "Found in this Freezer", iconValue: "character.textbox",isDisabled: true)
                
                TextFieldLabelCombo(textValue: self.$rack_label, label: "Rack Label", placeHolder: "Enter a Rack Label", iconValue: "pencil")
                HStack{
                    Text("Preview")
                    Text("\(freezer_detail.freezerLabel ?? "")_\(self.rack_label)")
                }
                
                //Dynamic grid based start
                LazyVGrid(columns: twoColumnGrid,spacing: 10){
                VStack{
                    Stepper("Rack Start Depth: \(rack_depth_start)", onIncrement: {
                        rack_depth_start += 1
                        
                        
                        
                        
                    }, onDecrement: {
                        rack_depth_start -= 1
                        
                        
                    })
                    
                    
                }
                
                VStack{
                    Stepper("Rack End Depth: \(rack_depth_end)", onIncrement: {
                        rack_depth_end += 1
                        
                        
                    }, onDecrement: {
                        rack_depth_end -= 1
                        
                    })
                    
                    
                }
            }
                LazyVGrid(columns: twoColumnGrid,spacing: 10){
                //Same row
                Group{
                    VStack{
                        Stepper("Row Start: \(selected_row)", onIncrement: {
                            selected_row += 1
                            
                            //update the end by one or decrease to keep the values in line
                            selected_row_end = selected_row + 1
                            
                            
                        }, onDecrement: {
                            selected_row -= 1
                            
                            selected_row_end -= 1
                        })
                        
                        
                    }
                    
                    VStack{
                        Stepper("Row End: \(selected_row_end)", onIncrement: {
                            selected_row_end += 1
                            
                            
                        }, onDecrement: {
                            selected_row_end -= 1
                            
                        })
                        
                        
                    }
                }
                
                Group{
                    VStack{
                        Stepper("Column Start: \(selected_col)", onIncrement: {
                            selected_col += 1
                            
                            selected_col_end = selected_col + 1
                            
                            
                            
                        }, onDecrement: {
                            selected_col -= 1
                            if selected_col > 0{
                                selected_col_end = selected_col - 1
                            }
                        })
                        
                        
                    }
                    
                    VStack{
                        Stepper("Column End: \(selected_col_end)", onIncrement: {
                            selected_col_end += 1
                            
                            
                        }, onDecrement: {
                            selected_col_end -= 1
                            
                        })
                        
                        
                    }
                }
                
                
                    Section(header: Text("Row and Column Preview")){
                        LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? twoColumnGrid : phoneOneColumnGrid,spacing: 10){
                            
                            VStack{
                                HStack{
                                    Text("Row").font(.title3).bold()
                                    Text("start: ").font(.caption).foregroundColor(.secondary).bold()
                                }
                                Text("\(self.selected_row)").font(.subheadline).bold()
                            }
                            VStack{
                                
                                HStack{
                                    Text("Column").font(.title3).bold()
                                    Text("start: ").font(.caption).foregroundColor(.secondary).bold()
                                }
                                Text("\(self.selected_col)").font(.subheadline).bold()
                            }
                            
                            
                            
                            VStack{
                                HStack{
                                    Text("Row").font(.title3).bold()
                                    Text("end: ").font(.caption).foregroundColor(.secondary).bold()
                                }
                                
                                Text("\(self.selected_row)").font(.subheadline).bold()
                            }
                            VStack{
                                HStack{
                                    Text("Column").font(.title3).bold()
                                    Text("end: ").font(.caption).foregroundColor(.secondary).bold()
                                }
                                Text("\(self.selected_col)").font(.subheadline).bold()
                            }
                            
                        }
                    }
            }
                //MARK: - Rack Position Map - start
                ///Map of the Freezer and allow the user to select position of the rack
                ///
                Toggle("Show Map",isOn: $show_freezer_grid_layout.animation(.spring()))
                //MARK: Make show_freezer_grid_layout true if row and column = 0
                if show_freezer_grid_layout{
                    Text("Select Rack Position").font(.caption)
                    // ScrollView([.horizontal,.vertical], showsIndicators: false){
                    //  GeometryReader{reader in
                    VStack(alignment: .center){
                    FreezerLayoutPreview(freezer_max_rows: .constant($freezer_detail.freezerCapacityRows.wrappedValue ?? 0), freezer_max_columns: .constant($freezer_detail.freezerCapacityColumns.wrappedValue ?? 0),selected_row: self.$selected_row,selected_column: self.$selected_col,show_freezer_grid_layout: $show_freezer_grid_layout).padding()
                }
                 //   }
                   // }
                }
                //MARK: - Rack Position Map - end
                
                
                //button  rack_profile_service
                
                Spacer()
            }.padding()
            
            .navigationTitle("Create New Rack")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar{
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        //send the freezer to the server
                        createNewRackProfile()
                    }) {
                        HStack{
                            Text("Add Rack").font(.caption)//.bold()
                        }     .font(.caption)
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
        } .toast(isPresenting: $rack_vm.showResponseMsg){
            if self.rack_vm.isErrorMsg{
                return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.rack_vm.responseMsg )")
            }
            else{
                return AlertToast(type: .regular, title: "Response", subTitle: "\(self.rack_vm.responseMsg )")
            }
        }
        
            .onAppear(){
                self.freezer_label = freezer_detail.freezerLabel ?? ""
                
                //set row and column
                self.selected_row = rack_position_row
                self.selected_col = rack_position_column
                
                //set rack name, making it unique
                if let label_slug = self.freezer_detail.freezerLabelSlug{
                    self.rack_label = "\(label_slug )_rack_\(selected_row)_\(selected_col)"
                    
                }
                    //MARK: Initial Values
                selected_col_end = selected_col + 1
                
                selected_row_end = selected_row + 1
            }
        
        
    }
}

struct CreateNewRackView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewRackView(freezer_detail: FreezerProfileModel(), show_create_new_rack: .constant(false),rack_position_row: .constant(0),rack_position_column: .constant(0))
    }
}


extension CreateNewRackView{
    
    func createNewRackProfile(){
        var rack_profile = RackItemModel()
        ///Added +1 because array starts at 1
      //  if self.selected_row == 0{
      //      rack_profile.freezer_rack_row_start = self.selected_row + 1
       //     rack_profile.freezer_rack_row_end = self.selected_row + 1
       // }
       // else if self.selected_row > 0{
            rack_profile.freezer_rack_row_start = self.selected_row
            rack_profile.freezer_rack_row_end = self.selected_row_end
       // }
      
       
        rack_profile.freezer_rack_label = self.rack_label
        rack_profile.freezer = self.freezer_detail.freezerLabelSlug ?? ""
      //  if self.selected_col == 0{
      //      rack_profile.freezer_rack_column_start = self.selected_col + 1
      //      rack_profile.freezer_rack_column_end = self.selected_col + 1
      //  }
      //  else if self.selected_col > 0{
            rack_profile.freezer_rack_column_start = self.selected_col
            rack_profile.freezer_rack_column_end = self.selected_col_end
      //  }
        
        rack_profile.freezer_rack_depth_start = self.rack_depth_start
        rack_profile.freezer_rack_depth_end = self.rack_depth_end
        
        
        let request_data : RackItemModel = rack_profile
        Task{
            do{
                let response =  try await rack_vm.createNewFreezerRackProfile(_rackDetail: request_data){
                    response in
                 
                   
                    //go back to the previous screen
                    if !response.isError{

                        dismiss()
                    }
                }
                
                
            }
            catch{
                //  AlertToast(type: .error(Color.red), title: "Error: \(error.localizedDescription)")
                print("Error: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    
    
}
