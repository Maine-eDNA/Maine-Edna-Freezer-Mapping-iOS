//
//  MultiLineTextFieldLabelCombo.swift
//  Gurenter-LandLord
//
//  Created by Keijaoh Campbell on 1/13/21.
//

import SwiftUI

struct MultiLineTextFieldLabelCombo: View {
    @Binding var textValue : String
    var label : String
    var iconValue : String
    
    var body: some View {
 
            VStack(alignment: .leading){
                
                Text(label).font(.callout).foregroundColor(.secondary).bold()
                HStack {
                  Image(systemName: iconValue).foregroundColor(.gray)
                  TextEditor(text: $textValue)
                    //.textFieldStyle(RoundedBorderTextFieldStyle())
                    //.frame(width: nil, height: 100)
                  }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
            }.padding()
    
    }
}

