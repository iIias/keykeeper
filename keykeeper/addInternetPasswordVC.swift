//
//  addInternetPasswordVC.swift
//  keykeeper
//
//  Created by Ilias Ennmouri on 26/11/2016.
//  Copyright © 2016 keykeeper. All rights reserved.
//

import Cocoa
import KeychainAccess

class addInternetPasswordVC: NSViewController {
    
    @IBOutlet weak var itemNameField: NSTextField!
    @IBOutlet weak var accountNameField: NSTextField!
    @IBOutlet weak var accountPasswordField: NSSecureTextField!
    @IBOutlet weak var commentField: NSTextField!
    @IBAction func addPasswordButtonAction(_ sender: Any) {
        if itemNameField.stringValue.isEmpty && accountNameField.stringValue.isEmpty && accountPasswordField.stringValue.isEmpty {
            itemNameField.stringValue = "required"
            accountNameField.stringValue = "required"
            accountPasswordField.stringValue = "required"
            commentField.stringValue = "required" }
        AppDelegate().internetKeychain = Keychain(server: itemNameField.stringValue, protocolType: .https, authenticationType: .htmlForm)
        do { try AppDelegate().internetKeychain
            .accessibility(.afterFirstUnlock)
            .synchronizable(true)
            .label("keykeeper \(itemNameField.stringValue) (\(accountNameField.stringValue))")
            .comment(commentField.stringValue)
            .set(accountPasswordField.stringValue, key: "\(accountNameField.stringValue) » \(itemNameField.stringValue)")
        } catch let error {
            print("error: \(error)") }
        itemNameField.stringValue = ""
        accountNameField.stringValue = ""
        accountPasswordField.stringValue = ""
        commentField.stringValue = ""
        print(AppDelegate().internetKeychain)
        AppDelegate().closeInternetPopover(sender: sender as AnyObject?)
        AppDelegate().refreshMenu() }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    } }
