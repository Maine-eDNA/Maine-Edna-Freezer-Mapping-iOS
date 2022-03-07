//
//  UserCssThemeCoreDataManagement.swift
//  Maine-Edna-Freezer-Mapping
//
//  Created by Keijaoh Campbell on 2/24/22.
//show list of themes and the user can select a theme


import SwiftUI
import CoreData


class UserCssThemeCoreDataManagement : ObservableObject{
    
    //user id to find the theme
    @AppStorage(AppStorageNames.stored_user_id.rawValue)  var stored_user_id : Int = 0
    
    //set up container
    let container : NSPersistentContainer
    
    
    @Published var addNewFreezer = false
    //save the freezer and link the rack layouts to it
    @Published var user_css_entities : [UserCssThemeEntity] = []
    @Published var user_css_entity : UserCssThemeEntity = UserCssThemeEntity()
    
    init(){
        //setting up Coredata  FreezerEdnaContainer
        container = NSPersistentContainer(name: "FreezerEdnaContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error Loading Core Data. \(error)")
            }
            
        }
        fetchTargetUserCssById(_userCssId: stored_user_id)
        fetchAllUserCssThemes()
        
    }
    
    ///Need to add the ability to fetch the default theme where isDefault is true
    func fetchTargetUserCssById(_userCssId : Int){
     //Research Generics
     let request = NSFetchRequest<UserCssThemeEntity>(entityName: "UserCssThemeEntity")
     
     do{
     //save the result
     let localUserCssEntities =  try container.viewContext.fetch(request)

        
     
 
     //filter
     //   let predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@", argumentArray: [today,tommorow])
     
         if let user_css = localUserCssEntities.first(where: {$0.id  == _userCssId}){
             user_css_entity = user_css
         }
     

     }
     catch let error{
     print("Error fetching. \(error)")
     }
     
     
     }
    
    func fetchAllUserCssThemes(){
        //Research Generics
        let request = NSFetchRequest<UserCssThemeEntity>(entityName: "UserCssThemeEntity")
        
        do{
            //save the result
            user_css_entities =  try container.viewContext.fetch(request)
            
            print(user_css_entities.count)
        }
        catch let error{
            print("Error fetching. \(error)")
        }
        
        
    }
    func createNewUserCssThemeCoreModel(_userCssThemeCoreModel : UserCssThemeEntity){
        
        
        var userCssTheme = UserCssThemeEntity(context: container.viewContext)
        //add to the reusable obj
        userCssTheme = _userCssThemeCoreModel
        
        saveUserCssThemeData()
        
    }
    
    func createNewUserCssTheme(_userCssDetail : UserCssModel){
        let userCssTheme = UserCssThemeEntity(context: container.viewContext)
        
        
 
       // userCssTheme.id = _userCssDetail.id
 
    
        userCssTheme.custom_css_label =  _userCssDetail.custom_css_label
    
       
        userCssTheme.user =   _userCssDetail.user

        userCssTheme.created_by =   _userCssDetail.created_by
      
        userCssTheme.created_datetime =   _userCssDetail.created_datetime

        userCssTheme.default_css_label =   _userCssDetail.default_css_label
     
        userCssTheme.css_selected_background_color =   _userCssDetail.css_selected_background_color
  
        userCssTheme.css_selected_text_color =  _userCssDetail.css_selected_text_color

        userCssTheme.freezer_empty_css_background_color =  _userCssDetail.freezer_empty_css_background_color
        
        userCssTheme.freezer_empty_css_text_color =  _userCssDetail.freezer_empty_css_text_color

        userCssTheme.freezer_inuse_css_background_color =  _userCssDetail.freezer_inuse_css_background_color

        userCssTheme.freezer_inuse_css_text_color =  _userCssDetail.freezer_inuse_css_text_color
 
        userCssTheme.freezer_empty_rack_css_background_color =  _userCssDetail.freezer_empty_rack_css_background_color

        userCssTheme.freezer_empty_rack_css_text_color =  _userCssDetail.freezer_empty_rack_css_text_color

        userCssTheme.freezer_inuse_rack_css_background_color =  _userCssDetail.freezer_inuse_rack_css_background_color

        userCssTheme.freezer_empty_box_css_background_color =  _userCssDetail.freezer_empty_box_css_background_color

        userCssTheme.freezer_empty_box_css_text_color =  _userCssDetail.freezer_empty_box_css_text_color
   
        userCssTheme.freezer_inuse_box_css_background_color =  _userCssDetail.freezer_inuse_box_css_background_color

        userCssTheme.freezer_inuse_box_css_text_color =  _userCssDetail.freezer_inuse_box_css_text_color

        userCssTheme.freezer_empty_inventory_css_background_color =  _userCssDetail.freezer_empty_inventory_css_background_color
    
        userCssTheme.freezer_empty_inventory_css_text_color =  _userCssDetail.freezer_empty_inventory_css_text_color
 
        userCssTheme.freezer_inuse_inventory_css_background_color =  _userCssDetail.freezer_inuse_inventory_css_background_color

        userCssTheme.freezer_inuse_inventory_css_text_color =  _userCssDetail.freezer_inuse_inventory_css_text_color

        userCssTheme.created_by =  _userCssDetail.created_by

        userCssTheme.created_datetime =  _userCssDetail.created_datetime

        userCssTheme.modified_datetime =  _userCssDetail.modified_datetime

        userCssTheme.freezer_inuse_rack_css_text_color =  _userCssDetail.freezer_inuse_rack_css_text_color

        
        

        saveUserCssThemeData()
        
        //TODO: save the data I just saved to the server for back up
        
    }
    
    func translateFreezerModelToEntity(_userCssDetail : UserCssModel) -> UserCssThemeEntity
    {
        let userCssTheme = UserCssThemeEntity(context: container.viewContext)
        
        
            userCssTheme.custom_css_label =  _userCssDetail.custom_css_label
        
           
            userCssTheme.user =   _userCssDetail.user

            userCssTheme.created_by =   _userCssDetail.created_by
          
            userCssTheme.created_datetime =   _userCssDetail.created_datetime

            userCssTheme.default_css_label =   _userCssDetail.default_css_label
         
            userCssTheme.css_selected_background_color =   _userCssDetail.css_selected_background_color
      
            userCssTheme.css_selected_text_color =  _userCssDetail.css_selected_text_color

            userCssTheme.freezer_empty_css_background_color =  _userCssDetail.freezer_empty_css_background_color
            
            userCssTheme.freezer_empty_css_text_color =  _userCssDetail.freezer_empty_css_text_color

            userCssTheme.freezer_inuse_css_background_color =  _userCssDetail.freezer_inuse_css_background_color

            userCssTheme.freezer_inuse_css_text_color =  _userCssDetail.freezer_inuse_css_text_color
     
            userCssTheme.freezer_empty_rack_css_background_color =  _userCssDetail.freezer_empty_rack_css_background_color

            userCssTheme.freezer_empty_rack_css_text_color =  _userCssDetail.freezer_empty_rack_css_text_color

            userCssTheme.freezer_inuse_rack_css_background_color =  _userCssDetail.freezer_inuse_rack_css_background_color

            userCssTheme.freezer_empty_box_css_background_color =  _userCssDetail.freezer_empty_box_css_background_color

            userCssTheme.freezer_empty_box_css_text_color =  _userCssDetail.freezer_empty_box_css_text_color
       
            userCssTheme.freezer_inuse_box_css_background_color =  _userCssDetail.freezer_inuse_box_css_background_color

            userCssTheme.freezer_inuse_box_css_text_color =  _userCssDetail.freezer_inuse_box_css_text_color

            userCssTheme.freezer_empty_inventory_css_background_color =  _userCssDetail.freezer_empty_inventory_css_background_color
        
            userCssTheme.freezer_empty_inventory_css_text_color =  _userCssDetail.freezer_empty_inventory_css_text_color
     
            userCssTheme.freezer_inuse_inventory_css_background_color =  _userCssDetail.freezer_inuse_inventory_css_background_color

            userCssTheme.freezer_inuse_inventory_css_text_color =  _userCssDetail.freezer_inuse_inventory_css_text_color

            userCssTheme.created_by =  _userCssDetail.created_by

            userCssTheme.created_datetime =  _userCssDetail.created_datetime

            userCssTheme.modified_datetime =  _userCssDetail.modified_datetime

            userCssTheme.freezer_inuse_rack_css_text_color =  _userCssDetail.freezer_inuse_rack_css_text_color
        
        return userCssTheme
        
        
    }
    
    func translateFreezerEntityToModel(_userCssDetail : UserCssThemeEntity) -> UserCssModel
    {
 
        let userCssTheme = UserCssModel()
        
        
            userCssTheme.custom_css_label =  _userCssDetail.custom_css_label ?? ""
        
           
            userCssTheme.user =   _userCssDetail.user ?? ""

            userCssTheme.created_by =   _userCssDetail.created_by ?? ""
          
            userCssTheme.created_datetime =   _userCssDetail.created_datetime ?? ""

            userCssTheme.default_css_label =   _userCssDetail.default_css_label ?? ""
         
            userCssTheme.css_selected_background_color =   _userCssDetail.css_selected_background_color ?? ""
      
            userCssTheme.css_selected_text_color =  _userCssDetail.css_selected_text_color ?? ""

            userCssTheme.freezer_empty_css_background_color =  _userCssDetail.freezer_empty_css_background_color ?? ""
            
            userCssTheme.freezer_empty_css_text_color =  _userCssDetail.freezer_empty_css_text_color ?? ""

            userCssTheme.freezer_inuse_css_background_color =  _userCssDetail.freezer_inuse_css_background_color ?? ""

            userCssTheme.freezer_inuse_css_text_color =  _userCssDetail.freezer_inuse_css_text_color ?? ""
     
            userCssTheme.freezer_empty_rack_css_background_color =  _userCssDetail.freezer_empty_rack_css_background_color ?? ""

            userCssTheme.freezer_empty_rack_css_text_color =  _userCssDetail.freezer_empty_rack_css_text_color ?? ""

            userCssTheme.freezer_inuse_rack_css_background_color =  _userCssDetail.freezer_inuse_rack_css_background_color ?? ""

            userCssTheme.freezer_empty_box_css_background_color =  _userCssDetail.freezer_empty_box_css_background_color ?? ""

            userCssTheme.freezer_empty_box_css_text_color =  _userCssDetail.freezer_empty_box_css_text_color ?? ""
       
            userCssTheme.freezer_inuse_box_css_background_color =  _userCssDetail.freezer_inuse_box_css_background_color ?? ""

            userCssTheme.freezer_inuse_box_css_text_color =  _userCssDetail.freezer_inuse_box_css_text_color ?? ""

            userCssTheme.freezer_empty_inventory_css_background_color =  _userCssDetail.freezer_empty_inventory_css_background_color ?? ""
        
            userCssTheme.freezer_empty_inventory_css_text_color =  _userCssDetail.freezer_empty_inventory_css_text_color ?? ""
     
            userCssTheme.freezer_inuse_inventory_css_background_color =  _userCssDetail.freezer_inuse_inventory_css_background_color ?? ""

            userCssTheme.freezer_inuse_inventory_css_text_color =  _userCssDetail.freezer_inuse_inventory_css_text_color ?? ""

            userCssTheme.created_by =  _userCssDetail.created_by ?? ""

            userCssTheme.created_datetime =  _userCssDetail.created_datetime ?? ""

            userCssTheme.modified_datetime =  _userCssDetail.modified_datetime ?? ""

            userCssTheme.freezer_inuse_rack_css_text_color =  _userCssDetail.freezer_inuse_rack_css_text_color ?? ""
        
        return userCssTheme
            
        
        
    }
    
    
    func saveUserCssThemeData(){
        do{
            try container.viewContext.save()
            
            //after saved data update the todo list by fetching the latest
            //get latest for current date
            fetchAllUserCssThemes()
            
            
        }
        catch let error{
            print("Error saving. \(error)")
        }
    }
    
    //delete and update function
    func deleteUserCssTheme(indexSet: IndexSet){
        guard let index = indexSet.first else{return}
        let entity = user_css_entities[index]
        container.viewContext.delete(entity)
        
        saveUserCssThemeData()
        
    }
#warning("TODO soon")
    func updateFreezer(entity : FreezerEntity){
        
        //all attributes
        let currentfreezerLabel = entity.freezerLabel
        
        let newTitle = "new value"
        
        entity.freezerLabel = newTitle
        
        saveUserCssThemeData()
        
    }
    
}





