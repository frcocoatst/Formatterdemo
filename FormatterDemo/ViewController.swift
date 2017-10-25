//
//  ViewController.swift
//  FormatterDemo
//
//  Created by Friedrich HAEUPL on 24.10.17.
//  Copyright © 2017 Friedrich HAEUPL. All rights reserved.
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

class ViewController: NSViewController {

    @IBOutlet weak var outputIP: NSTextField!

    @IBOutlet weak var enterIP: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterIP.stringValue = "Enter Number"
        outputIP.stringValue = "Output Number"
        
        // set the formatter
        // let onlyIntFormatter = IntegerFormatter()
        //let onlyIntFormatter = OnlyNumber()
        let ipFormatter = IPFormatter()
        enterIP.formatter = ipFormatter
        
    
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func setIPAction(_ sender: Any) {
        
        outputIP.stringValue =  enterIP.stringValue
        
    }
    
}

