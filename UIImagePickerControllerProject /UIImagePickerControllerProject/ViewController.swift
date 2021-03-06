//
//  ViewController.swift
//  UIImagePickerControllerProject
//
//  Created by Ilija Mihajlovic on 3/8/19.
//  Copyright © 2019 Ilija Mihajlovic. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var imagePicker: UIImagePickerController?
    var flashMode = AVCaptureDevice.FlashMode.off
    
    private var toggleFlashButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "flashOff"), for: .normal)
        
        button.addTarget(self, action: #selector(toggleCameraFlash), for: .touchUpInside)
        button.layer.zPosition = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var backgroundView: UIImageView = {
        var someimageView = UIImageView()
        someimageView.image = UIImage(named: "background")
        someimageView.translatesAutoresizingMaskIntoConstraints = false
        someimageView.layer.zPosition = 0
        return someimageView
    }()
    
    
    private var imageViewTake: UIImageView = {
        var someImageView = ScaledHeightImageView()

        someImageView.clipsToBounds = true

        someImageView.contentMode = .scaleAspectFit
        someImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return someImageView
    }()
    
    private var TakeImageButton: UIButton = {
        var button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.layer.zPosition = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        
        return button
    }()
    
    
    private var saveImageButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "save"), for: .normal)
       
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSubView()
        setupConstraints()
        
    }

    
    //MARK: Toggle Flash
    @objc func toggleCameraFlash() {
        if flashMode == .on {
            flashMode = .off
            toggleFlashButton.setImage(UIImage(named: "flashOff"), for: .normal)
        } else {
            flashMode = .on
            toggleFlashButton.setImage(UIImage(named: "flashOn"), for: .normal)
        }
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            
            //We got back an error!
            showAlertWith(title: "Error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved", message: "Your image has been saved to your photos.")
            
        }
    }
    
   @objc fileprivate func takePhoto(_ seder: UIButton!) {
    guard  UIImagePickerController.isSourceTypeAvailable(.camera) else {
        selectImageFrom(.photoLibary)
        return
    }
    selectImageFrom(.camera)
    TakeImageButton.setTitle("Take a Image", for: .normal)
    
    }
    
    
    func selectImageFrom(_ source: ImageSource) {
        imagePicker = UIImagePickerController()
       
        guard let imagePicker = imagePicker else { return }
        
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        switch  source {
        case .camera:
            imagePicker.sourceType = .camera
       
        case .photoLibary:
            imagePicker.sourceType = .photoLibrary
            
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
   @objc fileprivate func save(_ sender: AnyObject) {
        guard let selectedImage = imageViewTake.image else {
            showAlertWith(title: "Error", message: "You Need To First Taka a Photo or Chose One From Libary")
            return
        }
    
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    
    }
    
  
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    

    fileprivate func addSubView() {

        [TakeImageButton, backgroundView, imageViewTake, saveImageButton, toggleFlashButton].forEach{view.addSubview(($0))}
    }
    
    //MARK: - Constraints
    fileprivate func setupConstraints() {
        
        //ChoseOrTakeImageButton Constraint
        TakeImageButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 50, height: 50))
        
        TakeImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //BackgrounView Constraint
        backgroundView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        
        //ImageViewTake Constraint
        imageViewTake.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 250))
        
        imageViewTake.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageViewTake.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        
        
        //SaveImageButton Constraint
        saveImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 12), size: .init(width: 50, height: 50))
        
        //ToggleFlashButton Constraint
        toggleFlashButton.anchor(top: saveImageButton.bottomAnchor, bottom: nil, leading: nil, trailing: saveImageButton.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 4), size: .init(width: 50, height: 50))
    }

}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let imagePicker = imagePicker else { return }
        
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Item not found!")
            return
        }
        imageViewTake.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}


