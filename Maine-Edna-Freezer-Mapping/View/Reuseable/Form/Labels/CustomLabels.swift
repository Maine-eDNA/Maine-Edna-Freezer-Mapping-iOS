//
//  CustomLabels.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 5/24/22.
//

import Foundation
import SwiftUI



struct LabelTextValueHStack : View{
    
    @Binding var label : String
    @Binding var textValue : String
    
    var body : some View{
        HStack{
            Text(label).secondaryLabelStyle()
            
            Text("\(textValue)").bold().primaryLabelTitle3()
        }
    }
}
