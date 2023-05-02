//
//  PersistenceManager.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/05/02.
//

import Foundation
import CoreData

final class PersistenceManager {
    static var shared: PersistenceManager = PersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    private init() { }
    
    // MARK: - Create
    func createContent(with diary: Diary) throws {
        let diaryContext = Diary(context: context)
        
        diaryContext.content = diary.content
        diaryContext.date = diary.date
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
    
    // MARK: - Read
    func fetchContent() throws -> [Diary] {
        let fetchRequest = NSFetchRequest<Diary>(entityName: "Diary")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let diaryData = try context.fetch(fetchRequest)
            
            return diaryData
        } catch {
            throw error
        }
    }
}