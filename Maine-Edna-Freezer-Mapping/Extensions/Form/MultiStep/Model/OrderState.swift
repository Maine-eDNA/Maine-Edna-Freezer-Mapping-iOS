//
//  OrderState.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 4/25/23.
//

import Foundation

enum OrderState : String, CaseIterable  {
    case queryMode = "switch.2"
    case entryMode = "text.append"
    case freezerMap = "refrigerator"
    case rackMap = "square.grid.3x3"
    case boxMap = "server.rack"
    case sampleMap = "testtube.2"
    case summaryView = "doc.text"
}


enum ReturnOrderState : String, CaseIterable  {
    case queryMode = "switch.2"
    case sampleReturnBatches = "text.append"
    case sampleMap = "testtube.2"
    case returnGuideMode = "doc.text"
}


enum CartStateVariant {
    case search(OrderState)
    case returnVariant(ReturnOrderState)
}
