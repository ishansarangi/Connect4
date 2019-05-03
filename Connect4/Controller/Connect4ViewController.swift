//
//  Connect4ViewController.swift
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


import UIKit

final class Connect4ViewController: UIViewController {
    
    @IBOutlet weak var boardLayoutLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    private var viewModel: Connect4ViewModelProtocol!
    
    // MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.addDoneButtonToKeyboard(with: #selector(self.inputTextField.resignFirstResponder))
        viewModel = ViewModelFactory.getConnect4ViewModel(delegate: self)
        viewModel.startGame()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        enterButton.layer.cornerRadius = enterButton.bounds.height/2
        restartButton.layer.cornerRadius = restartButton.bounds.height/2
    }
    
    // MARK:- View Setup
    func updateBoardLayout(){
        let layoutString : String = viewModel.getBoardLayout()
        boardLayoutLabel.attributedText = getAttributedStringForBoardLayout(from: layoutString)
        messageLabel.text = String(format: Constants.playerTurnMessage, viewModel.currentPlayer.name)
        self.inputTextField.text = ""
    }
    
    func getAttributedStringForBoardLayout(from layoutString: String) -> NSMutableAttributedString{
        
        let commonAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 28),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue,
            NSAttributedString.Key.underlineColor: UIColor.underLine,
            NSAttributedString.Key.foregroundColor: UIColor.text]
        
        // for player R' token
        let redAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.red]
        
        // for player Y's token
        let yellowAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.yellow]
        
        let borderAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 31),
            NSAttributedString.Key.foregroundColor: UIColor.border,
            NSAttributedString.Key.backgroundColor: UIColor.clear ]
        
        let whiteSpaceAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 3),
            NSAttributedString.Key.backgroundColor: UIColor.clear ]

        let attributedString = NSMutableAttributedString(string: layoutString,attributes: commonAttributes)
            attributedString.addAttributesForAllOccuranceOfText(Constants.playerRToken, with: redAttributes)
            attributedString.addAttributesForAllOccuranceOfText(Constants.playerYToken, with: yellowAttributes)
            attributedString.addAttributesForAllOccuranceOfText(Constants.boardColumnBorder, with: borderAttributes)
            attributedString.addAttributesForAllOccuranceOfText("\n", with: whiteSpaceAttributes)
            attributedString.addAttributesForAllOccuranceOfText("", with: whiteSpaceAttributes)
        
        return attributedString

    }
    
    func resetView(){
        self.viewModel.resetBoard()
    }
    
    // MARK:- IBActions:  column enter and restart
    @IBAction func enterButtonClicked(_ sender: Any) {
        if let inputText = inputTextField.text, let column = Int(inputText){
            viewModel.playerDidEnter(column: column)
        } else {
            //In case of no input
            let alertController: UIAlertController = UIAlertController(title: Constants.invalidInputTitle, message: Constants.emptyInputErrorMessage , preferredStyle: UIAlertController.Style.alert)
            let action: UIAlertAction = UIAlertAction(title: Constants.oKText, style: .default) { (action:UIAlertAction) in
                self.inputTextField.text?.removeAll()
                self.inputTextField.becomeFirstResponder()
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func restartButtonClicked(_ sender: Any) {
        self.resetView()
    }
    
}

// MARK:- Connect4ControllerDelegate methods
extension Connect4ViewController: Connect4ControllerDelegate{
    func setupBoard() {
        updateBoardLayout()
    }
    
    func invalidInput(with message: String) {
        let alertController:UIAlertController = UIAlertController(title: Constants.invalidInputTitle, message: message , preferredStyle: .alert)
        let action:UIAlertAction = UIAlertAction(title: Constants.retryText, style: .default) { (action:UIAlertAction) in
            self.inputTextField.text?.removeAll()
            self.inputTextField.becomeFirstResponder()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func gameDidFinish(with winner: String?) {
        let alertController:UIAlertController
        let action:UIAlertAction
        
        guard let winner = winner else {
            //In case it is a tie
            alertController = UIAlertController(title: Constants.gameTieTitle, message: Constants.gameTieMessage , preferredStyle: UIAlertController.Style.alert)
            action = UIAlertAction(title: Constants.resetText, style: .default) { [weak self] (action:UIAlertAction) in
                self?.resetView()
            }
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        alertController = UIAlertController(title: Constants.gameWonTitle, message: String(format: Constants.gameWonMessage, winner) , preferredStyle: .alert)
        action = UIAlertAction(title: Constants.oKText, style: .default) { [weak self] (action:UIAlertAction) in
            self?.resetView()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func boardDidUpdate() {
        self.updateBoardLayout()
    }
    
}

// MARK:- UITextFieldDelegate methods
extension Connect4ViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        //limit to 1 character
        return updatedText.count <= 1
    }
}
