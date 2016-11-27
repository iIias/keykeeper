//
//  AppDelegate.swift
//  keykeeper
//
//  Created by Ilias Ennmouri on 07/08/16.
//  Copyright © 2016 keykeeper. All rights reserved.
//

import Cocoa
import KeychainAccess
import AppKit
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let delegate = AppDelegate.self
    var appKeychain = Keychain(service: "co.keykeeper.keykeeper")
    var internetKeychain = Keychain(server: "https://example.com", protocolType: .https, authenticationType: .htmlForm)
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
        let addKeyItem = NSMenuItem(title: "🔐 Add Key", action: #selector(self.noFunction), keyEquivalent: "")
        let deletePasswordItem = NSMenuItem(title: "🗑 Remove Password", action: #selector(self.noFunction), keyEquivalent: "")
        let clipboardItem = NSMenuItem(title: "🖨 Copy Password", action: #selector(self.noFunction), keyEquivalent: "")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "🔒 Lock", action: #selector(self.lockKeykeeper), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "🔓 Unlock", action: #selector(self.noFunction), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(addKeyItem)
        menu.addItem(clipboardItem)
        addKeyMenu.addItem(NSMenuItem(title: "🌐 Add Internet Password", action: #selector(self.showInternetPopover), keyEquivalent: ""))
        addKeyMenu.addItem(NSMenuItem(title: "🔑 Add App Password", action: #selector(self.showAppPopover), keyEquivalent: ""))
        addKeyMenu.addItem(NSMenuItem(title: "💳 Add Credit Card", action: #selector(self.noFunction), keyEquivalent: ""))
        menu.addItem(deletePasswordItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "❌ Quit", action: #selector(self.quit), keyEquivalent: ""))
        clipboardItem.submenu = clipboardMenu
        deletePasswordItem.submenu = deletePasswordMenu
        addKeyItem.submenu = addKeyMenu
        
        for (index, value) in internetKeychain.allKeys().enumerated() {
            print("Item \(index): \(value)")
            deletePasswordMenu.addItem(NSMenuItem(title: "🚮 \(value)", action: #selector(AppDelegate.deleteKey), keyEquivalent: ""));
            clipboardMenu.addItem(NSMenuItem(title: "🔗 \(value)", action: #selector(AppDelegate.copyToPasteboard), keyEquivalent: "")); } }
    
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
        button.action = #selector(AppDelegate.noFunction)
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
    
    func copyToPasteboard() {
        pasteboard.clearContents()
        let token = try! internetKeychain.get("\(copyString)")
        pasteboard.setString("\(token!)", forType: NSPasteboardTypeString) }
    
    func deleteKey() {
        do {
        try internetKeychain.remove("\(deleteString)")
        print("key: \(deleteString) has been removed")
    } catch let error {
        print("error: \(error)") }
     refreshMenu() }
    
    func lockKeykeeper() {
        SecKeychainLock(keykeeper) } // lock current keykeeper

    func dialogDismiss(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "Dismiss")
        return myPopup.runModal() == NSAlertFirstButtonReturn }
    
    func noFunction() {
        print("Placeholder func used") }
    
    func quit() { NSApp.terminate(self) }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

