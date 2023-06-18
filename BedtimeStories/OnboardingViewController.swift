//
//  OnboardingViewController.swift
//  BedtimeStories
//
//  Created by Bao Van on 6/17/23.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill // Or .scaleAspectFit based on your need
        imageView.image = UIImage(named: "onboarding_screen") // Replace "YourImageName" with your image file name
        
        // If you want to allow the image to resize during orientation changes or different screen sizes, use autoresizing mask.
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(imageView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let creationViewController = OnboardingViewController2()
        navigationController?.pushViewController(creationViewController, animated: true)
    }
}


class OnboardingViewController2: UIViewController {
    let bottomSheetTransitioningDelegate = BottomSheetTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill // Or .scaleAspectFit based on your need
        imageView.image = UIImage(named: "onboarding_screen_2") // Replace "YourImageName" with your image file name
        
        // If you want to allow the image to resize during orientation changes or different screen sizes, use autoresizing mask.
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(imageView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let creationViewController = CreationViewController()
        let nav = UINavigationController(rootViewController: creationViewController)
           // 1
           nav.modalPresentationStyle = .pageSheet

           
           // 2
           if let sheet = nav.sheetPresentationController {

               // 3
               sheet.detents = [.medium(), .large()]

           }
        present(nav, animated: true, completion: nil)

    }
}

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class BottomSheetPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        return CGRect(x: 0, y: containerView.bounds.height / 2, width: containerView.bounds.width, height: containerView.bounds.height / 2)
    }
}
