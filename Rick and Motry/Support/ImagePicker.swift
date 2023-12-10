//
//  ImagePicker.swift
//  Rick and Motry
//
//  Created by Dmitry Pavlov on 9.12.23.
//

import UIKit
import AVFoundation

final class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Public methods
    public func showImagePicker(in viewController: UIViewController, fromSourceType: UIImagePickerController.SourceType, complition: ((UIImage) -> ())?) {
        //destination closure
        self.complition = complition
        //check source type image picker
        if fromSourceType == .camera {
            checkCameraAcess(in: viewController, fromSourceType: fromSourceType)
        } else {
            // check for supported device
            if UIImagePickerController.isSourceTypeAvailable(fromSourceType) {
                imagePickerController = UIImagePickerController()
                imagePickerController?.delegate = self
                imagePickerController?.sourceType = fromSourceType
                viewController.present(imagePickerController!, animated: true)
            }
        }
    }
    
    //MARK: - Variables
    private let defaults = UserDefaults.standard
    private var complition: ((UIImage) -> ())?
    private var imagePickerController: UIImagePickerController?
    
    //MARK: - Private methods
    // Check acess of camera
    private func checkCameraAcess(in viewController: UIViewController, fromSourceType: UIImagePickerController.SourceType) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings(in: viewController)
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(fromSourceType) {
                imagePickerController = UIImagePickerController()
                imagePickerController?.delegate = self
                imagePickerController?.sourceType = fromSourceType
                viewController.present(imagePickerController!, animated: true)
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                } else {
                    print("Permission denied")
                }
            }
        @unknown default:
            fatalError("ERROR")
        }
    }
    
    // Show alert with settings for open acess camera
    private func presentCameraSettings(in viewController: UIViewController) {
        let alertController = UIAlertController(title: "Необходим доступ к камере. Вы можете разрешить доступ в настройках устройства.",
                                                message: nil,
                                                preferredStyle: .alert)
        // action for go to settings
        alertController.addAction(UIAlertAction(title: "Настройки", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        })
        alertController.addAction(UIAlertAction(title: "ОК", style: .default))
        // show alertController
        viewController.present(alertController, animated: true)
    }
    
    //MARK: - Delegate for imagePickerController
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            // call closure with choosed image and close imagePicker
            self.complition?(image)
            picker.dismiss(animated: true)
        }
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // close imagePicker
        picker.dismiss(animated: true)
    }
}
