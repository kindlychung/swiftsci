//
//  main.swift
//  swiftsci
//
//  Created by Kaiyin Zhong on 1/17/16.
//  Copyright (c) 2016 emc. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

print("Starting...")
let doc: String = "Not a serious example.\n" +
        "\n" +
        "Usage:\n" +
        "  swiftsci sci \n" +
        "  swiftsci ibook \n" +
//        "  swiftsci <function> <value> [( , <value> )]...\n" +
//        "  swiftsci <value> ( ( + | - | * | / ) <value> )...\n" +
        "  swiftsci (-h | --help)\n" +
        "\n" +
//        "Examples:\n" +   
//        "  swiftsci 1 + 2 + 3 + 4 + 5\n" +
//        "  swiftsci 1 + 2 '*' 3 / 4 - 5    # note quotes around '*'\n" +
//        "  swiftsci sum 10 , 20 , 30 , 40\n" +
        "Options:\n" +
        "  -h, --help\n"

var args = Process.arguments
args.removeAtIndex(0) // arguments[0] is always the program_name
let opts = Docopt.parse(doc, argv: args, help: true, version: "1.0")

//func showNotification(title: String, info: String) -> Void {
//    let notification = NSUserNotification()
//    notification.title = title
//    notification.informativeText = info
//    notification.soundName = NSUserNotificationDefaultSoundName
//    NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
//}

let pasteBoard = NSPasteboard.generalPasteboard()
if let sumCmd = opts["sci"] {
    func replaceClipSci() throws {
        let o = pasteBoard.pasteboardItems
        if let o1 = o {
            let oldString = o1[0].stringForType("public.utf8-plain-text")!
            let newString = try oldString.sci1()
            if newString != oldString {
                print("Hit!")
                pasteBoard.clearContents()
                pasteBoard.writeObjects([newString])
                print("Old: \(oldString)\nNew: \(newString)")
//                showNotification("Clipboard changed", info: "Old: \(oldString.firstN(10))\nNew: \(newString.firstN(10))")
            }
        }
    }
    while true {
        try replaceClipSci()
        NSThread.sleepForTimeInterval(0.1)
    }
}




//let z1 = try "Here we have -3.213e-043, and there we have 4.243E+432".sci()
//print(z1)
