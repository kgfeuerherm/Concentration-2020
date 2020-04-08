//
//  ViewController.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-27.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

// CONTROLLER

// Note: This game was designed to look good in portrait mode
// on iPhone 11 Pro rather than iPhone X due to current XCode
// choices at the present time.

import UIKit

class ViewController: UIViewController
{
    // The theme library for the game follows.
    //     To add a new theme, simply add a new tuple anywhere in the list with the appropriate
    // elements as specified in the type definition. The game loads with the first theme in the
    // list as the default.
    typealias Theme                         =
    (
        name                : String,       // not currently needed but could be useful later or in debugging
        viewBackgroundColour: UIColor,      // colour of main view
        cardBackgroundColour: UIColor,      // colour of face-down cards
        emojiSet            : [ String ]    // emojis available to a given theme
    )

    let themeChoices: [ Theme ]             =
    [
        ( "Hallowe'en",    #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), [ "👻", "🎃", "🧹", "😸", "👹", "👺", "👿", "🏴‍☠️", "🎩", "☠️", "💍", "🐍" ] ),
        ( "Living things", #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1), [ "🐥", "🦆", "🦅", "🦉", "🦇", "🐺", "🐗", "🐴", "🦄", "🐝", "🦋", "🐞" ] ),
        ( "Moon phases",   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), [ "🌔", "🌙", "🌛", "🌜", "🌚", "🌕", "🌖", "🌗", "🌘", "🌑", "🌒", "🌓" ] ),
        ( "Weather",       #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), [ "☀️", "🌤", "⛅️", "🌥", "☁️", "🌦", "🌧", "⛈", "🌩", "🌨", "💧", "💦" ] ),
        ( "Fruit",         #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1), [ "🍏", "🍎", "🍐", "🍊", "🥑", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑" ] ),
        ( "Time",          #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), [ "🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕛" ] ),
    ]
    
    // Identity of the currently chosen theme. As noted earlier, the game loads with the first in the library.
    var currentThemeID                      = 0
    
    // Storage for (mutating) manipulation of current theme.
    lazy var currentTheme                   = themeChoices[ currentThemeID ]
    
    lazy var game                           = Concentration( numberOfPairsOfCards: ( cardButtons.count + 1 ) / 2 )
    
    // Label to display the current score.
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [ UIButton ]!
    
    @IBAction func touchCard( _ sender: UIButton )
    {
        if let cardNumber = cardButtons.firstIndex( of: sender )
        {
            game.chooseCard( at: cardNumber )
            updateViewFromModel()
        }
        else
        {
            print( "card not found in cardButtons array" )
        }
    }
        
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBAction func resetGame(_ sender: UIButton)
    {
        // Set up a new set of cards. (The old set goes into garbage collection by default.)
        game                        = Concentration( numberOfPairsOfCards: ( cardButtons.count + 1 ) / 2 )
        
        // Choose a new theme; it may or may not differ from the current one.
        currentThemeID              = Int.random( in: 0 ..< themeChoices.count )
        currentTheme                = themeChoices[ currentThemeID ]
        flipCountLabel.textColor    = currentTheme.cardBackgroundColour
        
        // Finally, synchronize the view in light of the new data.
        updateViewFromModel()
    }

    func updateViewFromModel()
    {
        // Show the score.
        scoreLabel.text     = "Score: \(game.score)"
        
        // Update card buttons in accordance with their internal (model) state.
        for index in cardButtons.indices
        {
            let button  = cardButtons[ index ]
            let card    = game.cards[ index ]
            if card.isFaceUp
            {
                button.setTitle( emoji( for: card ), for: UIControl.State.normal )
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else
            {
                button.setTitle( "", for: UIControl.State.normal )
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : themeChoices[ currentThemeID ].cardBackgroundColour
            }
        }
        
        // Show the number of flips.
        flipCountLabel.text = "Flips: \( game.flipCount )"
    }
    
    var emoji = [ Int : String ]()

    func emoji( for card: Card ) -> String
    {
        if emoji[ card.identifier ] == nil, currentTheme.emojiSet.count > 0
        {
            let randomIndex = Int.random( in: 0 ..< currentTheme.emojiSet.count )
            emoji[ card.identifier ] = currentTheme.emojiSet.remove( at: randomIndex )
        }
        return emoji[ card.identifier ] ?? "?"
    }
}

