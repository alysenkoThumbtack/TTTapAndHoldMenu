//
//  BaseViewController.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 21/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

class BaseViewController : UIViewController, TTTapAndHoldMenuDataSource, TTTapAndHoldMenuDelegate, UserDetailsViewControllerListener {
    var dataController = DataController()
    var contextMenu = TTTapAndHoldMenu()
    
    var users: [User] {
        get {
            return dataController.users
        }
        
        set {
            dataController.users = newValue
        }
    }
    
    var anotherUsers: [User] {
        get {
            return dataController.anotherUsers
        }
        
        set {
            dataController.anotherUsers = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuAppearance()
        
        contextMenu.dataSource = self
        contextMenu.delegate = self
    }
    
    // MARK: - update view when data source changed
    
    func reloadView() {
        // override this method in child class
    }
}