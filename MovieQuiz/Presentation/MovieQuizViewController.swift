import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var previewImageView: UIImageView!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - IBActions
    
    // Метод вызывается когда юзер нажимает кнопку "Да"
    @IBAction private func didTapYesButton(_ sender: Any) {
        guard let currentQuestions = currentQuestion else {
            return
        }
        let givenAnswer: Bool = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestions.correctAnswer)
    }
    
    // Метод вызывается когда юзер нажимает кнопку "Нет"
    @IBAction private func didTapNoButton(_ sender: Any) {
        guard let currentQuestions = currentQuestion else {
            return
        }
        let givenAnswer: Bool = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestions.correctAnswer)
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
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupQuestionFactory()
        //setupAlertPresenter()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    // Метод, который вызовет Фабрика, чтобы показать готовый вопрос
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    
    // Метод, который вызовет AlertPresenter, чтобы сообщить, что Алерта показана
    // и юзер нажал кнопку "Сыграть еще раз"
    func didShowAlert() {
        self.currentQuestionIndex = 0
        self.correctAnswers = 0
        questionFactory?.requestNextQuestion()
        self.hideBorder()
    }
    
    // MARK: - Private Methods
    
    // Метод инициализации Label
    private func setupUI() {
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionTitleLabel.text = "Вопрос"
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        previewImageView.layer.cornerRadius = 20
    }
    
    // Метод инициализации фабрики вопросов и установки делегата
    private func setupQuestionFactory() {
        let questionFactory = QuestionFactory()
        questionFactory.didSetDelegate(self)
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
        if let firstQuestion = currentQuestion {
            show(quiz: convert(model: firstQuestion))
        }
    }
    
    
    // Метод конвертации из структуры вопроса во вью модель
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(named: model.imageName) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // Метод отображения информации на экране
    private func show(quiz step: QuizStepViewModel) {
        indexLabel.text = "\(step.questionNumber)"
        previewImageView.image = step.image
        questionLabel.text = step.question
        setButtonsIsEnabled(to: true)
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
        hideBorder()
    }
    
    // Метод вызывается, когда нужно показать Результат Квиза
    // Сначала создает модель AlertPresenter
    // и передать ее Делегатору.
    private func calledWhenNeedShowResults () {
        resultQuiz = AlertModel (
            title: "Этот раунд окончен!",
            message: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
            buttonText: "Сыграть еще раз",
            completion: { self.didShowAlert()
            }
        )
        let alertPresenter = AlertPresenter()
        alertPresenter.didSetDelegate(self)
        self.alertPresenter = alertPresenter

        alertPresenter.showAlert(viewControler: self, with: resultQuiz)
    }
}

//    Старый метод формирующий алерту с результатами квиза
//    private func show(quiz result: QuizResultsViewModel) {
//        let alert = UIAlertController(
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert
//        )
//        let action = UIAlertAction(
//            title: result.buttonText,
//            style: .default
//        ) { [weak self] _ in // это слабая ссылка на self
//            guard let self = self else { return } // разворачиваем self
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            questionFactory?.requestNextQuestion()
//            self.hideBorder()
//
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }

/*
 Задача Sprint_05
 -- В классе MovieQuizViewController есть метод show(quiz result: QuizResultsViewModel). Он отвечает за отображение алерта с результатами квиза после прохождения всех вопросов.
 -- Отображением другого экрана необязательно должен заниматься именно MovieQuizViewController. Вынесите эту логику в отдельный класс AlertPresenter.
 + Чтобы передавать данные для отображения, создайте структуру AlertModel в отдельном файле и сохраните его в папке Models.
 -- В структуре AlertModel должны быть:
 + текст заголовка алерта title,
 + текст сообщения алерта message,
 + текст для кнопки алерта buttonText,
 + замыкание без параметров для действия по кнопке алерта completion.
 + Файл AlertPresenter.swift положите в папку Presentation.
 Контроллер в методе окончания игры должен:
 создавать модель для AlertPresenter,
 передавать её в написанный метод этого класса для отображения алерта.
 По нажатию на кнопку алерта контроллер должен обновить состояние и запустить игру заново.
 
 т.е. Контролер формирует данные с результатами Квиза, передает их в AlertPresenter, а AlertPresenter с новой логикой ТОЛЬКО отображает их!
 
 Мне нужно:
 0 -- Инициализируем делегата для AlertPresenter тогда когда Квиз подошел к концу или в начале?
 0 -- В НАЧАЛЕ
 1 -- Контролер формирует данные для Алерты согласно AlertModel
 1 -- Контролер в showNextQuestionOrResults формирует данные в структуре QuizResultsViewModel и нужно их конвертировать в структуру данных AlertModel для Алерты и передает их в метод АлертПрезентора
 2 -- Контролер вызывает метод отображения Алерты у Делегатора
 3 -- Делегатор принимает данные у Контролера и отображает Алерту
 4 -- Юзер нажимает кнопку "Сыграть еще раз"
 5 -- Делегатор сообщает об этом Делегату-Контролеру
 6 -- Контролер показывает первый вопрос
 
 
 */

