//
//  ReaderViewController.swift
//  BedtimeStories
//
//  Created by Bao Van on 6/16/23.
//

import UIKit

class ReaderViewController: UIViewController {
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.tintColor = .white
        progressBar.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        return progressBar
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    
    var currentIndex: Int = 0
    var storyData: Story?
    var isCompleted = false
    var isPlaying = false
    var images: [UIImage?] = []
    let yesButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Yes", for: .normal)
        button.addTarget(self, action: #selector(didTapYes), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont(name: "Inter-Bold", size: 25)

        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3.0
        button.backgroundColor = UIColor(rgb: 0x143C77)
        
        return button
    }()
    
    let noButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("No", for: .normal)
        button.addTarget(self, action: #selector(didTapNo), for: .touchUpInside)
        
        button.titleLabel?.font = UIFont(name: "Inter-Bold", size: 25)

        
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3.0
        button.backgroundColor = UIColor(rgb: 0x143C77)
        
        return button
    }()
    var imageUrls: [String] = ["https://preview.redd.it/sbl0qy0jlhl91.png?width=1024&format=png&auto=webp&v=enabled&s=c2b55b97c07c02f99fcc3dbbca1cc630b92c0fcb", "https://w0.peakpx.com/wallpaper/853/463/HD-wallpaper-midjourney-ai-art-for-book-cover-design-how-is-this-legal.jpg","https://imageio.forbes.com/specials-images/imageserve/63f8118ae17897a4890f01a1/0x0.jpg?format=jpg&width=1200"]
    
    var texts = ["This is story part 1", "THis is story part 2 the middle part", "The finale"]
    
    let fullScreenImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var isReaderMode: Bool = true {
        didSet {
            updateLayout()
        }
    }
    
    var defaultConstraints: [NSLayoutConstraint] = []
    var immersiveConstraints: [NSLayoutConstraint] = []
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Method to toggle between text and visual mode
    @objc func toggle() {
        toggleButton.isTextMode.toggle()
        isReaderMode = !isReaderMode
        self.view.setNeedsLayout()
    }
    
    @objc func didTapYes() {
        if(isCompleted){
            yesButton.setTitle("Yes", for: .normal)
            noButton.setTitle("No", for: .normal)
            noButton.isHidden = false
            textView.text = storyData?.s1.text
            isCompleted = false
            

            let nextVC = CreationViewController()
           dismiss(animated: true)
            return
        }
        isCompleted = true
        showCompletion()
    }
    
    @objc func didTapNo() {
        textView.text = storyData?.s2.text
        noButton.isHidden = true
        yesButton.setTitle("Understood", for: .normal)
        storyService.pauseAudio()
         playButton.setBackgroundImage(UIImage(named: "play_button"), for: .normal)
        storyService.setUpAudio(named: "test_intermediary")
        
    }
    
    func showCompletion() {
        storyService.pauseAudio()
         playButton.setBackgroundImage(UIImage(named: "play_button"), for: .normal)
        storyService.setUpAudio(named: "test_conclusion")
        textView.text = storyData?.s3.text
        noButton.isHidden = true
        yesButton.setTitle("Done", for: .normal)
    }
    
    func highlightExtraBold(text: String, color: UIColor) {
        guard let range = textView.text.range(of: text) else { return }
        let nsRange = NSRange(range, in: textView.text)
        let mutableAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)

        let fontDescriptor = UIFontDescriptor(name: "Inter-Bold", size: 20)
            let font = UIFont(descriptor: fontDescriptor, size: 0) // size: 0 means it will use the font size defined in the descriptor

            mutableAttributedText.addAttribute(.font, value: font, range: nsRange)
        mutableAttributedText.addAttribute(.foregroundColor, value: color, range: nsRange)

        textView.attributedText = mutableAttributedText
    }

    
    
    func highlight(text: String) {
        guard let range = textView.text.range(of: text) else { return }
        let nsRange = NSRange(range, in: textView.text)
        let mutableAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableAttributedText.addAttribute(.font, value: UIFont(name: "Inter-Bold", size: 32), range: nsRange)

        textView.attributedText = mutableAttributedText
    }
    
    var imageViewHeightConstraint: NSLayoutConstraint?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let playButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "play_button"), for: .normal)
        return button
    }()
    
    let textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.setCustomFont(name: "Inter-Bold", size: 20)
        return textView
    }()
    
    
    let durationTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isScrollEnabled = false
        textView.setCustomFont(name: "Inter-Bold", size: 12)
        return textView
    }()
    
    let immersiveTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 32)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let storyService = StoryService()

    
    var toggleButton: ToggleButton = {
        let button = ToggleButton()
        button.textImage = UIImage(named: "text_toggle_button")
        button.visualImage = UIImage(named: "visual_toggle_button")
        button.isTextMode = true // Ensures that initial image is set
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        return button
    }()
    
    
    
    func updateLayout() {
        if isReaderMode {
            fullScreenImageView.isHidden = true
            imageView.isHidden = false
            playButton.isHidden = false
            scrollView.isHidden = false
            immersiveTextView.isHidden = true
            NSLayoutConstraint.deactivate(immersiveConstraints)
            NSLayoutConstraint.activate(defaultConstraints)
        } else {
            imageView.isHidden = true
            playButton.isHidden = false
            scrollView.isHidden = true
            fullScreenImageView.isHidden = false
            immersiveTextView.isHidden = false
            NSLayoutConstraint.deactivate(defaultConstraints)
            NSLayoutConstraint.activate(immersiveConstraints)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        
        if location.x > view.frame.size.width / 2 {
            currentIndex = (currentIndex + 1) % images.count // Next image
        } else {
            currentIndex = (currentIndex - 1 + images.count) % images.count // Previous image
        }

        immersiveTextView.text = texts[currentIndex]
        fullScreenImageView.image = images[currentIndex]
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()

        storyService.fetchStory(name: "Amelie", character_environment: "Ninja world with Naruto", topic: "Elementary school physics and energy", value: "Persistence") { [weak self] (result) in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()

            switch result {

            case .success(let story):
                self.storyData = story
                self.textView.text = "The Energetic Wizard \n \(story.s1.text) \n\n\(story.question.text)"
                highlight(text: "The Energetic Wizard")

                highlightExtraBold(text: "\(story.question.text)", color: .orange)
                
                imageUrls = story.s4.imageUrl
                texts = story.s4.text
                
                loadFullScreenImages(with: imageUrls)
                loadImage()

                print(imageUrls)


            case .failure(let error):
                print("Error fetching story: \(error)")
            }
        }
        
        durationTextView.text = "3:00"

        storyService.setUpAudio(named: "test_audio")
                      
        // Set the background color to purple
        self.view.backgroundColor = UIColor(rgb: 0x143C77)
        
        // Add subviews
        self.view.addSubview(fullScreenImageView)
        self.view.addSubview(progressBar)
        self.view.addSubview(imageView)
        self.view.addSubview(scrollView)
        self.view.addSubview(toggleButton)
        self.view.addSubview(immersiveTextView)

        scrollView.addSubview(textView)
        scrollView.addSubview(yesButton)
        scrollView.addSubview(noButton)
        scrollView.addSubview(playButton)
        scrollView.addSubview(durationTextView)
        
        self.view.addSubview(activityIndicator)

        immersiveTextView.text = texts[0]

        // Load image
        

               
        
        // Handle play button tap
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 250)

        defaultConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewHeightConstraint!,
        
            toggleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            toggleButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),

            scrollView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            playButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            playButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            
            progressBar.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            progressBar.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -80),
            
            durationTextView.leadingAnchor.constraint(equalTo: progressBar.trailingAnchor, constant: 8),
            durationTextView.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),

            
            textView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -100),
            textView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32), // ensure the width of textView same as scrollView to enable vertical scroll
            
            yesButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            yesButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50),
            yesButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.4, constant: -24), // subtract the padding of leading and trailing buttons
            yesButton.heightAnchor.constraint(equalToConstant: 50),
            
            noButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            noButton.leadingAnchor.constraint(equalTo: yesButton.trailingAnchor, constant: 16),
            noButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            noButton.heightAnchor.constraint(equalToConstant: 50),
            noButton.widthAnchor.constraint(equalTo: yesButton.widthAnchor), // ensure both buttons are of same width
            
            // To prevent content cutoff and enable scrolling, we need to set bottom constraint
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: yesButton.topAnchor, constant: -16),

        ]
        
        immersiveConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            fullScreenImageView.topAnchor.constraint(equalTo: view.topAnchor),
            fullScreenImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            playButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            playButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            
            
            toggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),

            toggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant:0),
            
            immersiveTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            immersiveTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            immersiveTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            immersiveTextView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32)

        ]
        updateLayout()

    }
    
    // Add a dummy function to handle the play button tap
    @objc func playButtonTapped() {
        if !isPlaying {
            storyService.playAudio()
            playButton.setBackgroundImage(UIImage(named: "pause_button"), for: .normal)
            
            // Start updating the progress bar
            let duration = storyService.getAudioDuration()
            progressBar.setProgress(0, animated: false)
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                let progress = storyService.getAudioProgress()
                self.progressBar.setProgress(Float(progress / duration), animated: true)
                
                if progress >= duration {
                    timer.invalidate()
                    self.isPlaying = false
                    self.playButtonTapped()
                }
            }
        } else {
            storyService.pauseAudio()
            playButton.setBackgroundImage(UIImage(named: "play_button"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }

    
    func loadFullScreenImages(with urlStrings: [String]) {
        let dispatchGroup = DispatchGroup()
        
        // Initialize the images array with nil values
        self.images = Array(repeating: nil, count: urlStrings.count)
        print("ssx \(urlStrings)")
        for (index, urlString) in urlStrings.enumerated() {
            let fullScreenURL = URL(string: "http://localhost:8000\(urlString)")
                                    print("ssx here")
            guard let fullScreenURL = URL(string: "http://localhost:8000\(urlString)") else { continue }
            dispatchGroup.enter()
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: fullScreenURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.images[index] = image // Save the image at the correct index
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
        }
        

        
        dispatchGroup.notify(queue: .main) {
            print("All images are loaded")
            self.fullScreenImageView.image = self.images[self.currentIndex]
            // Clean up images array by removing nil values if any
            self.images = self.images.compactMap { $0 }
        }
    }
    
    func loadImage() {
        guard let url = URL(string: storyData?.s1.imageUrl?[0] ?? "https://images.immediate.co.uk/production/volatile/sites/4/2023/02/Midjourney-small-f3a9034.jpg") else { return }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
    }
    
    class ToggleButton: UIButton {
        // Custom properties to store the images for toggle states
        var textImage: UIImage?
        var visualImage: UIImage?
        
        // Current toggle state
        var isTextMode: Bool = true {
            didSet {
                // Update the button's image based on the toggle state
                setImage(isTextMode ? textImage : visualImage, for: .normal)
            }
        }
        
        // Initialization
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            // Set up the initial button image
            setImage(textImage, for: .normal)
            
            // Add a target to handle button taps
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
    }
}

extension UILabel {
    func setCustomFont(name: String, size: CGFloat) {
        if let customFont = UIFont(name: name, size: size) {
            self.font = customFont
        } else {
            // Fallback to the system font or a default font if the custom font is not found.
            self.font = UIFont.systemFont(ofSize: size)
            // Alternatively, you can display a warning or handle the failure differently.
            // print("Custom font '\(name)' not found.")
        }
    }
}

extension UITextView {
    func setCustomFont(name: String, size: CGFloat) {
        if let customFont = UIFont(name: name, size: size) {
            self.font = customFont
        } else {
            self.font = UIFont.systemFont(ofSize: size)
            // Alternatively, handle the font not found scenario as per your requirements.
            // print("Custom font '\(name)' not found.")
        }
    }
}


extension String {
    func nsRange(from range: Range<Index>) -> NSRange {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view),
           let to = range.upperBound.samePosition(in: utf16view) {
            return NSRange(location: utf16view.distance(from: utf16view.startIndex, to: from),
                           length: utf16view.distance(from: from, to: to))
        }
        return NSRange(location: 0, length: 0)
    }
}
