//
//  CollectionViewItem.swift
//  BIGFile
//
//  Created by Abby Liu on 6/27/17.
//  Copyright © 2017 Abby Liu. All rights reserved.
//

import Cocoa

class CollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var iconImageView: NSImageView!
    @IBOutlet weak var titleLabel: NSTextField!
    
    
    override var representedObject: Any? {
        didSet {
            guard let data = self.representedObject as? Node else {
                return
            }
            if data.category == 0 {
                let image = NSImage(named: NSImageNameFolder)
                iconImageView.image = image
                
            } else {
                let image = NSImage(named: "File")
                iconImageView.image = image
            }
            
            if let title = data.value as? String {
                titleLabel.stringValue = title
            }
            
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.view.layer?.backgroundColor = NSColor(red: 223/255, green: 223/255, blue: 221/255, alpha: 0.8).cgColor
            } else {
                self.view.layer?.backgroundColor = NSColor.clear.cgColor
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
