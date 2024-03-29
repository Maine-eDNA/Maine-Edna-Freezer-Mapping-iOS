//
//  GuidedCartView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/10/22.
//

import SwiftUI
import StepperView
import Kingfisher

//MARK: Need to remove the extra freezer_label etc that i add to create the slug the API already does it
//Test
//MARK: Split the CartView into Cart View (Extraction Return and Return todo Next based on drawings) and Utilities
//MARK: Make into documentation
//MARK: only handles Search (to find and take from freezer) and Return to freezer
struct GuidedCartView: View {
    //MARK: Put the form details in a view model to clean up the UI start
    ///Step indicator start
    
    //new start
    //For multistep
    @State var orderStatus : [OrderState] = [.queryMode]
    @State var currentStatus : OrderState = .queryMode
    
    
    //for returns
    @State var currentReturnStatus : ReturnOrderState = .queryMode
    @State var returnOrderStatus : [ReturnOrderState] = [.queryMode]
    
    //new end
    
    
    @State private var changePosition : Bool = true
    @State var current_position_in_form : String = ""
    @State var next_position_in_form : String = ""
    @State var current_form_index : Int = 0
    @State var next_form_index : Int = 1
    
    //have steps for return
 
    /*
    @State var general_steps = [ Text("Mode").font(.caption),
                                 Text("Entry").font(.caption),
                                 Text("Freezer").font(.caption),
                                 Text("Rack").font(.caption),
                                 Text("Box").font(.caption)
                                 
                                 
    ]
     
     */
    //MARK: steps for return
    @State var return_steps = [ Text("Mode").font(.caption),
                                 Text("Batch").font(.caption),
                                 Text("Confirm").font(.caption),
                                 Text("Returns").font(.caption),
                                 Text("Summary").font(.caption)
                                 
                                 
    ]
    
    let return_indicationTypes = [
        StepperIndicationType.custom(NumberedCircleView(text: "1",triggerAnimation: false)),
        .custom(NumberedCircleView(text: "2")),
        .custom(NumberedCircleView(text: "3")),
        .custom(NumberedCircleView(text: "4",triggerAnimation: false)),
        .custom(NumberedCircleView(text: "5"))
        
    ]
    
    //special steps for Remove and Transfer steps
    
    
    let alignments = [StepperAlignment.center,.center,.center, .center, .center]
    
    let indicationTypes = [
        StepperIndicationType.custom(NumberedCircleView(text: "1",triggerAnimation: false)),
        .custom(NumberedCircleView(text: "2")),
        .custom(NumberedCircleView(text: "3")),
        .custom(NumberedCircleView(text: "4",triggerAnimation: false)),
        .custom(NumberedCircleView(text: "5"))
        
    ]
    
    //grid settings
    private var threeColumnGrid = [
        GridItem(.adaptive(minimum: 300,maximum: 700))
        
    ]
    ///Multiple batch returns logic
    //MARK: be able to select a batch of samples to be that was taken from a freezer, and merge it with another set
    //because some samples may not be returned at the same time since some will be in a temp freezer
    //so give the option at the begining to select one or more batches, it then will merge all the samples into one big list
    //grouping by freezer, rack and box, then present it to the user giving them the option to remove the ones that isnt being returned at this time and so it will remain in the batch once the process is done. So they can be returned in the future
    
    /// Mode selector properties start
    @State private var selection : String = "Search"
    @State var actions = ["Search","Return"]
    
    @State var return_selection : String = "Return"
    @State var return_actions = ["Return","Extraction Return"]
    
    
    /// Mode selector properties end
   
    
    ///Step indicator end
    ///current position in the form properties start
    @State var currentIndex : Int = 0
    ///current position in the form properties end
    
    //toolbar
    @State var showTutorials : Bool = false
    @State var tutorialImage : String = "https://wwwcdn.cincopa.com/blogres/wp-content/uploads/2019/02/video-tutorial-image.jpg"
    
    ///properties shared within the sections of the form (steps)
    //@State var target_freezer : FreezerProfileModel = FreezerProfileModel()
    
    
    
    @StateObject var util_vm : UtilitiesCartFormViewModel = UtilitiesCartFormViewModel()
    
    @State var freezer_rack_label_slug : String = ""
    //Send the data to and from Rack
    @State var target_rack : RackItemModel = RackItemModel()
    @State var freezer_profile : FreezerProfileModel = FreezerProfileModel()
    
    @State var inventoryLocations : [InventorySampleModel] = []
    
    //MARK: batch section
    @State var showBatchDetailView : Bool = false
    @State var targetBatches : Set<SampleBatchModel> = Set<SampleBatchModel>()
    
    //@State var allSamplesInBatches : [InventorySampleModel] = [InventorySampleModel]()
    @State var targetSamplesToProcess : Set<InventorySampleModel> = Set<InventorySampleModel>()
    
    //MARK: Put the form details in a view model to clean up the UI end
    
    @State var figureToFindEnd : Int =  -2
    
    @State var target_barcodes : [String] = [String]()
    
    //the grouped and re-ordered map of results
    @State var sampleLocationMaps : [SearchModeSampleMapModel] = [SearchModeSampleMapModel]()
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment: .leading,spacing: 10){
                    
                 
                    
                    if selection == "Search"{
                        main_form_switcher
                    }
                    else if selection == "Return"{
                        
                        return_main_form_switcher
                    }
                    
                    Spacer()
                }
                
                //show tutorial button
            }
            
            //TOOL BAR
            .navigationBarTitle("Cart")
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
        }.navigationViewStyle(.stack)
        .sheet(isPresented: $showTutorials, content: {
            cartviewtutorialsection
        })
        
        .onAppear{
            
        }
        
        
    }
}



extension GuidedCartView{
    
    
    
    private var cartviewtutorialsection : some View{
        NavigationView{
            VStack(alignment: .leading){
                List{
                    // Text("Show Tutorials here in this list when clicked will show view and text")
                    
                    HStack{
                        
                        KFImage(URL(string: tutorialImage))
                            .onSuccess { r in
                                // r: RetrieveImageResult
                                print("success: \(r)")
                            }
                            .onFailure { e in
                                // e: KingfisherError
                                print("failure: \(e)")
                            }
                            .placeholder {
                                // Placeholder while downloading.
                                
                                KFImage(URL(string: tutorialImage))
                                    .resizable()
                                    .clipped()
                                    .cornerRadius(15)
                                    .frame(width: 100, height: 100)
                                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                            }
                        //make reusable view modifier
                            .resizable()
                            .clipped()
                            .cornerRadius(15)
                            .frame(width: 100, height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1))
                        
                        
                        VStack(alignment: .leading, spacing: 2) {
                            HStack{
                                Text("camera scanner")
                                    .bold()
                                    .font(.caption)
                                    .padding()
                                    .textInputAutocapitalization(.words)
                                    .foregroundColor(Color.white)
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1).background(Color.teal).cornerRadius(15).frame(maxHeight: 25) )
                                
                                
                                
                            }
                            
                            
                            Text("Using the Built in Camera for Barcode Scanning")
                                .foregroundColor(Color.primary)
                                .bold()
                                .font(.subheadline)
                            
                            
                            Spacer()
                        }
                    }
                    
                }.listStyle(.plain)
                    .navigationTitle("User Guides")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    ///general step indicator

    
    ///special indicator types: for Remove and Transfer Box
    ///
    ///
    
    #warning("Place on separate screens")
    #warning("Move Utility to menu and Return as its own tab then make the parts reusabled on each screen instead of swapping")
    //MARK: form switcher section start
    
    private var return_main_form_switcher : some View{
        Section(header: Text(" Return Cart Sections").bold().font(.subheadline).foregroundColor(.secondary)) {
            VStack {
                            // MULTI-STEPS View
                MultiStepsView(steps: $returnOrderStatus, extraContent: ReturnOrderState.allValues, extraContentPosition : .above, extraContentSize: CGSize(width: 30, height: 30), action: {_ in }) {
                                RoundedRectangle(cornerRadius: 5).frame(height: 10)
                            }
                            .padding()
                            .font(.title2)
                            
                            Spacer()
                            // STEP VIEW - CONDITIONAL
       
                switch currentReturnStatus {
                    /*
      
                     case sampleMap = "testtube.2"
                     case returnGuideMode = "doc.text"
                     */
                    
                case .queryMode:
                    // Text("Search Mode")
                    ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Cart")
                    
                case .sampleReturnBatches:
                    MultiBatchSampleListView(showBatchDetailView: $showBatchDetailView, selection: $targetBatches)
                    
                case .sampleMap:
                    
                    ShowAllSamplesInBatchesView(targetBatches: $targetBatches, targetSamplesToProcess: $targetSamplesToProcess)
                    
                case .returnGuideMode:
                    ExtractionSampleReturnGuideView(targetSamplesToProcess: $targetSamplesToProcess)
         
                }
                            
                            Spacer()
                            /*
                             
                             Button {
                                 
                                 guard orderStatus.count > 1 else { return }
                                 orderStatus.removeAll(where: {$0 == currentStatus})
                                 currentStatus = currentStatus.previous()
                                 
                             } label: {
                                 HStack{
                                     Text("Back")
                                 } .frame(maxWidth: .infinity).colorRoundedButtonStyle(selectedColor: Color.theme.red)
                                    
                             }
                             .padding(.horizontal)
                             .padding(.top,20)
                             
                    
             
                             Button {
                                 if !orderStatus.contains(currentStatus.next()) {
                                     currentStatus = currentStatus.next()
                                     orderStatus.append(currentStatus)
                                 }
                             } label: {
                                 HStack{
                                     Text("Next")
                                 } .frame(maxWidth: .infinity).colorRoundedButtonStyle(selectedColor: Color.blue)
                                    
                             }
                             .padding(.horizontal)
                             .padding(.top,20)
                             */
                            // BOTTOM BUTTONS
                            HStack {
                                
                                Button {
                                    
                                    guard returnOrderStatus.count > 1 else { return }
                                    returnOrderStatus.removeAll(where: {$0 == currentReturnStatus})
                                    currentReturnStatus = currentReturnStatus.previous()
                                    
                                } label: {
                                    HStack{
                                        Text("Back")
                                    } .frame(maxWidth: .infinity).colorRoundedButtonStyle(selectedColor: Color.theme.red)
                                       
                                }
                                .padding(.horizontal)
                                .padding(.top,20)
                                
                       
                
                                Button {
                                    if !returnOrderStatus.contains(currentReturnStatus.next()) {
                                        currentReturnStatus = currentReturnStatus.next()
                                        returnOrderStatus.append(currentReturnStatus)
                                    }
                                } label: {
                                    HStack{
                                        Text("Next")
                                    } .frame(maxWidth: .infinity).colorRoundedButtonStyle(selectedColor: Color.blue)
                                       
                                }
                                .padding(.horizontal)
                                .padding(.top,20)

                                
                            }
                          
               
                    }
        }
    
    

    }
    
    private var main_form_switcher : some View{
       
        /*
        //GeometryReader ( content: { geometry in
        VStack{
            #warning("NEXT: Continue here do the Search, then take samples from the freezer and add it to a batch, make the list accessible ")
            VStack {
                TabView(selection: $currentIndex) {
                    
                    if selection == "Search"{
                        //MARK: Search should take the barcodes -> then show the positions of all the samples that was added to the list
                        Section{
                            //MARK: will change this according to the mode
                            ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Cart")
                                .tag (0)
                            CartDataCaptureFormView(target_barcodes: $target_barcodes)
                                .tag(1)
                            
                            #warning("Show a new Screen which shows the list of samples that have been found and where they have been found")
                            SamplesFoundFromListView(target_barcodes: $target_barcodes, sampleLocationMaps: $sampleLocationMaps)
                                .tag (2)
                            
                            GroupedResultsMapView(sampleLocationMaps: $sampleLocationMaps)
                                .tag(3)
                            /*
                            FreezerCartFormView(target_freezer: $freezer_profile, selectMode: $selection)
                                .tag (2)
                            
                            // RackCartFormView(freezer_profile: $freezer_profile, freezer_rack_label_slug: $freezer_rack_label_slug,target_rack: $target_rack, inventoryLocations: $inventoryLocations )
                            RackCartFormView(freezer_rack_label_slug: $freezer_rack_label_slug, target_rack: $target_rack, freezer_profile: $freezer_profile, inventoryLocations: $inventoryLocations, selectMode: $selection)
                                .tag (3)
                            //BoxCartFormView(freezer_rack_label_slug: $freezer_rack_label_slug)
                           
                            //Clean this up to only show the samples
                           // BoxCartFormView(freezer_rack_label_slug: $freezer_rack_label_slug, target_rack: $target_rack, freezer_profile: $freezer_profile, inventoryLocations: $inventoryLocations)
                             //MARK: make this into a summary page
                                EmptyView()
                                .tag(4)
                            
                            */
                        }
                    }
                    else if selection == "Return"{
                        //MARK: if the extraction return has special pages compared to the regular return which doesnt change the barcode just return to the existing position
                        Section{
                      
                            ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Cart")
                                .tag (0)
                            
                            //select a batch from the list
                            MultiBatchSampleListView(showBatchDetailView: $showBatchDetailView, selection: $targetBatches)
                            //Add unique navi option
                                .tag(1)
                            ShowAllSamplesInBatchesView(targetBatches: $targetBatches, targetSamplesToProcess: $targetSamplesToProcess)
                                .tag(2)
                            
                            ExtractionSampleReturnGuideView(targetSamplesToProcess: $targetSamplesToProcess)
                                .tag(3)
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
        */
        
        //use this in the edit part of the app as well the tabview

            
            Section(header: Text("Cart Sections").bold().font(.subheadline).foregroundColor(.secondary)) {
                VStack {
                                // MULTI-STEPS View
                    MultiStepsView(steps: $orderStatus, extraContent: OrderState.allValues, extraContentPosition : .above, extraContentSize: CGSize(width: 30, height: 30), action: {_ in }) {
                                    RoundedRectangle(cornerRadius: 5).frame(height: 10)
                                }
                                .padding()
                                .font(.title2)
                                
                                Spacer()
                                // STEP VIEW - CONDITIONAL
                    if selection == "Search"{
                        switch currentStatus {
                        case .queryMode:
                            // Text("Search Mode")
                            ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Cart")
                            
                        case .entryMode:
                            
                            //Text("Entry Mode")
                            CartDataCaptureFormView(target_barcodes: $target_barcodes)
                        case .freezerMap:
                            
                            //Text("Freezer Map")
                            FreezerCartFormView(target_freezer: $freezer_profile, selectMode: $selection)
                            
                        case .rackMap:
                            //Text("Rack Map")
                            RackCartFormView(freezer_rack_label_slug: $freezer_rack_label_slug, target_rack: $target_rack, freezer_profile: $freezer_profile, inventoryLocations: $inventoryLocations, selectMode: $selection)
                            
                        case .boxMap:
                            Text("Box Map")
                        case .sampleMap:
                            // ReferenceAndBackgroundPreview(showAddNewDocumentView: $showAddNewDocumentView)
                            //.environmentObject(manager)
                            Text("Samples In Box")
                            
                        case .summaryView:
                            Text("Summary of Actions done")
                        }
                        
                    }
                    else if selection == "Return"{
                        switch currentStatus {
                        case .queryMode:
                            // Text("Search Mode")
                            ModeSelectorFormView(selection: $selection, actions: $actions, return_selection: $return_selection,return_actions: $return_actions, viewCalling: "Cart")
                            
                        default:
                            Text("Not Valid Selection")
                        }
                    }
                                
                                
                                Spacer()
                                
                                // BOTTOM BUTTONS
                                HStack {
                                    
                                    Button {
                                        
                                        guard orderStatus.count > 1 else { return }
                                        orderStatus.removeAll(where: {$0 == currentStatus})
                                        currentStatus = currentStatus.previous()
                                        
                                    } label: {
                                        HStack{
                                            Text("Back")
                                        } .frame(maxWidth: .infinity).colorRoundedButtonStyle(selectedColor: Color.theme.red)
                                           
                                    }
                                    .padding(.horizontal)
                                    .padding(.top,20)
                                    
                           
                    
                                    Button {
                                        if !orderStatus.contains(currentStatus.next()) {
                                            currentStatus = currentStatus.next()
                                            orderStatus.append(currentStatus)
                                        }
                                    } label: {
                                        HStack{
                                            Text("Next")
                                        } .frame(maxWidth: .infinity).colorRoundedButtonStyle(selectedColor: Color.blue)
                                           
                                    }
                                    .padding(.horizontal)
                                    .padding(.top,20)

                                    
                                }
                              
                                
                            }
            }
        
        
    }

    
    //MARK: form switcher section end
    
    
}


struct GuidedCartView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedCartView()
    }
}






