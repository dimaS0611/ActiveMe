//
//  PersistanceController.swift
//  ActiveMe
//
//  Created by Dima Semenovich on 9.05.22.
//

import CoreData

struct PersistenceController {
    // A singleton for our entire app to use
  static let shared = PersistenceController()
  
    // Storage for Core Data
  let container: NSPersistentContainer
  
    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
  init(inMemory: Bool = false) {
      // If you didn't name your model Main you'll need
      // to change this name below.
    container = NSPersistentContainer(name: "ActiveMeCoreData")
    
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func saveSleepData(_ data: [SleepClassificationData]) {
    for datum in data {
      saveSleepData(datum)
    }
  }
  
  func saveSleepData(_ data: SleepClassificationData) {
    let sleepData =  SleepData(context: container.viewContext)
    sleepData.id = data.id
    sleepData.startTime = data.startTime
    sleepData.endTime = data.endTime
    sleepData.date = Date()
    sleepData.sleepStage = data.sleepStage
    
    save()
  }
  
  func save() {
    let context = container.viewContext
    
    if context.hasChanges {
      do {
        try context.save()
      } catch let error as NSError {
        debugPrint("Unresolved error: \(error) \(error.userInfo)")
      }
    }
  }
  
  func deleteData() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SleepData")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try container.persistentStoreCoordinator.execute(deleteRequest, with: container.viewContext)
    } catch let error as NSError {
      debugPrint("Unresolved error: \(error) \(error.userInfo)")
    }
  }
}
