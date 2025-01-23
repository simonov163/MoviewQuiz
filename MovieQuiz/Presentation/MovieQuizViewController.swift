import UIKit

struct QuizQuestion {
  let image: String
  let text: String
  let correctAnswer: Bool
}

struct QuizStepViewModel {
  let image: UIImage
  let question: String
  let questionNumber: String
}

struct QuizResultsViewModel {
  let title: String
  let text: String
  let buttonText: String
}

final class MovieQuizViewController: UIViewController {
   
    @IBOutlet private weak var questionTitleLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var indexLabel: UILabel!
    @IBOutlet private weak var filmImage: UIImageView!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    private var result: Int = 0
    private var currentIndex: Int = 0
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.myBackground
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let firstQuestion = convert(model: questions[currentIndex])
        show(quiz: firstQuestion)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.myBackground
        
        questionTitleLabel.text = "Вопрос:"
        questionTitleLabel.textColor = .myWhite
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        indexLabel.textColor = .myWhite
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        filmImage.layer.cornerRadius = 15
        filmImage.contentMode = .scaleAspectFill
        filmImage.clipsToBounds = true
        
        questionLabel.textColor = .myWhite
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 2
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        setupButton(for: noButton, title: "Нет")
        setupButton(for: yesButton, title: "Да")
    }
    
    private func setupButton(for button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.tintColor = .myBlack
        button.backgroundColor = .myWhite
        button.layer.cornerRadius = 15
    }
    
    private func showResult(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentIndex = 0
            self.result = 0
            
            let firstQuestion = self.questions[self.currentIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentIndex + 1)/\(questions.count)")
            return viewModel
    }
     
    private func show(quiz step: QuizStepViewModel) {
        filmImage.image = step.image
        filmImage.layer.borderWidth = 0
        questionLabel.text = step.question
        indexLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            result += 1
            }
        
        filmImage.layer.masksToBounds = true
        filmImage.layer.borderWidth = 8
        filmImage.layer.borderColor = isCorrect ? UIColor.myGreen.cgColor : UIColor.myRed.cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNextQuestionOrResults()
            }
    }
    
    private func showNextQuestionOrResults() {
        if currentIndex == questions.count - 1 {
            let text = "Ваш результат: \(result)/10"
                    let viewModel = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
                    showResult(quiz: viewModel)
      } else {
          currentIndex += 1
          let nextQuestion = questions[currentIndex]
          let viewModel = convert(model: nextQuestion)
          show(quiz: viewModel)
      }
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    @IBAction private func noButtonDidTap(_ sender: Any) {
        let currentQuestion = questions[currentIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonDidTap(_ sender: Any) {
        let currentQuestion = questions[currentIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
*/
