//
//  ViewController.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 03/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import UIKit

enum Gender: String {
    case Male = "Male"
    case Female = "Female"
    
    static func values() -> [String] {
        return [Male.rawValue, Female.rawValue]
    }
}

enum Role: String {
    case User = "User"
    case Admin = "Admin"
    
    static func values() -> [String] {
        return [User.rawValue, Admin.rawValue]
    }
}

class User {
    var id: Int
    var name: String
    var surname: String
    var gender: Gender
    
    var role: Role
    
    static var nextId = 1
    
    init(name: String, surname: String, gender: Gender, role: Role) {
        self.name = name
        self.surname = surname
        self.gender = gender
        
        self.role = role
        
        self.id = User.nextId
        User.nextId++
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TTTapAndHoldMenuDataSource, TTTapAndHoldMenuDelegate, UserDetailsViewControllerListener {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []
    var anotherUsers: [User] = []
    
    var contextMenu = TTTapAndHoldMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prefillUsers()
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        contextMenu.hintTextColor = UIColor.blackColor()
        contextMenu.backViewColor = UIColor.clearColor()
        contextMenu.backStancilViewColor = UIColor(white: 1.0, alpha: 0.6)
        
        contextMenu.radius = 64
        contextMenu.angle = M_PI_4
        
        contextMenu.dataSource = self
        contextMenu.delegate = self
        contextMenu.attachToView(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Init data
    
    private func prefillUsers() {
        let bob = User(name: "Bob", surname: "Brown", gender: .Male, role: .Admin)
        let mary = User(name: "Mary", surname: "Right", gender: .Female, role: .User)
        let gary = User(name: "Gary", surname: "Oldman", gender: .Male, role: .User)
        
        users.append(bob)
        users.append(mary)
        users.append(gary)
        
        let bilbo = User(name: "Bilbo", surname: "Baggins", gender: .Male, role: .User)
        anotherUsers.append(bilbo)
        
        for (var i = 0; i < 20; i++) {
            let gender = (i % 2 == 0) ? Gender.Male : Gender.Female
            let role = (i % 3 == 0) ? Role.Admin : Role.Admin
            let user = User(name: "user\(i)", surname: "\(i)", gender: gender, role: role)
            
            anotherUsers.append(user)
        }
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
        view?.backgroundView?.backgroundColor = UIColor.blackColor()
        if section == 0 {
            view?.textLabel?.text = "Users"
        }
        else {
            view?.textLabel?.text = "Another Users"
        }
        
        return view
    }
    
    // MARK: - TTTapAndHoldMenu data source methods
    
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
                let source = (indexPath.section == 0) ? users : anotherUsers
                let user = source[indexPath.row]
                if user.gender == .Male {
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
    
    // MARK: - TTTapAndHoldMenu delegate methods
    
    func contextMenu(menu: TTTapAndHoldMenu, didSelectItemAtIndex index: Int, withTag tag: String?) {
        if tag == Action.Add {
            if let section = menu.info.section {
                pushUserDetailsViewController(.AddNew(extraInfo:section))
            }
        }
        else {
            switch (menu.info) {
            case .TableViewCell(_, let indexPath):
                if tag == Action.Remove {
                    if indexPath.section == 0 {
                        users.removeAtIndex(indexPath.row)
                    }
                    else {
                        anotherUsers.removeAtIndex(indexPath.row)
                    }
                    
                    tableView.reloadData()
                }
                else if tag == Action.ViewProfile {
                    let user = (indexPath.section == 0) ? users[indexPath.row] : anotherUsers[indexPath.row]
                    pushUserDetailsViewController(.Edit(user: user, extraInfo:indexPath.section))
                }
            default:
                break
            }
        }
    }
    
    func pushUserDetailsViewController(type: UserDetailsViewControllerType) {
        if let detailController = storyboard?.instantiateViewControllerWithIdentifier("UserDetailsViewController") as? UserDetailsViewController {
            detailController.type = type
            detailController.listener = self
            let navigationController = UINavigationController(rootViewController: detailController)
            self.presentViewController(navigationController, animated: true, completion: { () -> Void in
            })
        }
    }
    
    // MARK: - UserDetailsViewController listener methods
    
    func userDetailsViewController(viewController: UserDetailsViewController, finishedWithUser theUser: User) {
        switch (viewController.type) {
        case .AddNew(let extraInfo):
            let section = (extraInfo as? NSInteger) ?? 0
            if section == 0 {
                users.append(theUser)
            }
            else {
                anotherUsers.append(theUser)
            }
            
        case .Edit(let user, let extraInfo):
            let section = (extraInfo as? NSInteger) ?? 0
            if section == 0 {
                users = users.map({ u -> User in
                    if u.id == user.id {
                        return theUser
                    }
                    
                    return u
                })
            }
            else {
                anotherUsers = anotherUsers.map({ u -> User in
                    if u.id == user.id {
                        return theUser
                    }
                    
                    return u
                })
            }
        }
        
        tableView.reloadData()
    }
}

