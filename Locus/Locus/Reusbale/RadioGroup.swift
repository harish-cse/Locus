//
//  RadioGroup.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

protocol RadioGroupDelegate: AnyObject {
    func radionGroup(_ radioGroup: RadioGroup, didSelect option: String)
}

class RadioGroup: UIView {

    weak var delegate: RadioGroupDelegate?
    private var options = [String]()
    var selectedOption: String? {
        didSet {
            updateSelected()
        }
    }
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addOptions(_ options: [String], seletedOption: String?) {
        self.options = options
        stackView.subviews.forEach { $0.removeFromSuperview() }
        for index in 0..<options.count {
            let string = options[index]
            let button =  UIButton.makeRadio(string, isSelected: string.lowercased() == selectedOption?.lowercased())
            button.tag = index
            button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        self.selectedOption = seletedOption
    }
}

private extension RadioGroup {
    func setup() {
        addSubViewWithAutolayout(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func updateSelected() {
        if options.isEmpty { return }
        for index in 0..<stackView.arrangedSubviews.count {
            guard let button = stackView.arrangedSubviews[index] as? UIButton else { return }
            button.isSelected = options[index].lowercased() == selectedOption?.lowercased()
        }
    }

    @objc
    func radioButtonTapped(_ sender: UIButton) {
        let tag = sender.tag
        selectedOption = options[tag]
        delegate?.radionGroup(self, didSelect: selectedOption ?? "")
    }
}


private extension UIButton {
    static func makeRadio(_ option: String, isSelected: Bool = true) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(option, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage.radioUnchecked, for: .normal)
        button.setImage(UIImage.radioChecked, for: .selected)
        button.isSelected = isSelected
        return button
    }
}
