//
//  main.swift
//  BIGFile
//
//  Created by Abby Liu on 2/14/17.
//  Copyright © 2017 Abby Liu. All rights reserved.
//


import Cocoa

class Node{
    
    var value: String
    var probability: Double
    var level: Int
    var index: Int
    // category represents the type: 0 - folder, 1 - file
    var category: Int
    var original_index: Int
    var search_index: Int
    
    var children: [Node] = []  // child
    var parent: Node?  // parent
    
    init(value: String, probability: Double, level: Int, index: Int, category: Int, original_index: Int, search_index: Int){
        self.value = value
        self.probability = probability
        self.level = level
        self.index = index
        self.category = category
        self.original_index = original_index
        self.search_index = search_index
    }
    
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }
}


extension Node: CustomStringConvertible {
    
    var description: String {
        
        let text = "\(value)" + ", \(probability)" + ", \(level)" + ", \(index)" + ", \(search_index)"
        return text
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.15f",self)
    }
}

extension Int {
    func toString() -> String {
        return String(format: "%d",self)
    }
}


