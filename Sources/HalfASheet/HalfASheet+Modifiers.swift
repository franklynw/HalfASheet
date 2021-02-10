//
//  File.swift
//  
//
//  Created by Franklyn Weber on 04/02/2021.
//

import SwiftUI


extension HalfASheet {
    
    /// The proportion of the containing view's height to use for the height of the HalfASheet
    /// - Parameter height: a HalfASheetHeight case - either .fixed(required height in pixels) or .proportional(proportion of the containing view's height - 1 is 100% of the height)
    public func height(_ height: HalfASheetHeight) -> Self {
        var copy = self
        copy.height = height
        return copy
    }
    
    /// Insets to use around the content of the HalfASheet
    /// - Parameter contentInsets: an EdgeInsets instance
    public func contentInsets(_ contentInsets: EdgeInsets) -> Self {
        var copy = self
        copy.contentInsets = contentInsets
        return copy
    }
    
    /// The background colour for the HalfASheet
    /// - Parameter backgroundColor: a UIColor
    public func backgroundColor(_ backgroundColor: UIColor) -> Self {
        var copy = self
        copy.backgroundColor = backgroundColor
        return copy
    }
    
    /// The color for the close button
    /// - Parameter closeButtonColor: a UIColor
    public func closeButtonColor(_ closeButtonColor: UIColor) -> Self {
        var copy = self
        copy.closeButtonColor = closeButtonColor
        return copy
    }
    
    /// Use this to disable the drag-downwards-to-dismiss functionality
    public var disableDragToDismiss: Self {
        var copy = self
        copy.allowsDraggingToDismiss = false
        return copy
    }
}


extension View {
    
    /// View extension in the style of .sheet - offers no real customisation. If more flexibility is required, use HalfASheet(...) directly, and apply the required modifiers
    /// - Parameters:
    ///   - isPresented: binding to a Bool which controls whether or not to show the partial sheet
    ///   - title: an optional title for the sheet
    ///   - content: the sheet's content
    public func halfASheet<T: View>(isPresented: Binding<Bool>, title: String? = nil, @ViewBuilder content: @escaping () -> T) -> some View {
        modifier(HalfASheetPresentationModifier(content: { HalfASheet(isPresented: isPresented, title: title, content: content) }))
    }
}


struct HalfASheetPresentationModifier<SheetContent>: ViewModifier where SheetContent: View {
    
    var content: () -> HalfASheet<SheetContent>
    
    init(@ViewBuilder content: @escaping () -> HalfASheet<SheetContent>) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            self.content()
        }
    }
}
