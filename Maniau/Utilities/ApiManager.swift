//
//  ApiManager.swift
//  Maniau
//
//  Created by Ryan Kanno on 8/25/21.
//

import Foundation

struct ApiManager {
   func performRequest<T: Codable>(urlString: String, returnType: T.Type, completion: @escaping (Result<T, Error>) -> Void ) {
      print("\n\(#function)")
      if let url = URL(string: urlString) {
         let session = URLSession(configuration: .default)
         let task = session.dataTask(with: url) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse as Any)
            if let error = error {
               completion(.failure(error))
               return
            } else {
               let httpResponse = response as? HTTPURLResponse
               print(httpResponse as Any)
            }
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
               print(json)
               let decodedData = try decoder.decode(T.self, from: data)
               completion(.success(decodedData))
            } catch let decodingErr {
               completion(.failure(decodingErr))
            }
         }
         task.resume()
      } else {
         print("something went wrong with the url")
      }
   }
}
