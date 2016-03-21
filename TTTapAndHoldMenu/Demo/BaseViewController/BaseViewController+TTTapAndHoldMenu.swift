//
//  UIViewController+TTTapAndHoldMenu.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 21/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

struct Action {
    static let Add = "Add"
    static let Remove = "Remove"
    static let ViewProfile = "View Profile"
    static let Clear = "Clear"
    static let DiscardChanges = "Discard Changes"
}

extension BaseViewController {
    
    // MARK: - TTTapAndHoldMenu appearance settings
    
    func setupMenuAppearance() {
        contextMenu.hintTextColor = UIColor.blackColor()
        contextMenu.backViewColor = UIColor.clearColor()
        contextMenu.backStancilViewColor = UIColor(white: 1.0, alpha: 0.6)
        
        contextMenu.radius = 64
        contextMenu.angle = M_PI_4
        contextMenu.imageSize = CGSize(width: 40, height: 40)
        contextMenu.selectedImageSize = CGSize(width: 50, height: 50)
    }
}

extension TTTapAndHoldMenuDataSource where Self: BaseViewController {
    
    // MARK: - TTTapAndHoldMenu data source methods
    
    func contextMenu(menu: TTTapAndHoldMenu, tagForItemAtIndex index: Int) -> String? {
        var tag: String? = nil
        
        switch(menu.recipient) {
        case .TableViewCell(_):
            tag = itemActionTag(index)
        case .TableViewSectionHeader(_):
            tag = Action.Add
        case .TableViewHeader(_):
            if index == 0 {
                tag = Action.Clear
            }
            else {
                tag = Action.DiscardChanges
            }
        case .CollectionViewItem(_):
            tag = itemActionTag(index)
        case .CollectionViewSupplementaryView(_):
            tag = Action.Add
        case .View(_):
            tag = Action.DiscardChanges
        default:
            print("Error!")
        }
        
        return tag
    }
    
    private func itemActionTag(index: NSInteger) -> String {
        if index == 0 {
            return Action.Remove
        }
        else {
            return Action.ViewProfile
        }
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, imageForItemAtIndex index: Int, withTag tag: String?, forState selected: Bool) -> UIImage {
        var imageName = ""
        if tag == Action.Add {
            imageName = "plus.png"
        }
        else if tag == Action.Remove {
            imageName = "minus.png"
        }
        else if tag == Action.Clear {
            imageName = "clear.png"
        }
        else if tag == Action.DiscardChanges {
            imageName = "undo.png"
        }
        else if tag == Action.ViewProfile {
            if let indexPath = menu.recipient.indexPath {
                let source = (indexPath.section == 0) ? users : anotherUsers
                let user = source[indexPath.row]
                if user.gender == .Male {
                    imageName = (selected) ? "user-male-selected.png" : "user-male.png"
                }
                else {
                    imageName = (selected) ? "user-female-selected.png" : "user-female.png"
                }
            }
        }
        
        return UIImage(named: imageName)!
    }
    
    func contextMenu(menu: TTTapAndHoldMenu, hintForItemAtIndex index: Int, withTag tag: String?) -> String {
        return tag!
    }
    
    func numberOfItemsForMenu(menu: TTTapAndHoldMenu) -> Int {
        switch (menu.recipient) {
        case .TableViewCell(_):
            return 2
        case .CollectionViewItem(_):
            return 2
        case .CollectionViewSupplementaryView(_):
            return 1
        case .TableViewSectionHeader(_):
            return 1
        case .TableViewHeader(_):
            return 2
        case .View(_):
            return 1
        default:
            return 0
        }
    }
}

extension TTTapAndHoldMenuDelegate where Self: BaseViewController {
    
    func contextMenu(menu: TTTapAndHoldMenu, didSelectItemAtIndex index: Int, withTag tag: String?) {
        if tag == Action.Add {
            if let section = menu.recipient.section {
                pushUserDetailsViewController(.AddNew(extraInfo:section))
            }
        }
        else if tag == Action.Clear {
            users.removeAll()
            anotherUsers.removeAll()
            reloadView()
        }
        else if tag == Action.DiscardChanges {
            dataController.restoreDefaultUsers()
            reloadView()
        }
        else {
            if let indexPath = menu.recipient.indexPath {
                if tag == Action.Remove {
                    if indexPath.section == 0 {
                        users.removeAtIndex(indexPath.row)
                    }
                    else {
                        anotherUsers.removeAtIndex(indexPath.row)
                    }
                    
                    reloadView()
                }
                else if tag == Action.ViewProfile {
                    let user = (indexPath.section == 0) ? users[indexPath.row] : anotherUsers[indexPath.row]
                    pushUserDetailsViewController(.Edit(user: user, extraInfo:indexPath.section))
                }
            }
        }
    }

}

