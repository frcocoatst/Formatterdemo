//
//  ViewController.swift
//  FormatterDemo
//
//  Created by me on 24.10.17.
//  Copyright © 2017 me. All rights reserved.
//
//  https://stackoverflow.com/questions/12161654/restrict-nstextfield-to-only-allow-numbers
//


import Cocoa
/*
this works:
 
extension String {
    
    func isInt() -> Bool {
        
        if let intValue = Int(self) {
            
            if intValue >= 0 {
                return true
            }
        }
        
        return false
    }
    
    func numberOfCharacters() -> Int {
        return self.characters.count
    }
}

class IntegerFormatter: NumberFormatter {
    
    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        // Allow blank value
        if partialString.numberOfCharacters() == 0  {
            return true
        }
        
        // Validate string if it's an int
        if partialString.isInt() {
            return true
        } else {
            NSSound.beep()
            return false
        }
    }
}
 
 // calling:
 //     let onlyIntFormatter = IntegerFormatter()
 //     enterIP.formatter = onlyIntFormatter
*/

// var enteredString = String()

class ViewController: NSViewController {
    

    @IBOutlet weak var outputIP: NSTextField!

    @IBOutlet weak var enterIP: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enterIP.stringValue = "255.255.255.255"
        self.outputIP.stringValue = "Entered IP"
        
        // some formatters
        // let onlyIntFormatter = OnlyNumber()
        // self.enterIP.formatter = onlyIntFormatter
        
        // let macAddressFormatter = MacAddressFormatter()
        // self.enterIP.formatter = macAddressFormatter

        let ipFormatter = IPFormatter()
        self.enterIP.formatter = ipFormatter
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func setIPAction(_ sender: Any) {
        
        // enteredString = self.enterIP.stringValue
        // self.outputIP.stringValue = self.enterIP.stringValue
        
        let enteredString = self.enterIP.stringValue
        self.outputIP.stringValue = enteredString
        
        print(" entered string: \(self.enterIP.stringValue)")
    }
    
}

