//
//  ReferenceTests.swift
//  
//
//  Created by oozoofrog on 2022/03/05.
//

import SwiftLayout
import Testing
import UIKit

@MainActor
final class ReferenceTests {

    var view: SelfReferenceView?
    weak var weakView: UIView?

    @Test
    func testReferenceReleasing() async throws {
        @MainActor
        func prepare() async {
            DeinitView.deinitCount = 0
            self.view = SelfReferenceView()
            self.weakView = view

            self.view?.sl.updateLayout()
            self.view = nil
        }

        @MainActor
        func checkReleaseReference() async {
            #expect(weakView == nil)
            #expect(DeinitView.deinitCount == 2)
        }

        await prepare()
        try await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        await checkReleaseReference()
    }

    class DeinitView: UIView {
        static var deinitCount: Int = 0

        deinit {
            Task { @MainActor in
                DeinitView.deinitCount += 1
            }
        }
    }

    class SelfReferenceView: UIView, Layoutable {
        var layout: some Layout {
            self.sl.sublayout {
                DeinitView().sl.anchors {
                    Anchors.allSides.equalToSuper()
                }.sublayout {
                    DeinitView()
                }
            }
        }

        var activation: Activation?
    }
}
