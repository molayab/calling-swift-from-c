//
//  MyLibraryInC.swift
//  MyC
//
//  Created by Mateo Olaya on 10/06/24.
//

import Foundation

actor HelloActor {
    func run() async {
        await withTaskGroup(of: Void.self, body: { group in
            group.addTask(priority: .medium, operation: {
                for a in 0...100 {
                    print(" > Actor 1 says: \(a)")
                    try? await Task.sleep(nanoseconds: 10_000_000)
                }
            })
            group.addTask(priority: .medium, operation: {
                for a in 0...100 {
                    print(" > Actor 2 says: \(a)")
                    try? await Task.sleep(nanoseconds: 1_000_000)
                }
            })
            group.addTask(priority: .medium, operation: {
                for a in 0...100 {
                    print(" > Actor 3 says: \(a)")
                    try? await Task.sleep(nanoseconds: 1_000_000)
                }
            })
        })
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
    let semaphore = DispatchSemaphore(value: 0)
    let myActor = HelloActor()
    
    Task { [myActor] in
        print(" > DataIn :: \(query.dataIn)")
        await myActor.run()
        
        // Finished, now signal semaphone and leave process kill.\
        semaphore.signal()
    }
    
    semaphore.wait() // Wait for the cooperative tasks to finish.
    
    return SWIFT_RESULT(dataOut: 800)
}
