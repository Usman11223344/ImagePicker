//
//  ViewController.swift
//  ImagePicker
//
//  Created by Usman Javed on 5/25/17.
//  Copyright © 2017 MDVisions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = ImagePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSelectImage(_ sender: UIButton) {
        
        imagePicker.showPopover(viewController: self, source: sender, success: {
            (_ orignalPhoto : UIImage?, _ editedPhoto : UIImage?, _ imageType : String?) in
            
            if let _editedPhoto = editedPhoto {
                
                self.imageView.image = _editedPhoto
            }
        })
    }
}

