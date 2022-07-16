//
//  ImagePickerManager.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

enum ImagePickerError: LocalizedError {
    case generic

    var errorDescription: String? {
        "No Image found"
    }
}

typealias ImageSelectionCompletion = (Result<UIImage, Error>) -> Void

protocol ImagePickerManagerType {
    func pickImage(_ viewController: UIViewController, completion: @escaping ImageSelectionCompletion)
}

class ImagePickerManager: NSObject, ImagePickerManagerType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let picker = UIImagePickerController()
    private var completion: ImageSelectionCompletion?
    weak var viewController: UIViewController?

    override init() {
        super.init()
        picker.delegate = self
    }

    func pickImage(_ viewController: UIViewController, completion: @escaping ImageSelectionCompletion) {
        self.completion = completion
        self.viewController = viewController
        showSheet()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            completion?(.failure(ImagePickerError.generic))
            return
        }
        completion?(.success(image))
    }

    private func showSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.viewController?.view

        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            self.openGallery()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        viewController?.present(alert, animated: true, completion: nil)
    }

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            self.viewController?.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }

    func openGallery() {
        picker.sourceType = .photoLibrary
        self.viewController?.present(picker, animated: true, completion: nil)
    }
}
