//
//  FormRepository.swift
//  Locus
//
//  Created by Harish Kumar Yadav on 13/07/22.
//

import Foundation

protocol FormProvidable {
    func requestForm(completion: @escaping (Result<[FormInputModel], Error>) -> Void)
}

class FormRepository: FormProvidable {
    func requestForm(completion: @escaping (Result<[FormInputModel], Error>) -> Void) {
        Bundle.parse(fromFileName: "Form", completion: completion)
    }
}

extension Bundle {
    static func parse<T: Decodable>(fromFileName name: String, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
