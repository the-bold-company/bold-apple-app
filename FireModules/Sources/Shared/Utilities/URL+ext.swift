import Foundation

public extension URL {
    /// Return a URL that points to a local path
    static func local(backward steps: Int) -> URL {
        var path = #file.components(separatedBy: "/")
        path.removeLast(steps)
        let json = path.joined(separator: "/")
        return URL(fileURLWithPath: json)
    }
}
