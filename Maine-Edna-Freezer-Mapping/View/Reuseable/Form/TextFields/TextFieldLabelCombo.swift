//
//  TextFieldLabelCombo.swift
//  Gurenter-LandLord
//
//  Created by Keijaoh Campbell on 1/12/21.
//

import SwiftUI

struct TextFieldLabelCombo: View {
    @Binding var textValue : String
    var label : String
    var placeHolder : String
    var iconValue : String
    var keyboardType : UIKeyboardType = UIKeyboardType.default
    var autoCorrection : Bool = true
    var body: some View {
 
            VStack(alignment: .leading){
                
                Text(label).font(.callout).foregroundColor(.secondary).bold()
                HStack {
                  Image(systemName: iconValue).foregroundColor(.gray)
                  TextField(placeHolder, text: $textValue)
                    .modifier(TextFieldClearButton(text: $textValue))
                    .keyboardType(keyboardType)
                    .disableAutocorrection(autoCorrection)
                  }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
            }.padding()
    
    }
}


