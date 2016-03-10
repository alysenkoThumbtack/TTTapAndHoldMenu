//
//  ViewController.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 03/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TTTapAndHoldMenuDataSource, TTTapAndHoldMenuDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var contextMenu = TTTapAndHoldMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        contextMenu.hintTextColor = UIColor.blackColor()
        
        contextMenu.dataSource = self
        contextMenu.delegate = self
        contextMenu.attachToView(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UITableView data source methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if indexPath.row == 0 {
            cell?.backgroundColor = UIColor.redColor()
        }
        else if indexPath.row == 1 {
            cell?.backgroundColor = UIColor.greenColor()
        }
        else {
            cell?.backgroundColor = UIColor.blueColor()
        }
        
        cell?.selectionStyle = .None
        cell?.selectedBackgroundView = nil
        
        return cell!
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header")
        view?.backgroundView?.backgroundColor = UIColor.blackColor()
        
        return view
    }
    
    //MARK: - TTTapAndHoldMenu data source methods
    
    private struct Action {
        static let Add = "Add"
        static let Remove = "Remove"
        static let ViewProfile = "View Profile"
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, tagForItemAtIndex index: Int) -> String? {
        var tag: String? = nil
        
        switch(menu.info) {
        case .TableViewCell(_, _):
            if index == 0 {
                tag = Action.Remove
            }
            else {
                tag = Action.ViewProfile
            }
        case .TableViewSectionHeader(_, _):
            tag = Action.Add
        default:
            print("Error!")
        }
        
        return tag
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, imageForItemAtIndex index: Int, withTag tag: String?, forState selected: Bool) -> UIImage {
        var imageName = ""
        
        if tag == Action.Add {
            imageName = "plus.png"
        }
        else if tag == Action.Remove {
            imageName = "minus.png"
        }
        else if tag == Action.ViewProfile {
            switch (menu.info) {
            case .TableViewCell(_, let indexPath):
                if indexPath.row == 0 {
                    imageName = (selected) ? "user-male-selected.png" : "user-male.png"
                }
                else {
                    imageName = (selected) ? "user-female-selected.png" : "user-female.png"
                }
            default:
                break
            }
        }
        
        return UIImage(named: imageName)!
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, hintForItemAtIndex index: Int, withTag tag: String?) -> String {
        return tag!
    }
    
    func numberOfItemsForMenu(menu: TTTapAndHoldMenu) -> Int {
        switch (menu.info) {
        case .TableViewCell(_, _):
            return 2
        case .TableViewSectionHeader(_, _):
            return 1
        default:
            return 0
        }
    }
    
    func angleForMenu(menu: TTTapAndHoldMenu) -> Double {
        return M_PI_4
    }
    
    func radiusForMenu(menu: TTTapAndHoldMenu) -> Float {
        return 64
    }
    
    func backViewColor(menu: TTTapAndHoldMenu) -> UIColor {
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    }
    
    func backStancilViewColor(menu: TTTapAndHoldMenu) -> UIColor {
        return UIColor(white: 1.0, alpha: 0.6)
    }
}

