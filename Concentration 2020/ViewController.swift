//
//  ViewController.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-27.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

// CONTROLLER

import UIKit

class ViewController: UIViewController
{
    // Classes get a default initializer so long as all their variables are
    // initialized, as in this case.
    //     'lazy' defers the initialization of 'game' until it is actually used. This
    // is necessary because we cannot otherwise access 'cardButtons', since it only
    // becomes available once initialization is complete (catch-22).
    //     NOTE: lazy variables cannot have a 'didSet'!
    lazy var game        = Concentration( numberOfPairsOfCards: ( cardButtons.count + 1 ) / 2 )
    
    var flipCount   = 0 // properties must be initialized; type inferred as Int
    {
        // Property observer: whenever flipCount is modified, the following code
        // is automatically executed.
        didSet
        {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
     
    // Outlet to reflect current value of flipCount.
    //     NOTE: this control will typically fail to display in the latest Xcode/Swift
    // unless constraints have been set manually once its position has been adjusted
    // following placement on the storyboard.
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // Choosing 'Outlet Collection' produces an array (rather than a single var)
    // containing the automatically assigned and unique integer identifiers of the
    // controls associated with it.
    //     From the story board, one can also cntl-click the leftmost icon (yellow
    // circle with white centre) and drag to the controls to establish connections
    // to the code.
    @IBOutlet var cardButtons: [ UIButton ]!
    
    // Each variable has an external followed by an internal name. In this case, we're
    // not interested in having an external name, so we set a placeholder '_'.
    //     Cntl-drag from the control to the code and set the appropriate
    // choices; mousing over the bullet will show the connection.
    @IBAction func touchCard( _ sender: UIButton )
    {
        // Use 'let' rather than 'var' for constants. Xcode offers to 'fix' this.
        //     Note also that the firstIndex method returns an optional Int, since
        // the lookup may or may not succeed. Thus, the result must be unwrapped
        // once we are sure that the optional has in fact been set.
        if let cardNumber = cardButtons.firstIndex( of: sender ) // deprecated: index( of ...)
        {
            game.chooseCard( at: cardNumber )
            flipCount += 1
            // Choosing a card may well alter the state of play, so we need (potentially)
            // to update the view.
            updateViewFromModel()
        }
        else
        {
            print( "card not found in cardButtons array" )
        }
    }
    
    func updateViewFromModel()
    {
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
                // Opt-click on an item pulls up the help information for it.
                button.setTitle( "", for: UIControl.State.normal )
                // Typing "color" offers "Color literal" as the first choice;
                // double-cclicking inserts a colour swatch which can then be double-clicked
                // to bring up a palette from which other colours can be chosen.
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    var emojiChoices = [ "👻", "🎃", "😈", "💀", "😺", "👽", "👾", "👺"  ] // inferred to be [ String ]
    
    var emoji = [ Int : String ]()

    // Note repeated identifier 'emoji': Swift allows for identifier overloading. The two
    // types are easily distinguishable according to usage.
    func emoji( for card: Card ) -> String
    {
        // Assign an emoji to the card if it doesn't already have one.
        //     Note the special syntax for back-to-back nested if's using comma.
        if emoji[ card.identifier ] == nil, emojiChoices.count > 0
        {
            // The imported C function 'arc4random_uniform' has been superseded.
            let randomIndex = Int.random( in: 0 ..< emojiChoices.count )
            emoji[ card.identifier ] = emojiChoices.remove( at: randomIndex )
        }
        // Since interrogating optionals is so common, there is a special syntax for
        // conditional extraction.
        return emoji[ card.identifier ] ?? "?"
    }
    
    // When we copy-paste a control and associate it with a new action,
    // we actually end up associating it with the old action as well!
    //     The remedy is to right-click on the newly created control and fix
    // the connections.
}

