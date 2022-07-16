//
//  FormViewController.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

class FormViewController: UIViewController {

    private let viewModel: FormViewModelType
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(FormImageCell.self, forCellReuseIdentifier: String(describing: FormImageCell.self))
        tableView.register(FormSingleChoiceCell.self, forCellReuseIdentifier: String(describing: FormSingleChoiceCell.self))
        tableView.register(FormCommentCell.self, forCellReuseIdentifier: String(describing: FormCommentCell.self))
        return tableView
    }()

    private let imagePicker: ImagePickerManagerType

    init(_ viewModel: FormViewModelType, imagePicker: ImagePickerManagerType = ImagePickerManager()) {
        self.viewModel = viewModel
        self.imagePicker = imagePicker
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchForm()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
        removeKeyboardObservers()
        super.viewWillDisappear(animated)
    }
}

private extension FormViewController {
    func setup() {
        view.addSubViewWithAutolayout(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        addSubmitButton()
    }

    func addSubmitButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))
    }

    @objc
    func submitTapped() {
        viewModel.submit()
    }

    func fetchForm() {
        viewModel.requestForm { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
}

extension FormViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filledForm.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.filledForm[indexPath.row]
        switch model.form.type {
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormImageCell.self)) as? FormImageCell
            cell?.configure(model)
            cell?.delegate = self
            return cell ?? UITableViewCell()
        case .singleChoice:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormSingleChoiceCell.self)) as? FormSingleChoiceCell
            cell?.configure(model)
            return cell ?? UITableViewCell()
        case .comment:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FormCommentCell.self)) as? FormCommentCell
            cell?.delegate = self
            cell?.configure(model)
            return cell ?? UITableViewCell()
        }
    }
}

extension FormViewController: FormCommentCellDelegate {
    func formCommentCellDidUpdateLayout() {
        tableView.reloadData()
    }
}

extension FormViewController: FormImageCellDelegate {

    func formImageCellTappedOnImage(_ image: UIImage) {
        let vc = ImageDetailViewController(ImageDetailViewModel(image))
        navigationController?.pushViewController(vc, animated: true)
    }

    func formImageCellWillOpenPicker(_ cell: FormImageCell, completion: @escaping (UIImage?) -> Void) {
        imagePicker.pickImage(self) { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }
}

private extension FormViewController {
    func handleKeyboard() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow(_:)),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(keyboardWillHide(_:)),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }

    func removeKeyboardObservers() {
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    func keyboardWillShow(_ notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        UIView.animate(withDuration: 0.45) {
            self.view.layoutIfNeeded()
        }
    }

    @objc
    func keyboardWillHide(_ notification: NSNotification?) {
        tableView.contentInset = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.45) {
            self.view.layoutIfNeeded()
        }
    }
}
