//
//  addAppPasswordVC.swift
//  keykeeper
//
//  Created by Ilias Ennmouri on 27/11/2016.
//  Copyright © 2016 keykeeper. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import Cocoa
import KeychainAccess

class addAppPasswordVC: NSViewController {

    @IBOutlet weak var commentTextField: NSTextField!
    @IBOutlet weak var pwSecureTextField: NSSecureTextField!
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBAction func addAppPasswordAction(_ sender: Any) {
        let appKeychain = Keychain(service: "co.keykeeper.keykeeper", accessGroup: "AUHLTS98UR.shared")
        do {
            try appKeychain
                .accessibility(.afterFirstUnlock)
                .synchronizable(true)
                .comment(commentTextField.stringValue)
                .label("keykeeper \(titleTextField.stringValue)")
                .set(pwSecureTextField.stringValue, key: titleTextField.stringValue)
        } catch let error {
            print("error: \(error)")
        }
        commentTextField.stringValue = ""
        pwSecureTextField.stringValue = ""
        usernameTextField.stringValue = ""
        titleTextField.stringValue = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
