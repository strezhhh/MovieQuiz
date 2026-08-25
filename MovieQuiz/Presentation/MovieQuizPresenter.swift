//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.08.2026.
//

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Properties
    
    // Алерта, куда Контролер передаст данные с результатами Квиза.
    var alertPresenter: AlertPresenterProtocol?
    
    // Переменная хранящая статистику квизов
    private var statisticService: StatisticServiceProtocol?
    
    // Фабрика вопросов в которую будет обращаться MovieQuizPresenter
    var questionFactory: QuestionFactoryProtocol?
    
    // Переменная с количеством верных ответов
    private var correctAnswers: Int = 0
    
    // Переменная хранящая текущие результаты квиза
    private var resultQuiz: AlertModel?
    
    // Слабая ссылка на MovieQuizViewController
    weak var viewController: MovieQuizViewControllerProtocol?
    
    // Переменная с индексом текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    // Общее количество вопросов для Квиза
    private let questionsAmount: Int = 10
    
    // Вопрос который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    // MARK: - QuestionFactoryDelegate
    
    // Метод вызовут когда загрузяться данных с сервера
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    // Метод вызовут если получат ошибку с сервера
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(title: NSLocalizedString("errorLoadDataTitle", comment: ""), message: error.localizedDescription)
    }
    
    // Метод вызовут если пользователь не увидел изображение
    func didFailToLoadImage() {
        viewController?.showNetworkError(title: NSLocalizedString("errorLoadImageTitle", comment: ""), message: NSLocalizedString("errorLoadImageMessage", comment: ""))
    }
    
    // MARK: - AlertPresenterDelegate
    
    // Метод вызовут если юзер нажал кнопку "Сыграть еще раз" на Алерте
    func restartGame() {
        resetQuestionIndex()
        resetCorrectAnswers()
        questionFactory?.requestNextQuestion()
        viewController?.hideBorder()
    }
    
    // MARK: - Private Initialization Methods
    
    // Метод вызовет инициализацию необходимых сущностей
    init() {
        setupAlertPresenter()
        setupStatisticService()
        setupQuestionFactory()
    }
    
    // Метод инициализации переменной alertPresenter() и установки делегата в AlertPresenter()
    private func setupAlertPresenter() {
        alertPresenter = AlertPresenter()
        guard let alertPresenter else { return }
        alertPresenter.didSetDelegate(self)
        self.alertPresenter = alertPresenter
    }
    
    // Метод инициализации переменной statisticService
    private func setupStatisticService() {
        statisticService = StatisticService()
    }
    
    // Метод инициализации фабрики вопросов, установки делегата и инициации загрузки данных из сети
    private func setupQuestionFactory() {
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        guard let questionFactory else { return }
        questionFactory.didSetDelegate(self)
        questionFactory.loadData()
        guard let currentQuestion = self.currentQuestion else {return}
        viewController?.show(quiz: self.convert(model: currentQuestion))
    }
    
    // MARK: - Private Methods
    
    // Метод отображения корректности ответа
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect {
            increaseCorrectAnswers()
        }
        viewController?.showBorder(answer: isCorrect)
        viewController?.setButtonsIsEnabled(to: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    // Метод обновления статистики
    private func updateStatistic(){
        guard let statisticService else { return }
        statisticService.store(correct: self.correctAnswers, total: self.questionsAmount)
    }
    
    // Метод либо ведет на экран результатов либо на следующий вопрос
    private func proceedToNextQuestionOrResults() {
        if self.isLastQuestions() {
            updateStatistic()
            guard let statisticService = self.statisticService else { return }
            let dateFormatter = DateFormatter.defaultDateTime
            resultQuiz = AlertModel (
                title: NSLocalizedString("resultQuizTitle", comment: ""),
                message: """
                    \(NSLocalizedString("resultQuizMessageResult", comment: "")) \(self.correctAnswers)/\(self.questionsAmount)
                    \(NSLocalizedString("resultQuizMessgeCount", comment: "")) \(statisticService.gamesCount)
                    \(NSLocalizedString("resultQuizMessageRecord", comment: "")) \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(dateFormatter.string(from: statisticService.bestGame.date)))
                    \(NSLocalizedString("resultQuizMessageAccuracy", comment: "")) \(statisticService.totalAccuracy)%
                    """,
                buttonText: NSLocalizedString("resultQuizButtonText", comment: ""),
                completion: { [weak self] in
                    guard let self else { return }
                    self.restartGame()
                }
            )
            
            guard
                let alertPresenter = alertPresenter,
                let viewController = viewController
            else { return }
            alertPresenter.showAlertWithResult(viewController: viewController, with: resultQuiz)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // Метод сравнивает полученный от пользователя ответ с правильным
    private func didAnswer (guess: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        self.proceedWithAnswer(isCorrect: guess == currentQuestion.correctAnswer)
    }
    
    // Метод проверяет является ли текущий вопрос последним
    private func isLastQuestions() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    // Метод сбрасывает индекс вопросов на 0
    private func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    // Метод увеличивает индекс вопросов на 1
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // Метод увеличивает количесво правильных ответов на 1
    private func increaseCorrectAnswers() {
        correctAnswers += 1
    }
    
    // Метод сбрасывает количество правильных ответов на 0
    private func resetCorrectAnswers() {
        correctAnswers = 0
    }
    
    // Метод конвертации из структуры вопроса во вью модель
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            imageData: model.imageData,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // MARK: - Methods
    
    // Метод, который вызовет Фабрика, чтобы показать готовый вопрос
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.setButtonsIsEnabled(to: true)
            self?.viewController?.hideBorder()
        }
    }
    
    // Метод вызывается когда юзер нажимает кнопку "Да"
    func didTapYesButton() {
        didAnswer (guess: true)
    }
    
    // Метод вызывается когда юзер нажимает кнопку "Нет"
    func didTapNoButton() {
        didAnswer (guess: false)
    }
    
}
