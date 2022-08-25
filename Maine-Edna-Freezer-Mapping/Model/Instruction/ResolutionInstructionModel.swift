//
//  ResolutionInstructionModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/21/22.
//

import Foundation


class ResolutionInstructionModel{
    
    init(){
        self.instructionTitle = ""
        self.steps = [ResolutionInstructionStepsModel]()
    }
    
    init(instructionTitle : String,steps : [ResolutionInstructionStepsModel] ){
        self.instructionTitle = instructionTitle
        self.steps = steps
    }
    
    var id = UUID()
    var instructionTitle : String = ""
    var steps : [ResolutionInstructionStepsModel] = [ResolutionInstructionStepsModel]()
    
}


class ResolutionInstructionStepsModel{
    
    init(){
        self.stepTitle = ""
        self.stepDescription = ""
        self.stepVideoCode = ""
    }
    
    
    init(stepTitle : String,stepDescription : String ){
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
    
    }
    
    init(stepTitle : String,stepDescription : String, stepVideoCode : String ){
        self.stepTitle = stepTitle
        self.stepDescription = stepDescription
        self.stepVideoCode = stepVideoCode
    
    }
    
    
    var id = UUID()
    var stepTitle : String = ""
    var stepDescription : String = ""
    var stepVideoCode : String = "" //Youtube video code (Optional)
    
}
