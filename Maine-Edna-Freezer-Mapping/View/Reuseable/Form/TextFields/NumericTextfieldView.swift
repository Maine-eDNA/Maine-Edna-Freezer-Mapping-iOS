//
//  NumericTextfieldView.swift
//  Gurenter-LandLord
//
//  Created by Keijaoh Campbell on 3/6/21.
//

import SwiftUI

struct NumericTextfieldView: View {
    @Binding var numericValue : Double
    @State var placeholder : String

      let formatter: NumberFormatter = {
          let formatter = NumberFormatter()
          formatter.numberStyle = .decimal
          return formatter
      }()

      var body: some View {
          VStack {
              TextField(placeholder, value: $numericValue, formatter: formatter)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                  .padding()

              
          }
      }
}

