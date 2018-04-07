//
//  ViewController.swift
//  BIGFile
//
//  Created by Abby Liu on 2/26/17.
//  Copyright © 2017 Abby Liu. All rights reserved.
//

import Cocoa
import AppKit


class ViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var ListView: NSScrollView!
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var mainCollectionView: NSCollectionView!
    
    
    fileprivate func configureCollectionView() {

        // the BIG part
        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        collectionView.collectionViewLayout = layout
        collectionView.register(CollectionViewItem.self, forItemWithIdentifier: "Cell")
        collectionView.isSelectable = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layer?.backgroundColor = NSColor.white.cgColor
        
        
        // the icon view part
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        mainCollectionView.collectionViewLayout = flowLayout
        mainCollectionView.register(mainCollectionViewItem.self, forItemWithIdentifier: "Cell")
        mainCollectionView.isSelectable = true
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        view.wantsLayer = true
  
        mainCollectionView.layer?.backgroundColor = NSColor.white.cgColor
        
    }

    // define nodes and their relationships here
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureCollectionView()
        
        // set up List View
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.target = self
        tableView.doubleAction = #selector(tableViewDoubleClick(_:))
        
        disableView2(disabledView: mainCollectionView)

    }
    
    func tableViewDoubleClick(_ sender:AnyObject) {
        
        // get the user behavior
        let item = shown[tableView.selectedRow]
        
        previous_shown = shown
        previous_state = objects
        
        user_input = tableView.selectedRow + 1
        item.update()
        print(user_input)
        
        current_node = item
        print(item.value)
        
        if item.category == 0 {
            item.directc()
            shown = new_nodes
            item.best_items()
            
            tableView.reloadData()
            collectionView.reloadData()
            
        } else {
            if item.value == target.value {
                print("target found!")
                target.probability = 1
                
            } else {
                print("wrong target!")
            }
        }
        print("target probability: ", target.probability)
        
    }
    
    
    // show target
    @IBAction func targetWindow(_ sender: AnyObject) {
        

        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let TargetWindowController = storyboard.instantiateController(withIdentifier: "Target Window Controller") as! NSWindowController
        
        if let TargetWindow = TargetWindowController.window {
            

            let TargetViewController = TargetWindow.contentViewController as! TargetViewController
            
            TargetViewController.target = target.BIG_parents(Node: target)
            

            let application = NSApplication.shared()
            application.runModal(for: TargetWindow)
  
            TargetWindow.close()
        }
    }
    
    // To disable the views that are not required for the moment
    
    func disableView1(disabledView: NSTableView){
        disabledView.isHidden = true
    }
    
    func disableView2(disabledView: NSCollectionView){
        disabledView.isHidden = true
        

    }
    
    // To enable the view that is required for the moment
    
    func enableView1(enabledView: NSTableView){
        enabledView.isHidden = false
    }
    
    func enableView2(enabledView: NSCollectionView){
        enabledView.isHidden = false
    }
    
}

// Implement the required data source method

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {

        return shown.count
        
    }
}

 //populate the BIG items
extension ViewController : NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        // if it's icon layout, only one section
        if collectionView == self.mainCollectionView {

            return 1
        } else {
            // here decide how many BIG items to show
            return 4
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        // returns the levels
        if collectionView == self.mainCollectionView {

            return shown.count - 2
            
        } else {
            return ToBIG[section].count
        }

    }
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:)
    func collectionView(_ collectionView: NSCollectionView,
                        layout collectionViewLayout: NSCollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> NSSize   {
        
        
        if collectionView == self.mainCollectionView {
            
            return CGSize(width: 160, height: 140)
            
        } else {
            let value = ToBIG[indexPath.section][indexPath.item].value

            let myString: NSString = value as NSString
            let size: CGSize = myString.size(withAttributes: [NSFontAttributeName: NSFont.systemFont(ofSize: 13.0)])
            
            return CGSize(width: size.width+50, height: 25)
        }

    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        if collectionView == self.mainCollectionView {
            let item = mainCollectionView.makeItem(withIdentifier: "mainCollectionViewItem", for: indexPath)
     
            if shown[indexPath.item].category == 0 {
                item.imageView?.image = NSImage(named: NSImageNameFolder)
            } else {
                item.imageView?.image = NSImage(named:"File")
            }
            
            item.textField?.stringValue = shown[indexPath.item].value
            if shown[indexPath.item].search(index_o: target.original_index) == 1 {
                item.view.layer?.backgroundColor = NSColor(red: 255/255, green: 255/255, blue: 153/255, alpha: 0.8).cgColor
             }
            return item
            
        } else {
            let item = collectionView.makeItem(withIdentifier: "CollectionViewItem", for: indexPath)
        
            if ToBIG[indexPath.section][indexPath.item].category == 0 {
                item.imageView?.image = NSImage(named: NSImageNameFolder)
                
            } else {
                item.imageView?.image = NSImage(named:"File")
            }
            
            if indexPath.item != ToBIG[indexPath.section].count - 1 {
                item.textField?.stringValue = ToBIG[indexPath.section][indexPath.item].value + "  >"
            } else {
                item.textField?.stringValue = ToBIG[indexPath.section][indexPath.item].value
            }

            return item
            
        }
    }
    
    //NSCollectionViewDelegate
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        print(indexPaths)
    }
}

// Implement TableView delegate

extension ViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let NameCell = "NameCellID"
        static let DateCell = "DateCellID"
        static let SizeCell = "SizeCellID"
    }
    
    
    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        if tableColumn == tableView.tableColumns[0] {
            
            if shown[row].category == 0 {
                image = NSImage(named: NSImageNameFolder)!
            } else {
                image = NSImage(named: "File")!
            }
            text = shown[row].value

            cellIdentifier = CellIdentifiers.NameCell
        }
        else if tableColumn == tableView.tableColumns[1] {
            text = "Apr 5, 2017, 2:02pm"
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[2] {
            if shown[row].category == 0 {
                text = "--"
            } else {
                text = "60k"
            }
            cellIdentifier = CellIdentifiers.SizeCell
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView{
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            
            return cell
        }

        return nil
    }
    
}

extension Node {
    // get the direct children
    func directc() {
        new_nodes.removeAll()
        var Iindex = 0
        for child in children {
            if child.level == self.level + 1 {
                child.index = Iindex
                Iindex = Iindex + 1
                new_nodes.append(child)
            }
        }
    }
    
    // if a target is included in a folder
    func search(index_o: Int) -> Int? {
        if index_o == self.original_index {
            return 1
        }
        for child in children {
            if child.search(index_o: index_o) == 1 {
                return 1
            }
        }
        
        return 0
    }

    // return all parents for the BIG part
    func BIG_parents(Node: Node) -> String {
        var parents = [Node]
        for pp in all {
            if pp.search(index_o: Node.original_index) == 1 && pp.level < Node.level && pp.level > current_node.level {
                parents.append(pp)
            }
        }
        parents.sort {$0.level < $1.level}
        var path = ""
        for level in 0...parents.count-1 {

            path = path + " > " + parents[level].value
        }
        return path
    }
    
    func BIGpp(Node: Node) {
        BIGP.removeAll()
        
        for pp in all {
            if pp.search(index_o: Node.original_index) == 1 && pp.level < Node.level && pp.level > current_node.level {
                BIGP.append(pp)
            }
        }
        BIGP.append(Node)
        BIGP.sort {$0.level < $1.level}
    
    }
    
    // return all the parents
    func parents(index_o: Int) {
    
        for folders in all {
            if folders.search(index_o: index_o) == 1 && folders.level > current_node.level
            {
                Pparents.append(folders)
            }
        }
    }
    
    // find the siblings of a node
    func sibling(Node: Node) {
    
        var tempP = tem
        Siblings.removeAll()
        for direct_parent in all {
            if direct_parent.search(index_o: Node.original_index) == 1 && direct_parent.level == Node.level - 1
            {
                tempP = direct_parent
            }
        }
        tempP.direct_sibling(Node: Node)
        
    }
    
    // get the siblings
    func direct_sibling(Node: Node) {
        for child in children {
            if child.level == self.level + 1 && child.original_index != Node.original_index {
                Siblings.append(child)
            }
        }
    }
    
    // compare the potential targets to the current shown items
    func button(file: Node) -> Int {
        var sub = 0
        for s in shown {
            if s.search(index_o: file.original_index) == 1 {
                sub = s.index + 1
            }
        }
        if sub == 0 {
            sub = shown.count + 1
        }
        return sub
    }
    
    // user behavior function
    func Pr_BGI(click: Int, file: Node) -> Double {
        var P_BGI = 0.0
        let sub = button(file: file)
        
        if click == 1 {
            switch sub {
            case 1:
                P_BGI = 1.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 2 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 1.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 3 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 1.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 4 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 1.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 5 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 1.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 6 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 1.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 7 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 1.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 8 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 1.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 9 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 1.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 10 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 1.0
            case 11:
                P_BGI = 0.0
            default:
                P_BGI = 0.0
            }
        }
        if click == 11 {
            switch sub {
            case 1:
                P_BGI = 0.0
            case 2:
                P_BGI = 0.0
            case 3:
                P_BGI = 0.0
            case 4:
                P_BGI = 0.0
            case 5:
                P_BGI = 0.0
            case 6:
                P_BGI = 0.0
            case 7:
                P_BGI = 0.0
            case 8:
                P_BGI = 0.0
            case 9:
                P_BGI = 0.0
            case 10:
                P_BGI = 0.0
            case 11:
                P_BGI = 1.0
            default:
                P_BGI = 0.0
            }
        }
        
        
        return P_BGI
    }

    // work on the potential targets
    func P_BI(click: Int) -> Double {
        var P_BI = 0.0
        for ptar in objects {
            P_BI = P_BI + Pr_BGI(click: click, file: ptar) * ptar.probability
        }
        return P_BI
    }
    
    // for search
    func P_BI_Search(click: Int) -> Double {
        var P_BI_Search = 0.0
        for x in Search_targets {
            P_BI_Search = P_BI_Search + Pr_BGI(click: click, file: x) * x.probability
        }
        return P_BI_Search
    }
    
    // calculate the expected information gain
    func Expected_IG() -> Double {
        var EXP = 0.0
        var BU = 0.0
        var bu_temp = 0.0
        var ubu_temp = 0.0
        var UBU = 0.0
        
        // uncertainty
        for input in 1...11 {
            if P_BI_Search(click: input) > 0.0 {
                bu_temp = -P_BI_Search(click: input) * log(P_BI_Search(click: input))
            } else {
                bu_temp = 0.0
            }
            BU = BU + bu_temp
        }
        
        // User behaviour uncertainty
        for ptarget in Search_targets {
            for input in 1...11 {
                if Pr_BGI(click: input, file: ptarget) > 0.0 {
                    ubu_temp = -Pr_BGI(click: input, file: ptarget) * log(Pr_BGI(click: input, file: ptarget)) * ptarget.probability
                } else {
                    ubu_temp = 0.0
                }
                UBU = UBU + ubu_temp
            }
        }
        
        EXP = BU - UBU
        
        if EXP < 0 {
            EXP = -EXP
        }

        return EXP
    }
    
    // compute the actual information gain and update the probability
    // repopulate the shown function

    func update() {
        var H_goal = 0.0
        var ent = 0.0
        
        
        for q in objects {
            if q.probability != 0.0 {
                ent = -q.probability * log(q.probability)
            } else {
                ent = 0.0
            }
            H_goal = H_goal + ent
        }
        
        // update probability
        // get user input
        
        let user_input = user_click(target: target)

        let tw = P_BI(click: user_input)
        var t = 0.0
        
        for nn in objects {
            let PBGI = Pr_BGI(click: user_input, file: nn)
            t = PBGI * nn.probability / tw
            nn.probability = t

        }
        
        var H_goalBI = 0.0
        var entr = 0.0
        
        for ss in objects {
            if ss.probability != 0.0 {
                entr = -ss.probability * log(ss.probability)
            } else {
                entr = 0.0
            }
            H_goalBI = H_goalBI + entr
        }
        
        // the actual information gain
        var IG = H_goal - H_goalBI
        if IG < 0.0 {
            IG = 0.0
        }
        
    }
    
    func best_items() {
        
        var expIG = 0.0
        var max_expIG = 0.0
        var happen = 0
        var show_1 = 0
        var show_2 = 0

        
        for tas in objects {
            if tas.probability == 1 {
                happen = 1
            }
        }
        
        if happen != 1 {
        
            Pparents.removeAll()
            
            // first, re-order objects list
            objects.sort {$0.probability > $1.probability}
            
            // find the first 6 most likely items and find all of their parents and put them in Pparents
            
            for q in 0...5 {
                parents(index_o: objects[q].original_index)
            }

            ToSearch.removeAll()
            
            var encountered = Set<String>()
            for everything in Pparents {
                if encountered.contains(everything.value) {
                    
                } else {
                    encountered.insert(everything.value)
                    ToSearch.append(everything)
                }
            }

            for levels in (1...5).reversed() {
                for this in ToSearch {
                    if this.level == levels {
                        var ppparent = current_node
                        this.sibling(Node: this)
                        for sib in Siblings {
                            if ToSearch.contains(where: {$0.value == sib.value}) {
                                
                            } else {
                                for direct_parent in all {
                                    if direct_parent.search(index_o: this.original_index) == 1 && direct_parent.level == this.level-1
                                    {
                                        ppparent = direct_parent
                                    }
                                }
                                ppparent.search_index = this.search_index
                            }
                        }
                    }
                }
            }
            
            // clear SearchSet first
            SearchSet.removeAll()
            
            // function to get the useless parents
            var rejected = [Node]()
            for element in ToSearch {
                if !rejected.contains(where: {$0.value == element.value}) {
                    for another_element in ToSearch {
                        if element.search_index == another_element.search_index {
                            if element.value != another_element.value {
                                if element.original_index > another_element.original_index {
                                    if !rejected.contains(where: {$0.value == another_element.value}) {
                                        rejected.append(another_element)
                                    }
                                } else {
                                    if !rejected.contains(where: {$0.value == element.value}) {
                                        rejected.append(element)
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }
            }
            
            
            // new search range
            for ssearch in ToSearch {
                if !rejected.contains(where: {$0.value == ssearch.value}) {
                    SearchSet.append(ssearch)
                }
            }
            
            for search in SearchSet {
                if search.category == 1 {
                    Search_targets.append(search)
                }
            }
            
            if shown.count == 8 {
                
                shown.append(tem)
                shown.append(tem)
                
                
                for i in 0...SearchSet.count-2 {
                    if SearchSet[i].level >= current_node.level && !shown.contains(where: { $0.original_index == SearchSet[i].original_index }) && SearchSet[i].probability != 0 {
                        shown[8] = SearchSet[i]
                        
                    }
                    
                    for j in i+1...SearchSet.count-1 {
                        if SearchSet[j].level >= current_node.level && !shown.contains(where: { $0.original_index == SearchSet[j].original_index }) && SearchSet[j].original_index != shown[8].original_index && j != i && SearchSet[j].probability != 0
                        {
                            shown[9] = SearchSet[j]
                                
                        }
                        expIG = Expected_IG()
                        
                        if expIG > max_expIG {
                            
                            max_expIG = expIG
                            // need to get the index
                            show_1 = i
                            show_2 = j

                        }
                    }
                }
                shown[8] = SearchSet[show_1]
                shown[9] = SearchSet[show_2]
                
                
                shown[8].index = 8
                shown[9].index = 9

                
            }
        }
    }


}

