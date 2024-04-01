import Foundation

public extension CustomStringConvertible {
    var description: String {
        let mirror = Mirror(reflecting: self)
        var description = ""

        if let type = Self.self as? AnyObject.Type {
            let className = NSStringFromClass(type)
            let unmanaged = Unmanaged.passUnretained(self as AnyObject)
            let pointer = unmanaged.toOpaque()
            description += "**** \(objectName(of: self)) <\(pointer)> ****\n"
        }
        for child in mirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }

        return description
    }
}

private func objectName(of object: Any) -> String {
    let objectType = type(of: object)
    return String(describing: objectType)
}
