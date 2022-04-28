//
//  HapticManager.swift
//  CryptoPals
//
//  Created by Keijaoh Campbell on 3/16/22.
//

import Foundation
import SwiftUI

class HapticManager{
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type : UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
