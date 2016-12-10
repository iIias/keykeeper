//
//  AppDelegate.swift
//  keykeeper
//
//  Created by Ilias Ennmouri on 07/08/16.
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
import AppKit
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let delegate = AppDelegate.self
    let pasteboard = NSPasteboard.general()
    var eventMonitor: EventMonitor?
    let menu = NSMenu()
    var keykeeper: SecKeychain? = nil
    var theDriveName: String = ""
    let addKeyMenu = NSMenu(title: "Add")
    let deletePasswordMenu = NSMenu(title: "Password")
    let clipboardMenu = NSMenu(title: "Copy")
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let internetPasswordPopover = NSPopover()
    let appPasswordPopover = NSPopover()
    var deleteString: String = ""
    var copyString: String = ""
    
    func addMenuItems() {
        let addKeyItem = NSMenuItem(title: "🔐 Add Password", action: #selector(self.noFunction), keyEquivalent: "")
        let deletePasswordItem = NSMenuItem(title: "🗑 Remove Password", action: #selector(self.noFunction), keyEquivalent: "")
        let clipboardItem = NSMenuItem(title: "🖨 Copy Password", action: #selector(self.noFunction), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "🔒 Lock", action: #selector(self.lockKeykeeper), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "🔓 Unlock", action: #selector(self.noFunction), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(addKeyItem)
        menu.addItem(clipboardItem)
        addKeyMenu.addItem(NSMenuItem(title: "🌐 Add Website Password", action: #selector(self.showInternetPopover), keyEquivalent: ""))
        addKeyMenu.addItem(NSMenuItem(title: "🔑 Add Password", action: #selector(self.showAppPopover), keyEquivalent: ""))
        menu.addItem(deletePasswordItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "🔄 Refresh", action: #selector(self.refreshMenu), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "❌ Quit", action: #selector(self.quit), keyEquivalent: ""))
        clipboardItem.submenu = clipboardMenu
        deletePasswordItem.submenu = deletePasswordMenu
        addKeyItem.submenu = addKeyMenu
    
    for key in addInternetPasswordVC().internetKeychain.allKeys() {
        deletePasswordMenu.addItem(NSMenuItem(title: "🚮🌐 \(key)", action: #selector(deleteWebKey(_:)), keyEquivalent: ""));
        clipboardMenu.addItem(NSMenuItem(title: "🔗🌐 \(key)", action: #selector(copyPasteWebKey(_:)), keyEquivalent: ""));
        }
    
    for key in addAppPasswordVC().appKeychain.allKeys() {
    deletePasswordMenu.addItem(NSMenuItem(title: "🚮🔑 \(key)", action: #selector(deleteAppKey(_:)), keyEquivalent: ""));
    clipboardMenu.addItem(NSMenuItem(title: "🔗🔑 \(key)", action: #selector(copyPasteAppKey(_:)), keyEquivalent: ""));
        } }
    
    func refreshMenu() {
        menu.removeAllItems()
        addKeyMenu.removeAllItems()
        clipboardMenu.removeAllItems()
        deletePasswordMenu.removeAllItems()
        addMenuItems()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared()
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.internetPasswordPopover.isShown  {
                self.closeInternetPopover(sender: event) }
            else if self.appPasswordPopover.isShown {
                self.closeAppPopover(sender: event) } }
        eventMonitor?.start() // starting event monitor
        internetPasswordPopover.contentViewController = addInternetPasswordVC(nibName: "addInternetPasswordVC", bundle: nil)
        appPasswordPopover.contentViewController = addAppPasswordVC(nibName: "addAppPasswordVC", bundle: nil)
        addMenuItems()
        refreshMenu()
        
    if let button = statusItem.button {
        button.title = "🔑"
        button.action = #selector(AppDelegate.refreshMenu)
        button.target = self }
        statusItem.menu = menu
    NSApp.activate(ignoringOtherApps: true) }
    
    func showInternetPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            internetPasswordPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start() } }
    
    func showAppPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            appPasswordPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY) } }
    
    func closeInternetPopover(sender: AnyObject?) {
        internetPasswordPopover.performClose(sender)
        eventMonitor?.stop() }
    
    func closeAppPopover(sender: AnyObject?) {
        appPasswordPopover.performClose(sender)
        eventMonitor?.stop() }
    
    func togglePopover(sender: AnyObject?) {
        if internetPasswordPopover.isShown {
            closeInternetPopover(sender: sender) } else { showInternetPopover(sender: sender) } }

    
    func deleteWebKey(_ sender: NSMenuItem) {
        do {
            let key = sender.title.substring(from: sender.title.range(of: " ")!.upperBound)
            try addInternetPasswordVC().internetKeychain.remove("\(key)")
            print("key: \(key) has been removed")
            refreshMenu()
        } catch let error {
            print("error: \(error)")
        }
    }

    func deleteAppKey(_ sender: NSMenuItem) {
        do {
            let key = sender.title.substring(from: sender.title.range(of: " ")!.upperBound)
            try addAppPasswordVC().appKeychain.remove("\(key)")
            print("key: \(key) has been removed")
            refreshMenu()
        } catch let error {
            print("error: \(error)")
        }
    }
    
    func copyPasteWebKey(_ sender: NSMenuItem) {
        pasteboard.clearContents()
        let key = sender.title.substring(from: sender.title.range(of: " ")!.upperBound)
        let token = try! addInternetPasswordVC().internetKeychain.get("\(key)")
        pasteboard.setString("\(token!)", forType: NSPasteboardTypeString)
    }
    
    func copyPasteAppKey(_ sender: NSMenuItem) {
        pasteboard.clearContents()
        let key = sender.title.substring(from: sender.title.range(of: " ")!.upperBound)
        let token = try! addAppPasswordVC().appKeychain.get("\(key)")
        pasteboard.setString("\(token!)", forType: NSPasteboardTypeString)
    }
    
    func lockKeykeeper() {
        SecKeychainLock(keykeeper)
    } // lock current keykeeper

    func dialogDismiss(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "Dismiss")
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    func noFunction() {
        print("Placeholder func used")
    }
    
    func quit() { NSApp.terminate(self)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

