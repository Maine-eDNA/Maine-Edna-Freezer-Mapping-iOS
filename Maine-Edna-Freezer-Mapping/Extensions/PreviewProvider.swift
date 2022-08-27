//
//  PreviewProvider.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/9/21.
//

import Foundation
import SwiftUI

//Preview data to use throughtout the app as singletons
extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
    static var device : PreviewDevices{
        return PreviewDevices.instance
    }
    
}

//preview device names and layouts --start


struct ScreenPreview<Screen: View>: View {
    var screen: Screen

    var body: some View {
        //MARK: Resource intensive , more efficient to show only the configs you require
       /* ForEach(deviceNames, id: \.self) { device in
           // ForEach(ColorScheme.allCases, id: \.self) { scheme in
                NavigationView {
                    self.screen
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                }
                .previewDevice(PreviewDevice(rawValue: device))
              //  .colorScheme(scheme)
                //.previewDisplayName("\(scheme.previewName): \(device)")
               // .navigationViewStyle(StackNavigationViewStyle())
         //   }
        }*/
        Group{
            NavigationView {
                self.screen
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro"))
                
                self.screen
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .previewDevice(PreviewDevice(rawValue: "iPad Air (4th generation)"))
                
                self.screen
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (4th generation)"))
            }
            
        }
        
    }

    private var deviceNames: [String] {
        [
           // "iPhone 8",
            "iPhone 13",
            "iPhone 13 Pro",
            //"iPhone 13 Pro Max",
            "iPad Air (4th generation)",
            "iPad Pro (12.9-inch) (4th generation)"
        ]
    }
}

extension View {
    func previewAsScreen() -> some View {
        ScreenPreview(screen: self)
    }
}

//preview device names and layouts --end


//Store all the constant values into the core data
//MARK: /api/utility/choices_vol_units/
//store this in the system


class PreviewDevices{
    static let instance = PreviewDevices()
    private init() { }
    
    //enum option to get the devices
    
    enum Devices : String{
        case iphone8 = "iPhone 8"
        case iphone13 = "iPhone 13"
        case iphone13Pro = "iPhone 13 Pro"
        case iphone13ProMax = "iPhone 13 Pro Max"
        case ipadAir4th = "iPad Air (4th generation)"
        case ipadPro12inch4th = "iPad Pro (12.9-inch) (4th generation)"
    
    }
    
    //get the devices as static string

    let iphone13 = "iPhone 13"
    let iphone13Pro = "iPhone 13 Pro"
    let iphone13ProMax = "iPhone 13 Pro Max"
    let ipadAir4th = "iPad Air (4th generation)"
    let ipadPro12inch4th = "iPad Pro (12.9-inch) (4th generation)"
    
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }
    
    let dashboardVM = DashboardViewModel()
    
    let returnMetaDataResult = FreezerInventoryReturnMetaDataResults(freezerReturnSlug: "20211230_175110_Return_filter-esg_e01_19w_0001", freezerReturnMetadataEntered: "no", freezerReturnActions: ["qpcr","lib_prep"], freezerReturnVolTaken: "10", freezerReturnVolUnits: "microliter", freezerReturnNotes: "Testing of the notes", freezerLog: "Testing of the notes", createdBy: "keijaoh campbell", createdDatetime: "12/12/2022", modifiedDatetime: "12/12/2022")
    
    
   /* var freezer_profile = FreezerProfileModel()
    freezer_profile.freezerLabel =
    freezer_profile.freezerDepth = "10"
    freezer_profile.freezerLength = "110"
    freezer_profile.freezerCapacityColumns = 10
    freezer_profile.freezerCapacityRows = 10
    freezer_profile.freezerRoomName = "Murray 313"*/
    let freezerProfile = FreezerProfileModel(id: 1, freezerLength: "100", freezerWidth: "100", freezerLabel: "Test Freezer 1", freezerLabelSlug: "Test_Freezer_1", freezerRoomName: "213 Murray Hall", freezerDepth: "3", freezerDimensionUnits: "feet", freezerRatedTempUnits: "Farenheit", createdBy: "keijaoh.campbell@maine.edu", createdDatetime: "04/04/2022", modifiedDatetime: "04/04/2022", freezerCapacityColumns: 10, freezerCapacityRows: 10, freezerCapacityDepth: 5, freezerRatedTemp: -20)
    
    
    let inventoryLocationResult = InventoryLocationResult(id: 1, freezerLabel: "Test_Freezer_1",freezerRoomName: "Murray 213", sampleBarcode: "esg_e01_19w_0001", freezerInventorySlug: "filter-esg_e01_19w_0001", freezerInventoryType: "filter", freezerInventoryStatus: "In Stock", freezerInventoryColumn: 1, freezerInventoryRow: 1, freezerBox: BoxModel(id: 1, freezer_box_label: "test_box3", freezer_box_label_slug: "test_freezer_1_test_rack3_test_box3", freezer_box_column: 1, freezer_box_row: 3, freezer_box_depth: 1, freezer_box_capacity_column: 10, freezer_box_capacity_row: 10, freezer_rack: RackModel(freezer_rack_label: "test_rack3"), created_by: "keijaoh.campbell@maine.edu", created_datetime: "04/14/2022", modified_datetime: "04/14/2022"), createdBy: "04/14/2022", createdDatetime: "04/14/2022", modifiedDatetime: "04/14/2022", isHighlighed: true)
    
    
    let targetBarcodes : [String] = [
        "esg_e01_19w_0001",
        "esg_e01_19w_0002",
        "esg_e01_19w_0003",
        "esg_e01_19w_0004",
        "esg_e01_19w_0005",
        "esg_e01_19w_0006",
    
    ]
    
    let sampleBarcodesToRemove : [String] = [
        "esg_e01_19w_0001",
        "esg_e01_19w_0002",
        "esg_e01_19w_0003",
        "esg_e01_19w_0004",
        "esg_e01_19w_0005",
        "esg_e01_19w_0006",
    
    ]
 
}

