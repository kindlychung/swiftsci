//
//  main.swift
//  swiftsci
//
//  Created by Kaiyin Zhong on 1/17/16.
//  Copyright (c) 2016 emc. All rights reserved.
//

import Foundation
import AppKit
import Darwin

let doc: String = "Not a serious example.\n" +
    "\n" +
    "Usage:\n" +
    //        "  swiftsci sci \n" +
    //        "  swiftsci ibook \n" +
    //        "  swiftsci <function> <value> [( , <value> )]...\n" +
    "  swiftsci <function> \n" +
    //        "  swiftsci <value> ( ( + | - | * | / ) <value> )...\n" +
    "  swiftsci (-h | --help)\n" +
    "\n" +
            "Examples:\n" +
            "  swiftsci sci\n" +
            "  swiftsci ibook\n" +
    "Options:\n" +
"  -h, --help\n"

var args = Process.arguments

args.removeAtIndex(0) // arguments[0] is always the program_name

print(args)
if(args.count != 1) {
    print("You must give a command!")
    exit(1)
}

let opts = Docopt.parse(doc, argv: args, help: true, version: "1.0")

let pasteBoard = NSPasteboard.generalPasteboard()

func fSci(s: String) throws -> String {
    return try s.sci()
}
func fIbook(s: String) throws -> String {
    return try s.ibook()
}

let funcMap = [ "sci": fSci, "ibook": fIbook ]

func replaceClip(f: String throws -> String) throws {
    func helper() throws {
        let o = pasteBoard.pasteboardItems
        if let o1 = o {
            let oldString = o1[0].stringForType("public.utf8-plain-text")!
            //        let newString = try oldString.sci()
            let newString = try f(oldString)
            if newString != oldString {
                print("Hit!")
                pasteBoard.clearContents()
                pasteBoard.writeObjects([newString])
                print("Old: \(oldString)\nNew: \(newString)")
            }
        }
    }
    
    while true {
        try helper()
        NSThread.sleepForTimeInterval(0.1)
    }
}



if let cmd = opts["<function>"] {
    let cmd = cmd as! String
    print(cmd)
    if let f = funcMap[cmd] {
        try replaceClip(f)
    }
}







//let z1 = try "Here we have -3.213e-043, and there we have 4.243E+432".sci()
//print(z1)
