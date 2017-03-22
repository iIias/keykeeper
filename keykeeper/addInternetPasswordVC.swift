//
//  addInternetPasswordVC.swift
//  keykeeper
//
//  Created by Ilias Ennmouri on 26/11/2016.
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

class addInternetPasswordVC: NSViewController {
    
    @IBOutlet weak var itemNameField: NSTextField!
    @IBOutlet weak var accountNameField: NSTextField!
    @IBOutlet weak var accountPasswordField: NSSecureTextField!
    @IBOutlet weak var commentField: NSTextField!
    let internetKeychain = Keychain(server: "keykeeper.co", protocolType: .https, authenticationType: .htmlForm)
    @IBAction func addPasswordButtonAction(_ sender: Any) {
        if itemNameField.stringValue == "" && accountNameField.stringValue == "" {
        } else {
        do { try internetKeychain
            .accessibility(.afterFirstUnlock)
            .synchronizable(true)
            .label("keykeeper \(itemNameField.stringValue) (\(accountNameField.stringValue))")
            .comment(commentField.stringValue)
            .set(accountPasswordField.stringValue, key: "\(accountNameField.stringValue) » \(itemNameField.stringValue)")
        } catch let error {
            print("error: \(error)") }
            refreshMenu()
        itemNameField.stringValue = ""
        accountNameField.stringValue = ""
        accountPasswordField.stringValue = ""
        commentField.stringValue = ""
        }
    }
    
    func refreshMenu() {
        AppDelegate().menu.removeAllItems()
        AppDelegate().addKeyMenu.removeAllItems()
        AppDelegate().clipboardMenu.removeAllItems()
        AppDelegate().deletePasswordMenu.removeAllItems()
        AppDelegate().addMenuItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    } 
}
