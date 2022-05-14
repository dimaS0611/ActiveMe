  //
  //  PersistanceContainer.swift
  //  ActiveMe WatchKit Extension
  //
  //  Created by Dima Semenovich on 9.05.22.
  //

import CoreData

struct WatchPersistenceController {
    // A singleton for our entire app to use
  static let shared = WatchPersistenceController()
  
    // Storage for Core Data
  let container: NSPersistentContainer
  
    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
  init(inMemory: Bool = false) {
      // If you didn't name your model Main you'll need
      // to change this name below.
    container = NSPersistentContainer(name: "ActiveMeWatchCoreData")
    
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
  
  func saveSleepData(_ data: [SleepStage]) {
    for datum in data {
      saveSleepData(datum)
    }
  }
  
  func saveSleepData(_ data: SleepStage) {
    let sleepData =  SleepData(context: container.viewContext)
    sleepData.id = data.id
    sleepData.startTime = data.startTime
    sleepData.endTime = data.endTime
    sleepData.date = Date()
    sleepData.sleepStage = data.stage
    
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
  
  func fetchLastRecord() {
    // get the current calendar
    let calendar = Calendar.current
    // get the start of the day of the selected date
    let startDate = calendar.startOfDay(for: Date())
    // get the start of the day after the selected date
    let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
    // create a predicate to filter between start date and end date
    let predicate = NSPredicate(format: "dateAdded >= %@ AND dateAdded < %@", startDate as NSDate, endDate! as NSDate)
    
    // Create a fetch request for a specific Entity type
    let fetchRequest: NSFetchRequest<SleepData>
    fetchRequest = SleepData.fetchRequest()
    fetchRequest.predicate = predicate

    // Get a reference to a NSManagedObjectContext
    let context = container.viewContext

    // Fetch all objects of one Entity type
    let objects = try? context.fetch(fetchRequest)
  }
}
