import Foundation

final class AnyLayoutBuilding<L: Layout>: LayoutBuilding {
    internal init(_ layout: L) {
        self.layout = layout
    }
    
    var deactivable: Deactivable?
    var layout: L
}
