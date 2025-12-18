import SwiftLayout
import Testing
import SwiftLayoutPlatform

@MainActor
enum LayoutDSLTests {

    @MainActor
    class LayoutDSLTestsBase {
        let window = SLView(frame: .init(x: 0, y: 0, width: 150, height: 150)).withIdentifier("window")

        let root = SLView().withIdentifier("root")
        let child = SLView().withIdentifier("child")
        let button = SLView().withIdentifier("button")
        let label = SLView().withIdentifier("label")
        let red = SLView().withIdentifier("red")
        let blue = SLView().withIdentifier("blue")
        let green = SLView().withIdentifier("green")
        let image = SLView().withIdentifier("image")

        var activation: Activation?

        init() {
            root.translatesAutoresizingMaskIntoConstraints = false
            window.addSubview(root)
        }
    }
}
