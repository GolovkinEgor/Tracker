//
//  CategoryService.swift
//  Tracker
//
//  Created by Golovkin Egor on 11.05.2025.
//



import CoreData
import UIKit

struct Category {
    let id: NSManagedObjectID
    let name: String
}

final class CategoryService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }

    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        context.perform {
            let req: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            do {
                let cds = try self.context.fetch(req)
                let models = cds.map { Category(id: $0.objectID, name: $0.name ?? "") }
                completion(.success(models))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
