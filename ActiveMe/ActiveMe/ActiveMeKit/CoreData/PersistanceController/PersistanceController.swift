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
    sleepData.sessionId = data.sessionId
    sleepData.stringDate = data.stringDate
    
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

  func fetchRecordsForDate(dateString: String) -> [SleepData] {
    let predicate = NSPredicate(format: "stringDate == %@", dateString)

    // Create a fetch request for a specific Entity type
    let fetchRequest: NSFetchRequest<SleepData>
    fetchRequest = SleepData.fetchRequest()
    fetchRequest.predicate = predicate

    // Get a reference to a NSManagedObjectContext
    let context = container.viewContext

    // Fetch all objects of one Entity type
    var objects = try? context.fetch(fetchRequest)

    guard let sessionId = objects?.first?.sessionId else {
      return []
    }

    let sessionIdPredicate = NSPredicate(format: "sessionId == %@", sessionId as CVarArg)

    let sessionIdFetchRequest: NSFetchRequest<SleepData>
    sessionIdFetchRequest = SleepData.fetchRequest()
    sessionIdFetchRequest.predicate = sessionIdPredicate

    // Fetch all objects of one Entity type
    objects = try? context.fetch(fetchRequest)

    return objects ?? []
  }

}
