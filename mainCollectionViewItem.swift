//
//  mainCollectionViewItem.swift
//  BIGFile
//
//  Created by Abby Liu on 6/21/17.
//  Copyright © 2017 Abby Liu. All rights reserved.
//

import Cocoa

class mainCollectionViewItem: NSCollectionViewItem {

    @IBOutlet weak var mainimageView: NSImageView!
    @IBOutlet weak var mainlabel: NSTextField!
    
    override var representedObject: Any? {
        didSet {
            guard let data = self.representedObject as? Node else {
                return
            }
            if data.category == 0 {
                let image = NSImage(named: NSImageNameFolder)
                mainimageView.image = image
                
            } else {
                let image = NSImage(named: "File")
                mainimageView.image = image
            }
            
            if let title = data.value as? String {
                mainlabel.stringValue = title
            }
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.view.layer?.borderColor = NSColor.orange.cgColor
                self.view.layer?.borderWidth = 2.0
                
            } else {
                self.view.layer?.borderColor = NSColor.clear.cgColor
                self.view.layer?.borderWidth = 0.0
            }
        }
    }
    
    override var highlightState: NSCollectionViewItemHighlightState {
        didSet {
            if highlightState == .forSelection {
                self.view.layer?.backgroundColor = NSColor.gray.cgColor
            } else {
                self.view.layer?.backgroundColor = NSColor.clear.cgColor
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    }
    
}
