//
//  GuidedCartView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 6/10/22.
//

import SwiftUI
import StepperView
import Kingfisher


//Test
//MARK: Split the CartView into Cart View (Extraction Return and Return todo Next based on drawings) and Utilities
//MARK: Make into documentation
struct GuidedCartView: View {
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
    
    ///Step indicator end
    ///current position in the form properties start
    @State var currentIndex : Int = 0
    ///current position in the form properties end
    
    //toolbar
    @State var showTutorials : Bool = false
    @State var tutorialImage : String = "https://wwwcdn.cincopa.com/blogres/wp-content/uploads/2019/02/video-tutorial-image.jpg"
    
    
    
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
        }
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
    private var step_indicator_section : some View{
        
        HStack{
            Spacer()
            //need to indicate where you are in the list
            StepperView()
                .addSteps(general_steps)
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
                    ModeSelectorFormView()
                        .tag (0 )
                    CartDataCaptureFormView()
                        .tag(1)
                    FreezerCartFormView()
                        .tag (2)
                    
                    RackCartFormView()
                        .tag (3)
                    BoxCartFormView()
                        .tag(4)
                    
                    
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
                                .accentColor(.secondary)
                            Text("Back")
                                .foregroundColor(Color.secondary)
                            
                        }
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        maxHeight: 44
                    )
                    .background(Color.white)
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
                    if currentIndex != (general_steps.count - 1) {
                        currentIndex += 1
                    }
                }) {
                    HStack(alignment: .center, spacing: 10) {
                        //if equal the last section
                        //MARK: change to be the number of count of steps to know when at the end
                        Text(currentIndex == (general_steps.count - 1) ? "Done" : "Next")
                            .foregroundColor(.white)
                        Image(systemName: currentIndex == (general_steps.count - 1) ? "checkmark" : "arrow.right")
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
            // Spacer()
        }
    }
    
    
    //MARK: form switcher section end
    
    
}

struct GuidedCartView_Previews: PreviewProvider {
    static var previews: some View {
        GuidedCartView()
    }
}


//MARK: put these in separate files and sub-views to make more maintainable start

struct ModeSelectorFormView : View{
    
    /// Mode selector properties start
    @State private var selection : String = "Search"
    @State var actions = ["Add","Return", "Remove", "Search", "Transfer Box"]
    
    /// Mode selector properties end
    
    var body: some View{
        VStack(alignment: .center,spacing: 5){
            title_instruction_section
            
            MenuStyleClicker(selection: self.$selection, actions: self.$actions,label: "Mode",label_action: self.$selection).frame(width: 200)
            
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

//MARK: put these in separate files and sub-views to make more maintainable end


///Captures barcodes using, CSV, Manual or Barcode Scanner start
struct CartDataCaptureFormView : View{
    
    @State private var entry_selection : String = "Scan"
    @State var entry_modes = ["Scan", "CSV", "Manual"]
    
    //scanner mode
    @State private var scanner_selection : String = "Camera"
    @State var scanner_modes = ["Camera","Barcode Scanner"]
    
    
    ///Barcode scanner properties start
    @State var show_barcode_scanner : Bool = false
    @State var target_barcodes : [String] = [String]()
    @State var current_barcode : String = ""//esg_e01_19w_0002"//remove after testin
    @State var show_barcode_scanner_btn : Bool = false
    @State var maximizeListSpace : Bool = false
    
    
    ///Barcode scanner properties end
    var body: some View{
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
                                        
                                        Section{
                                            scanner_mode_section
                                            //MARK: Still make this visible
                                            
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
                        //}
                    }
                }
            }
            //MARK: show the barcode capture mode forms or controls here
            start_scanner_capture
            
            barcodes_to_query_section
            
#warning("TODO next to allow capture barcodes")
            //MARK: In manual Mode use autocomplete text by fetching all the barcodes when i am on this page then filtering through the list like I do with Maine Road condition app to find the barcode, if none found say it was not found would you like to add it to the system (search after 4 second delay and animate to iindicate it is loading
            //https://www.google.com/search?q=autocomplete+textfield+swiftui&ie=UTF-8&oe=UTF-8&hl=en-us&client=safari
            
            
            Spacer()
            
        }
    }
}

extension CartDataCaptureFormView{
    
    
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
                MenuStyleClicker(selection: self.$entry_selection, actions: self.$entry_modes,label: "Entry Mode",label_action: self.$entry_selection).frame(width: 200)
                
                
            }
        }
    }
    
    private var scanner_mode_section : some View{
        
        Section{
            title_instruction_section
            
            HStack{
                MenuStyleClicker(selection: self.$scanner_selection, actions: self.$scanner_modes,label: "Which Scanner are you using?",label_action: self.$scanner_selection,reverseTxtOrder: true).frame(width: 200)
                
                
            }
        }
    }
    
    
}

///Captures barcodes using, CSV, Manual or Barcode Scanner end

///Shows the freezers available in the Cart view for Remove, Search, Transfer etc
struct FreezerCartFormView : View{
    var body: some View{
        Text("Freezers Available Form")
    }
}


///Shows the rack available for a target freezer in the Cart view for Remove, Search, Transfer etc
struct RackCartFormView : View{
    var body: some View{
        Text("Racks Available Form")
    }
}


///Shows the box available for a target rack in the Cart view for Remove, Search, Transfer etc
///When the box is clicked it goes into the box and shows all the samples where the add, remove, search process will be complete
///If is the transfer process it will allow the user to click to see in a box (to see what is in it) and from the box level click transfer, then select the target freezer -> rack
///the box should be transfered to
struct BoxCartFormView : View{
    var body: some View{
        Text("Box Available Form")
    }
}



//put in its own class

struct BarcodeListView : View{
    @Binding var target_barcodes : [String]
    
    @StateObject var cart_vm : CartViewModel = CartViewModel()
    @State var show_guided_steps : Bool = false
    
    @State var show_sample_detail : Bool = false
    
    @State var show_edit_list : Bool = false
    
    @Binding var maximizeListSpace : Bool
    
    var body: some View{
        
        
        
        ZStack{
            VStack{
                //Edit mode to be able to swipe because of the swipe problem
                if target_barcodes.count > 0{
                    withAnimation(.easeOut){
                        edit_expand_barcode_list_section
                            .padding(.horizontal)
                            .padding(.bottom)
                    }
                }
                //Edit btn end
                
                // Text("Target Barcodes").bold()
                //Add swipe left to delete
                //swipe right to get details about the target barcode (search the db to find data on it)
                
                List( self.target_barcodes, id: \.self){barcode in
                    
                    HStack{
                        Text("\(barcode)")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                        /* if self.show_guided_steps{
                         withAnimation(.easeInOut){
                         Image(systemName: (self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode}) != nil) ? "checkmark.circle" : "xmark.circle")
                         .foregroundColor(((self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode})) != nil) ? Color.green : Color.red)
                         }
                         
                         }*/
                        
                    }
                    /* .swipeActions(edge: .leading){
                     Button(action: {
                     
                     
                     
                     cart_vm.FetchSingleInventoryLocation(_sample_barcode: barcode,_isAddToListMode: false)
                     
                     self.show_sample_detail.toggle()
                     }, label:{
                     HStack{
                     Image(systemName: "info.circle")
                     
                     }
                     }).tint(.blue)
                     
                     
                     
                     }
                     .swipeActions(edge: .trailing) {
                     Button(action: {
                     //remove from list
                     if let target_code = self.target_barcodes.firstIndex(of: barcode)
                     {
                     print("Index \(target_code)")
                     self.target_barcodes.remove(at: target_code)
                     }
                     //    let box_sample : InventorySampleModel = freezer_box_sample_locals.filter{log in return log.freezer_inventory_slug == _freezer_inventory_slug}.first!//results from the db
                     }, label:{
                     HStack{
                     Image(systemName: "trash")
                     
                     }
                     }).tint(.red)
                     
                     }*/
                }
                
                .listStyle(.plain)
                //.animation(.spring(), value: 2)
                //  .padding(.horizontal,10)
                
            }
        }.background(
            
            NavigationLink(isActive: $show_edit_list, destination: {
                EditBarcodeListView(target_barcodes: $target_barcodes)
            }, label: {
                EmptyView()
            })
        )
        
        
        
        
    }
}

extension BarcodeListView{
    
    private var edit_expand_barcode_list_section : some View{
        HStack(spacing: 10){
            Spacer()
            
            
            Button {
                //action
                self.maximizeListSpace.toggle()
                
            } label: {
                HStack{
                    Image(systemName: self.maximizeListSpace == true ? "rectangle.arrowtriangle.2.inward":"rectangle.expand.vertical")
                    Text("List")
                }.roundButtonStyle()
            }
            
            Button {
                //open edit modal
                self.show_edit_list.toggle()
            } label: {
                HStack{
                    Image(systemName: "pencil")
                    Text("Barcodes")
                }.roundButtonStyle()
            }
            
        }
    }
    
}

//MARK: Add to its own View

struct EditBarcodeListView : View{
    //May want to show more details to track with the barcode number
    @Binding var target_barcodes : [String]
    
    @StateObject var cart_vm : CartViewModel = CartViewModel()
    @State var show_guided_steps : Bool = false
    
    @State var show_sample_detail : Bool = false
    
    var body: some View{
        ZStack{
        VStack{
            
            List( self.target_barcodes, id: \.self){barcode in
                
                HStack{
                    Text("\(barcode)")
                        .font(.subheadline)
                        .foregroundColor(Color.primary)
                    if self.show_guided_steps{
                        withAnimation(.easeInOut){
                            Image(systemName: (self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode}) != nil) ? "checkmark.circle" : "xmark.circle")
                                .foregroundColor(((self.cart_vm.inventoryLocations.first(where: {$0.sampleBarcode == barcode})) != nil) ? Color.green : Color.red)
                        }
                        
                    }
                    
                }
                .swipeActions(edge: .leading){
                    Button(action: {
                        
                        
                        
                        cart_vm.FetchSingleInventoryLocation(_sample_barcode: barcode,_isAddToListMode: false)
                        
                        self.show_sample_detail.toggle()
                    }, label:{
                        HStack{
                            Image(systemName: "info.circle")
                            
                        }
                    }).tint(.blue)
                    
                    
                    
                }
                .swipeActions(edge: .trailing) {
                    Button(action: {
                        //remove from list
                        if let target_code = self.target_barcodes.firstIndex(of: barcode)
                        {
                            print("Index \(target_code)")
                            self.target_barcodes.remove(at: target_code)
                        }
                        //    let box_sample : InventorySampleModel = freezer_box_sample_locals.filter{log in return log.freezer_inventory_slug == _freezer_inventory_slug}.first!//results from the db
                    }, label:{
                        HStack{
                            Image(systemName: "trash")
                            
                        }
                    }).tint(.red)
                    
                }
            }
            
            .listStyle(.plain)
            //.animation(.spring(), value: 2)
            //  .padding(.horizontal,10)
        }
        }.background(
            NavigationLink(isActive: $show_sample_detail, destination: {
                ResultsPreviewView(inventoryLocation: $cart_vm.inventoryLocation)
            }, label: {
                EmptyView()
            })
        )
        .navigationTitle("Edit Barcode List")
    }
}
