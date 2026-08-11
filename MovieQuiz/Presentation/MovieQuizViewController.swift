import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - IBActions
    
    // Метод вызывается когда юзер нажимает кнопку "Да"
    @IBAction private func didTapYesButton(_ sender: Any) {
        guard let currentQuestions = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: currentQuestions.correctAnswer)
    }
    
    // Метод вызывается когда юзер нажимает кнопку "Нет"
    @IBAction private func didTapNoButton(_ sender: Any) {
        guard let currentQuestions = currentQuestion else {
            return
        }
        showAnswerResult(isCorrect: !currentQuestions.correctAnswer)
    }
    
    // MARK: - Properties
    
    // Переменная с количеством верных ответов
    private var correctAnswers: Int = 0
    
    // Переменная с индексом текущего вопроса
    private var currentQuestionIndex: Int = 0
    
    // Общее количество вопросов для Квиза
    private let questionsAmount: Int = 10
    
    // Фабрика вопросов в которую будет обращаться Контролер
    private var questionFactory: QuestionFactoryProtocol?
    
    // Вопрос который видит пользователь
    private var currentQuestion: QuizQuestion?
    
    // Алерта, куда Контролер передаст данные с результатами Квиза.
    private var alertPresenter: AlertPresenterProtocol?
    
    // Переменная хранящая текущие результаты квиза
    private var resultQuiz: AlertModel?
    
    // Переменная хранящая статистику квизов
    private var statisticService: StatisticServiceProtocol?
    
    // Переменная хранящая модель для Network error
    private var networkError: AlertModel?
    
    // Переменная хранит загрузчик данных по сети
    private var moviesLoader: MoviesLoader?
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAlertPresenter()
        setupStatisticService()
        showLoadingIndicator()
        setupQuestionFactory()
        setButtonsIsEnabled(to: false)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    // Метод, который вызовет Фабрика, чтобы показать готовый вопрос
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
        setButtonsIsEnabled(to: true)
        hideBorder()
    }
    
    // Метод сообщит о получении данных с сервера
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    // Метод сообщит о получении ошибки с сервера
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - AlertPresenterDelegate
    
    // Метод, который вызовет AlertPresenter, чтобы сообщить, что Алерта показана
    // и юзер нажал кнопку "Сыграть еще раз"
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
        hideBorder()
    }
    
    // MARK: - Private Initialization Methods
    
    // Метод инициализации Label
    private func setupUI() {
        questionLabel.font = Fonts.ysDisplayBold23
        questionTitleLabel.font = Fonts.ysDisplayMedium20
        questionTitleLabel.text = SetUI.tittleLabelText
        indexLabel.font = Fonts.ysDisplayMedium20
        previewImageView.layer.cornerRadius = CGFloat(SetUI.imageViewCornerRadius)
    }
    
    // Метод инициализации фабрики вопросов и установки делегата
    private func setupQuestionFactory() {
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        guard let questionFactory else { return }
        questionFactory.didSetDelegate(self)
        self.questionFactory = questionFactory
        questionFactory.loadData()
        if let firstQuestion = currentQuestion {
            show(quiz: convert(model: firstQuestion))
        }
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
    
    
    // MARK: - Private Methods
    
    // Метод конвертации из структуры вопроса во вью модель
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // Метод отображения информации на экране
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = "\(step.questionNumber)"
        previewImageView.image = step.image
        questionLabel.text = step.question
    }
    
    // Метод показывает обводку. Вызывается в методе showAnswerResult()
    private func showBorder(_ color: CGColor) {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.borderWidth = 8
        previewImageView.layer.borderColor = color
    }
    
    // Метод скрывает обводку. Вызывается в методе showNextQuestionOrResults()
    private func hideBorder() {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.borderWidth = 0
        previewImageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    // Метод отображения корректности ответа
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        showBorder(isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor)
        setButtonsIsEnabled(to: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    // Метод включает или выключает кнопки "Нет" и "Да"
    private func setButtonsIsEnabled(to newStatus: Bool) {
        noButton.isEnabled = newStatus
        yesButton.isEnabled = newStatus
    }
    
    // Метод либо ведет на экран результатов либо на следующий вопрос
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            calledWhenNeedShowResults()
        } else {
            calledWhenNeedShowNextQuestion()
        }
    }
    
    // Метод вызывается, когда нужно показать следующий вопрос
    private func calledWhenNeedShowNextQuestion() {
        currentQuestionIndex += 1
        questionFactory?.requestNextQuestion()
    }
    
    
    // Метод вызывается, когда нужно показать Результат Квиза
    private func calledWhenNeedShowResults () {
        updateStatistic()
        preparingAlertMessage()
    }
    
    
    // Метод обновляет данные для статистики
    private func updateStatistic(){
        
        guard let statisticService else { return }
        statisticService.store(correct: correctAnswers, total: questionsAmount)
    }
    
    // Метод формирует текст для Алерты на основе данных StatisticService.
    private func preparingAlertMessage() {
        
        guard let statisticService else { return }
        // Меняем формат даты под нужный формат dd.MM.yy HH:mm
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy HH:mm"
            return formatter
        }()
        
        resultQuiz = AlertModel (
            title: "Этот раунд окончен!",
            message: """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(dateFormatter.string(from: statisticService.bestGame.date)))
            Средняя точность: \(statisticService.totalAccuracy)%
            """,
            buttonText: "Сыграть еще раз",
            completion: { [weak self] in
                guard let self else { return }
                self.restartGame()
            }
        )
        
        guard let alertPresenter else { return }
        alertPresenter.show(viewController: self, with: resultQuiz)
    }
    
    // Метод отображения индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    // Метод формирования сообщения об ошибке получения данных по сети
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        networkError = AlertModel (
            title: "Ошибка!",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
                guard let self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.loadData()
                self.questionFactory?.requestNextQuestion()
                self.showLoadingIndicator()
            }
        )
        
        guard let alertPresenter else { return }
        alertPresenter.show(viewController: self, with: networkError)
    }
    
}


