//
//  CreateNewRackView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/5/21.
//

import SwiftUI

struct CreateNewRackView: View {
    @State var freezer_detail : FreezerProfileModel
    @State var rack_label : String = ""
    @State var selected_row : Int = 0
    @State var selected_col : Int = 0
    
    @State var rack_depth_start : Int = 0
    @State var rack_depth_end : Int = 0
    
    @State var show_freezer_grid_layout : Bool = true
    
    @ObservedObject var rack_profile_service : RackCreation = RackCreation()
    
    @State var showResponseMsg : Bool = false
    @State var isError : Bool = false
    
    @Binding var show_create_new_rack : Bool
    
    var body: some View {
   
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                Text("\(freezer_detail.freezerLabel ?? "")").font(.title3).bold()
                TextFieldLabelCombo(textValue: self.$rack_label, label: "Rack Label", placeHolder: "Enter a Rack Label", iconValue: "pencil")
                HStack{
                    Text("Preview")
                    Text("\(freezer_detail.freezerLabel ?? "")_\(self.rack_label)")
                }
                
                //Dynamic grid based start
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
                
                HStack{
                    Text("Rack Row and Column")
                    HStack{
                        Text("Row: ").font(.title3).bold()
                        Text("\(self.selected_row)").font(.subheadline)
                    }
                    HStack{
                        Text("Column: ").font(.title3).bold()
                        Text("\(self.selected_col)").font(.subheadline)
                    }
                }
                
                //MARK: - Rack Position Map - start
                ///Map of the Freezer and allow the user to select position of the rack
                ///
                Toggle("Show Map",isOn: $show_freezer_grid_layout.animation(.spring()))
                if show_freezer_grid_layout{
                Text("Select Rack Position").font(.caption)
                    FreezerLayoutPreview(freezer_max_rows: .constant($freezer_detail.freezerCapacityRows.wrappedValue ?? 0), freezer_max_columns: .constant($freezer_detail.freezerCapacityColumns.wrappedValue ?? 0),selected_row: self.$selected_row,selected_column: self.$selected_col,show_freezer_grid_layout: $show_freezer_grid_layout).frame(width: nil)
                }
                //MARK: - Rack Position Map - end
                
                
                //button  rack_profile_service
                
                HStack{
                    Spacer()
                    Button(action: {
                        //send the freezer to the server
                        var rack_profile = RackItemModel()
                      ///Added +1 because array starts at 1
                        rack_profile.freezer_rack_row_start = self.selected_row + 1
                        rack_profile.freezer_rack_row_end = self.selected_row + 1
                        rack_profile.freezer_rack_label = freezer_detail.freezerLabel ?? "" + "" + self.rack_label
                        rack_profile.freezer = self.freezer_detail.freezerLabel ?? ""
                        rack_profile.freezer_rack_column_start = self.selected_col
                        rack_profile.freezer_rack_column_end = self.selected_col
                        rack_profile.freezer_rack_depth_start = self.rack_depth_start
                        rack_profile.freezer_rack_depth_end = self.rack_depth_end
                        
                        
                        let request_data : RackItemModel = rack_profile
                        Task{
                            do{
                                let response =  try await    self.rack_profile_service.CreateNewRack(_rackDetail: request_data){
                                    response in
                                    print("Response is: \(response.serverMessage)")
                                    //self.showResponseMsg = response.serverMessage
                                    self.showResponseMsg = true
                                    self.isError = response.isError
                                    //go back to the previous screen
                                    if !self.isError{
                                       // self.presentationMode.wrappedValue.dismiss()
                                        
                                        self.show_create_new_rack.toggle()
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
                            Text("Add Rack").font(.title2).bold()
                        }.padding()
                    }.tint(Color.green)
                        .foregroundColor(.white)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.regular)
                      
                    
                    Spacer()
                }
            }
            
        }
        
        
    }
}

struct CreateNewRackView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewRackView(freezer_detail: FreezerProfileModel(), show_create_new_rack: .constant(false))
    }
}
