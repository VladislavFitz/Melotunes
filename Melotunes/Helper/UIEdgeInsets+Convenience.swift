import UIKit

public extension UIEdgeInsets {
  
  static func vertical(_ inset: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: inset,
                 left: 0,
                 bottom: inset,
                 right: 0)
  }
  
  static func horizontal(_ inset: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: 0,
                 left: inset,
                 bottom: 0,
                 right: inset)
  }
  
}
