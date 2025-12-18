import SwiftLayout
import Testing
import SwiftLayoutPlatform

extension LayoutDSLTests {

    final class ActivationTests: LayoutDSLTestsBase {
        @Test
        func active() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                        label
                        blue.sl.sublayout {
                            image
                        }
                    }
                }
            }

            activation = layout.active()

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [button, label, blue])
            expectView(button, superview: red, subviews: [])
            expectView(label, superview: red, subviews: [])
            expectView(blue, superview: red, subviews: [image])
            expectView(image, superview: blue, subviews: [])
        }

        @Test
        func deactive() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                        label
                        blue.sl.sublayout {
                            image
                        }
                    }
                }
            }

            activation = layout.active()

            activation?.deactive()

            expectView(root, superview: window, subviews: [])
            expectView(red, superview: nil, subviews: [])
            expectView(button, superview: nil, subviews: [])
            expectView(label, superview: nil, subviews: [])
            expectView(blue, superview: nil, subviews: [])
            expectView(image, superview: nil, subviews: [])
        }

        @Test
        func finalActive() {
            @LayoutBuilder
            var layout: some Layout {
                root.sl.sublayout {
                    red.sl.sublayout {
                        button
                        label
                        blue.sl.sublayout {
                            image
                        }
                    }
                }
            }

            layout.finalActive()

            expectView(root, superview: window, subviews: [red])
            expectView(red, superview: root, subviews: [button, label, blue])
            expectView(button, superview: red, subviews: [])
            expectView(label, superview: red, subviews: [])
            expectView(blue, superview: red, subviews: [image])
            expectView(image, superview: blue, subviews: [])
        }

        @Test
        func updateLayout() {
            var flag = true
            let parentView = CallCountView()
            let childView_0 = CallCountView()
            let childView_1 = CallCountView()

            @LayoutBuilder
            var layout: some Layout {
                parentView.sl.sublayout {
                    if flag {
                        childView_0
                    } else {
                        childView_1
                    }
                }
            }

            // active
            activation = layout.active(mode: .forced)

            expectView(parentView, superview: nil, subviews: [childView_0])
            expectView(childView_0, superview: parentView, subviews: [])
            expectView(childView_1, superview: nil, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 1)
            #expect(parentView.addSubviewCallCount(childView_1) == 0)
            #expect(childView_0.removeFromSuperviewCallCount == 0)
            #expect(childView_1.removeFromSuperviewCallCount == 0)

            // update without change
            activation = layout.update(fromActivation: activation!, mode: .forced)

            expectView(parentView, superview: nil, subviews: [childView_0])
            expectView(childView_0, superview: parentView, subviews: [])
            expectView(childView_1, superview: nil, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 2)
            #expect(parentView.addSubviewCallCount(childView_1) == 0)
            #expect(childView_0.removeFromSuperviewCallCount == 0)
            #expect(childView_1.removeFromSuperviewCallCount == 0)

            // "update with change
            flag.toggle()
            activation = layout.update(fromActivation: activation!, mode: .forced)

            expectView(parentView, superview: nil, subviews: [childView_1])
            expectView(childView_0, superview: nil, subviews: [])
            expectView(childView_1, superview: parentView, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 2)
            #expect(parentView.addSubviewCallCount(childView_1) == 1)
            #expect(childView_0.removeFromSuperviewCallCount == 1)
            #expect(childView_1.removeFromSuperviewCallCount == 0)

            // deactive
            activation?.deactive()
            activation = nil

            expectView(parentView, superview: nil, subviews: [])
            expectView(childView_0, superview: nil, subviews: [])
            expectView(childView_1, superview: nil, subviews: [])
            #expect(parentView.addSubviewCallCount(childView_0) == 2)
            #expect(parentView.addSubviewCallCount(childView_1) == 1)
            #expect(childView_0.removeFromSuperviewCallCount == 1)
            #expect(childView_1.removeFromSuperviewCallCount == 1)
        }
    }
}
