//
//  ExtractionSampleReturnGuideView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/27/22.
//

import SwiftUI

//MARK: add it its own file start
class BarcodeToExtractionModel : ObservableObject{
    
    init(){
        self.existing_barcode = ""
        self.new_extraction_barcode = ""
        self.freezer_inventory_status = ""
        self.freezer_inventory_column = 0
        self.freezer_inventory_row = 0
    }
    
    init(existing_barcode : String,new_extraction_barcode : String,freezer_inventory_status : String,freezer_inventory_column : Int,freezer_inventory_row : Int    ){
        
        self.existing_barcode = existing_barcode
        self.new_extraction_barcode = new_extraction_barcode
        self.freezer_inventory_status = freezer_inventory_status
        self.freezer_inventory_column = freezer_inventory_column
        self.freezer_inventory_row = freezer_inventory_row
    }
    var id = UUID()
    var existing_barcode : String = ""
    var new_extraction_barcode : String = ""
    
    var freezer_inventory_status : String = ""
    var freezer_inventory_column : Int = 0
    var freezer_inventory_row : Int = 0
    
}


struct BarcodeToExtractionDetail : View{
    @Binding var new_barcodes_to_process : [BarcodeToExtractionModel]
    
    var body: some View{
        VStack(alignment: .leading){
            barcode_list_section
        }
        
    }
}

extension BarcodeToExtractionDetail{
    
    private var barcode_list_section : some View{
        Section{
            List{
                ForEach(new_barcodes_to_process, id: \.id){ sample in
                    
                    HStack{
                        Text("\(sample.existing_barcode)")
                        
                        Text("\(sample.new_extraction_barcode)")
                        
                        VStack(alignment: .leading){
                            Text("Row")
                            Text("\(sample.freezer_inventory_row)")
                            
                            Text("Column")
                            Text("\(sample.freezer_inventory_column)")
                        }
                        
                    }
                    
                }
            }.listStyle(.plain)
        }
    }
    
}


//MARK: add it its own file end

struct ExtractionSampleReturnGuideView: View {
    @State var selection_mode : String = "Extraction_Return"
    //Change this to a list after the design is done
    @State var current_old_target_barcode : String = "esg_000_210"
    @State var current_replacement_barcode : String = ""
    
    //barcode scanner section
    @State var show_barcode_scanner : Bool = false
    @State var target_barcodes : [String] = [String]()
    @State var current_barcode : String = ""//esg_e01_19w_0002"//remove after testin
    @State var show_barcode_scanner_btn : Bool = false
    @State var maximizeListSpace : Bool = false
    
    @State var current_progress_in_list : Int = 1
    @State var barcode_count : Int = 51
    
    //MARK: need to track what was not returned so it can be returned in the future
    @State var barcodes_skipped : [String] = [String]()
    
    @Binding var targetSamplesToProcess : Set<InventorySampleModel>
    
    
    ///Step indicator start
    @State private var changePosition : Bool = true
    @State var current_position_in_form : String = ""
    @State var next_position_in_form : String = ""
    @State var current_form_index : Int = 0
    @State var next_form_index : Int = 1
    
    //have steps for return
    ///current position in the form properties start
    @State var currentIndex : Int = 0
    ///current position in the form properties end
    ///
    //MARK: Dont show the steps
    @State var general_steps = [ Text("Mode").font(.caption),
                                 Text("Entry").font(.caption),
                                 Text("Freezer").font(.caption),
                                 Text("Rack").font(.caption),
                                 Text("Box").font(.caption)
                                 
                                 
    ]
    
    //To track the old and new barcodes
    @State var new_barcodes_to_process : [BarcodeToExtractionModel] = [BarcodeToExtractionModel]()
    @State var showExtractionListDetail : Bool = false //show the old bar code, the new one and the location
    
    var body: some View {
        //Text("This is the screen that will show all the samples being returned one by one like a quiz survey to guide them step by step")
        ZStack{
            VStack(alignment: .leading, spacing: 10)
            {
#warning("Continue here by adding the list to this and make it go into a loop to keep running till the last barcode is returned or skipped")
                //form_layout_section
                
                //form_loop_section
                form_steps_extract
                
                Spacer()
            }.padding()
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            //show the barcodes
                            withAnimation {
                                self.showExtractionListDetail.toggle()
                            }
                        } label: {
                            HStack{
                                Image(systemName: "eye")
                                Text("List")
                            }.roundButtonStyle()
                        }
                        
                    }
                }
            
        }.background(
            NavigationLink(destination: BarcodeToExtractionDetail(new_barcodes_to_process: $new_barcodes_to_process), isActive: $showExtractionListDetail, label: {EmptyView()})
        )
        
    }
    
    
}

extension ExtractionSampleReturnGuideView{
#warning("Need to put in a tab view to press next or skip to go in the list")
    
    
    private var form_steps_extract : some View{
        Section{
            VStack {
                if self.targetSamplesToProcess.count > 0{
                    TabView(selection: $currentIndex) {
                        ForEach(Array(self.targetSamplesToProcess.enumerated()), id: \.offset){ index,sample in
                            
                            
                            ExtractFormStep(target_barcodes: $target_barcodes, current_barcode: captureCurrentBarcode(barcode: sample.sample_barcode), selection_mode: $selection_mode, current_progress_in_list: $current_progress_in_list, barcode_count: $barcode_count, targetSamplesToProcess: $targetSamplesToProcess, current_old_target_barcode: .constant(sample.sample_barcode), current_replacement_barcode: $current_replacement_barcode)
                                .tag(index)
                        }
                        
                    }.tabViewStyle(PageTabViewStyle())
                    // . indexViewStyle(PageIndexViewStyle(backgroundDisplayMode:.always))
                    //. frame (maxHeight: geometry.size.height * 0.8, alignment:. center)
                        .animation(.easeInOut(duration: 0.2),value: changePosition)
                    
                    
                    form_switcher_fwd_back_buttons
                        .padding(.bottom,10)
                    
                }
            }
        }
        
    }
    
    //MARK: sets a global variable used to track where we are in the loop and return the current barcode
    func captureCurrentBarcode(barcode : String) -> Binding<String>
    {
        #warning("Check the logic ")
        //set the current barcode
        self.current_barcode = barcode
        
        return .constant(barcode)
    }
    
    private var form_switcher_fwd_back_buttons : some View{
        VStack {
            // .. //
            HStack(alignment: .center, spacing: 8) {
                if currentIndex > 0 {
                    Button(action: {
                        //animate transition
                        changePosition.toggle()
                        currentIndex -= 1
                    }) {
                        HStack(alignment: .center, spacing: 10) {
                            Image(systemName: "arrow.backward")
                                .accentColor(.white)
                            Text("Back")
                                .foregroundColor(Color.primary)
                            
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        maxHeight: 44
                    )
                    .background(Color.secondary)
                    .cornerRadius(4)
                    .padding(
                        [.leading, .trailing], 20
                    )
                }
                Button(action: {
                    //animate transition
                    changePosition.toggle()
                    
                    //(general_steps.count - 1) meants at the end of the steps
                    //- 1 because the steps start from 0 while the steps count start from 1
#warning("Next")
                    //MARK: On Next add the value thats inside the textfield and associate it with the current barcode then clear the textfield and move to the next barcode
                    //MARK: be able to view the list so far anytime
                    self.new_barcodes_to_process.append(BarcodeToExtractionModel(existing_barcode: current_barcode, new_extraction_barcode: current_replacement_barcode, freezer_inventory_status: targetSamplesToProcess.first(where: {$0.sample_barcode == current_barcode})?.freezer_inventory_status ?? "N/A", freezer_inventory_column: targetSamplesToProcess.first(where: {$0.sample_barcode == current_barcode})?.freezer_inventory_column ?? 0, freezer_inventory_row: targetSamplesToProcess.first(where: {$0.sample_barcode == current_barcode})?.freezer_inventory_row ?? 0))
                    
                    //MARK: clear current_replacement_barcode and other variables
                    withAnimation {
                        self.current_replacement_barcode = ""
                        
                    }
                    
                    
                    if currentIndex != (general_steps.count - 1) {
                        currentIndex += 1
                    }
                    
                    
                    
                    
                }) {
                    HStack(alignment: .center, spacing: 10) {
                        //if equal the last section
                        //MARK: change to be the number of count of steps to know when at the end
                        
                        
                        
                        Section{
                            Text(currentIndex == (general_steps.count - 1) ? "Done" : "Next")
                                .foregroundColor(.white)
                            Image(systemName: currentIndex == (general_steps.count - 1) ? "checkmark" : "arrow.right")
                                .accentColor(.white)
                        }
                        
                        
                    }
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    maxHeight: 44
                )
                .background(Color.secondary)
                .cornerRadius(4)
                .padding(
                    [.leading, .trailing], 20
                )
            }
            // Spacer()
        }
    }
    
    
    
    private var form_loop_section : some View{
        List{
            ForEach(Array(self.targetSamplesToProcess), id: \.sample_barcode){ sample in
                
                //Text("Item: \(sample.sample_barcode)")
                //MARK: Need to update place in list etc
                ExtractFormStep(target_barcodes: $target_barcodes, current_barcode: $current_barcode, selection_mode: $selection_mode, current_progress_in_list: $current_progress_in_list, barcode_count: $barcode_count, targetSamplesToProcess: $targetSamplesToProcess, current_old_target_barcode: $current_old_target_barcode, current_replacement_barcode: $current_replacement_barcode)
                
            }
        }
    }
    
}

extension ExtractionSampleReturnGuideView{
    
    // Set up a method to generate a fraction string from two integers
    func fractionToString(_ dividend: Int, _ divisor: Int) -> String {
        let dividendString = dividend.superscriptString
        let separatorString = "\u{2044}"
        let divisorString = divisor.subscriptString
        
        let fractionString = dividendString + separatorString + divisorString
        
        return fractionString
    }
    
    
    
    private var steps_form_switcher_section : some View{
        Section{
            
        }
    }
    
    //Make this into a view so it can be used in a list
    private var form_layout_section : some View{
        Section{
            Text("What is the new \(selection_mode == "Extraction_Return" ? "extraction" : "") barcode replacement for \(Text(current_old_target_barcode).bold())")
                .font(.body)
                .foregroundColor(Color.primary)
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                HStack{
                    form_elements_section
                }
            }
            else if UIDevice.current.userInterfaceIdiom == .phone{
                VStack(spacing: 10){
                    form_elements_section
                    
                }
            }
            
            element_progress_counter_section
            HStack{
                skip_form_element_btn_section
                
                Spacer()
                
                next_form_element_btn_section
            }
            
        }
    }
    
    
    
    private var element_progress_counter_section : some View{
        Section{
            
            HStack{
                Text("\(fractionToString(current_progress_in_list, targetSamplesToProcess.count))")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.primary)
                /* Text("\(current_progress_in_list) / \(barcode_count) left")
                 */
                Text("left")
            }
        }
    }
    private var skip_form_element_btn_section : some View{
        Section{
            
            
            Button {
                //go to the next element in the list
                //MARK: dont remove the barcode from the list
                
                //use a similar logic to the one in guided cart view
                
            } label: {
                HStack{
                    Text("Skip")
                    
                }.roundButtonStyle()
            }
            
        }
    }
    
    
    private var next_form_element_btn_section : some View{
        Section{
            
            
            Button {
                //MARK: need to remove the item that was returned from the batch (need to track which batch each barcode belongs (add it to the barcode as a reference))
                //go to the next element in the list
                
                //use a similar logic to the one in guided cart view
                
            } label: {
                HStack{
                    Text("Next")
                    Image(systemName: "arrow.right")
                }.roundButtonStyle()
            }
            
        }
    }
    
    private var form_elements_section : some View{
        Section{
            
            
            start_scanner_capture
        }
    }
    
    
    private var start_scanner_capture : some View{
        VStack(spacing: 20){
            
            TextFieldLabelCombo(textValue: $current_replacement_barcode, label: "New Barcode", placeHolder: "Enter barcode to replace \(current_old_target_barcode)", iconValue: "number")
            
            BarcodeScannerBtn(show_barcode_scanner: self.$show_barcode_scanner, target_barcodes: self.$target_barcodes, current_barcode: self.$current_barcode, show_barcode_scanner_btn: self.$show_barcode_scanner_btn)
            
            //Go to another screen to show the results and be able to capture the results and send it to Freezer View
            
        }
    }
    
}



struct ExtractionSampleReturnGuideView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group{
            ExtractionSampleReturnGuideView(targetSamplesToProcess: .constant(Set<InventorySampleModel>()))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone 8")
            ExtractionSampleReturnGuideView(targetSamplesToProcess: .constant(Set<InventorySampleModel>()))
                .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            
            ExtractionSampleReturnGuideView(targetSamplesToProcess: .constant(Set<InventorySampleModel>()))
                .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                .previewDisplayName("iPad Air (4th generation)")
            
            
        }
    }
}


extension Int {
    
    var superscriptString: String {
        var superscriptString: String = ""
        let translationTable: [String: String] = [
            "0": "\u{2070}",
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}"
        ]
        for n in String(self) {
            let m: String = String(n)
            superscriptString += translationTable[m] ?? ""
        }
        return superscriptString
    }
    
    var subscriptString: String {
        var subscriptString: String = ""
        let translationTable: [String: String] = [
            "0": "\u{2080}",
            "1": "\u{2081}",
            "2": "\u{2082}",
            "3": "\u{2083}",
            "4": "\u{2084}",
            "5": "\u{2085}",
            "6": "\u{2086}",
            "7": "\u{2087}",
            "8": "\u{2088}",
            "9": "\u{2089}"
        ]
        for n in String(self) {
            let m: String = String(n)
            subscriptString += translationTable[m] ?? ""
        }
        return subscriptString
    }
}

//MARK: put in own file
struct ExtractFormStep : View{
    
    @Binding var target_barcodes : [String]
    @Binding var current_barcode : String
    @Binding var selection_mode : String
    @Binding var current_progress_in_list : Int
    @Binding var barcode_count : Int
    @Binding var targetSamplesToProcess : Set<InventorySampleModel>
    
    @Binding var current_old_target_barcode : String
    @Binding var current_replacement_barcode : String
    
    @State var show_barcode_scanner_btn : Bool = false
    @State var show_barcode_scanner : Bool = false
    
    var body: some View{
        VStack{
            Text("What is the new \(selection_mode == "Extraction_Return" ? "extraction" : "") barcode replacement for \(Text(current_old_target_barcode).bold())")
                .font(.body)
                .foregroundColor(Color.primary)
            
            // TextFieldLabelCombo(textValue: $current_replacement_barcode, label: "New Barcode", placeHolder: "Enter the new Barcode", iconValue: "note")
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                
                HStack{
                    form_elements_section
                }
            }
            else if UIDevice.current.userInterfaceIdiom == .phone{
                VStack(spacing: 10){
                    form_elements_section
                    
                }
            }
            
            element_progress_counter_section
            HStack{
                skip_form_element_btn_section
                
                Spacer()
                
                //next_form_element_btn_section
            }
            
        }
    }
}

extension ExtractFormStep{
    
    private var element_progress_counter_section : some View{
        Section{
            
            HStack{
                Text("\(fractionToString(current_progress_in_list, targetSamplesToProcess.count))")
                    .bold()
                    .font(.largeTitle)
                    .foregroundColor(Color.primary)
                /* Text("\(current_progress_in_list) / \(barcode_count) left")
                 */
                Text("left")
            }
        }
    }
    private var skip_form_element_btn_section : some View{
        Section{
            
            
            Button {
                //go to the next element in the list
                //MARK: dont remove the barcode from the list
                
                //use a similar logic to the one in guided cart view
                
            } label: {
                HStack{
                    Text("Skip")
                    
                }.roundButtonStyle()
            }
            
        }
    }
    
    
    private var next_form_element_btn_section : some View{
        Section{
            
            
            Button {
                //MARK: need to remove the item that was returned from the batch (need to track which batch each barcode belongs (add it to the barcode as a reference))
                //go to the next element in the list
                
                //use a similar logic to the one in guided cart view
                
                
                //MARK: need to call the return method to send the data to the API to permanently remove the sample and replace it (same location) with a new barcode (extraction)
                
            } label: {
                HStack{
                    Text("Next")
                    Image(systemName: "arrow.right")
                }.roundButtonStyle()
            }
            
        }
    }
    
    
    private var form_elements_section : some View{
        Section{
            
            
            start_scanner_capture
        }
    }
    
    
    private var start_scanner_capture : some View{
        VStack(spacing: 20){
            
            TextFieldLabelCombo(textValue: $current_replacement_barcode, label: "New Barcode", placeHolder: "Enter barcode to replace \(current_old_target_barcode)", iconValue: "number")
            
            SingleBarcodeScannerBtn(show_barcode_scanner: self.$show_barcode_scanner,current_barcode: self.$current_replacement_barcode, show_barcode_scanner_btn: self.$show_barcode_scanner_btn)
            
            
            //Go to another screen to show the results and be able to capture the results and send it to Freezer View
            
        }
    }
    
    // Set up a method to generate a fraction string from two integers
    func fractionToString(_ dividend: Int, _ divisor: Int) -> String {
        let dividendString = dividend.superscriptString
        let separatorString = "\u{2044}"
        let divisorString = divisor.subscriptString
        
        let fractionString = dividendString + separatorString + divisorString
        
        return fractionString
    }
    
}
