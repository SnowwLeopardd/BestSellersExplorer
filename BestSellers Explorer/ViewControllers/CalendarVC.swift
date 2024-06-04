//
//  CalendarVC.swift
//  BestSellers Explorer
//
//  Created by Aleksandr Bochkarev on 5/31/24.
//

import UIKit

class CalendarVC: UIViewController {
    
    private let calendarStack = UIStackView()
    
    private var numberOfQuestionLabel = UILabel()
    private var progressView = UIProgressView()
    private var questionLabel = UILabel()
    private let calendarView = UICalendarView()
    
    private let NYTimesLogo: UIImage
    private let NYTimesLogoImageView: UIImageView
    
    private var questions: [String]
    private var currentQuestion = 0
    private var currentProgress: Float = 0.00
    
    init() {
        questions = QuizManager.shared.getQuestions()
        NYTimesLogo = UIImage(named: "NYTimes Logo 1") ?? UIImage()
        NYTimesLogoImageView = UIImageView(image: NYTimesLogo)
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
        
        setupQuizUI()
        setupNumberOfQuestionsLabel()
        setupProgreeView()
        setupQuestionLabel()
        setupCalendar()
        setupNYTimesLogo()
        setupCalendarStack()
    }
    
    // MARK: - UIElements
    private func setupQuizUI() {
        currentProgress = Float(currentQuestion + 1) / Float(questions.count)
        questionLabel.text = questions[currentQuestion]
        progressView.setProgress(currentProgress, animated: true)
        numberOfQuestionLabel.text = "Question \(currentQuestion + 1) from \(questions.count)"
    }
    
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
    
    private func setupCalendar() {
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = dateSelection
    }
    
    private func setupNYTimesLogo() {
        NYTimesLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(NYTimesLogoImageView)
        
        NSLayoutConstraint.activate([
            NYTimesLogoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            NYTimesLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
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
