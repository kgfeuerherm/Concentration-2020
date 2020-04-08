//
//  Concentration.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-29.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

// MODEL

import Foundation

class Concentration
{
    // Set up an empty array of card(s) and a place to record
    // whether a given card has been flipped before or not.
    var cards                                   = [ Card ]()
    
    var flipped                                 = [ Bool ]()
    
    // When only one card is face up, keep track of it.
    var indexOfOneAndOnlyFaceUpCard:    Int?    = nil
    
    var flipCount:                      Int
    
    // NB: The example of matches and mismatches given in the assignment (item 3) is
    // not particularly clear, so the calculation given here may or may not reflect
    // the instructor's original intent. Caveat lector!
    var score:                          Int
    
func chooseCard( at index: Int )
    {
        // Make sure the chosen card was not already matched
        // and removed from the game. (If it was, take no action.)
        if !cards[ index ].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
                // Only one card is currently face up and a different card
                // has been chosen.
                if cards[ matchIndex ].identifier == cards[ index ].identifier
                {
                    // Match!
                    cards[ matchIndex ].isMatched   = true
                    cards[ index ].isMatched        = true
                    // Two points for a correct match.
                    score                           += 2
                }
                else
                {
                    // Mismatch :(. 1 demerit point for each card which had already
                    // been previously flipped. Where a card had not been flipped
                    // previously, record the fact that it has been now.
                    if flipped[ matchIndex ]
                    {
                        score                   -= 1
                    }
                    else
                    {
                        flipped[ matchIndex ]   = true
                    }
                    if flipped[ index ]
                    {
                        score                   -= 1
                    }
                    else
                    {
                        flipped[ index ]        = true
                    }
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
                cards[ index ].isFaceUp         = true
                indexOfOneAndOnlyFaceUpCard     = index
            }
            // Either way, increase the flip counter.
            flipCount   += 1
        }
    }
    
    init( numberOfPairsOfCards: Int )
    {
        // Initialize the properties.
        score       = 0
        flipCount   = 0

        for _ in 0 ..< numberOfPairsOfCards
        {
            let card = Card()
            // Insert the new card into the deck twice, and set
            // each one as never flipped.
            cards.append( card )
            flipped.append( false )
            cards.append( card )
            flipped.append( false )
        }
        // Randomize the order of the cards.
        cards.shuffle()
    }
}
