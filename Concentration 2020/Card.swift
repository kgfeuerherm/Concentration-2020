//
//  Card.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-29.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import Foundation

// Structs have no inheritance and are value types, while classes
// have inheritance and are reference types.
//     However, Swift uses 'copy on write' semantics, meaning that information
// is only copied (to a caller, for instance) when it will be modified.
//     Structs also get a default initializer which allows for setting of each
// internal variable to a particular value.
struct Card
{
    var isFaceUp        = false
    var isMatched       = false
    var identifier: Int
    
    // Static vars are stored with the type, rather than the instance.
    static var identifierFactory = 0
    
    // A static function cannot be invoked on an instance of the type;
    // it can only be invoked on the type itself.
    static func getUniqueIdentifier() -> Int
    {
        identifierFactory += 1
        return identifierFactory
    }
    
    // Initializers typically do not differentiate internal from external
    // names in their paramters.
    init()
    {
        // self.whatever refers to the type's (struct's or class') identifiers.
        self.identifier = Card.getUniqueIdentifier()
    }
}
