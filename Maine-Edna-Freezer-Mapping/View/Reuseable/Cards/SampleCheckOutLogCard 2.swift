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
                        Text("\(log.freezer_log_action.uppercased())").font(.title3).bold()
                 
                    }
                
                   
                }
                HStack{
                    Text("Created By").font(.title3).bold()
                    Text("\(log.created_by)").font(.body)
                }
                VStack(alignment: .leading){
                    Text("Notes").font(.title3).bold()
                    Text("\(String(log.freezer_log_notes.prefix(100)))").font(.body)
                }
            }
        }
    }
}

struct SampleCheckOutLogCard_Previews: PreviewProvider {
    static var previews: some View {
        SampleCheckOutLogCard(log: FreezerCheckOutLogModel())
    }
}
