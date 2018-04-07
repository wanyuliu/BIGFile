//
//  WindowController.swift
//  BIGFile
//
//  Created by Abby Liu on 2/26/17.
//  Copyright © 2017 Abby Liu. All rights reserved.
//

import Cocoa

var back = 0

class WindowController: NSWindowController {
    
    
    @IBAction func ListClick(_ sender: NSToolbarItem) {
        viewController.enableView1(enabledView: viewController.tableView)
        viewController.disableView2(disabledView: viewController.mainCollectionView)
        
    }
    
    @IBAction func BackClick(_ sender: NSToolbarItem) {
        objects = previous_state
        shown = previous_shown
        viewController.tableView.reloadData()
    }
    
    @IBAction func IconClick(_ sender: NSToolbarItem) {
        viewController.enableView2(enabledView: viewController.mainCollectionView)
        viewController.disableView1(disabledView: viewController.tableView)
    }
    
    var viewController: ViewController {
        get {
            return self.window!.contentViewController! as! ViewController
        }
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
    }

}
