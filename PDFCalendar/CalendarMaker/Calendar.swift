import Foundation
import UIKit
import PDFKit

class Calendar: NSObject, PDFDocumentDelegate {
  
  // Start with an empty PDFDocument.
  let doc = PDFDocument()
  
  init(images: [UIImage]) {
    super.init()
    for idx in 0..<12 {
      let page = CalendarPage(image: images[idx], month: idx + 1)
      doc.insert(page, at: idx)
    }
    doc.delegate = self
  }
  
  func classForPage() -> AnyClass {
    return CalendarPage.self
  }
}
