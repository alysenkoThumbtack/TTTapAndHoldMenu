//
//  UserDetailsViewController.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 11/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

protocol UserDetailsViewControllerListener: class {
    func userDetailsViewController(viewController: UserDetailsViewController, finishedWithUser user: User)
}

enum UserDetailsViewControllerType {
    case AddNew
    case Edit(user: User)
}

class UserDetailsViewController : UIViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var roleField: UITextField!
    
    var type: UserDetailsViewControllerType = .AddNew
    
    private let myContext = UnsafeMutablePointer<()>()
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    private var nameIsValid: Bool {
        get {
            return trimmedText(nameField.text)?.characters.count > 0
        }
    }
    private var surnameIsValid: Bool {
        get {
            return trimmedText(surnameField.text)?.characters.count > 0
        }
    }
    private var genderIsValid: Bool {
        if let text = genderField.text, _ = Gender(rawValue: text) {
            return true
        }
        
        return false
    }
    private var roleIsValid: Bool {
        if let text = roleField.text, _ = Role(rawValue: text) {
            return true
        }
        
        return false
    }
    
    private var allValuesIsValid: Bool {
        get {
            return nameIsValid && surnameIsValid && genderIsValid && roleIsValid
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    
    weak var listener: UserDetailsViewControllerListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "User Details"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "dismiss")
        
        doneButton.addTarget(self, action: "onDoneButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        
        setTextFieldsWithInitialValues()
        
        addTextChangesHandler(nameField)
        addTextChangesHandler(surnameField)
        
        genderField.delegate = self
        roleField.delegate = self
        
        updateDoneButtonState()
        setTextFieldsResignOnTouchOutside(true)
    }
    
    // MARK: - UITextField text initial values
    
    private func setTextFieldsWithInitialValues() {
        switch (type) {
        case .Edit(let user):
            fillTextFields(user)
        case .AddNew:
            fillTextFields(nil)
        }
    }
    
    private func fillTextFields(theUser: User?) {
        if let user = theUser {
            nameField.text = user.name
            surnameField.text = user.surname
            genderField.text = user.gender.rawValue
            roleField.text = user.role.rawValue
        }
        else
        {
            nameField.text = ""
            surnameField.text = ""
            genderField.text = Gender.Male.rawValue
            roleField.text = Role.User.rawValue
        }
    }
    
    // MARK: - Keyboard handling
    
    private func setTextFieldsResignOnTouchOutside(resign: Bool) {
        if resign {
            if tapGestureRecognizer == nil {
                tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
                tapGestureRecognizer!.numberOfTapsRequired = 1
            }
            
            self.view.addGestureRecognizer(tapGestureRecognizer!)
        }
        else {
            tapGestureRecognizer?.removeTarget(self, action: "handleSingleTap:")
            if tapGestureRecognizer != nil {
                self.view.removeGestureRecognizer(tapGestureRecognizer!)
            }
        }
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIButton actions handling methods
    
    func dismiss() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
    
    func onDoneButtonPressed() {
        if let name = nameField.text, surname = surnameField.text, gender = genderField.text, role = roleField.text {
            let user = User(name: name, surname: surname, gender: Gender(rawValue: gender)!, role: Role(rawValue: role)!)
            
            listener?.userDetailsViewController(self, finishedWithUser: user)
            dismiss()
        }
    }
    
    // MARK: - UITextField text changes mehods
    
    func addTextChangesHandler(textField: UITextField) {
        textField.addTarget(self, action: "updateDoneButtonState", forControlEvents: .EditingChanged)
    }
    
    func removeTextChangedHandler(textField: UITextField) {
        textField.removeTarget(self, action: "updateDoneButtonState", forControlEvents: .EditingChanged)
    }
    
    func updateDoneButtonState() {
        doneButton.enabled = allValuesIsValid
    }
    
    deinit {
        removeTextChangedHandler(nameField)
        removeTextChangedHandler(surnameField)
    }
    
    // MARK: - UITextField delegate methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == genderField || textField == roleField {
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == genderField {
            self.view.endEditing(true)
            showListOfValues(genderField, title: "Gender", values: Gender.values())
            
            return false
        }
        else if textField == roleField {
            self.view.endEditing(true)
            showListOfValues(roleField, title: "User Role", values: Role.values())
            
            return false
        }
        
        return true
    }
    
    // MARK: - Popover
    
    func showListOfValues(textField: UITextField, title: String, values: [String]) {
        setTextFieldsResignOnTouchOutside(true)
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        for value in values {
            let actionItem = UIAlertAction(title: value, style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                textField.text = value
            })
            
            alertController.addAction(actionItem)
        }
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        }
        
        alertController.modalPresentationStyle = .Popover
        if let presenter = alertController.popoverPresentationController {
            presenter.permittedArrowDirections = .Left
            presenter.sourceView = textField
            presenter.sourceRect = textField.bounds
            
            presenter.delegate = self
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: -
    
    func trimmedText(text: String?) -> String? {
        return text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}