//
//  GroupedResultsMapView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 9/15/22.
//

import SwiftUI

struct GroupedResultsMapView: View {
    @Binding var sampleLocationMaps : [SearchModeSampleMapModel]
    var body: some View {
        #warning("TODO this screen next that shows highlighted Freezer -> Rack -> Box (grouped)")
        Text("In This View, All the results a Mapped by Freezer -> Rack -> Box ")
    }
}

struct GroupedResultsMapView_Previews: PreviewProvider {
    static var previews: some View {
        GroupedResultsMapView(sampleLocationMaps: .constant([SearchModeSampleMapModel]()))
    }
}
