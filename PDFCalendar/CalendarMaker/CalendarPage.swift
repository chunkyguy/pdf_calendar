import Foundation
import UIKit
import PDFKit
import CoreText

class CalendarPage: PDFPage {
  let image: UIImage
  let month: Int
  
  init(image: UIImage, month: Int) {
    self.image = image
    self.month = month
    super.init()
  }
  
  override var label: String? {
    let names = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    return names[month - 1]
  }
  
  override func bounds(for box: PDFDisplayBox) -> CGRect {
    // Always return 8.5 x 11 inches (in points of course).
    return CGRect(origin: .zero, size: CGSize(width: 612, height: 792))
  }
  
  override func draw(with box: PDFDisplayBox, to context: CGContext) {
    super.draw(with: box, to: context)

    // Drag image.
    // ...........
    // Source rectangle.
    let sourceRect = CGRect(origin: .zero, size: image.size)
    
    // Represent the top half of the page.
    var topHalf = bounds(for: box)
    topHalf.origin.y += topHalf.size.height / 2.0
    topHalf.size.height = (topHalf.size.height / 2.0) - 36.0

    // Scale and center image within top half of page.
    var destRect = fitRectInRect(srcRect: sourceRect, destRect: topHalf)

    // Draw.
    context.draw(image.cgImage!, in: destRect)

    // Draw month name.
    // ...........
    destRect = bounds(for: box)
    destRect.origin.y += destRect.size.height / 2.0
    destRect.size.height = 48.0
    destRect.origin.y -= 48.0
    destRect.size.width -= 36.0
    destRect.origin.x += 36.0

    // Draw label.
    context.textMatrix = .identity
    context.textPosition = CGPoint(x: destRect.minX, y: destRect.minY)
    let attrStr = NSAttributedString(string: label!, attributes: [.font: UIFont.systemFont(ofSize: 36, weight: .bold)])
    let line = CTLineCreateWithAttributedString(attrStr as CFAttributedString)
    CTLineDraw(line, context)

    // Draw calendar grid.
    // ...........
    destRect = bounds(for: box)
    destRect.size.height = (destRect.size.height / 2.0) - 48.0 - 36.0
    destRect.size.width -= (36.0 * 2.0)
    destRect.origin.x += 36.0
    destRect.origin.y += 36.0

    // Set grid color.
    UIColor.gray.set()
    

    // Frame.
    context.stroke(destRect)

    for col in 1..<7 {
      let line = CGRect(
        x: destRect.origin.x + (CGFloat(col) * destRect.size.width / 7.0),
        y: destRect.origin.y,
        width: 1.0, height: destRect.size.height
      )
      context.stroke(line)
    }
    
    for row in 1..<5 {
      let line = CGRect(
        x: destRect.origin.x,
        y: destRect.origin.y + (CGFloat(row) * destRect.size.height / 5.0),
        width: destRect.size.width,
        height: 1.0
      )
      context.stroke(line)
    }
  }
  
  private func fitRectInRect(srcRect: CGRect, destRect: CGRect) -> CGRect {
    // Assign.
    var fitRect = srcRect
    
    // Only scale down.
    if fitRect.size.width > destRect.size.width {
      // Try to scale for width first.
      var scaleFactor = destRect.size.width / fitRect.size.width
      fitRect.size.width *= scaleFactor
      fitRect.size.height *= scaleFactor

      // Did it pass the bounding test?
      if fitRect.size.height > destRect.size.height {
        // Failed above test -- try to scale the height instead.
        fitRect = srcRect
        scaleFactor = destRect.size.height / fitRect.size.height
        fitRect.size.width *= scaleFactor
        fitRect.size.height *= scaleFactor
      }
    } else if fitRect.size.height > destRect.size.height {
      // Scale based on height requirements.
      let scaleFactor = destRect.size.height / fitRect.size.height
      fitRect.size.height *= scaleFactor
      fitRect.size.width *= scaleFactor
    }

    // Center.
    fitRect.origin.x = destRect.origin.x + ((destRect.size.width - fitRect.size.width) / 2.0)
    fitRect.origin.y = destRect.origin.y + ((destRect.size.height - fitRect.size.height) / 2.0)

    // Assign back.
    return fitRect
  }
}
