//
//  EventMonitor.swift
//  keykeeper
//
//  Created by Ilias Ennmouri on 01/11/2016.
//  Copyright © 2016 keykeeper. All rights reserved.
//

import Foundation
import Cocoa

public class EventMonitor {
    private var monitor: AnyObject?
    private let mask: NSEventMask
    private let handler: (NSEvent?) -> ()
    
  public init(mask: NSEventMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler }
    deinit { stop() }
    public func start() { monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject? }
    public func stop() { if monitor != nil { NSEvent.removeMonitor(monitor!); monitor = nil } } }
