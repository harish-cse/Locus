//
//  FormCommentCell.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

protocol FormCommentCellDelegate: AnyObject {
    func formCommentCellDidUpdateLayout()
}

class FormCommentCell: UITableViewCell {

    weak var delegate: FormCommentCellDelegate?

    private let titleLabel = UILabel()

    private let toggle = UISwitch(frame: .zero)

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your comment"
        textField.delegate = self
        return textField
    }()

    private let titleContentView = UIView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private var model: FilledFormModel?


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

private extension FormCommentCell {
    func setup() {
        selectionStyle = .none
        titleContentView.addSubViewWithAutolayout(titleLabel)
        titleContentView.addSubViewWithAutolayout(toggle)
        contentView.addSubViewWithAutolayout(stackView)
        stackView.addArrangedSubview(titleContentView)
        stackView.addArrangedSubview(textField)
        setupConstraints()
        configureActions()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleContentView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContentView.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: titleContentView.trailingAnchor),
            toggle.topAnchor.constraint(equalTo: titleContentView.topAnchor, constant: 4),
            toggle.bottomAnchor.constraint(equalTo: titleContentView.bottomAnchor, constant: -4),
            textField.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -4),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4)
        ])
    }

    func configureActions() {
        toggle.addTarget(self, action: #selector(toggleSwitch), for: .valueChanged)
    }

    @objc
    func toggleSwitch() {
        (model?.response as? CommentModel)?.showInputField = toggle.isOn
        delegate?.formCommentCellDidUpdateLayout()
    }
}

extension FormCommentCell {
    func configure(_ model: FilledFormModel) {
        self.model = model
        titleLabel.text = model.form.title
        textField.text = (model.response as? CommentModel)?.comment
        toggle.isOn = (model.response as? CommentModel)?.showInputField ?? false
        textField.isHidden = !toggle.isOn
    }
}

extension FormCommentCell: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        (model?.response as? CommentModel)?.comment = updatedString ?? ""
        return true
    }
}
