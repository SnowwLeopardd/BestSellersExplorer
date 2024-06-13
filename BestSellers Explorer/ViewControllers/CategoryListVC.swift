//
//  CalendarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import UIKit

class CategoryListVC: UIViewController {
    private let tableView = UITableView()
    
    private var numberOfQuestionLabel = UILabel()
    private let progressView = UIProgressView()
    private let questionLabel = UILabel()
    
    private var questions: [String]
    private var currentQuestion = 0
    private var currentProgress: Float!
    
    internal var sortedCategories: [List] = []
    internal var activityIndocator: UIActivityIndicatorView?
    internal var date: String
    
    init(with date: String) {
        questions = QuizManager.shared.getQuestions()
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        activityIndocator = ActivityIndicator.start(in: self.view, 
                                                    topAnchorConstant: 400,
                                                    size: .large)
        fetchCategoriesData()
        setupNumberOfQuestionsLabel()
        setupProgreeView()
        setupQuestionLabel()
    }
    
    // MARK: - UIElements
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
    
    internal func setupTableView() {
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

