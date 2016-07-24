//
//  DataStore.swift
//  SlapChat
//
//  Created by Flatiron School on 7/18/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    
    var recipients: [Recipient] = []
    static let sharedDataStore = DataStore()
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func fetchDataRecipient() {
        
        let recipientsRequest = NSFetchRequest(entityName: "Recipient")
        let nameSorter = NSSortDescriptor(key: "name", ascending:true)
        recipientsRequest.sortDescriptors = [nameSorter]
        
        do{
            self.recipients = try managedObjectContext.executeFetchRequest(recipientsRequest) as! [Recipient]
        } catch let nserror1 as NSError{
            print("\(nserror1)")
            self.recipients = []
        }
        
        if self.recipients.count == 0 {
            self.generateTestRecipientsData()
            self.saveContext()
            self.fetchDataRecipient()
        }
    }
    
    func generateTestRecipientsData() {
        
        let recipientOne: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: self.managedObjectContext) as! Recipient
        recipientOne.name = "Jenny"
        recipientOne.email = "jenny@email.com"
        recipientOne.phone = "333-4444-5555"
        recipientOne.twitter = "twitter"
        
        let messageThree: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        messageThree.content = "Jenny-message-1"
        messageThree.createdAt = NSDate()
        
        recipientOne.messages = [messageThree]
        
        let recipientTwo: Recipient = NSEntityDescription.insertNewObjectForEntityForName("Recipient", inManagedObjectContext: self.managedObjectContext) as! Recipient
        recipientTwo.name = "John"
        recipientTwo.email = "john@email.com"
        recipientTwo.phone = "333-4444-5555"
        recipientTwo.twitter = "twitter"
        
        let messageOne: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        messageOne.content = "John-message-1"
        messageOne.createdAt = NSDate()
        
        let messageTwo: Message = NSEntityDescription.insertNewObjectForEntityForName("Message", inManagedObjectContext: managedObjectContext) as! Message
        
        messageTwo.content = "John-message-2"
        messageTwo.createdAt = NSDate()
        
        recipientTwo.messages = [messageOne, messageTwo]
    }
    
    
    // MARK: - Core Data stack
    // Managed Object Context property getter. This is where we've dropped our "boilerplate" code.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SlapChat", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SlapChat.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    //MARK: Application's Documents directory
    // Returns the URL to the application's Documents directory.
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FlatironSchool.SlapChat" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
}