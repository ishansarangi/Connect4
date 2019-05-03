//
//  UIColorExtension.swift
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
import UIKit

extension UIColor {
    open class var underLine: UIColor{
        return UIColor(red: (212/255.0), green: (212/255.0), blue: (212/255.0), alpha: 1)
    }
    
    open class var text: UIColor{
        return UIColor(red: (239/255.0), green: (244/255.0), blue: (235/255.0), alpha: 1)
    }

    open class var border: UIColor{
        return UIColor(red: (232/255.0), green: (243/255.0), blue: (255/255.0), alpha: 1)
    }
    
}
