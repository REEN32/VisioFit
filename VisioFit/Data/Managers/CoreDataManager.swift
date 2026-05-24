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
        
        preloadDefaultData()
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func preloadDefaultData() {
        let request: NSFetchRequest<WorkoutSet> = WorkoutSet.fetchRequest()
        do {
            let count = try context.count(for: request)
            guard count == 0 else { return }
            
            let pushups = WorkoutSet(context: context)
            pushups.id = UUID()
            pushups.name = "Отжимания"
            pushups.approach = 4
            pushups.image = "0.square.fill"
            pushups.isTime = false
            pushups.completedApproach = 0
            pushups.requirementReps = 12
            
            let plank = WorkoutSet(context: context)
            plank.id = UUID()
            plank.name = "Планка"
            plank.approach = 3
            plank.image = "square"
            plank.isTime = true
            plank.completedApproach = 0
            plank.requirementReps = 30
            
            let squats = WorkoutSet(context: context)
            squats.id = UUID()
            squats.name = "Приседания"
            squats.approach = 4
            squats.image = "figure.cross.training"
            squats.isTime = false
            squats.completedApproach = 0
            squats.requirementReps = 12
            
            save()
        } catch {
            print("Database Preload error: \(error)")
        }
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
    
    func addWorkout(workout: (User) -> Void) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                workout(user)
                self.save()
            }
        } catch {
            print("DataBase create workout error: \(error)")
        }
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
    
    func getWorkouts() {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        do {
            let workouts = try context.fetch(request)
            print(workouts)
        } catch {
            print("CoreData fetch workouts error: \(error)")
        }
    }
//    
//    func getUserWorkouts() {
//        let request: NSFetchRequest<User> = User.fetchRequest()
//        
//        do {
//            let users = try context.fetch(request)
//            if let user = users.first {
//                let workouts = user.workout
//                print(workouts ?? [])
//            }
//        } catch {
//            print("CoreData fetch workouts error: \(error)")
//        }
//    }
    
    func getWorkoutsAccuracy() {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        do {
            let workouts = try context.fetch(request)
            for workout in workouts {
                print(workout.exerciseSet?.metricPoint?.quality ?? -1)
            }
        } catch {
            print("CoreData fetch workouts error: \(error)")
        }
    }
}
