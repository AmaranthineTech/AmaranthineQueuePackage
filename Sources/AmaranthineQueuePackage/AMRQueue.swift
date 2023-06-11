//
//  AMRQueue.swift
//  AMRQueue
//
//  Created by Instructor Amaranthine on 02/09/21.
//

import Foundation

/**
 AMRQueue<Element> class represents the entire queue
 
 **Variables**
 
 `startNode`
 
 Represents the starting node in the queue.
 
 `lastNode`
 
 Represents the last node in the queue.
 
 `length`
 
 Represents the size of the queue.
 
 **Functions**
 
 `func push(Element newElement : Element)`
 
 Used to add an element in the Queue
 
 `func pop() throws -> Element?`
 
 Removes the first element in the queue
 
 `func search(forElement searchElement : Element, with task : SearchClosure) throws -> SearchResult`
 
 Used to search for an element in the Queue
 
 ```Swift
 var intQueue : ARQueue<Int> = AMRQueue<Int>()
 try? intQueue.push(Element: 10)
 
 print(intQueue)
 ```
 
 **Protocols**
 
 Conforms to the following protocols
 
 `CustomStringConvertible`
 
 `Equatable`
 
 `Sequence`
 
 `Collection`
 
 `ExpressibleByArrayLiteral`
 
 - Tip: Check out the tutorials. <doc:Tutorial-Table-of-Contents>
 - Author: Arun Patwardhan
 - Version: 1.0
 */
public struct AMRQueue<Element> {
    //MARK: - Variables --------------------------------------------------
    fileprivate var startNode   : Node<Element>?    = nil
    public var size             : UInt64            = 0
    fileprivate var lastNode    : Node<Element>?    = nil
    private var maxCapacity     : UInt64            = UInt64.max
    
    //MARK: - Functions --------------------------------------------------
    //Empty queue
    /**
     This init creates an empty queue
     
     There are other ways of initializing a queue. You can use ``init(withCapacity:)`` or ``init(withValues:)`` to setup your queue.
     
     - important: This function does not do validation.
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015
     - version: 1.0
     */
    public init()
    {
    }
    
    //Queue with maximum limit
    /**
     This init creates queue whose length cannot exceed the capacity specified
     - important: This function does not do validation.
     - requires: iOS 11 or later
     - Since: iOS 11
     - parameter withCapacity: This is specifies the maximum number of elements allowed.
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015
     - version: 1.0
     */
    public init(withCapacity length : UInt64) {
        self.init()
        self.maxCapacity = length
    }
    
    //Queue with prepopulated values
    /**
     This init creates queue which is filled with the contents of the array provided
     - important: This function does not do validation. Items will be added in the sequence in which they are present in the array
     - warning: The initalizer fails if the array size is greater than the capacity.
     - requires: iOS 11 or later
     - Since: iOS 11
     - returns: Can return nil is max capacity exceeded.
     - parameter val: This is contains the items to be added to the queue.
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015
     - version: 1.0
     */
    public init?(withValues val : [Element]) {
        self.init()
        guard val.count <= self.maxCapacity
        else {
            return nil
        }
        for i in val {
            do {
                try self.push(Element: i)
            }
            catch {
                return nil
            }
        }
    }
    
    /**
     This property provides the length of the queue
     - important: This function does not do validation.
     - returns: `UInt64`.
     - requires: iOS 13 or later
     - Since: iOS 13
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015
     - version: 1.0
     */
    @available(iOS, introduced: 13, message: "This code uses syntax available in Swift 5.1 or later")
    public var length : UInt64 {
        self.size
    }
    
    /**
     This function adds an element to the end of the queue
     - important: This function does not do validation.
     - warning: `push` can throw if the maximum capacity is breached. More details about the kind of exceptions that can be thrown are found in ``QueueExceptions``. To print out the excptions explore: ``QueueExceptions/description``
     - returns: Void.
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11, message: "Use this to add elements to a Node")
    public mutating func push(Element newElement : Element) throws {
        guard self.size < self.maxCapacity
        else {
            throw QueueExceptions.queueFull("Reached the limit. Cannot add more than \(self.maxCapacity) items")
        }
        
        //1. Create a node
        let newNode : Node<Element> = Node<Element>(with: newElement)
        
        //2. Add node to queue
        if nil == startNode {
            startNode = newNode
        }
        else {
            lastNode?.nextNode = newNode
        }
        size += 1
        lastNode = newNode
    }
    
    /**
     This function removes the first element from the queue
     - important: This function throws an Exception if you try to remove from an empty queue
     - note: The reason why the return type is an optional is because the node may or may not hold data. A return value of `nil` indicates that there is a node, but the node is empty.
     - returns: `Element?`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Remove Element Function")
    @discardableResult public mutating func pop() throws -> Element? {
        guard nil != startNode
        else {
            throw QueueExceptions.empty("The queue is empty")
        }
        let returnNode          = startNode
        startNode               = startNode?.nextNode
        returnNode?.nextNode    = nil
        size -= 1
        return returnNode?.data
    }
}


//:#### Extension to Queue Class
/**
 Adds search capability.
 
 - Author: Arun Patwardhan
 - Version: 1.1
 */
extension AMRQueue {
    /**
     Closure Type used for searching
     
     *Arguments*
     
     Takes 2 arguments both of type element
     
     *Returns*
     
     `Bool`. True indicates a match.
     
     - Author: Arun Patwardhan
     - Version: 1.1
     */
    public typealias SearchClosure = (Element, Element) -> Bool
    
    /**
     This function searches for the given element in the queue
     - important: This function throws an Exception if you try to search from an empty queue
     - returns: `SearchResult`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Search for an Element Function")
    public func search(forElement searchElement : Element, with task : SearchClosure) throws -> SearchResult {
        guard nil != startNode
        else {
            throw QueueExceptions.empty("Cannot search. The queue is Empty.")
        }
        
        var searchNode : Node<Element>? = startNode
        for _ in 0..<size {
            guard nil != searchNode
                else {
                break
            }
            if nil != searchNode!.data {
                if task(searchElement, searchNode!.data!) {
                    return SearchResult.elementFound
                }
            }
            searchNode = searchNode!.nextNode
        }
        return SearchResult.elementNotFound
    }
}

//:#### Extension to Queue Class
/**
 Adds the following capabilities.
 ````
 +
 +=
 ````
 
 - Author: Arun Patwardhan
 - Version: 1.1
 */
extension AMRQueue {
    /**
     This function overloads the `+` operator for the Queue. This function takes 2 Queues and combines them to form a new Queue.
     - note: This method will not add an element to the queue if there is an excpetion while attempting to do so. It will just move on to the next item. No exception or warnings are thrown.
     - returns: `AMRQueue` This is a new queue independent of the other queues.
     - parameters:
        - lhs: The queue on the left hand side of the `+` operator
        - rhs: The queue on the right hand side of the `+` operator
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015
     - version: 1.0
     */
    @available(iOS, introduced: 11.0, message: "Remove Element Function")
    public static func +(lhs : AMRQueue, rhs : AMRQueue) -> AMRQueue {
        var resultingQueue  : AMRQueue  = AMRQueue()
        
        var iteratorNode    : Node<Element>?    = lhs.startNode
        
        for _ in 0..<lhs.size {
            guard nil != iteratorNode
            else {
                break
            }
            if nil != iteratorNode!.data {
                try? resultingQueue.push(Element: (iteratorNode?.data!)!)
            }
            iteratorNode = iteratorNode!.nextNode
        }
        
        iteratorNode = rhs.startNode
        
        for _ in 0..<rhs.size {
            guard nil != iteratorNode
            else {
                break
            }
            if nil != iteratorNode!.data {
                try? resultingQueue.push(Element: (iteratorNode?.data!)!)
            }
            iteratorNode = iteratorNode!.nextNode
        }
        return resultingQueue
    }
    
    /**
     This function overloads the `+=` operator for the Queue. This function takes 2 Queues and adds the contents of the second queue to your first queue.
     - note: This method will not add an element to the queue if there is an excpetion while attempting to do so. It will just move on to the next item. No exception or warnings are thrown.
     - returns: `Bool`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015
     - version: 1.0
     */
    @available(iOS, introduced: 11.0, message: "Remove Element Function")
    public static func +=(lhs : inout AMRQueue, rhs : AMRQueue) {
        var iteratorNode : Node<Element>? = rhs.startNode
        
        for _ in 0..<rhs.size {
            guard nil != iteratorNode
            else {
                break
            }
            if nil != iteratorNode!.data
            {
                try? lhs.push(Element: (iteratorNode?.data!)!)
            }
            iteratorNode = iteratorNode!.nextNode
        }
    }
}


//:#### Extension to Queue Class
/**
 Adds the following capabilities.
 ````
 empty queue
 ````
 
 - Author: Arun Patwardhan
 - Version: 1.2
 */
extension AMRQueue {
    /**
     This function removes all the elements from the queue
     - important: This function throws an Exception if you try to remove from an empty queue
     - returns: `Void`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Remove all Elements Function")
    public mutating func emptyQueue() throws {
        guard nil != startNode
        else {
            throw QueueExceptions.empty("The queue is empty")
        }
        
        for _ in 0..<size {
            let nodeToBeRemoved         = startNode
            startNode                   = startNode?.nextNode
            nodeToBeRemoved?.nextNode   = nil
        }
        size = 0
    }
}

//:#### Extension to Queue Class
/**
 Adds conformance to the CustomStringConvertible protocol
 
 - Author: Arun Patwardhan
 - Version: 1.5
 */
extension AMRQueue : CustomStringConvertible {
    public var description: String {
        var returnString : String = ""
        if nil != startNode {
            var searchNode : Node<Element>? = startNode
            for i in 0..<size {
                guard nil != searchNode else { break }
                if nil != searchNode!.data {
                    returnString += "[\(i)]: \(searchNode!.data!)\n"
                }
                searchNode = searchNode!.nextNode
            }
        }
        return returnString
    }
}

//:#### Extension to Queue Class
/**
 Adds computed properties to access first and last element
 - note: returns `nil` if queue is empty
 - Date: 24th January 2021
 - Author: Arun Patwardhan
 - Version: 1.5
 */
extension AMRQueue {
    var first : Element? {
        guard self.size > 0
        else {
            return nil
        }
        return self.startNode?.data
    }
    
    var last : Element? {
        guard self.size > 0
        else {
            return nil
        }
        return self.lastNode?.data
    }
}

//:#### Extension to Queue Class
/**
 Adds conformance to the Equatable protocol
 
 - Author: Arun Patwardhan
 - Version: 1.5
 */
extension AMRQueue : Equatable where Element : Equatable {
    public static func == (lhs: AMRQueue<Element>, rhs: AMRQueue<Element>) -> Bool {
        
        if lhs.size == rhs.size && lhs.first == rhs.first {
            return true
        }
        return false
    }
}

//:#### Extension to Queue Class
/**
 Adds the following Indexing & subscripting.
 
 - Author: Arun Patwardhan
 - Version: 1.3
 */
extension AMRQueue
{
    public typealias Index = Int
    
    /**
     This computed property returns the starting index of the queue
     - returns: `Index`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Starting index of the queue.")
    public var startIndex : Index {
        return 0
    }
    
    /**
     This computed property returns the last index of the queue
     - returns: `Index`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Last index of the queue.")
    public var endIndex: Index {
        return Int(size)
    }
    
    /**
     Enables subscripting behavior.
     - important: Note that the index for a queue also starts from `0` just like an array.
     - returns: Generic type `Element`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Subscripting")
    public subscript (position : Index) -> Element {
        get {
            var referenceNode = startNode
            for _ in 0..<position {
                referenceNode = referenceNode?.nextNode
            }
            return (referenceNode?.data!)!
        }
    }
}

//:#### Extension to Queue Class
/**
 Adds conformance to the sequence protocol
 
 - Author: Arun Patwardhan
 - Version: 1.4
 */
extension AMRQueue : Sequence {
    public typealias Iterator = AnyIterator<Element>
    
    /**
     This function returns an iterator which is used to iterate over the collection.
     - returns: `Iterator`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Iterator creation function")
    public func makeIterator() -> Iterator {
        var index = 0
        return AnyIterator({() -> Element? in
            if index < self.size {
                var referenceNode = self.startNode
                for _ in 0..<index {
                    referenceNode = referenceNode?.nextNode
                }
                let res =  referenceNode?.data
                index += 1
                return res
            }
            return nil
        })
    }
}

//:#### Extension to Queue Class
/**
 Adds conformance to the Collection protocol
 
 - Author: Arun Patwardhan
 - Version: 1.5
 */
extension AMRQueue : Collection {
    public typealias SubSequence = AMRQueue<Element>
    
    /**
     Enables subscripting behavior over a range of values.
     - returns: A subset of the queue `AMRQueue.SubSequence`
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    public subscript (bounds: Range<AMRQueue.Index>) -> AMRQueue.SubSequence {
        var newQueue : AMRQueue<Element> = AMRQueue<Element>()
        
        for i in bounds.lowerBound...bounds.upperBound {
            try? newQueue.push(Element: self[i])
        }
        return newQueue
    }
    
    /**
     This function returns the position immediately after the given index.
     - returns: The index value immediately after `i`.
     - parameter i: A valid index of the collection. `i` must be less than `endIndex`.
     - requires: iOS 11 or later
     - Since: iOS 11
     - author: Arun Patwardhan
     - copyright: Copyright (c) Amaranthine 2015 - version: 1.0*/
    @available(iOS, introduced: 11.0, message: "Iterator creation function")
    public func index(after i: Int) -> Int {
        if i < endIndex {
            return i + 1
        }
        return i
    }
}

//:#### Extension to Queue Class
/**
 Adds conformance to the ExpressibleByArrayLiteral protocol
 
 - Author: Arun Patwardhan
 - Version: 1.5
 */
extension AMRQueue : ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Element
    
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        for element in elements {
            try? self.push(Element: element)
        }
    }
}
