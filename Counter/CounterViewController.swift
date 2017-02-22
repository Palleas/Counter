import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

final class CounterView: UIView {

    let words = MutableProperty<Int>(0)

    private let content: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center

        return label
    }()

    private let motivation: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .cntMotivationFont()
        label.textColor = .cntJungleGreen
        label.backgroundColor = .white
        label.text = "You can do it!"

        return label
    }()

    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = .cntJungleGreen

        container.addArrangedSubview(content)
        container.addArrangedSubview(motivation)

        addSubview(container)
        NSLayoutConstraint.activate([
            container.leftAnchor.constraint(equalTo: leftAnchor),
            container.rightAnchor.constraint(equalTo: rightAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        content.reactive.attributedText <~ words.producer.map(format)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func format(wordCount: Int) -> NSAttributedString {
        let defaults: [String: Any] = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.cntTextStyleFont()!
        ]

        let formatted = NSMutableAttributedString(string: "You have written\n".uppercased(), attributes: defaults)
        formatted.append(NSAttributedString(string: "\(wordCount)", attributes: [
            NSForegroundColorAttributeName: UIColor.cntJungleGreen,
            NSFontAttributeName: UIFont.cntCountFont()!,
            NSBackgroundColorAttributeName: UIColor.white,
            NSKernAttributeName: 5
        ]))
        formatted.append(NSAttributedString(string: " words\n".uppercased(), attributes: [
            NSFontAttributeName: UIFont.cntCountFont()!,
            NSForegroundColorAttributeName: UIColor.white,
        ]))
        formatted.append(NSAttributedString(string: "this week".uppercased(), attributes: defaults))

        return formatted
    }
}

final class CounterViewController: UIViewController {

    private let viewModel = CounterViewModel()

    override func loadView() {
        let counterView = CounterView()
        counterView.words <~ viewModel.wordsCount

        view = counterView
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            fatalError("If you read this, a QA engineer ended up in a case that should not happen")
        }
    }

}

struct CounterViewModel {
    private let c = Counter()

    let wordsCount: SignalProducer<Int, NoError>

    init() {
        wordsCount = c.count().flatMapError { _ in SignalProducer<Int, NoError>.empty }
    }
}
