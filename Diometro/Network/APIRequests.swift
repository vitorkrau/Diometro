//
//  APIRequests.swift
//  Diometro
//
//  Created by Vitor Krau on 24/10/21.
//

import Foundation

class APIRequest {
    
    static let shared: APIRequest = APIRequest()

    func fetchAPI<T: Decodable>(endpoint: String, model: T.Type = T.self, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(APIRequestError.APIError(error)))
            }
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    completion(.failure(APIRequestError.ErrorStatusCode))
                }
            }
            if let data = data {
                do {
                    let dataResponse = try JSONDecoder().decode(model, from: data)
                    completion(.success(dataResponse))
                }
                catch {
                    completion(.failure(APIRequestError.unableToDecode))
                }
            }
        })
        task.resume()
    }
    
}


enum APIRequestError: Error {
    case APIError(_ error: Error)
    case ErrorStatusCode
    case unableToDecode
}
