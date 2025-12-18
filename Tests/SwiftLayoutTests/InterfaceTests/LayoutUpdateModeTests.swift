//
//  LayoutUpdateModeTests.swift
//

@testable import SwiftLayout
import Testing
import SwiftLayoutPlatform

@MainActor
struct LayoutUpdateModeTests {

    // MARK: - Deferred Update Tests

    @Test
    func deferredUpdateCoalescing() async throws {
        let view = UpdateCountView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)

        // Initial layout
        view.sl.updateLayout(.immediate)
        let initialCount = view.updateCount

        // Multiple deferred updates should coalesce into one
        view.value1 = 1
        view.value2 = 2
        view.value3 = 3

        // Updates haven't happened yet (deferred)
        #expect(view.updateCount == initialCount)

        // Wait for RunLoop
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second

        // Should have only one additional update
        #expect(view.updateCount == initialCount + 1)
    }

    @Test
    func deferredUpdateTiming() async throws {
        let view = UpdateCountView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)

        view.sl.updateLayout(.immediate)
        let initialCount = view.updateCount

        // Trigger deferred update
        view.sl.updateLayout(.deferred)

        // Should not update immediately
        #expect(view.updateCount == initialCount)

        // Wait for RunLoop
        try await Task.sleep(nanoseconds: 100_000_000)

        // Now it should be updated
        #expect(view.updateCount == initialCount + 1)
    }

    @Test
    func immediateUpdateTiming() async throws  {
        let view = UpdateCountView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)

        let initialCount = view.updateCount

        // Immediate update should happen synchronously
        view.sl.updateLayout(.immediate)

        #expect(view.updateCount == initialCount + 1)

        // Wait for RunLoop
        try await Task.sleep(nanoseconds: 100_000_000)

        // Now it should be updated
        #expect(view.updateCount == initialCount + 1)
    }

    @Test
    func firstDeferredCallAlsoDefers() async throws {
        let view = UpdateCountView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)

        // activation is nil at this point
        #expect(view.activation == nil)

        let initialCount = view.updateCount

        // First deferred call should also defer, not execute immediately
        view.sl.updateLayout(.deferred)

        // Should not update immediately even though activation was nil
        #expect(view.updateCount == initialCount)

        // Wait for RunLoop
        try await Task.sleep(nanoseconds: 100_000_000)

        // Now it should be updated
        #expect(view.updateCount == initialCount + 1)
        #expect(view.activation != nil)
    }

    // MARK: - LayoutProperty Mode Tests

    @Test
    func layoutPropertyDeferredMode() async throws {
        let view = DeferredPropertyView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)
        view.sl.updateLayout(.immediate)

        let initialCount = view.updateCount

        // Default mode is .deferred
        view.flag = false

        // Should not update immediately
        #expect(view.updateCount == initialCount)

        // Wait for RunLoop
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(view.updateCount == initialCount + 1)
    }

    @Test
    func layoutPropertyImmediateMode() {
        let view = ImmediatePropertyView()
        view.frame = .init(x: 0, y: 0, width: 100, height: 100)
        view.sl.updateLayout(.immediate)

        let initialCount = view.updateCount

        // Mode is .immediate
        view.flag = false

        // Should update immediately
        #expect(view.updateCount == initialCount + 1)
    }

    // MARK: - Test Views

    final class UpdateCountView: SLView, Layoutable {
        var activation: Activation?
        var updateCount: Int = 0

        let child = SLView()

        @LayoutProperty var value1: Int = 0
        @LayoutProperty var value2: Int = 0
        @LayoutProperty var value3: Int = 0

        var layout: some Layout {
            updateCount += 1
            return self.sl.sublayout {
                child
            }
        }
    }

    final class DeferredPropertyView: SLView, Layoutable {
        var activation: Activation?
        var updateCount: Int = 0

        let child = SLView()

        // Default mode is .deferred
        @LayoutProperty var flag: Bool = true

        var layout: some Layout {
            updateCount += 1
            return self.sl.sublayout {
                child
            }
        }
    }

    final class ImmediatePropertyView: SLView, Layoutable {
        var activation: Activation?
        var updateCount: Int = 0

        let child = SLView()

        @LayoutProperty(mode: .immediate) var flag: Bool = true

        var layout: some Layout {
            updateCount += 1
            return self.sl.sublayout {
                child
            }
        }
    }
}
