//
//  FormSingleChoiceCell.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

class FormSingleChoiceCell: UITableViewCell {

    private let titleLabel = UILabel()

    private var model: FilledFormModel?

    private let radioGroup = RadioGroup()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

private extension FormSingleChoiceCell {

    func setup() {
        selectionStyle = .none
        radioGroup.delegate = self
        contentView.addSubViewWithAutolayout(titleLabel)
        contentView.addSubViewWithAutolayout(radioGroup)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            radioGroup.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            radioGroup.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            radioGroup.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            radioGroup.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
}

extension FormSingleChoiceCell {
    func configure(_ model: FilledFormModel) {
        self.model = model
        titleLabel.text = model.form.title
        radioGroup.addOptions(model.form.dataMap.options ?? [], seletedOption: model.response as? String)
    }
}

extension FormSingleChoiceCell: RadioGroupDelegate {
    func radionGroup(_ radioGroup: RadioGroup, didSelect option: String) {
        model?.response = option
    }
}
