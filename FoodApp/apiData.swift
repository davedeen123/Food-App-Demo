//
//  apiData.swift
//  FoodApp
//
//  Created by Dayal N D on 17/02/21.
//

import Foundation


struct CategoryData: Decodable {
    let categoryarray: [CategoryArray]
    
    private enum CodingKeys: String, CodingKey {
        case categoryarray = "categories"
    }
}

struct CategoryArray: Decodable {
    
    
    let idCategory: String?
    let strCategory: String?
    let strCategoryThumb: String?
    let strCategoryDescription: String?
  


    
    private enum CodingKeys: String, CodingKey {
        case idCategory = "idCategory"
        case strCategory = "strCategory"
        case strCategoryThumb = "strCategoryThumb"
        case strCategoryDescription = "strCategoryDescription"
   
        
    }
}



