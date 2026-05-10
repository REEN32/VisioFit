import CoreData
import Combine

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "VisioFit")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Database loading error: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Database save error: \(error)")
            }
        }
    }
    
    func isFirstLaunch() -> Bool {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let user = try context.fetch(request)
            return user.isEmpty
        } catch {
            print("DataBase user fetch request error: \(error)")
        }
        return false
    }
    
    func addEntity<T: NSManagedObject>(_ entity: T.Type, setup: (T) -> Void) {
        let newObject = T(context: context)
        setup(newObject)
        self.save()
    }
    
    //============================================================
    func deleteUser() {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(request)
            users.forEach { context.delete($0) }
            self.save()
            print("CoreData users cleared")
        } catch {
            print("CoreData delete user error: \(error)")
        }
    }
}
