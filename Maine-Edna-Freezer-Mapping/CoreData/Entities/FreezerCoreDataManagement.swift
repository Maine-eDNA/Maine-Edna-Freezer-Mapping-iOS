//
//  FreezerCoreDataManagement.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 2/24/22.
//


import SwiftUI
import CoreData


class FreezerCoreDataManagement : ObservableObject{
    
    //set up container
    let container : NSPersistentContainer
    
    
    @Published var addNewFreezer = false
    //save the freezer and link the rack layouts to it
    @Published var freezer_entities : [FreezerEntity] = []
    
    init(){
        //setting up Coredata  FreezerEdnaContainer
        container = NSPersistentContainer(name: "FreezerEdnaContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error Loading Core Data. \(error)")
            }
            
        }
        fetchAllFreezers()
        
    }
    
    /* func fetchAllFreeezerByDate(_targetDate : Date){
     //Research Generics
     let request = NSFetchRequest<FreezerEntity>(entityName: "FreezerEdnaContainer")
     
     do{
     //save the result
     let localFreezerEntities =  try container.viewContext.fetch(request)
     print("Today \(_targetDate)")
     //print(localSavedTodoListEntities.first)
     // MARK: Predicate to Filter current date Tasks
     let calendar = Calendar.current
     
     let today = calendar.startOfDay(for: _targetDate)
     let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
     //filter
     //   let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorow])
     
     freezer_entities = localFreezerEntities.filter{$0.taskDate!  >= today && $0.taskDate! < tommorow}
     
     print(freezer_entities.count)
     }
     catch let error{
     print("Error fetching. \(error)")
     }
     
     
     }*/
    
    func fetchAllFreezers(){
        //Research Generics
        let request = NSFetchRequest<FreezerEntity>(entityName: "FreezerEntity")
        
        do{
            //save the result
            freezer_entities =  try container.viewContext.fetch(request)
            
            print(freezer_entities.count)
        }
        catch let error{
            print("Error fetching. \(error)")
        }
        
        
    }
    func createNewFreezerCoreModel(_freeezerCoreModel : FreezerEntity){
        
        
        var newFreezer = FreezerEntity(context: container.viewContext)
        //add to the reusable obj
        newFreezer = _freeezerCoreModel
        
        saveFreezerData()
        
    }
    
    func createNewTodoItem(_freezerDetail : FreezerEntity){
        var newFreezer = FreezerEntity(context: container.viewContext)
        
        
        newFreezer.id = _freezerDetail.id
        
        newFreezer.freezerLength = _freezerDetail.freezerLength
        newFreezer.freezerWidth = _freezerDetail.freezerWidth
        newFreezer.freezerLabel = _freezerDetail.freezerLabel
        newFreezer.freezerLabelSlug = _freezerDetail.freezerLabelSlug
        newFreezer.freezerRoomName = _freezerDetail.freezerRoomName
        newFreezer.freezerDepth = _freezerDetail.freezerDepth
        newFreezer.freezerDimensionUnits = _freezerDetail.freezerDimensionUnits
        
        newFreezer.freezerCapacityColumns = _freezerDetail.freezerCapacityColumns
        newFreezer.freezerCapacityRows = _freezerDetail.freezerCapacityRows
        newFreezer.freezerCapacityDepth = _freezerDetail.freezerCapacityDepth
        newFreezer.freezerRatedTempUnits = _freezerDetail.freezerRatedTempUnits
        newFreezer.createdBy = _freezerDetail.createdBy
        newFreezer.createdDatetime = _freezerDetail.createdDatetime
        newFreezer.modifiedDatetime = _freezerDetail.modifiedDatetime
        
        saveFreezerData()
        
        //TODO: save the data I just saved to the server for back up
        
    }
    
    func translateFreezerModelToEntity(_freezerDetail : FreezerProfileModel) -> FreezerEntity
    {
        var newFreezer = FreezerEntity(context: container.viewContext)
        
        
        if let id = _freezerDetail.id{
            newFreezer.id = Int32(id)
        }
        
        newFreezer.freezerLength = _freezerDetail.freezerLength
        newFreezer.freezerWidth = _freezerDetail.freezerWidth
        newFreezer.freezerLabel = _freezerDetail.freezerLabel
        newFreezer.freezerLabelSlug = _freezerDetail.freezerLabelSlug
        newFreezer.freezerRoomName = _freezerDetail.freezerRoomName
        newFreezer.freezerDepth = _freezerDetail.freezerDepth
        newFreezer.freezerDimensionUnits = _freezerDetail.freezerDimensionUnits
        
        if let capacity_col = _freezerDetail.freezerCapacityColumns{
            newFreezer.freezerCapacityColumns = Int32(capacity_col)
        }
        
        if let capacity_rows = _freezerDetail.freezerCapacityRows{
            newFreezer.freezerCapacityRows = Int32(capacity_rows)
        }
        if let capacity_depth = _freezerDetail.freezerCapacityDepth{
            newFreezer.freezerCapacityDepth = Int32(capacity_depth)
        }
        
        newFreezer.freezerRatedTempUnits = _freezerDetail.freezerRatedTempUnits
        newFreezer.createdBy = _freezerDetail.createdBy
        newFreezer.createdDatetime = _freezerDetail.createdDatetime
        newFreezer.modifiedDatetime = _freezerDetail.modifiedDatetime
        
        return newFreezer
        
        
    }
    
    func translateFreezerEntityToModel(_freezerDetail : FreezerEntity) -> FreezerProfileModel
    {
        var newFreezer = FreezerProfileModel()
        
        
        
        newFreezer.id = Int(_freezerDetail.id)
        
        
        newFreezer.freezerLength = _freezerDetail.freezerLength
        newFreezer.freezerWidth = _freezerDetail.freezerWidth
        newFreezer.freezerLabel = _freezerDetail.freezerLabel
        newFreezer.freezerLabelSlug = _freezerDetail.freezerLabelSlug
        newFreezer.freezerRoomName = _freezerDetail.freezerRoomName
        newFreezer.freezerDepth = _freezerDetail.freezerDepth
        newFreezer.freezerDimensionUnits = _freezerDetail.freezerDimensionUnits
        
        
        newFreezer.freezerCapacityColumns = Int(_freezerDetail.freezerCapacityColumns)
        
        
        newFreezer.freezerCapacityRows = Int(_freezerDetail.freezerCapacityRows)
        
        
        newFreezer.freezerCapacityDepth = Int(_freezerDetail.freezerCapacityDepth)
        
        
        newFreezer.freezerRatedTempUnits = _freezerDetail.freezerRatedTempUnits
        newFreezer.createdBy = _freezerDetail.createdBy
        newFreezer.createdDatetime = _freezerDetail.createdDatetime
        newFreezer.modifiedDatetime = _freezerDetail.modifiedDatetime
        
        return newFreezer
        
        
    }
    
    
    func saveFreezerData(){
        do{
            try container.viewContext.save()
            
            //after saved data update the todo list by fetching the latest
            //get latest for current date
            fetchAllFreezers()
            
            
        }
        catch let error{
            print("Error saving. \(error)")
        }
    }
    
    //delete and update function
    func deleteFreezerItem(indexSet: IndexSet){
        guard let index = indexSet.first else{return}
        let entity = freezer_entities[index]
        container.viewContext.delete(entity)
        saveFreezerData()
        
    }
#warning("TODO soon")
    func updateFreezer(entity : FreezerEntity){
        
        //all attributes
        let currentfreezerLabel = entity.freezerLabel
        
        let newTitle = "new value"
        
        entity.freezerLabel = newTitle
        
        saveFreezerData()
        
    }
    
}


public extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
}

