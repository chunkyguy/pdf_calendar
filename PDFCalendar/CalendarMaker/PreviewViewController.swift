import UIKit
import PDFKit

class PreviewViewController: UIViewController {
  private var isSetUp = false
  
  let calendar: Calendar
  
  init(calendar: Calendar) {
    self.calendar = calendar
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !isSetUp {
      isSetUp = true
      setUp()
    }
  }

  private func setUp() {
    let pdfVw = PDFView(frame: view.bounds)
    view.addSubview(pdfVw)
    pdfVw.autoScales = true
    // Assign PDFDocument ot PDFView.
    pdfVw.document = calendar.doc
  }
}
