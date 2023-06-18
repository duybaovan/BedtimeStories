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

        self.view.backgroundColor = UIColor.purple

        let nameLabel = UILabel(frame: CGRect(x: 20, y: 60, width: 100, height: 60))
        nameLabel.text = "Name"
        view.addSubview(nameLabel)
        
        let nameValueLabel = UILabel(frame: CGRect(x: 130, y: 60, width: Int(view.frame.width) - 150, height: 60))
        nameValueLabel.text = "Amelia"
        view.addSubview(nameValueLabel)

        let labelsText = ["Story World", "Value", "Lesson", "Question"]
        let pickersData = [names, values]
        
        for i in 0..<2 {
            let label = UILabel(frame: CGRect(x: 20, y: 120 + i * 60, width: 100, height: 60))
            label.text = labelsText[i]
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
            view.addSubview(label)

            let textField = UITextField(frame: CGRect(x: 130, y: 120 + i * 60, width: Int(view.frame.width) - 150, height: 60))
            textField.placeholder = "Enter " + labelsText[i]
            view.addSubview(textField)
        }
        
        let button = UIButton(frame: CGRect(x: 20, y: 60 * 6, width: view.frame.width - 40, height: 60))
        button.setTitle("Generate", for: .normal)
        button.backgroundColor = .blue
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
