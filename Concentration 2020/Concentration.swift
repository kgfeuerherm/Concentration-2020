//
//  Concentration.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-29.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

// MODEL

import Foundation

// Change from 'class' to struct' as the object is not being passed around.
struct Concentration
{
    // Set up an empty array of card(s) and a place to record
    // whether a given card has been flipped before or not.
    private( set ) var cards                                   = [ Card ]()
    
    private( set ) var flipped                                 = [ Bool ]()
    
    // When only one card is face up, keep track of it.
    private var indexOfOneAndOnlyFaceUpCard:    Int?
    {
        get
        {
            // Replace the handmade code which loops through the deck with a
            // simple closure.
            //     Because 'filter' takes only one argument, the parentheses can be
            // disposed of and the closure placed straight afterwards.
            //     Note that the type of 'faceUpCardIndices' is now displayed by Xcode as
            // '[ Range< Array< Card >.Index >.Element ]' rather than '[ Array.Index ]' as in the lecture.
            
            // Solution 1: straightforward application of a closure.
//            let faceUpCardIndices = cards.indices.filter { cards[ $0 ].isFaceUp }
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
            // Solution 2: using an extension to Collection.
            return cards.indices.filter { cards[ $0 ].isFaceUp }.oneAndOnly
        }
        set
        {
            // Run through the deck and turn all cards face down except for the one
            // indicated by newValue.
            for index in cards.indices
            {
                cards[ index ].isFaceUp = ( index == newValue )
            }
        }
    }
    
    private( set ) var flipCount:               Int
    
    // NB: The example of matches and mismatches given in the assignment (item 3) is
    // not particularly clear, so the calculation given here may or may not reflect
    // the instructor's original intent. Caveat lector!
    private( set ) var score:                   Int
    
    // Must fundamentally be available outside as it's the main API.
    //     However, since changes are being made to the (now) struct (which is a value type with
    // copy-on-write, functions which modify the internal contents must be identified as 'mutating'.
    mutating func chooseCard( at index: Int )
    {
        // Ensure that outside callers do not request something illegal; crash on failure.
        assert( cards.indices.contains( index ), "Concentration.chooseCard( at: \( index ) ): index out of bounds" )
        
        // Make sure the chosen card was not already matched
        // and removed from the game. (If it was, take no action.)
        if !cards[ index ].isMatched
        {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index
            {
                // Only one card is currently face up and a different card
                // has been chosen.
                //     Since Card is now hashable, we can test for identity directly.
                if cards[ matchIndex ] == cards[ index ]
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
                        score                       -= 1
                    }
                    else
                    {
                        flipped[ matchIndex ]       = true
                    }
                    if flipped[ index ]
                    {
                        score                       -= 1
                    }
                    else
                    {
                        flipped[ index ]            = true
                    }
                }
                cards[ index ].isFaceUp             = true
            }
            else
            {
                indexOfOneAndOnlyFaceUpCard     = index
            }
            // Either way, increase the flip counter.
            flipCount   += 1
        }
    }
    
    init( numberOfPairsOfCards: Int )
    {
        // Ensure that the deck will contain at least one pair of cards.
        assert( numberOfPairsOfCards > 0,
                "Concentration.init( \( numberOfPairsOfCards ) ): deck must contain at least one pair of cards" )

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

// Alternate soluton to simplifying the code for indexOfOneAndOnlyOneFaceUpCard.
extension Collection
{
    var oneAndOnly: Element?
    {
        // 'count' and 'first' are Collection methods, and can therefore be applied to
        // a Collection var without further ado.
        return count == 1 ? first : nil
    }
}
