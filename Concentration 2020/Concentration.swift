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
    //     Can be queried by outsiders, but can only be set here.
    private( set ) var cards                                   = [ Card ]()
    
    // Outsiders may be interested in knowing which cards have been flipped, but do not
    // allow them to alter the state.
    private( set ) var flipped                                 = [ Bool ]()
    
    // When only one card is face up, keep track of it.
    // Internal use only.
    private var indexOfOneAndOnlyFaceUpCard:    Int?
    {
        get
        {
            // Location of single face-up card.
            var foundAt: Int?
            
            // Search the deck.
            for index in cards.indices
            {
                if cards[ index ].isFaceUp
                {
                    // Found a face-up card.
                    if foundAt == nil
                    {
                        // It's the only one so far.
                        foundAt = index
                    }
                    else
                    {
                        // It's the second face-up card, so we cannot return the index
                        // of a single face-up card.
                        return nil
                    }
                }
            }
            // Having completed the search, we've either found the index of a single
            // face-up card or there wasn't one.
            return foundAt
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
    
    // Outsiders may query, but may not set this value.
    private( set ) var flipCount:               Int
    
    // NB: The example of matches and mismatches given in the assignment (item 3) is
    // not particularly clear, so the calculation given here may or may not reflect
    // the instructor's original intent. Caveat lector!
    //     Outsiders may query, but may not set this value.
    private( set ) var score:                   Int
    
    // Must fundamentally be available outside as it's the main API.
    func chooseCard( at index: Int )
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
