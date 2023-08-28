//
//  HalfASheet.swift
//
//  Created by Franklyn Weber on 28/01/2021.
//

import SwiftUI
import Combine


@available(macOS 10.15, *)
public struct HalfASheet<Content: View>: View {
    
    @Binding private var isPresented: Bool
    @State private var hasAppeared = false
    @State private var dragOffset: CGFloat = 0
    
    internal var height: HalfASheetHeight = .proportional(0.84) // about the same as a ColorPicker
    internal var contentInsets = EdgeInsets(top: 7, leading: 16, bottom: 12, trailing: 16)
    //internal var backgroundColor: UIColor = .tertiarySystemGroupedBackground
    internal var closeButtonColor: Color = .gray
    internal var allowsDraggingToDismiss = true
    
    private let title: String?
    private let content: () -> Content
    private let cornerRadius: CGFloat = 24
    private let additionalOffset: CGFloat = 44 // this is so we can drag the sheet up a bit
    private var startColor: Color = Color.black
    private var endColor: Color = Color("878787")
    
    private var actualContentInsets: EdgeInsets {
        return EdgeInsets(top: contentInsets.top, leading: contentInsets.leading, bottom: cornerRadius + additionalOffset + contentInsets.bottom, trailing: contentInsets.trailing)
    }
    
    
    public init(isPresented: Binding<Bool>, title: String? = nil, startCol: Color, endCol: Color, @ViewBuilder content: @escaping () -> Content) {
        _isPresented = isPresented
        self.title = title
        self.content = content
        self.startColor = startCol
        self.endColor = endCol
    }
    
    
    @available(macOS 11.0, *)
    public var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                if isPresented {
                    
                    Color.black.opacity(0.15)
                        .onTapGesture {
                            dismiss()
                        }
                        .transition(.opacity)
                        .onAppear { // we don't want the content to slide up until the background has appeared
                            withAnimation {
                                hasAppeared = true
                            }
                        }
                        .onDisappear() {
                            withAnimation {
                                hasAppeared = false
                            }
                        }
                }
                
                if hasAppeared {
                    
                    VStack {
                        
                        Spacer()
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundColor(.white)
                            RoundedRectangle(cornerRadius: cornerRadius)
                                                            .fill(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .top, endPoint: .bottom))
                            
                            content()
                                .padding(actualContentInsets)
                            
                            //titleView
                        }
                        .frame(height: height.value(with: geometry) + cornerRadius + additionalOffset)
                        .offset(y: cornerRadius + additionalOffset + dragOffset)
                    }
                    .transition(.verticalSlide(height.value(with: geometry)))
                    .highPriorityGesture(
                        dragGesture(geometry)
                    )
                    .onDisappear {
                        dragOffset = 0
                    }
                }
            }

        }
    }
}


// MARK: - Private
@available(macOS 10.15, *)
extension HalfASheet {
    /*
    @available(macOS 11.0, *)
    private var titleView: IfLet {

        let titleView = IfLet(title) { title in

            VStack {

                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .font(Font.title.weight(.semibold))
                        .opacity(0)
                        .padding(EdgeInsets(top: 10, leading: 13, bottom: 0, trailing: 0))
                    Spacer()
                    Text(title)
                        .font(Font.headline.weight(.semibold))
                        .padding(EdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 0))
                        .lineLimit(1)
                    Spacer()
                    closeButton
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 13))
                }
   
                Spacer()
            }

            
        } else: {
            
            VStack {
                HStack {
                    Spacer()
                    //closeButton.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 13))
                }
                Spacer()
            }
        }
        
        return titleView
    }
     */
    
    private func dragGesture(_ geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        
        let gesture = DragGesture()
            .onChanged {
                
                guard allowsDraggingToDismiss else {
                    return
                }
                
                let offset = $0.translation.height
                dragOffset = offset > 0 ? offset : sqrt(-offset) * -3
            }
            .onEnded {
                
                guard allowsDraggingToDismiss else {
                    return
                }
                
                if dragOffset > 0, $0.predictedEndTranslation.height / $0.translation.height > 2 {
                    dismiss()
                    return
                }
                
                let validDragDistance = height.value(with: geometry) / 2
                if dragOffset < validDragDistance {
                    withAnimation {
                        dragOffset = 0
                    }
                } else {
                    dismiss()
                }
            }
        
        return gesture
    }
    
    @available(macOS 11.0, *)
    private var closeButton: AnyView {
        
        let button = Button {
            dismiss()
        } label: {
            ZStack {
                Image(systemName: "xmark.circle.fill")
                    .font(Font.title.weight(.semibold))
                    .accentColor(Color.gray)
                Image(systemName: "xmark.circle.fill")
                    .font(Font.title.weight(.semibold))
                    .accentColor(closeButtonColor)
            }
        }
        
        return AnyView(button)
    }
    
    private func dismiss() {
        
        withAnimation {
            hasAppeared = false
            isPresented = false
        }
    }
}


@available(macOS 10.15, *)
public enum HalfASheetHeight {
    case fixed(CGFloat)
    case proportional(CGFloat)
    
    func value(with geometry: GeometryProxy) -> CGFloat {
        switch self {
        case .fixed(let height):
            return height
        case .proportional(let proportion):
            return geometry.size.height * proportion
        }
    }
}
