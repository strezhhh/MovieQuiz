import UIKit

final class MovieQuizViewController: UIViewController {
    
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
        
    // Переменная хранит Презентер
    private let presenter = MovieQuizPresenter()
    
    // Переменная хранящая модель для Network error
    private var networkError: AlertModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        presenter.viewController = self
        super.viewDidLoad()
        setupUI()
        showLoadingIndicator()
        setButtonsIsEnabled(to: false)
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
    
    // MARK: - Methods
    
    // Метод отображения информации на экране
    func show(quiz step: QuizStepViewModel) {
        indexLabel.text = "\(step.questionNumber)"
        previewImageView.image = UIImage(data: step.imageData) ?? UIImage()
        questionLabel.text = step.question
    }
    
    // Метод показывает обводку
    func showBorder(answer: Bool) {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.borderWidth = 8
        previewImageView.layer.borderColor = answer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    // Метод скрывает обводку
    func hideBorder() {
        previewImageView.layer.masksToBounds = true
        previewImageView.layer.borderWidth = 0
        previewImageView.layer.borderColor = UIColor.ypBlack.cgColor
    }
    
    // Метод включает или выключает кнопки "Нет" и "Да"
    func setButtonsIsEnabled(to newStatus: Bool) {
        noButton.isEnabled = newStatus
        yesButton.isEnabled = newStatus
    }
    
    // Метод отображения индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    // Метод скрывает индикатор загрузки
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
        }
    }
    
    // Метод формирования сообщения об ошибке получения данных по сети
    func showNetworkError(title: String, message: String) {
        hideLoadingIndicator()
        
        networkError = AlertModel (
            title: title,
            message: message,
            buttonText: "Попробовать еще раз",
            completion: { [weak self] in
                guard let self else { return }
                presenter.questionFactory?.loadData()
                self.showLoadingIndicator()
            }
        )
        
        guard let alertPresenter = presenter.alertPresenter else { return }
        alertPresenter.showAlertWithResult(viewController: self, with: networkError)
    }
    
}
