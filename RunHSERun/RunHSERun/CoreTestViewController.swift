import Foundation
import UIKit
import Vision

class CoreTestViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()
//        testML()
        
    }
    
    private lazy var makePhotoButton : UIButton = {
        let makePhotoButton = UIButton(type: .custom)
        makePhotoButton.backgroundColor = .systemBlue
        makePhotoButton.contentHorizontalAlignment = .center
        makePhotoButton.contentVerticalAlignment = .center
        makePhotoButton.layer.cornerRadius = 20
        makePhotoButton.layer.masksToBounds = false
        makePhotoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        makePhotoButton.setTitle("Make photo", for: .normal)
        makePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        makePhotoButton.addTarget(self, action: #selector(makephotoButtonClicked), for: .touchUpInside)
        return makePhotoButton
    } ()
    
    @objc private func makephotoButtonClicked() {
        promptPhoto()
    }
    
    func testML(userCgImage : CGImage) {
        let cgImage = userCgImage

        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        
        // Process the recognized strings.
        processResults(recognizedStrings)
    }
    
    func processResults(_ recognizedStrings : [String]) {
        if !recognizedStrings.isEmpty {
            print(recognizedStrings)
            gameLabel.text = recognizedStrings[0]
        }
    }


    private lazy var gameLabel : UILabel = {
        let gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.textColor = .systemBlue
        gameLabel.textAlignment = .center
        gameLabel.font = gameLabel.font.withSize(30)
        gameLabel.text = "Account Settings"
        return gameLabel
    } ()
    
    
    func scaleAndOrient(image: UIImage) -> UIImage {
        
        // Set a default value for limiting image size.
        let maxResolution: CGFloat = 640
        
        guard let cgImage = image.cgImage else {
            print("UIImage has no CGImage backing it!")
            return image
        }
        
        // Compute parameters for transform.
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        var transform = CGAffineTransform.identity
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        if width > maxResolution ||
            height > maxResolution {
            let ratio = width / height
            if width > height {
                bounds.size.width = maxResolution
                bounds.size.height = round(maxResolution / ratio)
            } else {
                bounds.size.width = round(maxResolution * ratio)
                bounds.size.height = maxResolution
            }
        }
        
        let scaleRatio = bounds.size.width / width
        let orientation = image.imageOrientation
        switch orientation {
        case .up:
            transform = .identity
        case .down:
            transform = CGAffineTransform(translationX: width, y: height).rotated(by: .pi)
        case .left:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: 0, y: width).rotated(by: 3.0 * .pi / 2.0)
        case .right:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: 0).rotated(by: .pi / 2.0)
        case .upMirrored:
            transform = CGAffineTransform(translationX: width, y: 0).scaledBy(x: -1, y: 1)
        case .downMirrored:
            transform = CGAffineTransform(translationX: 0, y: height).scaledBy(x: 1, y: -1)
        case .leftMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(translationX: height, y: width).scaledBy(x: -1, y: 1).rotated(by: 3.0 * .pi / 2.0)
        case .rightMirrored:
            let boundsHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundsHeight
            transform = CGAffineTransform(scaleX: -1, y: 1).rotated(by: .pi / 2.0)
        default:
            transform = .identity
        }
        
        return UIGraphicsImageRenderer(size: bounds.size).image { rendererContext in
            let context = rendererContext.cgContext
            
            if orientation == .right || orientation == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            context.concatenate(transform)
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
    }
    
    
    
    private func configureUI() {
        view.addSubview(gameLabel)
        view.addSubview(makePhotoButton)
        
        NSLayoutConstraint.activate([

            gameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            gameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameLabel.widthAnchor.constraint(equalToConstant: 250),
            gameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            makePhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            makePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            makePhotoButton.widthAnchor.constraint(equalToConstant: 250),
            makePhotoButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
}

extension CoreTestViewController : UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss picker, returning to original root viewController.
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
                                        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Extract chosen image.
        let originalImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let newImage = scaleAndOrient(image: originalImage)
//        originalImage = scaleAndOrient(image: originalImage)
        // Display image on screen.
//        show(originalImage)
        
        // Convert from UIImageOrientation to CGImagePropertyOrientation.
//        let cgOrientation = CGImagePropertyOrientation(originalImage.imageOrientation)
        
        // Fire off request based on URL of chosen photo.
        guard let cgImage = newImage.cgImage else {
            return
        }
        
//        performVisionRequest(image: cgImage,
//                             orientation: cgOrientation)
        testML(userCgImage: cgImage)
        // Dismiss the picker to return to original view controller.
        dismiss(animated: true, completion: nil)
    }
    
}

extension CoreTestViewController : UINavigationControllerDelegate {
    
    @objc
    func promptPhoto() {
        
        let prompt = UIAlertController(title: "Choose a Photo",
                                       message: "Please choose a photo.",
                                       preferredStyle: .actionSheet)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        func presentCamera(_ _: UIAlertAction) {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true)
        }
        
        let cameraAction = UIAlertAction(title: "Camera",
                                         style: .default,
                                         handler: presentCamera)
        
//        func presentLibrary(_ _: UIAlertAction) {
//            imagePicker.sourceType = .photoLibrary
//            self.present(imagePicker, animated: true)
//        }
//
//        let libraryAction = UIAlertAction(title: "Photo Library",
//                                          style: .default,
//                                          handler: presentLibrary)
//
//        func presentAlbums(_ _: UIAlertAction) {
//            imagePicker.sourceType = .savedPhotosAlbum
//            self.present(imagePicker, animated: true)
//        }
//
//        let albumsAction = UIAlertAction(title: "Saved Albums",
//                                         style: .default,
//                                         handler: presentAlbums)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        prompt.addAction(cameraAction)
//        prompt.addAction(libraryAction)
//        prompt.addAction(albumsAction)
        prompt.addAction(cancelAction)
        
        self.present(prompt, animated: true, completion: nil)
    }
    
}

