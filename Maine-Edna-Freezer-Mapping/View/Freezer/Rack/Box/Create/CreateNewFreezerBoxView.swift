//
//  CreateNewFreezerBoxView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/12/21.
//

import SwiftUI

//TODO: - When showing details of a rack show the option to add to add box to rack and show the current boxes found inside the rack (Top to bottom view =)

//TODO: - when creating new sample in the box let user be able to select from barcode dropdown list or scan bar code
//TODO: - for bulk sample adds let user be able to enter basic information and do bulk scans, which pre-populates with the info entered, so user just scans the barcodes
//TODO: - allow user to do bulk CSV import of samples in a particular format for a particular action (create blog post on this)
//TODO: - TODO list shows on the dashboard

//MARK: Make sure all forms work
struct CreateNewFreezerBoxView: View {
    
    @Binding var row : Int
    @Binding var column : Int
    @Binding var freezer_profile : FreezerProfileModel
    @Binding var rack_profile : RackItemModel
    
    //fields to create a box
    @State var freezer_rack_slug : String = ""
    @State var freezer_rack : String = ""
    
    @State var freezer_box_label: String = ""
    
    @State var freezer_box_depth : Int = 0
    
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                //  Text("Create New Box View Coming Soon")
                //   Text("Will be in Freezer \($freezer_profile.freezerLabel.wrappedValue ?? "") Rack : \(rack_profile.freezer_rack_label) Row: \(row) Column: \(column)")
                
                TextFieldLabelCombo(textValue: $freezer_rack, label: "Rack", placeHolder: "Found in this Rack", iconValue: "character.textbox",isDisabled: true)
                
                TextFieldLabelCombo(textValue: $freezer_box_label, label: "Box Label", placeHolder: "Place Box Label here", iconValue: "character.textbox")
                
                VStack(alignment: .leading){
                    Stepper("Box Depth: \(freezer_box_depth)", onIncrement: {
                        freezer_box_depth += 1
                        
                    }, onDecrement: {
                        freezer_box_depth -= 1
                        
                    })
                    
                    BoxDepthView(freezer_box_max_rows: self.$freezer_box_depth, background_color: .constant("blue"))
                }.padding()
                
                //Box Position Preview
                VStack(alignment: .leading){
                    Text("Box Position").bold().font(.title2).foregroundColor(.secondary)
                    boxpreviewsection
                    // .frame(width: 100, height: 100, alignment: .center)
                }
                Spacer()
            }
        }
        .navigationTitle("Box Creation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    //create new box by sending it to the api
                    
                    
                }) {
                    HStack{
                        Text("Save").font(.caption)
                    }  .font(.caption)
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
        
        
        .onAppear(){
            
            //MARK: make into a func
            //generating the box label
            //freezerName_RackName_box_row_column
            if let freezer_label = freezer_profile.freezerLabel{
                self.freezer_box_label = "\(freezer_label.lowercased())_\(rack_profile.freezer_rack_label.lowercased())_box_\(row)_\(column)"
                
            }
            
            self.freezer_rack = rack_profile.freezer_rack_label.lowercased()
            
            
        }
    }
}

struct CreateNewFreezerBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewFreezerBoxView(row: .constant(1), column: .constant(1), freezer_profile: .constant(FreezerProfileModel()), rack_profile: .constant(RackItemModel()))
    }
}


extension CreateNewFreezerBoxView{
    
    
    
    
    private var boxpreviewsection : some View{
        VStack(alignment: .leading,spacing: 0){
            GeometryReader{
                reader in
                
                VStack(spacing: 1){
                    //Rectangle().foregroundColor(.blue)
                    VStack{
                        Text("Column").font(.subheadline).foregroundColor(.secondary)
                        Text("\(column)").font(.subheadline).foregroundColor(.primary).bold()
                        
                    }
                    HStack{
                        VStack{
                            Text("Row").font(.subheadline).foregroundColor(.secondary)
                            Text("\(row)").font(.subheadline).foregroundColor(.primary).bold()
                            
                        }
                        
                        //start
                        SuggestedBoxItemCard(box_color: "blue", box_text_color: "white", freezer_box_row: 0, freezer_box_column: 0,freezer_rack: rack_profile.freezer_rack_label)
                        
                        //end
                        
                    }
                    
                }
            }.frame(width: 200,height: 200)
        }
    }
    
    
}
