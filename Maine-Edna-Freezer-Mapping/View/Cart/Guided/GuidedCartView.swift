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
//MARK: only handles Search (to find and take from freezer) and Return to freezer
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
    ///Multiple batch returns logic
    //MARK: be able to select a batch of samples to be that was taken from a freezer, and merge it with another set
    //because some samples may not be returned at the same time since some will be in a temp freezer
    //so give the option at the begining to select one or more batches, it then will merge all the samples into one big list
    //grouping by freezer, rack and box, then present it to the user giving them the option to remove the ones that isnt being returned at this time and so it will remain in the batch once the process is done. So they can be returned in the future
    
    /// Mode selector properties start
    @State private var selection : String = "Search"
    @State var actions = ["Search","Return"]
    
    /// Mode selector properties end
   
    
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
            #warning("NEXT: Continue here do the Search, then take samples from the freezer and add it to a batch, make the list accessible ")
            VStack {
                TabView(selection: $currentIndex) {
                    ModeSelectorFormView(selection: $selection, actions: $actions)
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






