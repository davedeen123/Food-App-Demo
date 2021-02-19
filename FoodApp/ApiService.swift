//
//  ApiService.swift
//  FoodApp
//
//  Created by Dayal N D on 17/02/21.
//

import Foundation

class ApiService {
    
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Get popular movies data
func getCategoryApiData(completion: @escaping (Result<CategoryData, Error>) -> Void) {
        
        let popularMoviesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Hndle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(CategoryData.self, from: data)
                
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }

}
