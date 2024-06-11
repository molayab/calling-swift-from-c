# About this 

This is an experiment to call a Swift library inside of C, block the process and wait for Swift to ends. Give a way to share some sort of data sturectures to send and receive data. Consider the internal use of Tasks in Swift (async calls and thread creation).

## Findings 
 
 1. Swift can be called from C, Objective-C and recantly lang added interop for C++.
 2. C can send and receive data to interact with.
 3. Swift block the call if desired, but probably it does not by-default.
 4. We can use C as entrypoint and move then to Swift in a non-apple systems.

## Cool things that possible can be achive
 
It should be possible to run a UI framework, maybe some open-source implementation for SwiftUI that could be run on non-apple machines. (This is possible but Apple remains core of SwiftUI close source.)
