//
//  Constants.swift
//  Connect4
//
//  Created by Ishan Sarangi on 4/20/19.
//  Copyright © 2019 Ishan Sarangi. All rights reserved.
//

/*MIT License
 
 Copyright (c) 2019 Ishan Sarangi
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */


import Foundation

struct Constants {
    static let playerTurnMessage: String = "%@'s Turn"
    static let gameWonTitle: String = "Congratulations!!!"
    static let gameWonMessage: String = "%@ won!!!"
    static let oKText: String = "OK"

    static let gameTieTitle: String = "It's a tie!!!"
    static let gameTieMessage: String = "Please try next time!!!"
    static let resetText: String = "Reset"

    static let invalidInputTitle: String = "Oops!!!"
    static let retryText: String = "Try Again"

    static let doneButtonTitle: String = "Done"

    //Error messages
    static let emptyInputErrorMessage: String = "Please enter a column!!!"
    static let unknownErrorMessage: String = "unknown error"
    static let invalidColumnErrorMessage: String = "That is an invalid input. Please enter a number from %@."
    static let columnNotEmptyErrorMessage: String = "That is an invalid input. The column is full."
    
    
    static let boardColumnBorder: String = "|"
    
    static let playerRToken: String = "R"
    static let playerYToken: String = "Y"
    static let emptyToken: String = "   "
    
    static let playerRName: String = "Player R"
    static let playerYName: String = "Player Y"
    static let noPlayerName: String = "No Player"
}
