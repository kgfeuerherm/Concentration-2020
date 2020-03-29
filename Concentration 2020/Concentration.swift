//
//  Concentration.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-29.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

// MODEL

import Foundation

// The file is generally named after the most important class.
class Concentration
{
    // Instance variables must be initialized. In this instance,
    // we set it up as an empty array of card(s).
    var cards = [ Card ]()
    
    // When only one card is face up, keep track of it.
    var indexOfOneAndOnlyFaceUpCard: Int? = nil
    
    func chooseCard( at index: Int )
    {
        if !cards[ index ].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
                // Only one card is currently face up and a different card
                // has been chosen.
                if cards[ matchIndex ].identifier == cards[ index ].identifier
                {
                    cards[ matchIndex ].isMatched   = true
                    cards[ index ].isMatched        = true
                }
                cards[ index ].isFaceUp         = true
                indexOfOneAndOnlyFaceUpCard     = nil
            }
            else
            {
                // Either 2 cards are face up or none are.
                for flipDownIndex in cards.indices
                {
                    cards[ flipDownIndex ].isFaceUp = false
                }
                cards[ index ].isFaceUp     = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init( numberOfPairsOfCards: Int )
    {
        // As the loop variable is not needed, simply set it to the placeholder
        // '_'.
        for _ in 0 ..< numberOfPairsOfCards
        {
            // The first 'identifier' below represents the parameter
            // of the Card initializer; the second is the loop variable.
//          let card = Card( identifier: identifier )
            // The identifier shouldn't be set outside the struct, so prefer
            let card = Card()
            // Since Card is a struct, a simple assignment copies all the
            // properties.
            cards.append( card )
            cards.append( card )
            // Alternatively:
            // cards += [ card, card ]
        }
        // Randomize the order of the cards.
        cards = cards.shuffled()
    }
}
