import UIKit

final class CounterView: UIView {

    let firstLine = UILabel()

    init() {
        super.init(frame: .zero)

        backgroundColor = UIColor(red:0.00, green:0.48, blue:0.33, alpha:1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CounterViewController: UIViewController {

    override func loadView() {
        view = CounterView()
    }

}
