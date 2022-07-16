//
//  FormViewModel.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

protocol FormViewModelType {
    func requestForm(completion: @escaping (Result<[FormInputModel], Error>) -> Void)
    func submit()
    var filledForm: [FilledFormModel] { get }
}

class FormViewModel: FormViewModelType {
    var filledForm: [FilledFormModel] = []

    private let formProvidable: FormProvidable

    init(_ formProvidable: FormProvidable = FormRepository()) {
        self.formProvidable = formProvidable
    }

    func requestForm(completion: @escaping (Result<[FormInputModel], Error>) -> Void) {
        formProvidable.requestForm { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                self.filledForm = models.map {
                    switch $0.type {
                    case .comment:
                        return FilledFormModel($0, response: CommentModel())
                    case .photo, .singleChoice:
                        return FilledFormModel($0)
                    }
                }
            case .failure:
                self.filledForm = []
            }
            completion(result)
        }
    }

    func submit() {
        print("===========> Start Printing Form <============")
        filledForm.forEach {
            let type = $0.form.type
            switch type {
            case .comment:
                print("form id => \($0.form.id)")
                print("user input => \(($0.response as? CommentModel)?.comment ?? "No Input provided")")
            case .photo, .singleChoice:
                print("form id => \($0.form.id)")
                print("user input => \($0.response ?? "No Input provided")")
            }
        }
        print("===========> End Printing Form <============")
    }
}
