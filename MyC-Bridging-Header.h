//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

/// This data structure defines an ABI to
/// receive a sort of data after a Swift call.
typedef struct {
    int dataOut; // This is dummy data, consider more complex.
} SWIFT_RESULT;

/// This data structure defines an ABI to
/// send data to a Swift spawned call.
typedef struct {
    int dataIn; // This is dummy data, consider more complex.
} SWIFT_QUERY;
