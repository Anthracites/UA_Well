import Foundation
import UIKit


class ExerciseView: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var  _scrollView: UIScrollView!
      let contentView = UIView()
    @IBOutlet weak var _textView: UITextView!
      let buttonStackView = UIStackView()
      let button1 = UIButton(type: .system)
      let button2 = UIButton(type: .system)
      let button3 = UIButton(type: .system)

      override func viewDidLoad() {
          super.viewDidLoad()

          setupScrollView()
          setupTextView()
          setupButtons()
          setupLayout()
      }

      func setupScrollView() {
          _scrollView.translatesAutoresizingMaskIntoConstraints = false
          _scrollView.addSubview(contentView)
          contentView.translatesAutoresizingMaskIntoConstraints = false

          NSLayoutConstraint.activate([
            _scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            _scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

              contentView.topAnchor.constraint(equalTo: _scrollView.topAnchor),
              contentView.leadingAnchor.constraint(equalTo: _scrollView.leadingAnchor),
              contentView.trailingAnchor.constraint(equalTo: _scrollView.trailingAnchor),
              contentView.bottomAnchor.constraint(equalTo: _scrollView.bottomAnchor),
              contentView.widthAnchor.constraint(equalTo: _scrollView.widthAnchor)
          ])
      }

      func setupTextView() {
          _textView.text = """
          Здесь будет размещен текст переменной длины. Текст может быть очень длинным или коротким, в зависимости от содержания. Внизу текста будут размещены кнопки для взаимодействия.
          """
          _textView.font = UIFont.systemFont(ofSize: 16)
          _textView.isEditable = false
          contentView.addSubview(_textView)
      }

      func setupButtons() {
          button1.setTitle("Кнопка 1", for: .normal)
          button2.setTitle("Кнопка 2", for: .normal)
          button3.setTitle("Кнопка 3", for: .normal)
          
          buttonStackView.axis = .horizontal
          buttonStackView.distribution = .fillEqually
          buttonStackView.spacing = 10
          buttonStackView.addArrangedSubview(button1)
          buttonStackView.addArrangedSubview(button2)
          buttonStackView.addArrangedSubview(button3)
          
          contentView.addSubview(buttonStackView)
      }

      func setupLayout() {
          _textView.translatesAutoresizingMaskIntoConstraints = false
          buttonStackView.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
            _textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            _textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            _textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

              buttonStackView.topAnchor.constraint(equalTo: _textView.bottomAnchor, constant: 20),
              buttonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
              buttonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
              buttonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
              buttonStackView.heightAnchor.constraint(equalToConstant: 50)
          ])
      }

  
}
