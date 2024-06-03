//
//  CalendarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import UIKit

class CategoryListVC: UIViewController {
    
    private var categoryList: CategotyList!
    private var sortedCategories: [List]!
    
    private let tableView = UITableView()
    
    private var numberOfQuestionLabel = UILabel()
    private let progressView = UIProgressView()
    private let questionLabel = UILabel()
    
    private var questions: [String]
    private var currentQuestion = 0
    private var currentProgress: Float!
    
    private let alertController: UIAlertController
    private var date: String

    init(with date: String) {
        questions = QuizManager.shared.getQuestions()
        alertController = UIAlertController(title: "Loading", message: "\n", preferredStyle: .alert)
        
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        print("This is \(date)")
        fetchCategoriesData()
        setupNumberOfQuestionsLabel()
        setupProgreeView()
        setupQuestionLabel()
    }
}

// MARK: - UIElements
extension CategoryListVC {
    // MARK: - NumberOfQuestionsLabel
    private func setupNumberOfQuestionsLabel() {
        
        numberOfQuestionLabel.textAlignment = .center
        numberOfQuestionLabel.textColor = UIColor.black
        numberOfQuestionLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        numberOfQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(numberOfQuestionLabel)
        
        NSLayoutConstraint.activate([
            numberOfQuestionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            numberOfQuestionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            numberOfQuestionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            numberOfQuestionLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - UIProgressView
    private func setupProgreeView() {
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            progressView.topAnchor.constraint(equalTo: numberOfQuestionLabel.bottomAnchor, constant: 0),
            progressView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    // MARK: - Question Label
    private func setupQuestionLabel() {
        
        questionLabel.textColor = UIColor.purple
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.font = UIFont.boldSystemFont(ofSize: 27)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            questionLabel.topAnchor.constraint(equalTo: progressView.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            questionLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
    }
}

// MARK: - QuizLogic
extension CategoryListVC {
    private func setCurrentProgress() {
        currentProgress = Float(currentQuestion + 1) / Float(questions.count)
        numberOfQuestionLabel.text = "Question \(currentQuestion + 1) from \(questions.count)"
        progressView.setProgress(currentProgress, animated: false)
        questionLabel.text = questions[currentQuestion]
    }
    
     func setQuizUI() {
        setCurrentProgress()
        currentQuestion += 1
        tableView.isHidden = false

    }
    
     func resetQuizUI() {
        tableView.isHidden = true
         
        currentQuestion = 1
        setCurrentProgress()
    }
}

// MARK: - UITableView
extension CategoryListVC: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let text = sortedCategories[indexPath.row].listName
        cell.textLabel?.text = text
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = sortedCategories[indexPath.row].listName
        let topBooksVC = TopBooksVC(selectedCategory: selectedCategory, selectedDate: date)
        navigationController?.pushViewController(topBooksVC, animated: true)
    }
    
    // MARK: - SetupTableViewUI
    private func setupTableViewUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ListCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    // MARK: - NetWorking
    private func fetchCategoriesData() {
        print("This is date 2 \(date)")
        let url = Link.fullOverview.rawValue + date + "/" + Link.NYTimesApiKey.rawValue
        print(url)
        NetworkManager.shared.fetch(CategotyList.self, from: url ) { [weak self] result in
            switch result {
            case .success(let list):
                let sortedCategories = list.results.lists.sorted { $0.listName < $1.listName }
                self?.sortedCategories = sortedCategories
                DispatchQueue.main.async {
                    self?.setupTableViewUI()
                    self?.setQuizUI()
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
}











extension CategoryListVC {
    private func showLoadingAlert() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        alertController.view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45),
            activityIndicator.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        present(alertController, animated: true)
    }
    
    private func hideLoadingAlert() {
        alertController.dismiss(animated: true)
    }
}



