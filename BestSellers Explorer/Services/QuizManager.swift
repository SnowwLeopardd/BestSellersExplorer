//
//  QuizManager.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

import Foundation

class QuizManager {
    
    static let shared = QuizManager()
    
    private init() {}
    
    func getQuestions() -> [String] {
        let firstQuestion = "Pick explore date"
        let secondQuestion = "Choose topic"
        
        let questions: [String] = [firstQuestion, secondQuestion]
        return questions
    }
}
