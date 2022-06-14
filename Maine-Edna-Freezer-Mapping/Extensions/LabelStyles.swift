//
//  LabelStyles.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 5/24/22.
//

import Foundation
import SwiftUI


//Secondary Label Style Start
struct SecondaryLabel: ViewModifier {
   
    
    func body(content: Content) -> some View {
        content
            .font(.subheadline).foregroundColor(Color.theme.secondaryText)
    }
}

extension View {
    func secondaryLabelStyle() -> some View {
        self.modifier(SecondaryLabel())
    }
}

//Secondary Label Style End
//

//Primary Label Title3 Font Start
struct PrimaryLabelTitle3Font: ViewModifier {
   
    
    func body(content: Content) -> some View {
        content
            .font(.title3).foregroundColor(Color.primary)
    }
}

extension View {
    func primaryLabelTitle3() -> some View {
        self.modifier(PrimaryLabelTitle3Font())
    }
}


//Primary Label Title3 Font End
