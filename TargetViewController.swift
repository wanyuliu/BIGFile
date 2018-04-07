//
//  TargetViewController.swift
//  BIGFile
//
//  Created by Abby Liu on 6/22/17.
//  Copyright © 2017 Abby Liu. All rights reserved.
//

import Cocoa

class TargetViewController: NSViewController {

    dynamic var target = "target"
    
    @IBAction func dismissTargetWindow(_ sender: NSButton) {
        let application = NSApplication.shared()
        application.stopModal()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
