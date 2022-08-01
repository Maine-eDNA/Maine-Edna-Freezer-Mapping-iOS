//
//  ExtractionSampleReturnGuideView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 7/27/22.
//

import SwiftUI

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
    
    var body: some View {
        //Text("This is the screen that will show all the samples being returned one by one like a quiz survey to guide them step by step")
        VStack(alignment: .leading, spacing: 10)
        {
#warning("Continue here by adding the list to this and make it go into a loop to keep running till the last barcode is returned or skipped")
            //form_layout_section
            
            form_loop_section
            
            Spacer()
        }.padding()
    }
}

extension ExtractionSampleReturnGuideView{
    #warning("Need to put in a tab view to press next or skip to go in the list")
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
            
            BarcodeScannerBtn(show_barcode_scanner: self.$show_barcode_scanner, target_barcodes: self.$target_barcodes, current_barcode: self.$current_barcode, show_barcode_scanner_btn: self.$show_barcode_scanner_btn)
            
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
