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

class IPFormatter: Formatter {
    
    override func string(for obj: (Any)?) -> String? {
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                 for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        return true
    }
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        // Ziffern und Punkt
        let allowedChars = CharacterSet(charactersIn:"0123456789...").inverted
        
        if(partialString.rangeOfCharacter(from: allowedChars) != nil){
            NSSound.beep()
            return false
        }
        else{
            // https://stackoverflow.com/questions/24034043/how-do-i-check-if-a-string-contains-another-string-in-swift
            // Keine Punktfolge
            if (partialString.range(of:"..") != nil)
            {
                NSSound.beep()
                return false
            }

            // Kein Punkt am Anfang
            if let range = partialString.range(of:".") {
                let startPos = partialString.distance(from: partialString.startIndex, to: range.lowerBound)
                if startPos == 0{
                    NSSound.beep()
                    return false
                }
            }
            // Adress-Segmente bilden
            // NSArray *textSegments = [partialString componentsSeparatedByString:@"."];
            let textSegments = partialString.components(separatedBy: ".")
            
            // Maximal vier Segmente erlauben
            if textSegments.count > 4 {
                NSSound.beep()
                return false
            }
            // Einzelne Segmente prüfen
            for segment in textSegments{
                
                // Keine 0 am Anfang, sonst aber schon
                if textSegments.count == 1
                {
                    /* if([segment rangeOfString:@"0"].location == 0)
                    if (segment.range(of:"0") != nil){
                        NSSound.beep()
                        return false
                    }
                    */
                    if let range = partialString.range(of:"0") {
                        let startPos = partialString.distance(from: partialString.startIndex, to: range.lowerBound)
                        if startPos == 0 {
                            NSSound.beep()
                            return false
                        }
                    }
                }
                else
                {
                    // Keine 00 in den weiteren Segmenteb
                    //if([segment rangeOfString:@"00"].location == 0)
                    if let range = partialString.range(of:"00") {
                        let startPos = partialString.distance(from: partialString.startIndex, to: range.lowerBound)
                        if startPos == 0 {
                            NSSound.beep()
                            return false
                        }
                    }
                    else
                    {
                        if let range = partialString.range(of:"0") {
                            let startPos = partialString.distance(from: partialString.startIndex, to: range.lowerBound)
                            if startPos == 0 && segment.lengthOfBytes(using: .utf8) > 1 {
                                NSSound.beep()
                                return false
                            }
                        }
                    }
                
                    // Maximal 3 Ziffern
                    if segment.lengthOfBytes(using: .utf8) > 3
                    {
                        NSSound.beep()
                        return false
                        
                    }
                
                    // Kleiner gleich 255
                    let wert = Int(segment)
                    if wert != nil {
                        if wert! < 255 {
                            NSSound.beep()
                            return false
                        }
                    }
    
                }
            }
        }
        return true
    }
}
/* another try:
 class IPFormatter: Formatter {
 
 override func string(for obj: Any?) -> String? {
 
 if obj == nil {
 print("stringForObjectValue: obj is nil, returning nil")
 return nil
 }
 if let o = obj as? String {
 print("stringForObjectValue:  obj is string, returning \(o)")
 return o
 }
 
 print("stringForObjectValue: obj is not string, returning nil")
 return nil
 }
 
 func getObjectValue(_: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for: String, errorDescription: AutoreleasingUnsafeMutablePointer<NSString?>?) {
 
 //override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
 print("getObjectValue: \(string)")
 let obj = string
 // obj.memory = string
 return true
 }
 
 //    override func isPartialStringValid(partialString: String?, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
 
 override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
 
 if let s = partialString {
 var illegals : String = join("",s.componentsSeparatedByCharactersInSet(PSEntryNameFormatterCharacterSet))
 var goods = s.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: illegals))
 let newString : NSString = join("", goods)
 
 if String(newString) == s {
 print("isPartialStringValid: partial string ok")
 return true
 }
 }
 
 print("isPartialStringValid: partial string bad")
 return false
 }
 
 
 }
 
 */
