import Foundation
import CoreData

class CoreDataStack {
    let context:NSManagedObjectContext
    let psc:NSPersistentStoreCoordinator
    let model:NSManagedObjectModel
    
    init() {
        // get the bundle
        let bundle = NSBundle.mainBundle()
        // get the url of our datamodel
        let modelURL = bundle.URLForResource("Data", withExtension: "momd")
        //create a model with that context model
        model = NSManagedObjectModel(contentsOfURL: modelURL!)!
        // pass the mode psc
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        // app directory
        
        
        // create the manage object context
        context = NSManagedObjectContext()
        // assign store to context
        context.persistentStoreCoordinator = psc
 
        let appDir = applicationDocumentDirectory()
        let storeURL = appDir.URLByAppendingPathComponent("Data")
        // needed for migration updating data model
        let option = [NSMigratePersistentStoresAutomaticallyOption:true]
        var err:NSError?
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil , URL: storeURL, options: option)
            
        } catch  let err1 as NSError {
            err = err1
        }
        if err != nil {
            print("Couldn't create store")
            abort()
        }
    }
    func save() {
        var err:NSError?
        do {
            try context.save()
            
        } catch  let err1 as NSError {
            err = err1
        }
        if err != nil {
            print("Couldn't not save data")
            abort()
        }
    }
    func applicationDocumentDirectory() -> NSURL {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[0]
    }
}
