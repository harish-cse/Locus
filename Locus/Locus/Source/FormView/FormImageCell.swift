//
//  FormImageCell.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

protocol FormImageCellDelegate: AnyObject {
    func formImageCellWillOpenPicker(_ cell: FormImageCell, completion: @escaping (UIImage?) -> Void)
    func formImageCellTappedOnImage(_ image: UIImage)
}

class FormImageCell: UITableViewCell {

    weak var delegate: FormImageCellDelegate?

    private let titleLabel = UILabel()

    private var model: FilledFormModel?

    private let inputImageButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        return button
    }()

    private let removeImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.cross, for: .normal)
        return button
    }()

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

private extension FormImageCell {
    func setup() {
        selectionStyle = .none
        contentView.addSubViewWithAutolayout(titleLabel)
        contentView.addSubViewWithAutolayout(inputImageButton)
        contentView.addSubViewWithAutolayout(removeImageButton)
        setupConstraints()
        configureActions()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            inputImageButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            inputImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            inputImageButton.widthAnchor.constraint(equalToConstant: 100),
            inputImageButton.heightAnchor.constraint(equalToConstant: 100),
            inputImageButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            removeImageButton.widthAnchor.constraint(equalToConstant: 36),
            removeImageButton.heightAnchor.constraint(equalToConstant: 36),
            removeImageButton.topAnchor.constraint(equalTo: inputImageButton.topAnchor, constant: -18),
            removeImageButton.leadingAnchor.constraint(equalTo: inputImageButton.trailingAnchor, constant: -18)
        ])
    }

    func configureActions() {
        inputImageButton.addTarget(self, action: #selector(thumbnailTapped), for: .touchUpInside)
        removeImageButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }

    @objc
    func thumbnailTapped() {
        if let image = model?.response as? UIImage {
            delegate?.formImageCellTappedOnImage(image)
        } else {
            delegate?.formImageCellWillOpenPicker(self, completion: { [weak self] image in
                self?.handleImage(image)
                self?.model?.response = image
            })
        }
    }

    @objc
    func removeButtonTapped() {
        model?.response = nil
        handleImage(nil)
    }

    func handleImage(_ image: UIImage?) {
        guard let image = image else {
            inputImageButton.setImage(UIImage.add, for: .normal)
            removeImageButton.isHidden = true
            return
        }
        inputImageButton.setImage(image, for: .normal)
        removeImageButton.isHidden = false
    }
}

extension FormImageCell {
    func configure(_ model: FilledFormModel) {
        self.model = model
        titleLabel.text = model.form.title
        guard let image = model.response as? UIImage else {
            inputImageButton.setImage(UIImage.add, for: .normal)
            removeImageButton.isHidden = true
            return
        }
        inputImageButton.setImage(image, for: .normal)
        removeImageButton.isHidden = false
    }
}
