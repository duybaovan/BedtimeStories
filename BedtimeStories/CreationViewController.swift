//
//  CreationViewController.swift
//  BedtimeStories
//
//  Created by Bao Van on 6/17/23.
//

import Foundation
import UIKit

class CreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let names = ["Harry Potter", "Peter Pan", "Pirates", "Naruto"]
    let values = ["Optimism", "Tenacity", "Collaboration"]

    var activePickerView: UIPickerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(rgb: 0x143C77)


        let nameLabel = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 60))
        nameLabel.text = "Name"
        view.addSubview(nameLabel)
        
        let nameValueLabel = UILabel(frame: CGRect(x: 130, y: 60, width: Int(view.frame.width) - 150, height: 60))
        nameValueLabel.text = "Amelia"
        let boldFont = UIFont.boldSystemFont(ofSize: nameValueLabel.font.pointSize)

        // Apply the bold font to the label's attributed text
        let attributedText = NSAttributedString(string: nameValueLabel.text ?? "", attributes: [.font: boldFont])
        nameValueLabel.attributedText = attributedText
        view.addSubview(nameValueLabel)

        let labelsText = ["Story World", "Value", "Lesson", "Question"]
        let pickersData = [names, values]
        let defaultValues = ["Science Chapter 7", "What is energy?"]

        for i in 0..<2 {
            let label = UILabel(frame: CGRect(x: 20, y: 120 + i * 60, width: 100, height: 60))
            label.text = labelsText[i]
            let boldFont = UIFont.boldSystemFont(ofSize: label.font.pointSize)

            // Apply the bold font to the label's attributed text
            let attributedText = NSAttributedString(string: label.text ?? "", attributes: [.font: boldFont])
            label.attributedText = attributedText
            
            view.addSubview(label)
            
            let pickerView = UIPickerView(frame: CGRect(x: 130, y: 120 + i * 60, width: Int(view.frame.width) - 150, height: 60))
            pickerView.tag = i
            pickerView.delegate = self
            pickerView.dataSource = self
            view.addSubview(pickerView)
        }

        for i in 2..<4 {
            let label = UILabel(frame: CGRect(x: 20, y: 120 + i * 60, width: 100, height: 60))
            label.text = labelsText[i]
            let boldFont = UIFont.boldSystemFont(ofSize: label.font.pointSize)

            // Apply the bold font to the label's attributed text
            let attributedText = NSAttributedString(string: label.text ?? "", attributes: [.font: boldFont])
            label.attributedText = attributedText
            view.addSubview(label)

            let textField = UITextField(frame: CGRect(x: 130, y: 120 + i * 60, width: Int(view.frame.width) - 150, height: 60))
            textField.text = defaultValues[i-2]
            view.addSubview(textField)
        }
        
        let button = UIButton(frame: CGRect(x: 20, y: 60 * 6, width: view.frame.width - 40, height: 60))
        button.setTitle("Create", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        button.backgroundColor = UIColor(rgb: 0x143C77)
        button.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func generateButtonTapped() {
        let nextVC = ReaderViewController()
        navigationController?.setViewControllers([nextVC], animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return names.count
        case 1:
            return values.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return names[row]
        case 1:
            return values[row]
        default:
            return ""
        }
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
