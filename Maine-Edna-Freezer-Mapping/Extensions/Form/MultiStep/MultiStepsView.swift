//
//  MultiStepsView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 4/25/23.
//


import Foundation
import SwiftUI

//multistep control

struct MultiStepsView <T, Content: View> : View where T: Swift.CaseIterable {
    @Binding var steps: [T]
    let extraContent : [String]?
    let extraContentPosition : ExtraContentPosition?
    let extraContentSize : CGSize?
    let action : (Int) -> Void
    @ViewBuilder let content: () -> Content
    
    @State var numberOfSteps : Int = 0
    @State var widthOfLastItem = 0.0
    @State var images : [UIImage] = []
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<numberOfSteps, id: \.self) { index in
                    ZStack {
                        HStack(spacing: 0) {
                            VStack {
                                if let extraContent = extraContent, extraContentPosition == .above {
                                    ExtraStepContent(index: index, color: index < steps.count ? .accentColor :.gray, extraContent: extraContent, extraContentSize: extraContentSize)
                                }
                                content().foregroundColor(index < steps.count ? Color.theme.accent :.gray)
                            }
                            if let extraContent = extraContent, extraContentPosition == .inline {
                                ExtraStepContent(index: index, color: index < steps.count ? .accentColor :.gray, extraContent: extraContent, extraContentSize: extraContentSize)
                            }
                        }
                    }.overlay {
                        if let extraContent = extraContent, extraContentPosition == .onTop , index < steps.count {
                            ExtraStepContent(index: index, color: .accentColor, extraContent: extraContent, extraContentSize: extraContentSize)
                        }
                    }
                    .onTapGesture {
                        action(index)
                    }
                }
            }
        }.onAppear() {
            numberOfSteps = type(of: steps).Element.self.allCases.count
        }
    }
}


//needed


enum ExtraContentPosition {
    case above
    case inline
    case onTop
}

//needed

struct ExtraStepContent: View {
    let index : Int
    let color : Color
    let extraContent : [String]
    let extraContentSize : CGSize?
    var body: some View {
        ZStack {
           
                if UIImage(systemName: extraContent[index]) != nil {
                    Image(systemName: extraContent[index])
                } else {
                    Text(extraContent[index])
                }
            
        }
        .foregroundColor(color)
        .frame(width: extraContentSize?.width, height: extraContentSize?.height)
    }
}


//required

extension CaseIterable where Self: Equatable & RawRepresentable {
    var allCases: AllCases { Self.allCases }
    func next() -> Self {
        let index = allCases.firstIndex(of: self)!
        let next = allCases.index(after: index)
        guard next != allCases.endIndex else { return allCases[index] }
        return allCases[next]
    }
    
    func previous() -> Self {
        let index = allCases.firstIndex(of: self)!
        let previous = allCases.index(index, offsetBy: -1)
        guard previous >= allCases.startIndex else { return allCases[index] }
        return allCases[previous]
    }
    
    static var allValues: [RawValue] {
        return allCases.map { $0.rawValue }
    }
}
