import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
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
    
    // Общее количество вопросов для квиза
    private let questionsAmount: Int = 10
    
    // Фабрика вопросов в которую будет обращаться Контролер
    private var questionFactory: QuestionFactoryProtocol?
    
    // Вопрос который видит пользователь
    private var currentQuestion: QuizQuestion? = nil
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupQuestionFactory()
    }
    
    // MARK: - QuestionFactoryDelegate

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
            //currentQuestion = firstQuestion
            show(quiz: convert(model: firstQuestion))
        }
    }
    
    // Метод конвертации из структуры вопроса в во вью модель
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
            let quizResults = QuizResultsViewModel (
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть еще раз"
            )
            show(quiz: quizResults)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            guard let convertNextQuestion = currentQuestion else { return }
            let nextQuestion = convert(model: convertNextQuestion )
            // let nextQuestion = convert(model: currentQuestion[currentQuestionIndex])
            show(quiz: nextQuestion)
            hideBorder()
        }
    }
    
    // Метод формирует алерту с результатами квиза
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default
        ) { [weak self] _ in // это слабая ссылка на self
            guard let self = self else { return } // разворачиваем self
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
            guard let convertNextQuestion = currentQuestion else { return }
            let newQuestion = convert(model: convertNextQuestion )
            // let newQuestion = self.convert(model: self.questions[self.currentQuestionIndex])
            self.show(quiz: newQuestion)
            self.hideBorder()
            
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
