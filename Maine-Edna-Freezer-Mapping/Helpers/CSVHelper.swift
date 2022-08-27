//
//  CSVHelper.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 8/27/22.
//

import Foundation
import TabularData

class CSVHelper{
    
    func importCsvViaUrl(url : String){
        
        do{
            /* let url : String = "https://firebasestorage.googleapis.com/v0/b/keijaoh-576a0.appspot.com/o/testcsv%2FSampleCSVFile_2kb.csv?alt=media&token=6243cbcf-32a8-4bf0-b176-148b8c3fe76e"*/
            let formattingOptions = FormattingOptions(maximumLineWidth: 250, maximumCellWidth: 15, maximumRowCount: 3, includesColumnTypes: false)
            let policies = try DataFrame(contentsOfCSVFile: URL(string: url)!, rows: 0..<5)
            
            print(policies.description(options: formattingOptions))
            
            #warning("Need to extract the data from the csv then display it in the list below (let it just be a list of barcodes")
            
            //Give it modes so that it can capture data from various types
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
}
