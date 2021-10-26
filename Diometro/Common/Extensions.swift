//
//  Extensions.swift
//  Diometro
//
//  Created by Vitor Krau on 25/10/21.
//

import Foundation
import SwiftUI

struct FadeModifier: AnimatableModifier {
    // To trigger the animation as well as to hold its final state
    private let control: Bool

    // SwiftUI gradually varies it from old value to the new value
    var animatableData: Double = 0.0

    // Re-created every time the control argument changes
    init(control: Bool) {
        // Set control to the new value
        self.control = control

        // Set animatableData to the new value. But SwiftUI again directly
        // and gradually varies it from 0 to 1 or 1 to 0, while the body
        // is being called to animate. Following line serves the purpose of
        // associating the extenal control argument with the animatableData.
        self.animatableData = control ? 1.0 : 0.0
    }

    // Called after each gradual change in animatableData to allow the
    // modifier to animate
    func body(content: Content) -> some View {
        // content is the view on which .modifier is applied
        content
            // Map each "0 to 1" and "1 to 0" change to a "0 to 1" change
            .opacity(control ? animatableData : 1.0 - animatableData)

            // This modifier is animating the opacity by gradually setting
            // incremental values. We don't want the system also to
            // implicitly animate it each time we set it. It will also cancel
            // out other implicit animations now present on the content.
            .animation(nil)
    }
}
