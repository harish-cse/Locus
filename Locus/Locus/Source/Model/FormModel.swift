//
//  FormModel.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 14/07/22.
//

import UIKit

//{
//    "type" : "TYPE",
//    "id" : "id of this item",
//    "title" : "Title to display for this item",
//    "dataMap" : {
//        // A map which contains data required to display the item.
//    }
//}


enum InputType: String, Decodable {
    case photo = "PHOTO"
    case singleChoice = "SINGLE_CHOICE"
    case comment = "COMMENT"
}

// Taking this as a class so that it shares accross Input form and modification can be updated
struct FormInputModel: Decodable {
    let type: InputType
    let id: String
    let title: String
    let dataMap: FormInputDataModel
}

struct FormInputDataModel: Decodable {
    let options: [String]?
}

// Keep it as a class so that it automatically manage reference
class FilledFormModel {
    let form: FormInputModel
    var response: Any?

    init(_ form: FormInputModel, response: Any? = nil) {
        self.form = form
        self.response = response
    }
}

class CommentModel {
    var comment: String?
    var showInputField: Bool

    init(_ comment: String? = nil, showInputField: Bool = false) {
        self.comment = comment
        self.showInputField = showInputField
    }
}
