//
//  ButtonStyles.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 5/24/22.
//

import Foundation
import SwiftUI



struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .padding()
            .background(Color.green)
            .foregroundColor(Color.white)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
    }
}

struct OverlayBackButton: ViewModifier {
    @Environment(\.presentationMode) var presentation
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }) {
                Image(systemName: "chevron.backward") // set image here
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                Text("Back")
                    .foregroundColor(.red)
                }
                .padding()
                ,alignment: .topLeading
            )
    }
}

extension View {
    func overlayBackButton() -> some View {
        self.modifier(OverlayBackButton())
    }
}


//Rounded Button Start

struct RoundButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(Color.primary)
            .padding(.vertical,10)
            .padding(.horizontal,20)
            .background(
            
                Capsule()
                    .stroke(Color.theme.accent,lineWidth: 1)
            )
    }
}

extension View{
    func roundButtonStyle() -> some View{
        self.modifier(RoundButtonStyle())
    }
}

//Rounded Button End

//Rounded Rectangle Button

struct RoundedRectangleButton : ViewModifier{
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(Color.primary)
            .padding(.vertical,10)
            .padding(.horizontal,20)
            .background(
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.theme.accent,lineWidth: 1)
            )
    }
}

extension View{
    
    func roundedRectangleButton() -> some View{
        self.modifier(RoundedRectangleButton())
    }
}



struct ColoredRoundedButtonStyle: ViewModifier {
    
    @Binding var selectedColor : Color
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundColor(Color.white)
            .padding(.vertical,8)
            .padding(.horizontal,15)
            .background(
            
                Capsule()
                    .fill(selectedColor)
                
            )
    }
}

extension View{
    func colorRoundedButtonStyle(selectedColor : Color = .blue) -> some View{
        self.modifier(ColoredRoundedButtonStyle(selectedColor: .constant(selectedColor)))
    }
}
