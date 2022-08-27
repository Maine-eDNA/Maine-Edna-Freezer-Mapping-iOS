//
//  CartDataCaptureFormView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI
import TabularData

//TODO: 
//MARK: Need the screen for taking scans from the Physical Barcode and working on the search and return function
//MARK: need to store the items that have been Search -> Taken from the freezer -> Reference Batch when Return (To match what is being returned with the exisiting record that was taken previously)
///Captures barcodes using, CSV, Manual or Barcode Scanner start
//MARK: NEXT
///Multi-Batch when is in the batch can add samples from another batch
///Select all or returns partial
///Partial Return (only 50% returned the rest is in temporary storage until it is finished) grouped by date
///
struct CartDataCaptureFormView : View{
    
    @State private var entry_selection : String = "Scan"
    @State var entry_modes = ["Scan", "CSV", "Manual"]
    
    //scanner mode
    @State private var scanner_selection : String = "Camera"
    @State var scanner_modes = ["Camera","Barcode Scanner"]
    
    ///Barcode scanner properties start
    enum FocusedField {
           case targetBarcode
       }
    @FocusState var focusedField: FocusedField?
   
    @State var show_barcode_scanner : Bool = false
    @Binding var target_barcodes : [String] 
    @State var current_barcode : String = ""//esg_e01_19w_0002"//remove after testin
    @State var show_barcode_scanner_btn : Bool = false
    @State var maximizeListSpace : Bool = false
    
    @State private var searchText = ""
    ///Barcode scanner properties end
    ///focused mode
    

       
    ///
    var body: some View{
        //MARK: Put it somewhere it doesnt affect the flow
        //ScrollView(showsIndicators: false){
        VStack(alignment: .center,spacing: 10){
            //Text("Data Capture Selector and Form")
            if !maximizeListSpace{
                withAnimation(.easeInOut){
                    VStack{
                        // Section{
                        entry_mode_section
                        
                        //MARK: if scan selected show the added option of barcode scanner and camera
                        if entry_selection == "Scan"{
                            Section{
                                withAnimation {
                                    Section{
                                        scanner_mode_section
                                       
                                        if scanner_selection == "Camera"{
                                            Section{
                                                
                                                //MARK: Still make this visible
                                                start_scanner_capture
                                            }
                                        }
                                        else  if scanner_selection == "Barcode Scanner"{
                                            Section{
                                                //Text("Space for manually scanning using a handheld")
                                                Text("Start Scanning, your barcodes will be added below")
                                                
                                                //AutoCompleteBarcodeTextField(barcodes: $target_barcodes, searchText: $searchText)
                                                  
                                                TextField("Enter your barcode", text: $searchText)
                                                    .focused($focusedField, equals: .targetBarcode)
                                            }
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
#warning("If Barcode Scanner selected then dont show the barcode scanner camera, just tell the user to plug in the barcode scanner and start scanning, when each item is scanned from the scanner show it in the list and give the option to edit individual barcodes to edit")
                                        //Add these to Notion
                                        //MARK: when the user presses done in the camera scanner should show a list and option to go back to see the entry mode area, or go backl to the list view, all entry methods add to the same barcode list so a list can be done by doing some manual some CSV and some Scanning
                                        
                                        //MARK: next for manual entry let the user start typing and auto suggest barcodes then let them press add to add it to the list to continue
                                        
                                        //MARK: add the CSV adder view to download from URL then show the preview of the data
                                        
                                        //MARK: Import from local CSV is added yet
                                        
                                    }
                                }
                            }
                            
                            //MARK: if CSV etc here
                            
                        }
                       
                        else if entry_selection == "Manual"{
                            Section{
                                
                                Text("Manual Section")
                                /*
                                 Autocomplete barcode then press add to the list of barcodes (same source
                                 */
                                manual_entry_form
                                    .frame(height: 300)
                                
                            }
                            
                        }
                        else if entry_selection == "CSV"{
                            Section{
                                Text("CSV Section")
                                
                                csvuploadersection
                            }
                            
                        }
                        
                    }
                }
            }
            //MARK: show the barcode capture mode forms or controls here
            
            
            barcodes_to_query_section
            
#warning("TODO next to allow capture barcodes")
            //MARK: In manual Mode use autocomplete text by fetching all the barcodes when i am on this page then filtering through the list like I do with Maine Road condition app to find the barcode, if none found say it was not found would you like to add it to the system (search after 4 second delay and animate to iindicate it is loading
            //https://www.google.com/search?q=autocomplete+textfield+swiftui&ie=UTF-8&oe=UTF-8&hl=en-us&client=safari
            
            
            Spacer()
            
        }
        
    
    }
}

extension CartDataCaptureFormView{
    
    //MARK: CSV
    private var csvuploadersection : some View{
        VStack{
            CsvDataDownloaderView()
        }
    }
    
    
    private var barcodes_to_query_section : some View{
        VStack(alignment: .leading){
            //Have a minimize and maximaze button to show the controls while adding barcodes or maximize to show the full list
            BarcodeListView(target_barcodes: self.$target_barcodes, maximizeListSpace: $maximizeListSpace)
            
        }
        
    }
    
    private var start_scanner_capture : some View{
        VStack(spacing: 20){
            
            
            
            BarcodeScannerBtn(show_barcode_scanner: self.$show_barcode_scanner, target_barcodes: self.$target_barcodes, current_barcode: self.$current_barcode, show_barcode_scanner_btn: self.$show_barcode_scanner_btn)
            
            //Go to another screen to show the results and be able to capture the results and send it to Freezer View
            
        }
    }
    
    
    private var title_instruction_section : some View{
        VStack(alignment: .leading){
            
            
            Text("Select the method you will use to enter the barcodes.")
                .font(.subheadline)
                .foregroundColor(Color.secondary)
            
            
        }
    }
    
    private var entry_mode_section : some View{
        
        Section{
            title_instruction_section
            
            HStack{
                MenuStyleClicker(selection: self.$entry_selection, actions: self.$entry_modes,label: "Entry Mode",label_action: self.$entry_selection, width: .constant(UIScreen.main.bounds.width * 0.90))
                
                
            }
        }
    }
    
    private var scanner_mode_section : some View{
        
        Section{
            title_instruction_section
            
            HStack{
                MenuStyleClicker(selection: self.$scanner_selection, actions: self.$scanner_modes,label: "Which Scanner are you using?",label_action: self.$scanner_selection,reverseTxtOrder: true,width: .constant(UIScreen.main.bounds.width * 0.90))
                    .onChange(of: scanner_selection) { newValue in
                        //set focused state once it changes
                        if newValue == "Barcode Scanner"{
                            focusedField = .targetBarcode
                        }
                    }
                
            }
        }
    }
    
    
    private var manual_entry_form : some View{
        
        ScrollView{
            AutoCompleteBarcodeTextField(barcodes: $target_barcodes, searchText: $searchText)
               
        }
        
    }
    
    
    
    
}


struct CartDataCaptureFormView_Previews: PreviewProvider {
    static var previews: some View {
        CartDataCaptureFormView(target_barcodes: .constant(dev.targetBarcodes))
    }
}
//MARK: Get all barcodes in the system

//MARK: Put in their own files

struct CsvDataDownloaderView : View{
    //for ducment picker
    @State private var fileContent = ""
    @State private var showDocumentPicker = false
    
    @State private var csvUrl : String = ""
    
    
    var body: some View{
        VStack{
            VStack{
                
                
                //  withAnimation {
                Text("CSV Uploader here")
                //MARK: Limitation: only via URL and pick the file from the device
                //MARK: use this link to get picker
                //MARK: https://stackoverflow.com/questions/65553282/select-file-or-directory-in-swiftui-in-an-appkit-app
                
                //test of picker
                /*
                 @State private var fileContent = ""
                 @State private var showDocumentPicker = false
                 */
                Text("Download CSV via URL")
                HStack{
                    TextFieldLabelCombo(textValue: $csvUrl, label: "CSV Url", placeHolder: "Enter URl to download CSV", iconValue: "file")
                    Button(action: {
                        //MARK: download the csv and extract the values  then add to the barcode list
                        importCsvViaUrl(url: self.csvUrl)
                        
                    }, label: {
                        HStack{
                            Text("Download")
                        }.roundButtonStyle()
                    })
                }
                
                Text("or")
                Text(fileContent ?? "No File Found").padding()
                
                Button {
                    showDocumentPicker = true
                } label: {
                    HStack{
                        Text("Import File").roundButtonStyle()
                    }
                }
                
                //   }
                
                
            }
            .sheet(isPresented: self.$showDocumentPicker) {
                DocumentPicker(fileContent: $fileContent)
            }
        }
    }
}

extension CsvDataDownloaderView{
    func importCsvViaUrl(url : String){
        
        do{
            /* let url : String = "https://firebasestorage.googleapis.com/v0/b/keijaoh-576a0.appspot.com/o/testcsv%2FSampleCSVFile_2kb.csv?alt=media&token=6243cbcf-32a8-4bf0-b176-148b8c3fe76e"*/
            let formattingOptions = FormattingOptions(maximumLineWidth: 250, maximumCellWidth: 15, maximumRowCount: 3, includesColumnTypes: false)
            let policies = try DataFrame(contentsOfCSVFile: URL(string: url)!, rows: 0..<5)
            
            print(policies.description(options: formattingOptions))
            
            #warning("Need to extract the data from the csv then display it in the list below (let it just be a list of barcodes")
            
            //Give it modes so that it can capture data from various types
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
}


struct AutoCompleteBarcodeTextField : View{
    
    @StateObject private var vm : BarcodeViewModel = BarcodeViewModel()
    @Binding var barcodes : [String]
    @Binding var searchText : String
    
    var searchResults: [BarcodeResult] {
        if searchText.isEmpty {
            return vm.barcodes
        } else {
            return vm.barcodes.filter { $0.sampleBarcodeID.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View{
        
        VStack{
            TextFieldLabelCombo(textValue: $searchText, label: "Barcode", placeHolder: "Type & Select Barcode to add to list", iconValue: "rectangle.and.text.magnifyingglass",autoCapitalization: .none)
            #warning("Need A Barcode Scanner Button beside the search field")
            List{
                ForEach(searchResults){ barcode in
                    
                    Button(action: {
                      //  location_vm.showNextLocation(location: location)
                        //MARK: Add to list
                        barcodes.append(barcode.sampleBarcodeID)
                        //then clear the search text field
                        withAnimation(.easeOut) {
                            searchText = ""
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
            
                .navigationTitle("Search for Barcode.")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

