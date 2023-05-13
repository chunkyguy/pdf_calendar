import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private var isSetUp = false
  private var images: [UIImage] = []
  private var buttons: [UIButton] = []
  private var selectedBtn: UIButton?
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if !isSetUp {
      isSetUp = true
      setUp()
    }
  }
  
  private func setUp() {
    title = "PDF Calendar"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Generate", style: .done, target: self, action: #selector(onGenerate))
    
    view.backgroundColor = .white
    
    images = Array(repeating: UIImage(systemName: "photo")!, count: 12)

    let padding: CGFloat = 8
    let btnSize: CGFloat = 100
    let topLeft = CGPoint(
      x: (view.bounds.width - (3 * (btnSize + padding))) * 0.5,
      y: (view.bounds.height - (4 * (btnSize + padding))) * 0.5
    )
    for row in 0..<4 {
      for col in 0..<3 {
        let x = topLeft.x + (CGFloat(col) * (btnSize + padding))
        let y = topLeft.y + (CGFloat(row) * (btnSize + padding))
        let btnFrame = CGRect(x: x, y: y, width: btnSize, height: btnSize)
        let btn = UIButton(frame: btnFrame)
        let btnIdx = (row * 3) + col
        btn.backgroundColor = .darkGray
        btn.tintColor = .white
        btn.tag = btnIdx
        btn.setImage(images[btnIdx], for: .normal)
        btn.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        view.addSubview(btn)
        buttons.append(btn)
      }
    }
    
    let label = UILabel(frame: CGRect(
      x: topLeft.x, y: topLeft.y + (btnSize * 5),
      width: view.bounds.width - topLeft.x, height: 40
    ))
    label.textAlignment = .center
    label.text = "Tap cell to change image"
    view.addSubview(label)
  }
  
  @objc func onTap(_ sender: UIButton) {
    selectedBtn = sender
    let imagePickerVwCtrl = UIImagePickerController()
    imagePickerVwCtrl.allowsEditing = true
    imagePickerVwCtrl.delegate = self
    present(imagePickerVwCtrl, animated: true)
  }
  
  @objc func onGenerate() {
    let cal = Calendar(images: images)
    let previewVwCtrl = PreviewViewController(calendar: cal)
    present(previewVwCtrl, animated: true)
  }
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    if
      let button = selectedBtn,
      let image = info[.editedImage] as? UIImage {
      images[button.tag] = image
      selectedBtn?.setImage(image, for: .normal)
    }
    dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
}
