//
//  StorageManager.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import CoreData

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    // MARK: - UserDefault
    // MARK: - Calendar Date
    let userDefault = UserDefaults.standard
    
    func saveSelectedDate(_ dateComponents: DateComponents?) {
        let date = dateToString(dateComponents)
        userDefault.set(date, forKey: "selectedDate")
    }
    
    private func dateToString(_ dateComponents: DateComponents?) -> String {
        guard let dateComponents = dateComponents,
              let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else { return "no date" }
        
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
    
    func retrieveDate() -> String {
        guard let retrievedDate = userDefault.string(forKey: "selectedDate") else {
            return "No value found for the key"
        }
        return retrievedDate
    }
    
    // MARK: - SelectedCategory
    func saveSelectedCategory(_ category: String) {
        userDefault.setValue(category, forKey: "selectedCategory")
    }
    
    func retrieveSelectedCategory() -> String {
        guard let retrievedSelectedCategory = userDefault.string(forKey: "selectedCategory") else {
            return "No category found"
        }
        return retrievedSelectedCategory
    }
    
    

        // MARK: - QuizQuestions
        func getQuestions() -> [String] {
            
            let firstQuestion = "Pick explore date"
            let secondQuestion = "Choose topic"
            
            let questions: [String] = [firstQuestion, secondQuestion]
            return questions
        }
    }
