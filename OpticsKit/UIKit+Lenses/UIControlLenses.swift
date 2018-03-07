import UIKit

public typealias TargetSelectorControlEvent = (Any, Selector, UIControlEvents)

public protocol UIControlProtocol: UIViewProtocol {
  func actions(forTarget target: Any?, forControlEvent controlEvent: UIControlEvents) -> [String]?
  func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents)
  var allControlEvents: UIControlEvents { get }
  var allTargets: Set<AnyHashable> { get }
  var contentHorizontalAlignment: UIControlContentHorizontalAlignment { get set }
  var contentVerticalAlignment: UIControlContentVerticalAlignment { get set }
  var isEnabled: Bool { get set }
  var isHighlighted: Bool { get set }
  func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControlEvents)
  var isSelected: Bool { get set }
}

extension UIControl: UIControlProtocol {}

public extension LensHolder where Object: UIControlProtocol {
    
  public var contentHorizontalAlignment: Lens<Object, UIControlContentHorizontalAlignment> {
    return Lens(
      view: { $0.contentHorizontalAlignment },
      set: { $1.contentHorizontalAlignment = $0; return $1 }
    )
  }

  public var contentVerticalAlignment: Lens<Object, UIControlContentVerticalAlignment> {
    return Lens(
      view: { $0.contentVerticalAlignment },
      set: { $1.contentVerticalAlignment = $0; return $1 }
    )
  }

  public var isEnabled: Lens<Object, Bool> {
    return Lens(
      view: { $0.isEnabled },
      set: { $1.isEnabled = $0; return $1 }
    )
  }

  public var isHighlighted: Lens<Object, Bool> {
    return Lens(
      view: { $0.isHighlighted },
      set: { $1.isHighlighted = $0; return $1 }
    )
  }

  public var isSelected: Lens<Object, Bool> {
    return Lens(
      view: { $0.isSelected },
      set: { $1.isSelected = $0; return $1 }
    )
  }
}

