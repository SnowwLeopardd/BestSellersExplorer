//
//  CalendarViewController.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 1/22/24.
//

import UIKit

class QuizVC: UIViewController {
    
    private var categoryList: CategotyList!
    private var sortedCategories: [List]!
    
    private let tableView = UITableView()
    private let calendarStack = UIStackView()
    
    private var numberOfQuestionLabel = UILabel()
    private let progressView = UIProgressView()
    private let questionLabel = UILabel()
    private let calendarView = UICalendarView()
    
    private let NYTimesLogo: UIImage
    private let NYTimesLogoImageView: UIImageView
    
    private let alertController: UIAlertController
    
    private var questions: [String]
    private var currentQuestion = 0
    private var currentProgress: Float!
    
    init() {
        questions = UserDefaultsManager.shared.getQuestions()
        NYTimesLogo = UIImage(named: "NYTimes Logo 1") ?? UIImage()
        NYTimesLogoImageView = UIImageView(image: NYTimesLogo)
        alertController = UIAlertController(title: "Loading", message: "\n", preferredStyle: .alert)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true

        setupNumberOfQuestionsLabel()
        setupProgreeView()
        setupQuestionLabel()
        setupCalendar()
        setupNYTimesLogo()
        setupCalendarStack()
        setQuizUI()
    }
}

// MARK: - UIElements
extension QuizVC {
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
    
    // MARK: - NYTimes Logo
    private func setupNYTimesLogo() {
        NYTimesLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(NYTimesLogoImageView)
        
        NSLayoutConstraint.activate([
            NYTimesLogoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            NYTimesLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: - QuizLogic
extension QuizVC {
    private func setCurrentProgress() {
        currentProgress = Float(currentQuestion + 1) / Float(questions.count)
        numberOfQuestionLabel.text = "Question \(currentQuestion + 1) from \(questions.count)"
        progressView.setProgress(currentProgress, animated: true)
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
    
    // MARK: - UIStackView
        private func setupCalendarStack() {
            calendarStack.axis = .vertical
            calendarStack.alignment = .center
            calendarStack.distribution = .fill
            calendarStack.spacing = 16
            
            calendarStack.addArrangedSubview(calendarView)
            calendarStack.addArrangedSubview(NYTimesLogoImageView)
            
            view.addSubview(calendarStack)
            
            calendarStack.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                calendarStack.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
                calendarStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                calendarStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                calendarStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        }
}



// MARK: - Calendar
extension QuizVC: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        UserDefaultsManager.shared.saveSelectedDate(dateComponents)
        showLoadingAlert()
        fetchCategoriesData()

    }
    
    private func setupCalendar() {
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
    }
}

// MARK: - UIAlertController
extension QuizVC {
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

// MARK: - UITableView
extension QuizVC: UITableViewDataSource, UITableViewDelegate {
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
        UserDefaultsManager.shared.saveSelectedCategory(selectedCategory)
        pushTopBestSellersViewController()
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
        let url = Link.fullOverview.rawValue + UserDefaultsManager.shared.retrieveDate() + "/" + Link.NYTimesApiKey.rawValue
        NetworkManager.shared.fetch(CategotyList.self, from: url ) { [weak self] result in
            switch result {
            case .success(let list):
                let sortedCategories = list.results.lists.sorted { $0.listName < $1.listName }
                self?.sortedCategories = sortedCategories
                DispatchQueue.main.async {
                    self?.setupTableViewUI()
                    self?.hideLoadingAlert()
                    self?.setQuizUI()
                }
            case .failure(let error):
                print("Error fetching data: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Navigation
    private func pushTopBestSellersViewController() {
        let topBooksVC = TopBooksVC()
        navigationController?.pushViewController(topBooksVC, animated: true)
    }
}



