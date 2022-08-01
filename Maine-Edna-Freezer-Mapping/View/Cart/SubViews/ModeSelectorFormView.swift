//
//  ModeSelectorFormView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/21/22.
//

import SwiftUI


///Captures barcodes using, CSV, Manual or Barcode Scanner end
struct ModeSelectorFormView : View{
    @Binding var selection : String
    @Binding var actions : [String]
    
    @Binding var return_selection : String
    @Binding var return_actions : [String]
    
    var body: some View{
        VStack(alignment: .center,spacing: 10){
            title_instruction_section
            
            MenuStyleClicker(selection: self.$selection, actions: self.$actions,label: "Mode",label_action: self.$selection).frame(width: 200)
            
            if selection == "Return"{
                withAnimation {
                    Section{

                        //Show return options and change what screens show next in the process switch out the the tag(0) CartDataCaptureFormView to be Batch List to select the batch/batches to return
                        MenuStyleClicker(selection: self.$return_selection, actions: self.$return_actions,label: "Mode",label_action: self.$selection).frame(width: 200)
                    }
                }
            }
            
            Spacer()
        }
    }
    
}

extension ModeSelectorFormView{
    
    private var title_instruction_section : some View{
        VStack(alignment: .leading){
            Text("Welcome to Cart View")
                .font(.title3)
                .foregroundColor(Color.primary)
                .bold()
            
            Text("Here you can query Freezers, Racks, Boxes, Samples and more.")
                .font(.subheadline)
                .foregroundColor(Color.secondary)
            
            Text("Hint: click tutorial at the top right to learn more.")
                .font(.caption)
                .foregroundColor(Color.secondary)
        }
    }
    
}
