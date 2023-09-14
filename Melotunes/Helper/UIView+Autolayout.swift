import UIKit

public extension UIView {
  
  convenience init(autolayout: Void) {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func activate(_ constraints: NSLayoutConstraint...) {
    NSLayoutConstraint.activate(constraints)
  }
  
  func pin(top: NSLayoutYAxisAnchor? = nil,
           _ topPadding: CGFloat = 0,
           bottom: NSLayoutYAxisAnchor? = nil,
           _ bottomPadding: CGFloat = 0,
           leading: NSLayoutXAxisAnchor? = nil,
           _ leadingPadding: CGFloat = 0,
           trailing: NSLayoutXAxisAnchor? = nil,
           _ trailingPadding: CGFloat = 0) {
    var constraints: [NSLayoutConstraint] = []
    top.flatMap { constraints.append(topAnchor.constraint(equalTo: $0, constant: topPadding)) }
    bottom.flatMap { constraints.append(bottomAnchor.constraint(equalTo: $0, constant: -bottomPadding)) }
    leading.flatMap { constraints.append(leadingAnchor.constraint(equalTo: $0, constant: leadingPadding)) }
    trailing.flatMap { constraints.append(trailingAnchor.constraint(equalTo: $0, constant: -trailingPadding)) }
    NSLayoutConstraint.activate(constraints)
  }
  
  func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
    activate(
      topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
      bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
      leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
      trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right)
    )
  }
  
  func pin(to layoutGuide: UILayoutGuide, insets: UIEdgeInsets = .zero) {
    activate(
      topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top),
      bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: insets.bottom),
      leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: insets.left),
      trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: insets.right)
    )
  }
  
  func wrapped(top: NSLayoutYAxisAnchor? = nil,
               bottom: NSLayoutYAxisAnchor? = nil,
               leading: NSLayoutXAxisAnchor? = nil,
               trailing: NSLayoutXAxisAnchor? = nil,
               insets: UIEdgeInsets = .zero) -> UIView {
    let container = UIView(autolayout: ())
    container.addSubview(self)
    pin(to: container, insets: insets)
    return container
  }
  
  static var placeholder: UIView {
    UIView(autolayout: ())
  }
  
  static func placeHolder(width: CGFloat? = nil, height: CGFloat? = nil) -> UIView {
    let placeholder = self.placeholder
    if let width = width {
      placeholder.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    if let height = height {
      placeholder.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    return placeholder
  }
}
