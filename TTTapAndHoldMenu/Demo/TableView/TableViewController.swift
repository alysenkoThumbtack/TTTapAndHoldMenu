//
//  ViewController.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 03/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import UIKit


class TableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        let tableViewHeaderView = UIView()
        tableViewHeaderView.Height = 128
        tableViewHeaderView.backgroundColor = UIColor.darkGrayColor()
        tableView.tableHeaderView = tableViewHeaderView
        
        contextMenu.attachToView(tableView)
    }
    
    // MARK: - UITableView data source methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return users.count
        }
        else {
            return anotherUsers.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        cell?.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.95, alpha: 1.0)
        cell?.selectionStyle = .None
        cell?.selectedBackgroundView = nil
        
        let source = (indexPath.section == 0) ? users : anotherUsers
        let user = source[indexPath.row]
        cell?.textLabel?.text = "\(user.name) \(user.surname)"
        cell?.detailTextLabel?.text
        
        return cell!
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header")
        view?.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        if section == 0 {
            view?.textLabel?.text = "Users"
        }
        else {
            view?.textLabel?.text = "Another Users"
        }
        
        return view
    }
    
    // MARK: - update view when data source changed
    
    override func reloadView() {
        tableView.reloadData()
    }
}

