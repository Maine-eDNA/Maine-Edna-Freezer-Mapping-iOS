//
//  MenuStyleClicker.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/28/21.
//

import SwiftUI

struct MenuStyleClicker : View{
    @Binding var selection : String
    @Binding var actions : [String]
    @State var label : String = "Action"
    
    var body : some View{
        VStack(alignment: .leading){
            Text(label).font(.callout).foregroundColor(.secondary).bold()

            HStack{
                Picker(selection: self.$selection, label:
                        HStack{
                    Text("\(selection)")
                }.font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(10)
                        //.shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
                     
                       , content: {
                    ForEach(self.actions, id: \.self){
                        action in
                        Text(action)
                            .tag(action)
                    }
                }).frame(width: UIScreen.main.bounds.width * 0.90)
                    .pickerStyle(SegmentedPickerStyle()).textFieldStyle(.roundedBorder)
            }.padding(.horizontal,10)
                .padding(.vertical,5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
           
            
        }
    }
}



