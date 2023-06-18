//
//  ViewController.swift
//  BedtimeStories
//
//  Created by Bao Van on 6/16/23.
//

import UIKit

class ReaderViewController: UIViewController {

    var currentIndex: Int = 0
    var storyData: Story?
    var isPlaying = false
    var images: [UIImage?] = []
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
    
    func highlight(text: String) {
        guard let range = textView.text.range(of: text) else { return }
        let nsRange = NSRange(range, in: textView.text)
        let mutableAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        mutableAttributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: nsRange)

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
        textView.backgroundColor = .purple
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isScrollEnabled = false
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
        
        storyService.fetchStory { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let story):
                self.storyData = story
                self.textView.text = "Title of the story \n \(story.s1.text) \n \(story.s1.text)"
                highlight(text: "Title of the story")

            case .failure(let error):
                print("Error fetching story: \(error)")
            }
        }

        storyService.setUpAudio()
                      
        // Set the background color to purple
        self.view.backgroundColor = .purple
        
        // Add subviews
        self.view.addSubview(fullScreenImageView)
        self.view.addSubview(imageView)
        self.view.addSubview(scrollView)
        self.view.addSubview(toggleButton)
        self.view.addSubview(immersiveTextView)
        
        scrollView.addSubview(textView)
        scrollView.addSubview(playButton)
        
        immersiveTextView.text = texts[0]

        // Load image
        loadImage()
        loadFullScreenImages(with: imageUrls)
        

               
        
        // Handle play button tap
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)

        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 250)

        defaultConstraints = [
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
            
            textView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            textView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32) // ensure the width of textView same as scrollView to enable vertical scroll
        ]
        immersiveConstraints = [
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
        if(!isPlaying){
           storyService.playAudio()
            playButton.setBackgroundImage(UIImage(named: "pause_button"), for: .normal)
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
        
        for (index, urlString) in urlStrings.enumerated() {
            guard let fullScreenURL = URL(string: urlString) else { continue }
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
        guard let url = URL(string: "https://images.immediate.co.uk/production/volatile/sites/4/2023/02/Midjourney-small-f3a9034.jpg") else { return }
        
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
