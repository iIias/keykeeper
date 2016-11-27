//
//  addAppPasswordVC.swift
//  keykeeper
//
//  Created by Ilias Ennmouri on 27/11/2016.
//  Copyright © 2016 keykeeper. All rights reserved.
//

import Cocoa
import KeychainAccess

class addAppPasswordVC: NSViewController {

    @IBOutlet weak var commentTextField: NSTextField!
    @IBOutlet weak var pwSecureTextField: NSSecureTextField!
    @IBOutlet weak var usernameTextField: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBAction func addAppPasswordAction(_ sender: Any) {
        let appKeychain = Keychain(service: "co.keykeeper.keykeeper")
        do {
            try appKeychain
                .accessibility(.afterFirstUnlock)
                .set("01234567-89ab-cdef-0123-456789abcdef", key: "kishikawakatsumi")
        } catch let error {
            print("error: \(error)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
