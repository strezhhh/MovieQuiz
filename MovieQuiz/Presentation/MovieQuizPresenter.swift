//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Pavel Strezh on 19.08.2026.
//

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Properties
    
    // Фабрика вопросов в которую будет обращаться Контролер
    var questionFactory: QuestionFactoryProtocol?
    
    // Переменная с количеством верных ответов
    var correctAnswers: Int = 0
    
    // Переменная хранящая текущие результаты квиза
    private var resultQuiz: AlertModel?
    
    // Слабая ссылка на MovieQuizViewController
    weak var viewController: MovieQuizViewController?
    
    // Переменная с индексом текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    // Общее количество вопросов для Квиза
    let questionsAmount: Int = 10
    
    // Вопрос который видит пользователь
    var currentQuestion: QuizQuestion?
    
    // MARK: - QuestionFactoryDelegate
    
    // Метод сообщит о получении данных с сервера
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    // Метод сообщит о получении ошибки с сервера
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(title: "Ошибка!", message: error.localizedDescription)
    }
    
    // Метод сообщит, что пользователь не увидел изображение
    func didFailToLoadImage() {
        viewController?.showNetworkError(title: "Упс, постер не загрузился!", message: "В следующий раз точно загрузится!")
    }
    
    // MARK: - Private Initialization Methods

    // Метод вызовет инициализацию фабрики вопросов
    init() {
        setupQuestionFactory()
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
    
    // MARK: - Methods
    
    // Метод либо ведет на экран результатов либо на следующий вопрос
    func showNextQuestionOrResults() {
        if self.isLastQuestions() {
            viewController?.updateStatistic()
            guard let statisticService = viewController?.statisticService else { return }
                // Меняем формат даты под нужный формат dd.MM.yy HH:mm
                let dateFormatter: DateFormatter = {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yy HH:mm"
                    return formatter
                }()
                
                resultQuiz = AlertModel (
                    title: "Этот раунд окончен!",
                    message: """
                    Ваш результат: \(self.correctAnswers)/\(self.questionsAmount)
                    Количество сыгранных квизов: \(statisticService.gamesCount)
                    Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(dateFormatter.string(from: statisticService.bestGame.date)))
                    Средняя точность: \(statisticService.totalAccuracy)%
                    """,
                    buttonText: "Сыграть еще раз",
                    completion: { [weak self] in
                        guard let self else { return }
                        viewController?.restartGame()
                    }
                )
                
            guard
                let alertPresenter = viewController?.alertPresenter,
                let viewController = self.viewController
                else { return }
            alertPresenter.show(viewController: viewController, with: resultQuiz)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
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
    
    // Метод сравнивает полученный от пользователя ответ с правильным
    private func didAnswer (guess: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        viewController?.showAnswerResult(isCorrect: guess == currentQuestion.correctAnswer)
    }
    
    // Метод проверяет является ли текущий вопрос последним
    func isLastQuestions() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    // Метод сбрасывает индекс вопросов на 0
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    // Метод увеличивает индекс вопросов на 1
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // Метод конвертации из структуры вопроса во вью модель
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            // image: UIImage(data: model.imageData) ?? UIImage(), // старый код
            imageData: model.imageData, // рефакторинг
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" // надо добавить эти две переменные
        )
    }
    
}
