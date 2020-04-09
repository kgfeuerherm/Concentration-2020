//
//  Card.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-29.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import Foundation

struct Card
{
    var isFaceUp                            = false
    var isMatched                           = false
    var identifier: Int
    
    // The next two items are internal housekeeping items only.
    private static var identifierFactory    = 0
    
    private static func getUniqueIdentifier() -> Int
    {
        identifierFactory   += 1
        return identifierFactory
    }
    
    init()
    {
        self.identifier = Card.getUniqueIdentifier()
    }
}
