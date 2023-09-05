import UIKit
import PandasGradingSDK

class SDKViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedString = NSMutableAttributedString()
        let firstPart = NSAttributedString(string: "Hello, ", attributes: [.backgroundColor: UIColor.blue,
                                                                           .foregroundColor: UIColor.black])
        attributedString.append(firstPart)
        let secondPart = NSAttributedString(string: "World", attributes: [.foregroundColor: UIColor.white])
        attributedString.append(secondPart)
    }
    override func viewDidAppear(_ animated: Bool) {
        PandasGrading.shared.startGrading(navigationController: gradingNavigationController)
        gradingNavigationController.modalPresentationStyle = .overFullScreen
        present(gradingNavigationController, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var gradingNavigationController = GradingNavigationViewController()
    
    @IBAction func didTouchStartGradingButton(_ sender: Any) {
        PandasGrading.shared.startGrading(navigationController: gradingNavigationController)
        gradingNavigationController.modalPresentationStyle = .overFullScreen
        present(gradingNavigationController, animated: true)
    }
    
}

