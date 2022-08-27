//
//  UtilitiesView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/14/22.
//

import SwiftUI
import StepperView
import Kingfisher
import Combine
//MARK: Will do Add, Remove, Transfer Box on this screen
#warning("Need to add validation so that if form needs target barcodes then dont allow them to move further till they select atleast one sample")
///Used to share data between the Form Control on the Utilities and Cart View Page instead of sending additional parameters in between
class UtilitiesCartFormViewModel : ObservableObject{
    
 
    @Published var isLoading : Bool = false
    
    //private let freezerCheckOutDataService = FreezerCheckOutLogRetrieval()
    private var cancellables = Set<AnyCancellable>()
    
   // @AppStorage(AppStorageNames.store_email_address.rawValue)  var store_email_address = ""
    
    @Published var rack_profile : RackItemModel = RackItemModel()
    @Published var addToRackMode : Bool = false
    @Published var rack_position_row : Int = 0
    @Published var rack_position_column: Int = 0
    
    @Published var target_rack : RackItemModel = RackItemModel()
    @Published var showRackProfile : Bool = false
    @Published var freezer_profile : FreezerProfileModel = FreezerProfileModel()
    
    
    @Published var inventoryLocations : [InventorySampleModel] = [InventorySampleModel]()
    @Published var isInSearchMode : Bool = false
    
    init(){
        //addSubscribers()
    }
    
 
    
    func addSubscribers(){
        
   
    }
    
    
}

struct UtilitiesView: View {
    //MARK: Put the form details in a view model to clean up the UI
    ///Step indicator start
    @State private var changePosition : Bool = true
    @State var current_position_in_form : String = ""
    @State var next_position_in_form : String = ""
    @State var current_form_index : Int = 0
    @State var next_form_index : Int = 1
    @State var general_steps = [ Text("Mode").font(.caption),
                                 Text("Entry").font(.caption),
                                 Text("Freezer").font(.caption),
                                 Text("Rack").font(.caption),
                                 Text("Box").font(.caption)
                                 
                                 
    ]
    
    @State var remove_steps = [ Text("Mode").font(.caption),
                                 Text("Freezer").font(.caption),
                                 Text("Rack").font(.caption),
                                 Text("Samples").font(.caption)
                                 
                                 
    ]
    
    //special steps for Remove and Transfer steps
    
    
    let alignments = [StepperAlignment.center,.center,.center, .center, .center]
    
    let indicationTypes = [
        StepperIndicationType.custom(NumberedCircleView(text: "1",triggerAnimation: false)),
        .custom(NumberedCircleView(text: "2")),
       // .image(Image(systemName: "checkmark"), 10),
        .custom(NumberedCircleView(text: "3")),
        .custom(NumberedCircleView(text: "4",triggerAnimation: false)),
        .custom(NumberedCircleView(text: "5"))
        
    ]
    
    //grid settings
    private var threeColumnGrid = [
        GridItem(.adaptive(minimum: 300,maximum: 700))
        
    ]
    
    /// Mode selector properties start
    @State private var selection : String = "Add"
    @State var actions = ["Add", "Remove", "Transfer Box"]
    
    @State var return_selection : String = "Return"
    @State var return_actions = ["Return","Extraction Return"]
    /// Mode selector properties end
   
    
    ///Step indicator end
    ///current position in the form properties start
    @State var currentIndex : Int = 0
    ///current position in the form properties end
    
    //toolbar
    @State var showTutorials : Bool = false

    
    ///properties shared within the sections of the form (steps)
    /// //Send the data to and from Rack
    @State var target_rack : RackItemModel = RackItemModel()
    @State var freezer_profile : FreezerProfileModel = FreezerProfileModel()
    @State var inventoryLocations : [InventorySampleModel] = []
    
    @StateObject var util_vm : UtilitiesCartFormViewModel = UtilitiesCartFormViewModel()
    
    @State var freezer_rack_label_slug : String = ""
    
    @State var figureToFindEnd : Int =  -2
    
    @State var target_barcodes : [String] = [String]()
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment: .leading,spacing: 10){
                    step_indicator_section.padding(.top,10)
                    
                    main_form_switcher
                }
                
                //show tutorial button
            }
            
            //TOOL BAR
            .navigationBarTitle("Utilities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        //show the tutorial how to use the cart view
                        
                        withAnimation {
                            self.showTutorials.toggle()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "questionmark.circle")
                            
                            Text("Tutorial")
                            
                        }.modifier(RoundButtonStyle())
                    }
                    
                }
            }
        }
        .sheet(isPresented: $showTutorials, content: {
            cartviewtutorialsection
        })
        
        .onAppear{
            
        }
        
        
    }
}



extension UtilitiesView{
    
    
    
    private var cartviewtutorialsection : some View{
        Section{
            HowToTutorialsView()
        }
    }
    
    ///general step indicator
    private var step_indicator_section : some View{
        
        HStack{
            Spacer()
            //need to indicate where you are in the list
            StepperView()
                .addSteps(setStepsMode())
                .indicators(self.indicationTypes)
                .stepIndicatorMode(StepperMode.horizontal)
                .stepLifeCycles([StepLifeCycle.pending, .completed, .completed, .completed,.pending])
                .spacing(50)
                .lineOptions(StepperLineOptions.custom(1, Colors.blue(.teal).rawValue))
            
            
            Spacer()
        }.padding(.top,30)
        
    }
    
    ///special indicator types: for Remove and Transfer Box
    ///
    ///
    
    
    //MARK: form switcher section start
    private var main_form_switcher : some View{
        //GeometryReader ( content: { geometry in
        VStack{
            
            VStack {
                TabView(selection: $currentIndex) {
                    
                    //if selection == Remove then change to flow
                    /*
                      1. Selected Remove
                      2. Freezer
                     3. Box
                     4. Select the samples to remove
                     */
                    if selection == "Remove"{
                        Section{
                            //1. Selected Remove
                            ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Utilities")
                                .tag (0)
                           
                            //2. Add barcodes that should be removed
                            CartDataCaptureFormView(target_barcodes: $target_barcodes)
                                .tag(1)
                            
                            //3. Confirm the perm_removal of the target barcodes
                            RemoveConfirmationView(sampleBarcodesToRemove: $target_barcodes)
                                .tag(2)
                           /* FreezerCartFormView(target_freezer: $freezer_profile, selectMode: $selection)
                                .tag (1)
                            
                            //3. Select the rack
                            RackCartFormView(freezer_rack_label_slug: $freezer_rack_label_slug, target_rack: $target_rack, freezer_profile: $freezer_profile, inventoryLocations: $inventoryLocations,selectMode : $selection)
                                .tag (2)
                            
                            // 4. Select Box
                            #warning("May need to add another form that shows the summary of what will be removed")
                            */
                        }
                    }
                    else if selection == "Add"{
                        #warning("Copy the flow from search for adding ")
                        //MARK: Search should take the barcodes -> then show the positions of all the samples that was added to the list
                        Section{
                            ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Utilities")
                                .tag (0 )
                            
                            FreezerCartFormView(target_freezer: $freezer_profile, selectMode: $selection)
                                .tag (1)
                            
                            //MARK: will be in press only mode and in Add Mode
                            RackCartFormView(freezer_rack_label_slug: $freezer_rack_label_slug, target_rack: $target_rack, freezer_profile: $freezer_profile, inventoryLocations: $inventoryLocations,selectMode : $selection)
                                .tag (2)
                        }
                    }
                    
                    else if selection == "Transfer Box"{
                        //MARK: updates the target box location to be in a new freezer and rack
                        Section{
                            ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Utilities")
                                .tag (0 )
                            CartDataCaptureFormView(target_barcodes: $target_barcodes)
                                .tag(1)
                            FreezerCartFormView(target_freezer: $freezer_profile, selectMode: $selection)
                                .tag (2)
                            //MARK: Re-enable once the Guided Cart has been fixed
                           /* RackCartFormView(target_freezer: $target_freezer, freezer_rack_label_slug: $freezer_rack_label_slug)
                                .tag (3)
                            //This will no longer need params since it uses the viewmodel
                            //MARK: get this from the RackCartFormView  (maybe use a view model to share the data since so larget)
                            BoxCartFormView(freezer_rack_label_slug: $freezer_rack_label_slug)
                                .tag(4)*/
                        }
                    }
               
                    
                    
                }.tabViewStyle(PageTabViewStyle())
                // . indexViewStyle(PageIndexViewStyle(backgroundDisplayMode:.always))
                //. frame (maxHeight: geometry.size.height * 0.8, alignment:. center)
                    .animation(.easeInOut(duration: 0.2),value: changePosition)
                
            }
            /* Button {
             currentIndex += 1
             } label: {
             Text("Next")
             }*/
            
            
            //  })
            
            form_switcher_fwd_back_buttons
                .padding(.bottom,10)
        }
        
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
                                .accentColor(Color(wordName: ColorSetter().setTextForegroundColor()))
                            Text("Back")
                                .foregroundColor(Color(wordName: ColorSetter().setTextForegroundColor()))
                            
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        maxHeight: 44
                    )
                    //.background(Color.white)
                    .cornerRadius(4)
                    .padding(
                        [.leading, .trailing], 20
                    )
                }
                #warning("Switch the steps being used based on the mode")
              
                
                if currentIndex != (setStepsMode().count + figureToFindEnd){
                    Button(action: {
                        //animate transition
                        changePosition.toggle()
                        
                        //(setStepsMode().count - 1) meants at the end of the steps
                        //- 1 because the steps start from 0 while the steps count start from 1
                        if currentIndex != (setStepsMode().count + figureToFindEnd) {
                            currentIndex += 1
                        }
                    }) {
                        HStack(alignment: .center, spacing: 10) {
                            //if equal the last section
                            //MARK: change to be the number of count of steps to know when at the end
                            Text(currentIndex == (setStepsMode().count + figureToFindEnd) ? "Done" : "Next")
                                .foregroundColor(.white)
                            Image(systemName: currentIndex == (setStepsMode().count + figureToFindEnd) ? "checkmark" : "arrow.right")
                                .accentColor(.white)
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
            }
            // Spacer()
        }
    }
    
    
    //MARK: form switcher section end
    
    
}

extension UtilitiesView{
    #warning("Will need to update this to use a case or similar to set step mode for multiple selection types")
    ///sets the correct steps according to the mode to keep the form behavior consistent
    func setStepsMode() -> [Text]{
        return selection == "Remove" ? remove_steps : general_steps
    }
    

}

struct UtilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        UtilitiesView()
            .navigationViewStyle(.stack)
    }
}
