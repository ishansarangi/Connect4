//
//  GameBoard.swift
//  Connect4
//
//  Created by Ishan Sarangi on 4/19/19.
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

enum GameState {
    case active
    case won
    case tie
}

final class GameBoard {
    
    // MARK: Properties
    var activePlayer:Player
    let player:Player
    let opponent:Player
    
    //grid has the information for the board with the modified column to
    //facilitate printing of the board
    private var grid:[[String]]!
    
    //actual grid has the dimensions of the board without column modification
    private var actualGrid:[[String]]!
    private let dimensions:GridDimensions
    
    //used to get the layout of the grid in string format
    var boardLayout:String{
        var boardLayout: String = ""
        
        //add column numbers
        for col in 1...dimensions.columns{
            boardLayout += "  \(col)"
        }
        boardLayout += "\n";
        
        //create grid
        for row in 0..<grid.count{
            for col in 0..<grid[0].count{
                boardLayout += grid[row][col]
            }
            if row != grid.count-1{
                boardLayout += "\n"
            }
        }
        
        return boardLayout
    }
    
    private let totalConnectedCoinsToWin: Int = 4
    private var movesLeft: Int = 0
    private var currentMove: Move?
    
    // MARK: Initialization
    init(withDimension dimension: GridDimensions, player: Player, opponent: Player){
        self.dimensions = dimension
        self.player = player
        self.opponent = opponent
        activePlayer = player
        let gridTuple = initializeGrid(withDimension: dimensions)
        grid = gridTuple.gridLayout
        actualGrid = gridTuple.actualGrid
    }
    
    convenience init(player: Player, opponent: Player) {
        let dimension: GridDimensions = GridDimensions(rows: 6, columns: 7)
        self.init(withDimension: dimension, player: player, opponent: opponent)
    }
    
    private func initializeGrid(withDimension dimension:GridDimensions) -> (actualGrid:[[String]], gridLayout:[[String]]) {
        //update moves left
        self.movesLeft = dimensions.columns * dimensions.rows
        
        //create matrix
        let board: [[String]] = Array(repeating: Array(repeating: " ", count: dimensions.columns), count: dimensions.rows)
        var layout: [[String]] = Array(repeating: Array(repeating: " ", count: dimensions.columns*2 + 1), count: dimensions.rows)
        
        for row in 0..<dimensions.rows{
            for col in 0..<dimensions.columns*2 + 1{
                if(col % 2 == 0) {
                    layout[row][col] = Constants.boardColumnBorder
                } else {
                    layout[row][col] = Constants.emptyToken
                }
            }
        }
        return (board, layout)
    }
    
    // MARK:
    
    func isValidMove(at column:Int) throws -> Bool {
        if(column <= 0 || column >= 8) {
            //If the number was not from 1-7
            throw InvalidInputError.columnNotValidError(String(format: Constants.invalidColumnErrorMessage, "1-\(dimensions.columns)"))
        }
        else {
            //If it was a number from 1-7, check if the column is full or not
            if(isColumnFull(for: column)) {
                throw InvalidInputError.columnNotEmptyError(Constants.columnNotEmptyErrorMessage)
            }
            else {
                return true
            }
        }
    }
    
    func addToken(at column: Int) {
        for row in stride(from: grid.count-1, to: -1, by: -1){
            if let correctColumn = getCorrectColumn(for: column), (grid[row][correctColumn] == "   "){
                grid[row][correctColumn] = activePlayer.type.getToken()
                actualGrid[row][column-1] = activePlayer.type.getToken()
                currentMove = Move(row: row, column: column-1)
                updateMovesLeft()
                return
            }
        }
    }
    
    func checkWin() -> GameState{
        guard movesLeft>0 else {return GameState.tie}
        
        //check vertical, horizontal, back diagonal and forward diagonal tokens
        if self.checkVerticalWin() || self.checkHorizontalWin() || self.checkBackDiagonalWin() || self.checkForwardDiagonalWin(){
            return .won
        }
        
        return .active
    }
    
    func changeTurn(){
        activePlayer = activePlayer == player ? opponent : player
    }

    func clear() {
        let gridTuple = initializeGrid(withDimension: dimensions)
        grid = gridTuple.gridLayout
        actualGrid = gridTuple.actualGrid
        activePlayer = player
        
    }
    
}


extension GameBoard {
    private func updateMovesLeft(){
        movesLeft -= 1
    }
    
    private func getCorrectColumn(for column:Int) -> Int? {
        for i in 1...7{
            if(i == column) {
                //to convert it to the correct index of the array
                return (i * 2) - 1
            }
        }
        return nil
    }
    
    private func isColumnFull(for column:Int) -> Bool{
        if let correctColumn = getCorrectColumn(for: column), (grid[0][correctColumn] == PlayerType.none.getToken()){
            return false
        }
        return true
    }
    
    private func checkVerticalWin() -> Bool{
        guard let move = currentMove else {return false}
        var winMoves: [Move] = [Move]()
        var correctPiecesCountLeft: Int = totalConnectedCoinsToWin - 1
        
        //move up the current position
        if move.row > 0{
            for row in stride(from: move.row-1, to: -1, by: -1){
                if actualGrid[row][move.column] == activePlayer.type.getToken() {
                    correctPiecesCountLeft -= 1
                    winMoves.append(Move(row: row, column: move.column))
                    if correctPiecesCountLeft == 0{
                        print(winMoves)
                        return true
                    }
                } else {
                    break
                }
            }
        }
        
        //move down the current position
        if move.row < dimensions.rows-1{
            for row in stride(from: move.row+1, to: dimensions.rows, by: 1){
                if actualGrid[row][move.column] == activePlayer.type.getToken() {
                    correctPiecesCountLeft -= 1
                    winMoves.append(Move(row: row, column: move.column))
                    if correctPiecesCountLeft == 0{
                        print(winMoves)
                        return true
                    }
                } else {
                    break
                }
            }
        }
        
        return false
        
    }
    
    private func checkHorizontalWin() -> Bool{
        guard let move = currentMove else {return false}
        var winMoves: [Move] = [Move]()
        
        var correctPiecesCountLeft: Int = totalConnectedCoinsToWin - 1
        
        //move left of the current position
        if move.column > 0{
            for column in stride(from: move.column-1, to: -1, by: -1){
                if actualGrid[move.row][column] == activePlayer.type.getToken() {
                    correctPiecesCountLeft -= 1
                    winMoves.append(Move(row: move.row, column: column))
                    if correctPiecesCountLeft == 0{
                        print(winMoves)
                        return true
                    }
                } else {
                    break
                }
            }
        }
        
        //move right of the current position
        if move.column < dimensions.columns-1{
            for column in stride(from: move.column+1, to: dimensions.columns, by: 1){
                if actualGrid[move.row][column] == activePlayer.type.getToken() {
                    correctPiecesCountLeft -= 1
                    winMoves.append(Move(row: move.row, column: column))
                    if correctPiecesCountLeft == 0{
                        print(winMoves)
                        return true
                    }
                } else {
                    break
                }
            }
        }
        
        return false
        
    }
    
    private func checkBackDiagonalWin() -> Bool{
        guard let move = currentMove else {return false}
        var winMoves: [Move] = [Move]()
        
        var correctPiecesCountLeft: Int = totalConnectedCoinsToWin - 1
        var row = move.row, column = move.column
        
        //move top left diagonal of the current position
        while row > 0 && column > 0 {
            if actualGrid[row-1][column-1] == activePlayer.type.getToken() {
                correctPiecesCountLeft -= 1
                winMoves.append(Move(row: row-1, column: column-1))
                
                if correctPiecesCountLeft == 0{
                    print(winMoves)
                    return true
                }
            } else {
                break
            }
            
            row -= 1
            column -= 1
        }
        
        row = move.row
        column = move.column
        
        //move bottom right diagonal of the current position
        while row < dimensions.rows-1 && column < dimensions.columns-1 {
            if actualGrid[row+1][column+1] == activePlayer.type.getToken() {
                correctPiecesCountLeft -= 1
                winMoves.append(Move(row: row+1, column: column+1))
                
                if correctPiecesCountLeft == 0{
                    print(winMoves)
                    return true
                }
            } else {
                break
            }
            
            row += 1
            column += 1
        }
        
        return false
        
    }
    
    
    private func checkForwardDiagonalWin() -> Bool{
        guard let move = currentMove else {return false}
        var winMoves: [Move] = [Move]()
        
        var correctPiecesCountLeft: Int = totalConnectedCoinsToWin - 1
        var row = move.row, column = move.column
        
        //move top right diagonal of the current position
        while row > 0 && column < dimensions.columns-1 {
            if actualGrid[row-1][column+1] == activePlayer.type.getToken() {
                correctPiecesCountLeft -= 1
                winMoves.append(Move(row: row-1, column: column+1))
                
                if correctPiecesCountLeft == 0{
                    print(winMoves)
                    return true
                }
            } else {
                break
            }
            
            row -= 1
            column += 1
        }
        
        row = move.row
        column = move.column
        
        //move bottom left diagonal of the current position
        while row < dimensions.rows-1 && column > 0 {
            if actualGrid[row+1][column-1] == activePlayer.type.getToken() {
                correctPiecesCountLeft -= 1
                winMoves.append(Move(row: row+1, column: column-1))
                
                if correctPiecesCountLeft == 0{
                    print(winMoves)
                    return true
                }
            } else {
                break
            }
            
            row += 1
            column -= 1
        }
        
        return false
        
    }
}
