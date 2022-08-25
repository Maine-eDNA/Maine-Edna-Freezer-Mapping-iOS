//
//  ResolutionInstructionViewModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/21/22.
//

import Foundation
import Combine
import SwiftUI


class ResolutionInstructionViewModel : ObservableObject{
    
    @Published var moveInstructions : ResolutionInstructionModel = ResolutionInstructionModel(instructionTitle: "Move Samples Instructions", steps: [
    
        ResolutionInstructionStepsModel(stepTitle: "Select Sample", stepDescription: "Select the Sample to be moved."),
        ResolutionInstructionStepsModel(stepTitle: "Destination", stepDescription: "Select the destination of this sample."),
        ResolutionInstructionStepsModel(stepTitle: "Complete", stepDescription: "Press Complete.")
    ])
  
    //suggest instructions
    @Published var suggestMoveInstructions : ResolutionInstructionModel = ResolutionInstructionModel(instructionTitle: "Suggest Move Samples Instructions", steps: [
    
        ResolutionInstructionStepsModel(stepTitle: "Select Sample", stepDescription: "Suggested Sample locations have been highlighted green."),
        ResolutionInstructionStepsModel(stepTitle: "Place in Box", stepDescription: "When placed in box, press the locations to confirm additions have been done."),
        ResolutionInstructionStepsModel(stepTitle: "Complete", stepDescription: "Press Complete.")
    ])
    
    //Remove instructions
    @Published var removeInstructions : ResolutionInstructionModel = ResolutionInstructionModel(instructionTitle: "Remove Samples Instructions", steps: [
    
        ResolutionInstructionStepsModel(stepTitle: "Select Sample", stepDescription: "Select the Sample to be removed."),
        ResolutionInstructionStepsModel(stepTitle: "Complete", stepDescription: "Press Complete")
    ])
  
    
    
    
    private var cancellables = Set<AnyCancellable>()

    
    //MARK: Todo add the saved barcodes to the Coredata Db
    
    init(){
        addSubscribers()
    }
    
    
    func addSubscribers(){
        
        
    }
    

    
}

