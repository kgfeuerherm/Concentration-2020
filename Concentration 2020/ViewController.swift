//
//  ViewController.swift
//  Concentration 2020
//
//  Created by Karljürgen Feuerherm on 2020-03-27.
//  Copyright © 2020 Karljürgen Feuerherm. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var flipCount = 0 // properties must be initialized; type inferred as Int
    {
        // Property observer: whenever flipCount is modified, the following code
        // is automatically executed.
        didSet
        {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var emojiChoices = [ "👻", "🎃", "👻", "🎃" ] // inferred to be [ String ]
    
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
    
    // Cntl-drag from the control to the code and set the appropriate
    // choices; mousing over the bullet will show the connection.
    @IBAction func touchCard( _ sender: UIButton )
    {
        // Use 'let' rather than 'var' for constants. Xcode offers to 'fix' this.
        //     Note also that the firstIndex method returns an optional Int, since
        // the lookup may or may not succeed. Thus, the result must be unwrapped
        // once we are sure that the optional has in fact been set.
        if let cardNumber = cardButtons.firstIndex( of: sender ) // deprecated: index( of ...)
        {
            flipCard( withEmoji: emojiChoices[ cardNumber ], on:  sender )
            flipCount += 1
        }
        else
        {
            print( "card not found in cardButtons array" )
        }
    }
    
    // When we copy-paste a control and associate it with a new action,
    // we actually end up associating it with the old action as well!
    //     The remedy is to right-click on the newly created control and fix
    // the connections. (EDIT: Code deactivated later in the lesson.)
//    @IBAction func touchSecondCard(_ sender: UIButton)
//    {
//        flipCard( withEmoji: "🎃", on: sender )
//        flipCount +=  1
//    }
    
    // Each variable has an external followed by an internal name.
    func flipCard( withEmoji emoji: String, on button: UIButton )
    {
        // Change button attributes to their counterparts depending upon the current state.
        if button.currentTitle == emoji // card is face-up
        {
            // Opt-click on an item pulls up the help information for it.
            button.setTitle( "", for: UIControl.State.normal )
            // Typing "color" offers "Color literal" as the first choice;
            // double-cclicking inserts a colour swatch which can then be double-clicked
            // to bring up a palette from which other colours can be chosen.
            button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
        else // card is face-down
        {
            button.setTitle( emoji, for: UIControl.State.normal )
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
}

