//
//  SearchModeSampleMapModel.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 9/15/22.
//

import Foundation


///This model is used to re-order the series of steps needed to find where a sample is located
///Freezer -> Rack -> Box -> Sample
struct SearchModeSampleMapModel : Codable{
    
    init(){
        self.freezerProfile = FreezerProfileModel()
        self.rackProfile = RackModel()
        self.boxProfile = BoxModel()
        self.sampleProfile = InventorySampleModel()
    }
    
    init(freezerProfile : FreezerProfileModel,rackProfile : RackModel, boxProfile : BoxModel, sampleProfile : InventorySampleModel ){
        self.freezerProfile = freezerProfile
        self.rackProfile = rackProfile
        self.boxProfile = boxProfile
        self.sampleProfile = sampleProfile
    }
    
    var id = UUID()
    
    var freezerProfile : FreezerProfileModel = FreezerProfileModel()
    var rackProfile : RackModel = RackModel()
    var boxProfile : BoxModel = BoxModel()
    var sampleProfile : InventorySampleModel = InventorySampleModel()
    
}
