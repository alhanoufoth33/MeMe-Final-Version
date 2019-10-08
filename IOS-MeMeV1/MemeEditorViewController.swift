//
//  ViewController.swift
//  IOS-MeMeV1
//
//  Created by Alhanouf AlOthman on 04/10/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate, UITextFieldDelegate,
UINavigationControllerDelegate {
    
   
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor:  UIColor.black ,
        NSAttributedString.Key.foregroundColor: UIColor.white,
          NSAttributedString.Key.font:
        UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.0];
    
    let topFieldDefaultText = "Alhanouf"
    let bottomFieldDefaultText = "AlOthman"
    
    var memedImage = UIImage()
    
    //Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomToolbar: UIToolbar!
    @IBOutlet weak var topNavbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //Actions
    
    
    @IBAction func cancelButton(_ sender: Any) {
        setToDefault()
        
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let generatedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [generatedImage], applicationActivities: nil)
        
        // save to Meme object only if the share was successful
        activityController.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickImageCamera(_ sender: Any) {
        pickImage(isSourceAlbum: false)
    }
    
    @IBAction func pickImageAlbum(_ sender: Any) {
        pickImage(isSourceAlbum: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setTextFieldAttributes(textField: topTextField)
        setTextFieldAttributes(textField: bottomTextField)

        setToDefault()
    }
    
      override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
unsubscribeFromKeyboardNotifications()
        
    }
    
    //ViewController
    
    // ViewController functions
    func setToDefault() {
        bottomTextField.text = bottomFieldDefaultText
        topTextField.text = topFieldDefaultText
        imagePickerView.image = nil
        shareButton.isEnabled = false
        
    }
    
    func pickImage(isSourceAlbum: Bool) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = isSourceAlbum ? .photoLibrary : .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setTextFieldAttributes(textField: UITextField) {
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
    }
    
    
    //Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        } else {
            let alert = UIAlertController(title: "Error", message: "Failed To Select Picture",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default"),
                                          style: .default, handler: { _ in
                                            print("The picture in not availabel")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField.text == topFieldDefaultText || textField.text == bottomFieldDefaultText {
            textField.text = ""
          }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
      if bottomTextField.isFirstResponder {
        view.frame.origin.y = -getKeyboardHeight(notification)
      }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
      view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
      let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        //  Hide toolbar and navbar
        self.buttomToolbar.isHidden = true
        self.topNavbar.isHidden = true
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar and navbar
        
        self.buttomToolbar.isHidden = false
        self.topNavbar.isHidden = false
        
        self.memedImage = memedImage
        return memedImage
    }
    func save() {
        _ = Meme(topText: topTextField.text ?? topFieldDefaultText,
                 bottomText: bottomTextField.text ?? bottomFieldDefaultText,
                 originalImage: imagePickerView.image, memedImage: memedImage)
    }
}

