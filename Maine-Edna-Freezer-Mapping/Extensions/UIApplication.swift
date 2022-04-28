//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/9/21.
//

import Foundation
import SwiftUI

extension UIApplication {
    //dismiss the keyboard
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
