//
//  Connect4ViewModel.swift
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

protocol Connect4ViewModelProtocol {
    var delegate: Connect4ControllerDelegate? { get set }
    var currentPlayer:Player  {get}
    
    func startGame()
    func resetBoard()
    func getBoardLayout() -> String
    func playerDidEnter(column: Int)
}

protocol Connect4ControllerDelegate: class {
    func setupBoard()
    func boardDidUpdate()
    func gameDidFinish(with winner: String?)
    func invalidInput(with message:String)
}


final class Connect4ViewModel{
    fileprivate var gameboard: GameBoard
    fileprivate var gameState: GameState
    
    weak var delegate: Connect4ControllerDelegate?
    
    init(delegate:Connect4ControllerDelegate, with player: Player, and opponent: Player) {
        gameboard = GameBoard(player: player, opponent: opponent)
        self.delegate = delegate
        self.gameState = .active
    }
    
    convenience init(delegate:Connect4ControllerDelegate) {
        let player: Player = Player(type: .playerR)
        let opponent: Player = Player(type: .PlayerY)
        self.init(delegate: delegate, with: player, and: opponent)
    }
    
}


extension Connect4ViewModel: Connect4ViewModelProtocol{
    var currentPlayer: Player {
        return gameboard.activePlayer
    }
    
    func startGame() {
        delegate?.setupBoard()
    }
    
    func getBoardLayout() -> String {
        return gameboard.boardLayout
    }
    
    func resetBoard() {
        gameboard.clear()
        gameState = .active
        delegate?.boardDidUpdate()
    }
    
    func playerDidEnter(column: Int) {
        do{
            if try gameboard.isValidMove(at: column) && gameState == .active{
                gameboard.addToken(at: column)
                let state: GameState = gameboard.checkWin()
                if state == GameState.won {
                    self.gameState = .won
                    delegate?.gameDidFinish(with: currentPlayer.name)
                } else if state == .tie{
                    self.gameState = .tie
                    delegate?.gameDidFinish(with: nil)
                } else{
                    gameboard.changeTurn()
                }
                delegate?.boardDidUpdate()
            }
        } catch InvalidInputError.columnNotEmptyError(let errorMessage) {
            delegate?.invalidInput(with: errorMessage)
        } catch InvalidInputError.columnNotValidError(let errorMessage) {
            delegate?.invalidInput(with: errorMessage)
        } catch {
            delegate?.invalidInput(with: Constants.unknownErrorMessage)
        }
        
    }
    
    
}
