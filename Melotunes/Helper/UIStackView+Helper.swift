import UIKit

public extension UIStackView {
  
  static func vertical(distribution: UIStackView.Distribution = .fill,
                       alignment: UIStackView.Alignment = .fill,
                       spacing: CGFloat = 0,
                       subviews: () -> [UIView]) -> UIStackView {
    let stackView = UIStackView(autolayout: ())
    stackView.distribution = distribution
    stackView.alignment = alignment
    stackView.axis = .vertical
    stackView.spacing = spacing
    for subview in subviews() {
      stackView.addArrangedSubview(subview)
    }
    return stackView
  }
  
  static func horizontal(distribution: UIStackView.Distribution = .fill,
                         alignment: UIStackView.Alignment = .fill,
                         spacing: CGFloat = 0,
                         subviews: () -> [UIView]) -> UIStackView {
    let stackView = UIStackView(autolayout: ())
    stackView.distribution = distribution
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
  
  static func vStack(distribution: UIStackView.Distribution = .fill,
                     alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0,
                     subviews: () -> [UIView]) -> UIStackView {
    UIStackView.vertical(distribution: distribution,
                         alignment: alignment,
                         spacing: spacing,
                         subviews: subviews)
  }
  
  static func hStack(distribution: UIStackView.Distribution = .fill,
                     alignment: UIStackView.Alignment = .fill,
                     spacing: CGFloat = 0,
                     subviews: () -> [UIView]) -> UIStackView {
    UIStackView.horizontal(distribution: distribution,
                           alignment: alignment,
                           spacing: spacing,
                           subviews: subviews)
  }
  
}
