//
//  IPFormatter.swift
//  FormatterDemo
//
//  Created by Friedrich HAEUPL on 24.10.17.
//  Copyright © 2017 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

extension String {
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func location(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
}
/*
 usage:
 
 let str = "Hello, playground, playground, playground"
 str.index(of: "play")      // 7
 str.location(of: "play")
 str.endIndex(of: "play")   // 11
 str.indexes(of: "play")    // [7, 19, 31]
 str.ranges(of: "play")     // [{lowerBound 7, upperBound 11}, {lowerBound 19, upperBound 23}, {lowerBound 31, upperBound 35}]
 */

class OnlyNumber: Formatter {
    
    override func string(for obj: (Any)?) -> String? {
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        return true
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        if(partialString.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) != nil){
            // if(partialString.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) != nil) {
            NSSound.beep()
            return false
        }
        return true
    }
    
}

// IP-Formatter
class IPFormatter: Formatter {
    
    override func string(for obj: (Any)?) -> String? {
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        return true
    }
    
    override func isPartialStringValid(_ partialString: String,
                                       newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        // numbers and . allowed
        let notAllowedChars = CharacterSet(charactersIn:"0123456789.").inverted
        
        if(partialString.rangeOfCharacter(from: notAllowedChars) != nil){
            NSSound.beep()
            return false
        }
        else
        {
            // https://stackoverflow.com/questions/24034043/how-do-i-check-if-a-string-contains-another-string-in-swift
            // no double dots allowd
            if (partialString.range(of:"..") != nil)
            {
                NSSound.beep()
                return false
            }
            
            // No dot at the beginning
            if let range = partialString.range(of:".") {
                let startPos = partialString.distance(from: partialString.startIndex, to: range.lowerBound)
                if startPos == 0{
                    NSSound.beep()
                    return false
                }
            }
            // Array of segments
            let textSegments = partialString.components(separatedBy: ".")
            
            // allow only four segements
            if textSegments.count > 4 {
                NSSound.beep()
                return false
            }
            
            // check the individual segments
            for segment in textSegments{
                
                // no 0 in the first segment at the beginning
                if textSegments.count == 1
                {
                    if let range = segment.range(of:"0") {
                        let startPos = segment.distance(from: segment.startIndex, to: range.lowerBound)
                        if startPos == 0 {
                            NSSound.beep()
                            return false
                        }
                    }
                }
                else
                {
                    // No 00 in the segments at the segment start
                    if let range = segment.range(of:"00") {
                        let startPos = segment.distance(from: segment.startIndex, to: range.lowerBound)
                        if startPos == 0 {
                            NSSound.beep()
                            return false
                        }
                    }
                    else
                    {
                        // No 0 at segment start when other digits follow
                        if let range = segment.range(of:"0") {
                            let startPos = segment.distance(from: segment.startIndex, to: range.lowerBound)
                            if startPos == 0 && segment.lengthOfBytes(using: .utf8) > 1 {
                                NSSound.beep()
                                return false
                            }
                        }
                    }
                }
                
                // max three digits
                if segment.lengthOfBytes(using: .utf8) > 3
                {
                    NSSound.beep()
                    return false
                    
                }
                
                // IP segment should be less then 255
                let wert = Int(segment)
                if wert != nil {
                    if wert! > 255 {
                        NSSound.beep()
                        return false
                    }
                }
            }
        }
        return true
    }
}
