//
//  ViewController.swift
//  Aspidistra
//
//  Created by Alasdair Lampon-Monk on 04/10/2018.
//  Copyright © 2018 Alasdair Lampon-Monk. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var webView: WKWebView!
    
    var tableViewData = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.getReadingList()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func getReadingList() {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser.absoluteString.replacingOccurrences(of: "file://", with: "")
        let pathString = "\(homeDir)Library/Safari/Bookmarks.plist"
        
        let myDict = NSDictionary(contentsOfFile: pathString)
        let newDict : NSArray = myDict!.value(forKeyPath: "Children") as! NSArray
        let childrenArr : NSDictionary = newDict.object(at: 3) as! NSDictionary
        let readingListChildrenArr : NSArray = childrenArr.value(forKey: "Children") as! NSArray
        
        self.tableViewData = readingListChildrenArr as! [[String : Any]]
        self.tableView.reloadData()
    }
    
    
    @IBAction func didClick(_ sender: Any) {
        let selectedRow = self.tableView.selectedRow
        let rowDict : NSDictionary = self.tableViewData[selectedRow] as NSDictionary
        let rowUrl = rowDict.value(forKeyPath: "URLString") as! String
        webView.load(URLRequest.init(url: URL.init(string: rowUrl) ?? URL.init(string: "")!))
    }
}

extension ViewController:NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let rowDict : NSDictionary = self.tableViewData[row] as NSDictionary
        let result:KSTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "sourceCell"), owner: self) as! KSTableCellView
        result.wantsLayer = true
        result.url.stringValue = rowDict.value(forKeyPath: "URLString") as! String
        result.title.stringValue = rowDict.value(forKeyPath: "URIDictionary.title") as! String
        
        return result;
    }
}
