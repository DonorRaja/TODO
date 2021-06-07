//
//  Constant.swift
//  TODO
//
//  Created by DonorRaja on 7/06/21.
//

import Foundation
struct TODO {
    
    struct API {
        static let apiURL = "https://jsonplaceholder.typicode.com/"
        static let todos = "todos"
    }
    
    
    struct Model {
        static let completed = "completed"
        static let id = "id"
        static let userId = "userId"
        static let title = "title"
    }
    
    struct Search {
        static let searchHere = "Search here..."
    }
    
    struct Alert {
        static let networkError = "The Internet connection appears to be offline."
        static let alert = "Alert"
    }
}
