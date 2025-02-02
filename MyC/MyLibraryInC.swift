//
//  MyLibraryInC.swift
//  MyC
//
//  Created by Mateo Olaya on 10/06/24.
//

import Foundation

actor HelloActor {
    var sum = 0
    
    func run() async {
        await withTaskGroup(of: Int.self, body: { group in
            group.addTask(priority: .low, operation: {
                var sum = 0
                for a in 0...10 {
                    print(" > Actor 1 says: \(a)")
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    sum += a
                }
                return sum
            })
            group.addTask(priority: .medium, operation: {
                var sum = 0
                for a in 0...25 {
                    print(" > Actor 2 says: \(a)")
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    sum += a
                }
                return sum
            })
            group.addTask(priority: .high, operation: {
                var sum = 0
                for a in 0...5 {
                    print(" > Actor 3 says: \(a)")
                    try? await Task.sleep(nanoseconds: 1_000_000)
                    sum += a
                }
                return sum
            })
            
            
            while let next = await group.next() {
                print(" >> Subtask ended: \(next)")
                sum += next
            }
        })
    }
}

// MARK: - C entrypoint: ABI Entrypoint and Task routines allocation.

/// WARNING: This is unsafe, DO NOT CALL on multiple concurrent contexts
/// Use it just as bridge between Swift Concurrency root context and C
/// callback.
fileprivate final class SwiftCResultHanlder {
    /// Stores the result in memory and allows `Task { }` to set the
    /// return value and send it back to C, be sure to set it before.
    private(set) var result: SWIFT_RESULT!
    fileprivate func setResult(_ result: SWIFT_RESULT) {
        self.result = result
    }
}

/**
 This is a blocking operation, it gives control to swift library and block-call
 until the subtasks finishes.
 */
@_silgen_name("swift_blocking_entrypoint")
public func entrypoint(_ query: SWIFT_QUERY) -> SWIFT_RESULT {
    print("Hello World from Swift!!")
    
    // At this point we may want to convert all C types to Swift and proceed,
    // with native ones. At some point we will need to convert-back to C.
    // If more performance is required we can use C types directly.
    
    // This are stored on stack
    // WARNING: Semaphore may cause issues and should not be used. Check another way
    // to block tasks on sync context.
    let semaphore = DispatchSemaphore(value: 0)
    let myActor = HelloActor()
    let resultHandler = SwiftCResultHanlder()
    
    Task(priority: .high, operation: {
        print(" > DataIn :: \(query.dataIn)")
        await myActor.run()
        
        resultHandler.setResult(SWIFT_RESULT(dataOut: Int32(await myActor.sum)))
        // Finished, now signal semaphone and leave process kill.
        semaphore.signal()
    })
    
    semaphore.wait() // Wait for the cooperative tasks to finish.
    return resultHandler.result
}
