//
//  Node.swift
//  AmaranthineQueue
//
//  Created by Instructor Amaranthine on 02/09/21.
//

import Foundation

/**
 Node<Element> class represents a single node.
 
 *Parameters*
 
 `data`          Represents the data stored in the Node.
 
 `nextNode`      Represents the next node in the queue.
 
 - Author: Arun Patwardhan
 - Version: 1.0
 */
final class Node<Element> {
    var data        : Element?
    
    var nextNode    : Node<Element>?
    
    init(with newData : Element) {
        data = newData
    }
}
