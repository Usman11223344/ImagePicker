
//
//  ImagePicker.swift
//  SelectPictureDemo
//
//  Created by Usman Javed on 12/15/16.
//  Copyright © 2016 MDVisions. All rights reserved.
//

import UIKit

typealias ImagePickerSuccessBlock = (UIImage?, UIImage?, String?) -> Void

class ImagePicker: NSObject {
    
    var picker : UIImagePickerController? = nil
    var controller : UIViewController? = nil
    var sourceView : UIView? = nil
    var sourceRect : CGRect? = nil
    var callbacks : ImagePickerSuccessBlock?
    
    func showPopover(viewController : UIViewController, source : UIView, success: @escaping ImagePickerSuccessBlock) {
        
        picker = UIImagePickerController()
        controller = viewController
        sourceView = source
        sourceRect = source.bounds
        callbacks = success
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            
            self.showCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            
            self.showGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
            
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
//        alert.modalPresentationStyle = .popover
        alert.modalPresentationStyle = .popover
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceRect!
        controller?.present(alert, animated: true, completion: nil)
    }
    
    private func showGallery() -> Void {
        
        picker!.allowsEditing = true
        picker!.delegate = self
        picker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker!.modalPresentationStyle = .popover
        if let popover = picker!.popoverPresentationController {
            
            popover.delegate = self
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect!
            controller?.present(picker!, animated: true, completion: nil)
        }
    }
    
    private func showCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker!.allowsEditing = true
            picker!.delegate = self
            picker!.sourceType = UIImagePickerControllerSourceType.camera
            picker!.modalPresentationStyle = .popover
            if let popover = picker!.popoverPresentationController {
                
                popover.delegate = self
                popover.sourceView = controller?.view
                popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = .init(rawValue: 0)
                
                controller?.present(picker!, animated: true, completion: nil)
            }
        }
        else
        {
            showGallery()
        }
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let originalPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        let editedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage

        let path = info[UIImagePickerControllerReferenceURL] as? URL
        let imageExtension = path?.lastPathComponent
        var ext : String? = ""
        
        if (imageExtension?.components(separatedBy: ".").count == 2) {
            
            ext = (imageExtension?.components(separatedBy: ".")[1])
        }
        
        callbacks!(originalPhoto, editedPhoto, ext)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker: UIPopoverPresentationControllerDelegate {

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
     
        print("")
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        
        return true
    }
}


