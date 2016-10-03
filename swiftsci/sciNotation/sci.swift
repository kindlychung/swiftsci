//
// Created by Kaiyin Zhong on 1/18/16.
// Copyright (c) 2016 emc. All rights reserved.
//

import Foundation
import AppKit


public struct Str {
    public static func head(s: String) -> Character {
        return s[s.startIndex]
    }
    
    public static func tail(s: String) -> String {
        let range = (s.startIndex.advancedBy(1)) ..< s.endIndex
        return s[range]
    }
    
    
    public static func dealWithSign(s: String) -> String {
        if head(s) == "-" {
            return "-\(dealWithSign(tail(s)))"
        } else if head(s) == "+" {
            return dealWithSign(tail(s))
        } else {
            var s1 = s
            while (head(s1) == "0") {
                s1 = tail(s1)
            }
            return s1
        }
    }


    public static let superscriptDict: [Character:Character] = [
        "0": "\u{2070}",
        "1": "\u{00b9}",
        "2": "\u{00b2}",
        "3": "\u{00b3}",
        "4": "\u{2074}",
        "5": "\u{2075}",
        "6": "\u{2076}",
        "7": "\u{2077}",
        "8": "\u{2078}",
        "9": "\u{2079}",
        "-": "⁻"
    ]
}


public extension String {
    public func rangeFromNSRange(aRange: NSRange) -> Range<String.Index> {
        let s = self.startIndex.advancedBy(aRange.location)
        let e = self.startIndex.advancedBy(aRange.location + aRange.length)
        return s ..< e
    }

    public func firstN(n: Int) -> String {
        return self.substringToIndex(self.startIndex.advancedBy(n))
    }
    public var ns: NSString {
        return self as NSString
    }
    public subscript(aRange: NSRange) -> String? {
        get {
            return self.substringWithRange(self.rangeFromNSRange(aRange))
        }
    }

    public var cdr: String {
        return isEmpty ? "" : String(characters.dropFirst())
    }

    private func removeByRegex(s: String, match: NSTextCheckingResult) -> String {
        return ""
    }

    public func ibook() throws -> String {
        return try replaceByRegex("(“|”|\\s+Excerpt From:[^“”]+“[^“”]+” iBooks.)", f: removeByRegex)
    }

    public func toCaml() throws -> String {
        func f(s: String, match: NSTextCheckingResult) -> String {
            return s[
            match.rangeAtIndex(1)         // range of the capture group
            ]!.uppercaseString
        }

        return try replaceByRegex("_+(.)", f: f)
    }

    public func sci() throws -> String {
        func f(string: String, match: NSTextCheckingResult) -> String {
            let coef = string[match.rangeAtIndex(1)]!
            let exponent = Str.dealWithSign(string[match.rangeAtIndex(3)]!).characters.map({
                Str.superscriptDict[$0]!
            })
            return "\(coef)\u{00d7}10\(String(exponent))"
        }

        return try replaceByRegex("([+-]?\\d+(\\.\\d+)?)[Ee]([+-]?\\d+)", f: f)
    }

    public func replaceByRegex(pattern: String, regexOptions: NSRegularExpressionOptions = [], matchOptions: NSMatchingOptions = [], f: (string:String, match:NSTextCheckingResult) -> String) throws -> String {
        var s = self
        let regex = try NSRegularExpression(pattern: pattern, options: regexOptions)
        let matches = regex.matchesInString(s, options: matchOptions, range: NSMakeRange(0, s.ns.length)).reverse()
        for match in matches {
            let matchRange = s.rangeFromNSRange(match.range)
            let newString = f(string: s, match: match)
            s.replaceRange(matchRange, with: newString)
        }
        return s
    }
}

