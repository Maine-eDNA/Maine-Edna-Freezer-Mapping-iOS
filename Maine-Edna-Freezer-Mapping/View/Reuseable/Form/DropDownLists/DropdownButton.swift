//
//  DropdownButton.swift
//  Gurenter-LandLord
//
//  Created by Keijaoh Campbell on 1/13/21.
//

import SwiftUI

struct DropdownButton: View {
    @State var shouldShowDropdown = false
    @Binding var displayText: String
    var dropdownCornerRadius : CGFloat = 10
    var options: [DropdownOption]
    var onSelect: ((_ key: String) -> Void)?

    let buttonHeight: CGFloat = 30
    var body: some View {
        Button(action: {
            self.shouldShowDropdown.toggle()
        }) {
            HStack {
                Text(displayText).foregroundColor(.black)
                Spacer()
                    .frame(width: 20)
                Image(systemName: self.shouldShowDropdown ? "chevron.up" : "chevron.down").foregroundColor(.black)
            }
        }
        .padding(.horizontal)
        .cornerRadius(dropdownCornerRadius)
        .frame(height: self.buttonHeight)
        .overlay(
            RoundedRectangle(cornerRadius: dropdownCornerRadius)
                .stroke(Color.black, lineWidth: 1)
        )
        .overlay(
            VStack {
                if self.shouldShowDropdown {
                    Spacer(minLength: buttonHeight + 10)
                    Dropdown(options: self.options, onSelect: self.onSelect)
                }
            }, alignment: .topLeading
        )
        .background(
            RoundedRectangle(cornerRadius: dropdownCornerRadius).fill(Color.white)
        )
    }
}

struct DropdownOption: Hashable {
    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }

    var key: String
    var val: String
}

struct DropdownOptionElement: View {
    var val: String
    var key: String
    var onSelect: ((_ key: String) -> Void)?

    var body: some View {
        VStack{
            Divider()
        Button(action: {
            if let onSelect = self.onSelect {
                onSelect(self.key)
            }
        }) {
            Text(self.val).foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .frame(minWidth: 100, maxWidth: 300)
        .background(Color.secondary)
            
        }
    }
}

struct Dropdown: View {
    var options: [DropdownOption]
    var dropdownCornerRadius : CGFloat = 10
    var onSelect: ((_ key: String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(self.options, id: \.self) { option in
                DropdownOptionElement(val: option.val, key: option.key, onSelect: self.onSelect)
            }
        }

        .background(Color.white)
        .cornerRadius(dropdownCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: dropdownCornerRadius)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }
}

struct DropdownButton_Previews: PreviewProvider {
    static let options = [
        DropdownOption(key: "week", val: "This week"), DropdownOption(key: "month", val: "This month"), DropdownOption(key: "year", val: "This year")
    ]

    static let onSelect = { key in
        print(key)
    }

    static var previews: some View {
        Group {
            VStack(alignment: .leading) {
                DropdownButton(displayText: .constant("This month"), options: options, onSelect: onSelect)
            }
            .frame(maxWidth: 200, maxHeight: 200)
            .background(Color.secondary)
            .foregroundColor(Color.green)

            VStack(alignment: .leading) {
                DropdownButton(shouldShowDropdown: true, displayText: .constant("This month"), options: options, onSelect: onSelect)
                Dropdown(options: options, onSelect: onSelect)
            }
            .frame(maxWidth:  200, maxHeight: 200)
            .background(Color.secondary)
            .foregroundColor(Color.green)
        }
    }
}




