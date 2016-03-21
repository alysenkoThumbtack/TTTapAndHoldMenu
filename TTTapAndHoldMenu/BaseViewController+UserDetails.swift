//
//  BaseViewController+UserDetails.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 21/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

extension BaseViewController {
    
    // MARK: - User Details methods
    
    func pushUserDetailsViewController(type: UserDetailsViewControllerType) {
        if let detailController = storyboard?.instantiateViewControllerWithIdentifier("UserDetailsViewController") as? UserDetailsViewController {
            detailController.type = type
            detailController.listener = self
            let navigationController = UINavigationController(rootViewController: detailController)
            self.presentViewController(navigationController, animated: true, completion: { () -> Void in
            })
        }
    }
}

extension UserDetailsViewControllerListener where Self: BaseViewController {
    
    // MARK: - UserDetailViewController listener methods
    
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
        
        reloadView()
    }
}