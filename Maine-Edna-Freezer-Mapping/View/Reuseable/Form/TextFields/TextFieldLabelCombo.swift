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
    @State var isDisabled : Bool = false
    var body: some View {
 
            VStack(alignment: .leading){
                
                Text(label).font(.callout).foregroundColor(.secondary).bold()
                HStack {
                  Image(systemName: iconValue).foregroundColor(.gray)
                    if !isDisabled{
                      TextField(placeHolder, text: $textValue)
                         .modifier(TextFieldClearButton(text: $textValue))
                         .keyboardType(keyboardType)
                         .disableAutocorrection(autoCorrection)
                    }
                    else{
                        TextField(placeHolder, text: $textValue)
                           .keyboardType(keyboardType)
                           .disableAutocorrection(autoCorrection)
                    }
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1).background(isDisabled ? Color.gray.opacity(0.25) : Color.clear.opacity(0.00001)).cornerRadius(10))
                .disabled(isDisabled)
                    
            }//.padding()
    
    }
}

