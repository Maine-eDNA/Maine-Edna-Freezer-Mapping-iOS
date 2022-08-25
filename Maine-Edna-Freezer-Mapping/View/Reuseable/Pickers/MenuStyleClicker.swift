//
//  MenuStyleClicker.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/28/21.
//

import SwiftUI
#warning("TODO need to implement the hint list")
struct MenuStyleClicker : View{
    @Binding var selection : String
    @Binding var actions : [String]
    @State var label : String = "Action"
    @Binding var label_action : String
    
    @State var showHintModal : Bool = false
    //MARK: Need to send the details from the calling class as to what the hints are
    @State var hintDetails : [String] = []
    @State var reverseTxtOrder : Bool = false
    
    @Binding var width : CGFloat
    
    var body : some View{
        VStack(alignment: .leading){
            //Continue here
            HStack{
                if !reverseTxtOrder{
                    Text(label_action).font(.subheadline).foregroundColor(.primary).bold()
                    Text(label).font(.callout).foregroundColor(.secondary).bold()
                }
                else{
                    
                    Text(label).font(.callout).foregroundColor(.secondary).bold()
                    Text(label_action).font(.subheadline).foregroundColor(.primary).bold()
                }
               // Spacer()
                Button(action: {
                    //open the modal with the info on what the entry modes mean
                    withAnimation {
                        showHintModal.toggle() //MARK: if iOS 16 use the half modal
                    }
                }) {
                    Image(systemName: "info.circle").foregroundColor(Color.blue)
                }
            }
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
                }).frame(width: width)
                    .pickerStyle(SegmentedPickerStyle()).textFieldStyle(.roundedBorder)
            }.padding(.horizontal,10)
                .padding(.vertical,5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
           
            
        }.sheet(isPresented: $showHintModal){
            VStack{
                Text("Hint details will show here")
            }
        }
    }
}



