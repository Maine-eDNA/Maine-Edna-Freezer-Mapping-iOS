//
//  SampleCheckOutLogCard.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//

import SwiftUI

struct SampleCheckOutLogCard: View {
    
    var log : FreezerCheckOutLogModel
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment: .leading){
                        Text("Check Out").font(.title3).bold()
                        Text("\(log.freezer_checkout_datetime)").font(.body)
                    }
                    
                    VStack(alignment: .leading){
                        Text("Volumne Taken").font(.title3).bold()
                        Text("\(String(log.freezer_return_vol_taken))").font(.body)
                    }
                    VStack(alignment: .leading){
                        Text("Unit").font(.title3).bold()
                        Text("\(log.freezer_return_vol_units)").font(.body)
                    }
                   
                }
                HStack{
                    Text("by").font(.caption).bold()
                    Text("\(log.created_by)").font(.body)
                }
               /* VStack(alignment: .leading){
                    Text("Notes").font(.title3).bold()
                    Text("\(String(log.freezer_log_notes.prefix(100)))").font(.body)
                }*/
            }
        }
    }
}

struct SampleCheckOutLogCard_Previews: PreviewProvider {
    static var previews: some View {
        SampleCheckOutLogCard(log: FreezerCheckOutLogModel())
    }
}
