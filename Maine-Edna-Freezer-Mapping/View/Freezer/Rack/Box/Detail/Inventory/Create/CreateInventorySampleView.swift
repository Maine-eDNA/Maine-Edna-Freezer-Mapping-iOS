//
//  CreateInventorySampleView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/26/22.
//

import SwiftUI
import AlertToast

struct CreateInventorySampleView: View {
    //MARK: Pre-add the necessary data
    @Binding var target_sample_spot_detail : InventorySampleModel
    
    @StateObject var inventory_sample_vm = FreezerInventoryViewModel()
    @Environment(\.dismiss) var dismiss
    #warning("Need to finish the form implement it then work on the return work flow screens to get that working (most common task the users do)")
    ///Barcode scanner properties start
    enum FocusedField {
        case targetBarcode
    }
    @FocusState var focusedField: FocusedField?
    
    @State var show_barcode_scanner : Bool = false
    @State var target_barcodes : [String] = [String]()
   // @State var current_barcode : String = ""//esg_e01_19w_0002"//remove after testin
    @State var show_barcode_scanner_btn : Bool = false
    @State var maximizeListSpace : Bool = false
    
    @State private var sample_barcode = ""
    ///Barcode scanner properties end
    
    @Binding var freezer_box_label : String
    
    ///View Models
    @StateObject var inv_types_vm = MiscViewModel()
    @State var selected_inv_type : String = ""
    @State var selected_inv_status : String = ""
    
    var body: some View {
        // Text("Create a new inventory, in Target Box, can choose the barcode, can choose the type and status, the location is inherited from where the user clicked")
        
        ScrollView(showsIndicators: false){
            VStack(alignment: .leading){
                //Group{
                target_box_section
                freezer_inv_type_section
                
                
                freezer_inv_status_section
                
                inventory_item_position_preview
                #warning("Place the save or add button next to add sample")
                //MARK: Need to make this height dynamic so it doesnt affect controls below it
                barcode_scanner_search_section
                 
                //show location of sample preview here
            
                
        
               // }
                
                
                
                
                
                Spacer()
                
            }
            .navigationTitle("Create New Sample")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                Button {
                    //send the data to the API
                    createNewInventorySample()
                } label: {
                    HStack{
                        Image(systemName: "plus")
                        Text("Sample")
                    }.roundButtonStyle()
                }

            }
            
        }.padding()
            .toast(isPresenting: $inventory_sample_vm.showResponseMsg){
                if self.inventory_sample_vm.isErrorMsg{
                    return AlertToast(type: .error(.red), title: "Response", subTitle: "\(self.inventory_sample_vm.responseMsg )")
                }
                else{
                    return AlertToast(type: .regular, title: "Response", subTitle: "\(self.inventory_sample_vm.responseMsg )")
                }
            }
        
        .onAppear()
        {
           
            
        }
    }
}

struct CreateInventorySampleView_Previews: PreviewProvider {
    static var previews: some View {
        CreateInventorySampleView(target_sample_spot_detail: .constant(InventorySampleModel()), freezer_box_label: .constant(""))
    }
}

extension CreateInventorySampleView{
    
    
    private var freezer_inv_type_section : some View{
        Section{
            MenuStyleClicker(selection: self.$selected_inv_type, actions: self.$inv_types_vm.inventoryType.choices,label: "Freezer Inventory Type",label_action: self.$selected_inv_type,reverseTxtOrder: true, width: .constant(UIScreen.main.bounds.width * 0.90))//.frame(width: 200)
        }
    }
    
    private var freezer_inv_status_section : some View{
        Section{
            MenuStyleClicker(selection: self.$selected_inv_status, actions: self.$inv_types_vm.inventoryStatus.choices,label: "Freezer Inventory Status",label_action: self.$selected_inv_type,reverseTxtOrder: true,width: .constant(UIScreen.main.bounds.width * 0.90))//.frame(width: 200)
        }
    }
    
    //show what box we are in
    private var target_box_section : some View{
        TextFieldLabelCombo(textValue: $freezer_box_label, label: "Box Label", placeHolder: "Place Box Label here", iconValue: "character.textbox",isDisabled: true)
    }
    //barocde list
    
    private var barcode_scanner_search_section : some View{
        
        Section{
            AutoCompleteSingleBarcodeTextField(barcodes: $target_barcodes, searchText: $sample_barcode)
              
        }
        
    }
    //$target_sample_spot_detail.freezer_inventory_row
    private var inventory_item_position_preview : some View{
        VStack{
            ///+1 for the column since arrays start at 0 and -1 (if greater than 0) from row since  it is converting from a number to an array letter that starts at 0
           // Text("Column \(target_sample_spot_detail.freezer_inventory_column)")
            
            SamplePreviewPositionView(column: $target_sample_spot_detail.freezer_inventory_column, row:  .constant(convertFromNumberToAlphabet(digit: target_sample_spot_detail.freezer_inventory_row)), inven_type_abbrev: $selected_inv_type, barcode_last_three_digits: $sample_barcode)
            
        }
    }
    
}

extension CreateInventorySampleView{
    #warning("There is a logic bug where sometimes It says Row B when it should be Row A")
    #warning("It creates the record but It is not showing on the Map")
    func convertFromNumberToAlphabet(digit : Int) -> String
    {
        print("Current Value: \(digit)")
        
        return alphabet[digit].capitalized //+ "= \(digit)"

    }
    
    func createNewInventorySample(){
        print("Box \(target_sample_spot_detail.freezer_box)")
        print("Row \(target_sample_spot_detail.freezer_inventory_row) Column \(target_sample_spot_detail.freezer_inventory_column)")
        //Because the API prevents columns or rows that arent 1 or greater
        ///Example  {"freezer_inventory_row":["Ensure this value is greater than or equal to 1."]}
        
        if target_sample_spot_detail.freezer_inventory_row == 0{
            target_sample_spot_detail.freezer_inventory_row += 1
        }
        ///Add 1 to row and column to adhere with the validation
        inventory_sample_vm.createNewInvSample(_sampleDetail: InventorySampleModel(freezer_box: target_sample_spot_detail.freezer_box, freezer_inventory_column: target_sample_spot_detail.freezer_inventory_column , freezer_inventory_row: target_sample_spot_detail.freezer_inventory_row,freezer_inventory_type: self.selected_inv_type,freezer_inventory_status:  self.selected_inv_status,sample_barcode: sample_barcode,freezer_inventory_freeze_datetime: Date().ISO8601Format())) { response in
            
            if !response.isError{
                //then go back to previous screen
                dismiss()
            }
        }
    }
}




struct AutoCompleteSingleBarcodeTextField : View{
    
    @StateObject private var vm : BarcodeViewModel = BarcodeViewModel()
    @Binding var barcodes : [String]
    @Binding var searchText : String
    
    @State var showList : Bool = true
    
    var searchResults: [BarcodeResult] {
        if searchText.isEmpty {
            return vm.barcodes
        } else {
            return vm.barcodes.filter { $0.sampleBarcodeID.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View{
        
        VStack{
            HStack{
                TextFieldLabelCombo(textValue: $searchText, label: "Barcode", placeHolder: "Type & Select Barcode to add to list", iconValue: "rectangle.and.text.magnifyingglass",autoCapitalization: .none)
                    .onChange(of: searchText) { newValue in
                        if newValue.isEmpty{
                            showList = true
                        }
                    }
                
                VStack{
                    Spacer()
                    Button {
                        //show or hide list
                        withAnimation {
                            showList.toggle()
                        }
                    } label: {
                      
                        
                        HStack{
                            Image(systemName: self.showList == true ? "rectangle.arrowtriangle.2.inward":"rectangle.expand.vertical")
                            Text("List")
                        }.roundButtonStyle()
                    }
                    Spacer()
                }

            }
            if showList{
                List{
                    ForEach(searchResults){ barcode in
                        
                        Button(action: {
                            //  location_vm.showNextLocation(location: location)
                            //MARK: Add to list
                            //barcodes.append(barcode.sampleBarcodeID)
                            searchText = barcode.barcodeSlug ?? ""
                            //then clear the search text field
                            withAnimation(.easeOut) {
                                //searchText = ""
                                //hide the list
                                showList = false
                            }
                        }, label: {
                            // listRowView(location: location)
                            HStack{
                                VStack(alignment: .leading){
                                    Text(barcode.sampleBarcodeID).font(.headline)
                                    Text(barcode.siteID ?? "").font(.subheadline)
                                }.frame(maxWidth: .infinity,alignment: .leading)
                                
                            }
                            
                        }).padding(.vertical, 4)
                            .listRowBackground(Color.clear)
                        
                    }
                }.listStyle(PlainListStyle())
                    .frame(height: 300)
                /* .searchable(text: $searchText){
                 ForEach(searchResults, id: \.id) { result in
                 Text("Are you looking for \(result.sampleBarcodeID) ?").searchCompletion(result.sampleBarcodeID)
                 }
                 }*/
                    .refreshable {
                        vm.reloadBarcodeData()
                    }
                
            }
            
        }
    }
    
}
