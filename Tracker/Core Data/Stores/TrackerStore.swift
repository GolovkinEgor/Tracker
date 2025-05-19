//
//  TrackerStore.swift
//  Tracker
//
//  Created by Golovkin Egor on 23.04.2025.
//


import UIKit
import CoreData

protocol TrackerDataStore {
    var managedObjectContext: NSManagedObjectContext? { get }
    func addNewTracker(_ tracker: Tracker, category: String) throws
    func delete(_ record: NSManagedObject) throws
}
extension Notification.Name {
    // Уведомление о том, что список трекеров обновился
    static let trackersDidUpdate = Notification.Name("trackersDidUpdate")
}

final class TrackerStore: TrackerDataStore {
    static let shared = TrackerStore()
        
    private var trackers: [Tracker] = []
    private let context: NSManagedObjectContext
    let trackerCategoryStore = TrackerCategoryStore()
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func performSync<R>(_ action: (NSManagedObjectContext) -> Result<R, Error>) throws -> R {
        let context = self.context
        var result: Result<R, Error>!
        context.performAndWait { result = action(context) }
        return try result.get()
    }
    
    func addNewTracker(_ tracker: Tracker, category: String) throws {
        try performSync { context in
            Result {
                let trackerCoreData = TrackerCD(context: context)
                trackerCoreData.id = tracker.id
                trackerCoreData.name = tracker.name
                trackerCoreData.emoji = tracker.emoji
                trackerCoreData.color = tracker.color
                
                if let schedule = tracker.schedule, !schedule.isEmpty {
                    let daysSchedule = schedule.map { $0.rawValue }.joined(separator: ",")
                    trackerCoreData.schedule = daysSchedule
                } else {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let dateString = formatter.string(from: tracker.createdDate)
                    trackerCoreData.schedule = "ONCE_\(dateString)"
                }
                
                try trackerCategoryStore.addNewTrackerCategory(trackerCoreData, category: category)
                try context.save()
            }
        }
    }
    
    
    var managedObjectContext: NSManagedObjectContext? {
        context
    }
    
    func delete(_ record: NSManagedObject) throws {
        //TODO: доделать функцию для удаления
    }
    /// Переключает состояние «закреплено» у переданного объекта TrackerCD в Core Data
    func togglePin(_ trackerCD: TrackerCD) {
            do {
                _ = try performSync { context -> Result<Void, Error> in
                    // Внутреннее do–catch, чтобы не «пробросить» ошибку наружу
                    do {
                        let request: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
                        if let id = trackerCD.id {
                            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                        }
                        let results = try context.fetch(request)
                        if let cd = results.first {
                            cd.isPinned.toggle()
                            try context.save()
                        }
                        return .success(())
                    } catch {
                        return .failure(error)
                    }
                }
            } catch {
                print("❗️Ошибка togglePin в TrackerStore:", error)
            }
            // Уведомляем всех слушателей
            NotificationCenter.default.post(name: .trackersDidUpdate, object: nil)
        }


    
    
}
