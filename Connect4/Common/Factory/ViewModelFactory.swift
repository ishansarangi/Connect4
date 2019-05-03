//
//  ViewModelFactory.swift
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

/*
 * Factory to generate view model objects
 */
struct ViewModelFactory{
    
    private init(){}
    
    static func getConnect4ViewModel(delegate: Connect4ViewController) -> Connect4ViewModelProtocol{
        let viewModel: Connect4ViewModelProtocol = Connect4ViewModel(delegate: delegate)
        return viewModel
    }
    
    static func getConnect4ViewModel(delegate:Connect4ControllerDelegate, with player: Player, and opponent: Player) -> Connect4ViewModelProtocol{
        let viewModel: Connect4ViewModelProtocol = Connect4ViewModel(delegate: delegate,with: player, and: opponent)
        return viewModel
    }
    
}
