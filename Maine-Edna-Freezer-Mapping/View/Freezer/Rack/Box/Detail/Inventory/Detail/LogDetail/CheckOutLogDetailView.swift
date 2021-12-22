//
//  CheckOutLogDetailView.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 12/13/21.
//

import SwiftUI

struct CheckOutLogDetailView: View {
    
    var log : FreezerCheckOutLogModel
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    Text("\(log.freezer_log_action.uppercased())").font(.title2).bold()
             
                }.padding(.bottom,5)
                HStack(alignment: .top){
                   
                     
                    
                       
                 
                    VStack(alignment: .leading){
                        Text("Created By").font(.title3).bold()
                        Text("\(log.created_by)").font(.body)
                   
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Created Date").font(.title3).bold()
                        Text("\(String(log.created_datetime))").font(.body)
                        
                        Text("Modified Date").font(.title3).bold()
                        Text("\(String(log.modified_datetime))").font(.body)
                        
                    }
                }
                
               
                VStack(alignment: .leading){
                    Text("Notes").font(.title3).bold()
                    Text("\(String(log.freezer_log_notes))").font(.body)
                }
            }
      
           
            
            Spacer()
        }.padding()
    }
}

struct CheckOutLogDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutLogDetailView(log: FreezerCheckOutLogModel())
    }
}
