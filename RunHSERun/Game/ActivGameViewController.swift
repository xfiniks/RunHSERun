import Foundation
import UIKit
import Vision

class ActivGameViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let background = UIImage(named: "background")
        view.layer.masksToBounds = true
        view.layer.contents = background?.cgImage
        configureUI()
        setupAuthorizationTimer()
//        nextText()
    }
    
    private lazy var backgroundView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.backgroundColor = .white
        return view
    } ()
    
    private lazy var textLabel : UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.font = timerLabel.font.withSize(30)
        textLabel.textColor = .systemBlue
        textLabel.numberOfLines = 4
        return textLabel
    } ()
    
    private lazy var timerLabel : UILabel = {
        let timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .center
        timerLabel.text = "00:00"
        timerLabel.font = timerLabel.font.withSize(40)
        timerLabel.textColor = .systemBlue
        return timerLabel
    } ()
    
    private var timeLeft = 0
    
    private var gameTimer : Timer?
    
    private func setupAuthorizationTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gameTimerTick), userInfo: nil, repeats: true)
    }
    
    @objc private func gameTimerTick() {
        timeLeft += 1
        updateUI()
    }
    
    var textId : Int = 0
    
    let texts = ["Can you run faster than baby?", "I'm rooting for your opponent..."]
    
    private func nextText() {
        if textId == texts.count - 1 {
            textLabel.animate(newText: texts[0], characterDelay: 0.05)
//            textLabel.text = texts[0]
            textId = 0
        } else {
            textId += 1
//            textLabel.text = texts[1]
            textLabel.animate(newText: texts[textId], characterDelay: 0.05)
        }
    }
    
    private func updateUI() {
//        if (timeLeft != 0 && timeLeft % 15 == 0) {
//            nextText()
//        }
            var minutes = String(timeLeft / 60)
            var seconds = String(timeLeft % 60)
        if (timeLeft / 60 < 10) {
            minutes = "0\(minutes)"
        }
        if (timeLeft % 60 < 10) {
            seconds = "0\(seconds)"
        }
            timerLabel.text = "\(minutes):\(seconds)"
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
    
    func makeRequest(userCgImage : CGImage) {
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
        }
    }
    
    
    private lazy var exitButton : UIButton = {
        let exitButton = UIButton(type: .custom)
        exitButton.backgroundColor = .white
        var image = UIImage(named: "exit")!.withRenderingMode(.alwaysOriginal)
        exitButton.setBackgroundImage(image, for: .normal)
        exitButton.contentHorizontalAlignment = .center
        exitButton.contentVerticalAlignment = .center
        exitButton.layer.cornerRadius = 20
        exitButton.layer.masksToBounds = false
        exitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        exitButton.setTitleColor(.systemGray5, for: .selected)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
//        exitButton.addTarget(self, action: #selector(exitButtonClicked), for: .touchUpInside)
        return exitButton
    } ()


    private lazy var gameLabel : UILabel = {
        let gameLabel = UILabel()
        gameLabel.translatesAutoresizingMaskIntoConstraints = false
        gameLabel.textColor = .systemBlue
        gameLabel.textAlignment = .center
        gameLabel.font = gameLabel.font.withSize(50)
        gameLabel.text = "Run!"
        return gameLabel
    } ()
    
    private lazy var auditoryLabel : UILabel = {
        let auditoryLabel = UILabel()
        auditoryLabel.translatesAutoresizingMaskIntoConstraints = false
        auditoryLabel.textColor = .systemBlue
        auditoryLabel.textAlignment = .center
//        auditoryLabel.font = gameLabel.font.withSize(30)
        auditoryLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        auditoryLabel.numberOfLines = 2
        auditoryLabel.text = """
        Audience:
        N503
        """
        return auditoryLabel
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
        view.addSubview(timerLabel)
//        view.addSubview(textLabel)
        view.addSubview(gameLabel)
        view.addSubview(makePhotoButton)
        view.addSubview(backgroundView)
        view.addSubview(exitButton)
        backgroundView.addSubview(auditoryLabel)
        backgroundView.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 50, width: 200, height: 200)
        
        NSLayoutConstraint.activate([

            gameLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 30),
            gameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameLabel.widthAnchor.constraint(equalToConstant: 250),
            gameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timerLabel.topAnchor.constraint(equalTo: gameLabel.bottomAnchor, constant: 50),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.widthAnchor.constraint(equalToConstant: 250),
            timerLabel.heightAnchor.constraint(equalToConstant: 100),
            
//            backgroundView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 50),
//            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            backgroundView.widthAnchor.constraint(equalToConstant: 250),
//            backgroundView.heightAnchor.constraint(equalToConstant: 250),
//            view.layer. = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 200, height: 200),
            auditoryLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            auditoryLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            auditoryLabel.heightAnchor.constraint(equalToConstant: 100),
            auditoryLabel.widthAnchor.constraint(equalToConstant: 200),
            
//            textLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 100),
//            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            textLabel.widthAnchor.constraint(equalToConstant: 250),
//            textLabel.heightAnchor.constraint(equalToConstant: 120),
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            exitButton.widthAnchor.constraint(equalToConstant: 35),
            exitButton.heightAnchor.constraint(equalToConstant: 35),

            makePhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            makePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            makePhotoButton.widthAnchor.constraint(equalToConstant: 250),
            makePhotoButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
}

extension ActivGameViewController : UIImagePickerControllerDelegate {
    
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
        makeRequest(userCgImage: cgImage)
        // Dismiss the picker to return to original view controller.
        dismiss(animated: true, completion: nil)
    }
    
}

extension ActivGameViewController : UINavigationControllerDelegate {
    
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


