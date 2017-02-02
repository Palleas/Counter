import Foundation
import CoreData
import ReactiveSwift

final class Synchronizer {
    private let storage = NSPersistentContainer(name: "Model")
    private let counter: Counter

    init(counter: Counter) {
        self.counter = counter
    }

    func synchronize() -> SignalProducer<Synchronization, SynchronizationError> {
        return counter
            .count()
            .mapError { SynchronizationError.counterError($0) }
            .flatMap(.latest) { [storage = self.storage.reactive] count -> SignalProducer<Synchronization, SynchronizationError> in
                return storage.loadPersistentStores().flatMap(.latest) { container -> SignalProducer<Synchronization, SynchronizationError> in
                    let context = container.newBackgroundContext()

                    let synchronization = Synchronization(context: context)
                    synchronization.count = Int64(count) // FIXME
                    synchronization.timestamp = NSDate()

                    return SignalProducer.attempt { try context.save() }.map { synchronization }.mapError { _ in SynchronizationError.savingError }
                }
            }
    }

}



enum SynchronizationError: Error {
    case savingError
    case loadingError(Error)
    case counterError(Counter.CounterError)
}

extension Reactive where Base: NSManagedObjectContext {
    func save() -> SignalProducer<(), SynchronizationError> {
        return SignalProducer { [base = self.base] sink, _ in

        }
    }
}

extension Reactive where Base: NSPersistentContainer {
    func loadPersistentStores() -> SignalProducer<NSPersistentContainer, SynchronizationError> {
        return SignalProducer { [base = self.base] sink, disposable in
            base.loadPersistentStores { description, error in
                if let error = error {
                    sink.send(error: .loadingError(error))
                    return
                }

                sink.send(value: base)
                sink.sendCompleted()
            }
        }
    }
}
