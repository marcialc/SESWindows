import UIKit

/// View with CAGradientLayer layer class.
open class SJGradientView: UIView {
    
    /// The UIView's layer class. Overrided to return CAGradientLayer.
    override open class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
}


