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
        presenter.didTapYesButton()
    }
    
    // Метод вызывается когда юзер нажимает кнопку "Нет"
    @IBAction private func didTapNoButton(_ sender: Any) {
        presenter.didTapNoButton()
    }
    
    // MARK: - Properties
    
    // Переменная с количеством верных ответов
    private var correctAnswers: Int = 0
    
    // Фабрика вопросов в которую будет обращаться Контролер
    private var questionFactory: QuestionFactoryProtocol?
        
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
    
    //
    private let presenter = MovieQuizPresenter()
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        presenter.viewController = self
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
        presenter.didReceiveNextQuestion(question: question)
        setButtonsIsEnabled(to: true)
        hideBorder()
    }
    
    // Метод сообщит о получении данных с сервера
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    // Метод сообщит о получении ошибки с сервера
    func didFailToLoadData(with error: Error) {
        showNetworkError(title: "Ошибка!", message: error.localizedDescription)
    }
    
    // Метод сообщит, что пользователь не увидел изображение
    func didFailToLoadImage() {
        showNetworkError(title: "Упс, постер не загрузился!", message: "В следующий раз точно загрузится!")
    }
    
    
    // MARK: - AlertPresenterDelegate
    
    // Метод, который вызовет AlertPresenter, чтобы сообщить, что Алерта показана
    // и юзер нажал кнопку "Сыграть еще раз"
    func restartGame() {
        presenter.resetQuestionIndex()
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
        activityIndicator.hidesWhenStopped = true
    }
    
    // Метод инициализации фабрики вопросов, установки делегата и инициации загрузки данных из сети
    private func setupQuestionFactory() {
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader())
        guard let questionFactory else { return }
        questionFactory.didSetDelegate(self)
        questionFactory.loadData()
        guard let currentQuestion = presenter.currentQuestion else {return}
        show(quiz: presenter.convert(model: currentQuestion))
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
    
    // Метод отображения информации на экране
    func show(quiz step: QuizStepViewModel) {
        indexLabel.text = "\(step.questionNumber)"
        previewImageView.image = UIImage(data: step.imageData) ?? UIImage()
        questionLabel.text = step.question
    }
    
    // Метод показывает обводку. Вызывается в методе showAnswerResult()
    func showBorder(_ color: CGColor) {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.borderWidth = 8
        previewImageView.layer.borderColor = color
    }
    
    // Метод скрывает обводку. Вызывается в методе showNextQuestionOrResults()
    func hideBorder() {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.borderWidth = 0
        previewImageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    // Метод отображения корректности ответа
    func showAnswerResult(isCorrect: Bool) {
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
    func setButtonsIsEnabled(to newStatus: Bool) {
        noButton.isEnabled = newStatus
        yesButton.isEnabled = newStatus
    }
    
    // Метод либо ведет на экран результатов либо на следующий вопрос
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestions() {
            calledWhenNeedShowResults()
        } else {
            calledWhenNeedShowNextQuestion()
        }
    }
    
    // Метод вызывается, когда нужно показать следующий вопрос
    private func calledWhenNeedShowNextQuestion() {
        presenter.switchToNextQuestion()
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
        statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
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
            Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
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
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
        }
    }
    
    // Метод формирования сообщения об ошибке получения данных по сети
    private func showNetworkError(title: String, message: String) {
        hideLoadingIndicator()
        
        networkError = AlertModel (
            title: title,
            message: message,
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
                guard let self else { return }
                self.questionFactory?.loadData()
                self.showLoadingIndicator()
            }
        )
        
        guard let alertPresenter else { return }
        alertPresenter.show(viewController: self, with: networkError)
    }
    
}


