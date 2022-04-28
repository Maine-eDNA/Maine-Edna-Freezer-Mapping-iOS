//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/14/21.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    
    func convertDateFormat(withFormat inputDate: String) -> Date {

        let isoDate = inputDate

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: isoDate)
       
        if let target_date = date{
            print("date: \(target_date)")
            
            return target_date
            
        }
        else{
            return Date()
        }
    }
    
    
   
    
}


/*
 
 func toString(withFormat format: String = "EEEE ، d MMMM yyyy") -> String {

     let dateFormatter = DateFormatter()
     dateFormatter.locale = Locale(identifier: "fa-IR")
     dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
     dateFormatter.calendar = Calendar(identifier: .persian)
     dateFormatter.dateFormat = format
     let str = dateFormatter.string(from: self)

     return str
 }
 */
