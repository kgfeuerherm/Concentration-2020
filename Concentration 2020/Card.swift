//
//  Card.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-29.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import Foundation

// Make type Card conform to protocol 'Hashable' so that cards may be compared directly
// in lieu of allowing outsiders to see the internal control variable 'identifier'.
struct Card : Hashable
{
    // The use of 'hashValue' as demonstrated in the lecture has been deprecated. The code
    // proposed there follows.
//    var hashValue: Int
//    {
//        return identifier
//    }
    
    // The preferred approach is to implement 'hash( into: ...) and specify the keys needed
    // to identify an item uniquely, with one 'hasher.combine' line each.
    //     In this particular case, only one such line is required.
    //     Note also that this function cannot be made private; it must have the same
    // accessibility as the enclosing type (i.e., internal, in this case).
    func hash( into hasher: inout Hasher )
    {
        // Specify the key to be hashed. Note that what is specified here must match what is
        // used in the implementation of '=='.
        hasher.combine( identifier )
    }
    
    var isFaceUp                            = false
    var isMatched                           = false
    
    // Since the use an an integer identifier is now merely a matter of internal implementation,
    // make it private.
    private var identifier: Int
    
    // The next two items are internal housekeeping items only.
    private static var identifierFactory    = 0
    
    private static func getUniqueIdentifier() -> Int
    {
        identifierFactory   += 1
        return identifierFactory
    }
    
    // Function on the type 'Card' to perform identity checks.
    static func ==( lhs: Card, rhs: Card ) -> Bool
    {
        return lhs.identifier == rhs.identifier
    }
    
    init()
    {
        self.identifier = Card.getUniqueIdentifier()
    }
}
