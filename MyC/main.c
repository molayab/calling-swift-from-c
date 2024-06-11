//
//  main.c
//  MyC
//
//  Created by Mateo Olaya on 10/06/24.
//

#include <stdio.h>
#include "MyC-Bridging-Header.h"

/// # About this experiment:
/// This C files looks to call a library built in Swift and
/// wait for a usable response back in C.
///
/// # Considerations
/// 1. Both languages MUST know the API for send and reiceive
/// data. See `MyC-Bridging-Header.h` for more details.
///    -> Struct for _DATA_IN_ `SWIFT_QUERY`.
///    -> Struct for _DATA_OUT_ `SWIFT_RESULT`.
/// 2. Call to Swift entrypoint is a blocking mechanism that
/// will wait until the end of the process spawn.
///    -> Use this with as needed, pthread it if required but
///    keep in mind that Swift will also thread internally to
///    handle async operations.

// Define our entrypoint in the swift external library.
SWIFT_RESULT swift_blocking_entrypoint(SWIFT_QUERY);

int main(int argc, const char * argv[]) {
    // Prepare some data to be send to Swift.
    SWIFT_QUERY swift_exec_query = {
        100
    };
    
    // This spawns a swift library.
    // WARNING: This call is blocking, and will block here
    // the execution until swift call finishes.
    SWIFT_RESULT result = swift_blocking_entrypoint(swift_exec_query);
    
    // Do something with the received data:
    printf(" !! Here, back in C we got: %i\n\n", result.dataOut);
    return 0;
}
