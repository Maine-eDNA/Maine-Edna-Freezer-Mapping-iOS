//
//  ResolutionModelView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/21/22.
//

import SwiftUI

struct ResolutionModalView: View {
    /// Mode selector properties start
    @State private var selection : String = "Move"
    @State var actions = ["Move","Suggest","Info","Remove"]
    
    @StateObject var instructions_vm : ResolutionInstructionViewModel = ResolutionInstructionViewModel()
    @StateObject var sampleData_vm : ResolutionSampleDataViewModel = ResolutionSampleDataViewModel()
    
    @Binding var inventorySample : InventorySampleModel
    
    var oneColumnGrid : [GridItem] = [GridItem(.flexible())]
    var twoColumnGrid : [GridItem] = [GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
       // ScrollView(showsIndicators: false){
        VStack(alignment: UIDevice.current.userInterfaceIdiom == .pad ? .center : .leading){
            if UIDevice.current.userInterfaceIdiom == .phone{
                Spacer().frame(height: 30)
            }
                resolution_mode_sector_section
                
                //tab mode content
                tab_mode_content
                
                Spacer()
            }
        //}
        
            .onAppear(){
                self.sampleData_vm.loadSampleLogs(freezerInventorySlug: inventorySample.freezer_inventory_slug)
            }
    }
}

extension ResolutionModalView{
    
    private var resolution_mode_sector_section : some View{
        Section{
            MenuStyleClicker(selection: self.$selection, actions: self.$actions,label: "Resolution Mode",label_action: self.$selection, width: UIDevice.current.userInterfaceIdiom == .pad ? .constant(400) : .constant(UIScreen.main.bounds.width * 0.75))
        }
    }
    
    private var tab_mode_content : some View{
        Section{
            if selection == "Move"{
                //MARK: Switches the map into Move mode so that it will allow the user to carry out the instructions stated below
                move_instruction_section
            }
            else if selection == "Suggest"{
                suggest_move_instruction_section
            }
            else if selection == "Info"{
                //Details of the target sample
                sample_info_instruction_section
            }
            else if selection == "Remove"{
                remove_sample_instruction_section
            }
        }
    }
    
    private var move_instruction_section : some View{
        Section{
            VStack(alignment: .leading) {
                Text("\(instructions_vm.moveInstructions.instructionTitle)")
                    .bold()
                    .foregroundColor(Color.secondary)
                    .font(.title3)
                    .minimumScaleFactor(0.6)
                    
                //List of instruction for Move Mode
                //MARK: Create Model and list of rules in a View Model that contains each type
                List(instructions_vm.moveInstructions.steps, id: \.id){ step in
                    
                    HStack{
                        Image(systemName: "circle.dashed")
                        
                        Text("\(step.stepDescription)")
                            .foregroundColor(Color.primary)
                            .font(.subheadline)
                            .minimumScaleFactor(0.6)
                    }
                }.listStyle(.plain)
                
            }
        }
    }
    
    private var suggest_move_instruction_section : some View{
        Section{
            VStack(alignment: .leading) {
                Text("\(instructions_vm.suggestMoveInstructions.instructionTitle)")
                    .bold()
                    .foregroundColor(Color.secondary)
                    .font(.title3)
                    .minimumScaleFactor(0.6)
                    
                //List of instruction for Move Mode
                //MARK: Create Model and list of rules in a View Model that contains each type
                List(instructions_vm.suggestMoveInstructions.steps, id: \.id){ step in
                    
                    HStack{
                        Image(systemName: "circle.dashed")
                        
                        Text("\(step.stepDescription)")
                            .foregroundColor(Color.primary)
                            .font(.subheadline)
                            .minimumScaleFactor(0.6)
                    }
                }.listStyle(.plain)
                
            }
        }
    }
    
    private var remove_sample_instruction_section : some View{
        Section{
            VStack(alignment: .leading) {
                Text("\(instructions_vm.removeInstructions.instructionTitle)")
                    .bold()
                    .foregroundColor(Color.secondary)
                    .font(.title3)
                    .minimumScaleFactor(0.6)
                    
                //List of instruction for Move Mode
                //MARK: Create Model and list of rules in a View Model that contains each type
                List(instructions_vm.removeInstructions.steps, id: \.id){ step in
                    
                    HStack{
                        Image(systemName: "circle.dashed")
                        
                        Text("\(step.stepDescription)")
                            .foregroundColor(Color.primary)
                            .font(.subheadline)
                            .minimumScaleFactor(0.6)
                    }
                }.listStyle(.plain)
                
            }
        }
    }
    
    private var sample_info_instruction_section : some View{
        Section{
            sample_info_header_section
            
            if self.sampleData_vm.sampleLogs.count > 0{
                sample_info_log_list_section
                
            }
            else{
                Text("No Logs found for \(inventorySample.sample_barcode). Check back later.")
                    .bold()
                    .foregroundColor(Color.secondary)
                    .font(.title2)
                    .minimumScaleFactor(0.6)
            }
        }
        
    }
    
    private var sample_info_header_section : some View{
        LazyVGrid(columns: UIDevice.current.userInterfaceIdiom == .pad ? twoColumnGrid : oneColumnGrid,alignment: UIDevice.current.userInterfaceIdiom == .pad ? .center : .leading){
            
            VStack(alignment: .leading) {
                Text("Sample Barcode")
                    //.bold()
                    .foregroundColor(Color.secondary)
                    .font(.callout)
                    .minimumScaleFactor(0.6)
                
                Text("\(inventorySample.sample_barcode)")
                    .bold()
                    .foregroundColor(Color.secondary)
                    .font(.title3)
                    .minimumScaleFactor(0.6)
                
                Text("Type")
                   // .bold()
                    .foregroundColor(Color.secondary)
                    .font(.callout)
                    .minimumScaleFactor(0.6)
                
                Text("\(inventorySample.freezer_inventory_type)")
                    .bold()
                    .foregroundColor(Color.secondary)
                    .font(.title3)
                    .minimumScaleFactor(0.6)
            }
            
            SamplePreviewPositionView(column: $inventorySample.freezer_inventory_column, row:  .constant(convertFromNumberToAlphabet(digit: inventorySample.freezer_inventory_row)), inven_type_abbrev: $inventorySample.freezer_inventory_type, barcode_last_three_digits: $inventorySample.sample_barcode)
        }
    }
    
    private var sample_info_log_list_section : some View{
        Section{
            List(self.sampleData_vm.sampleLogs, id: \.id){ log in
                
                SampleCheckOutLogCard(log: log)
                
            }
          
        }
    }
    
    
    func convertFromNumberToAlphabet(digit : Int) -> String
    {
        print("Current Value: \(digit)")
        
        return alphabet[digit].capitalized //+ "= \(digit)"

    }
    
}


struct ResolutionModalView_Previews: PreviewProvider {
    static var previews: some View {
        ResolutionModalView(inventorySample: .constant(InventorySampleModel()))
    }
}
