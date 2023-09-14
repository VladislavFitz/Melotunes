import UIKit

public extension UIStackView {
  
  static func vertical(alignment: UIStackView.Alignment = .fill,
                       spacing: CGFloat = 0,
                       subviews: () -> [UIView]) -> UIStackView {
    let stackView = UIStackView(autolayout: ())
    stackView.alignment = alignment
    stackView.axis = .vertical
    stackView.spacing = spacing
    for subview in subviews() {
      stackView.addArrangedSubview(subview)
    }
    return stackView
  }
  
  static func horizontal(alignment: UIStackView.Alignment = .fill,
                         spacing: CGFloat = 0,
                         subviews: () -> [UIView]) -> UIStackView {
    let stackView = UIStackView(autolayout: ())
    stackView.alignment = alignment
    stackView.axis = .horizontal
    stackView.spacing = spacing
    for subview in subviews() {
      stackView.addArrangedSubview(subview)
    }
    return stackView
  }
  
}

public extension UIView {
  
  static func vStack(alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0,
                     subviews: () -> [UIView]) -> UIStackView {
    UIStackView.vertical(alignment: alignment,
                         spacing: spacing,
                         subviews: subviews)
  }
  
  static func hStack(alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0,
                     subviews: () -> [UIView]) -> UIStackView {
    UIStackView.horizontal(alignment: alignment,
                           spacing: spacing,
                           subviews: subviews)
  }
  
}
