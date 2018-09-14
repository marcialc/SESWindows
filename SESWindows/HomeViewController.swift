import UIKit
import MessageUI

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var skyScrollView: UIScrollView!
    @IBOutlet weak var segmentedControl: SJFluidSegmentedControl!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var segmentedControlBGView: UIView!
    var homeScrollView: UIScrollView!
    
    var userScrolled = false
    var segmentSelected = false
 
    var selectedCellIndexPath: IndexPath?
    let screenSize = UIScreen.main.bounds
    var viewAppearedCounter = 0
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var timerCounter: CGFloat = 0.0
    var firstLoopPassed = false
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        if #available(iOS 8.2, *) {
//            segmentedControl.textFont = UIFont.boldSystemFont(ofSize: 12.0)
        } else {
//            segmentedControl.textFont = UIFont.boldSystemFont(ofSize: 12.0)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Uncomment the following line to set the current segment programmatically.

    }
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if viewAppearedCounter == 0 {
            let slides:[ScreensView] = creatSlides()
            setUpSlideScrollView(slides)
//            segmentedControl.setCurrentSegmentIndex(0, animated: false)
            skyScrollView.setContentOffset(CGPoint(x: 0, y: UIApplication.shared.statusBarFrame.height), animated: false)
            viewAppearedCounter += 1
//            segmentedControl.textColor = UIColor.red
        }
    }
    
}

// MARK: - SJFluidSegmentedControl Data Source Methods

extension HomeViewController: SJFluidSegmentedControlDataSource, UIScrollViewDelegate {
    
    func prepareLayout() {
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        segmentedControl.layer.borderColor = UIColor.clear.cgColor
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.layer.borderWidth = 2.0
//        segmentedControl.layer.shadowColor = UIColorFromRGB(rgbValue: 0x31597F).cgColor
//        segmentedControl.layer.shadowOpacity = 0.3
//        segmentedControl.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//        segmentedControl.layer.shadowRadius = 5.0
//        segmentedControl.layer.masksToBounds = false
        
        segmentedControlBGView.backgroundColor = UIColor.clear
//        segmentedControlBGView.isOpaque = false
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = segmentedControlBGView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.clipsToBounds = true
        segmentedControlBGView.addSubview(blurEffectView)
        
        skyScrollView.delegate = self
        
        skyScrollView.showsHorizontalScrollIndicator = false
            
    }
    
    @objc func runTimedCode() {
        if timerCounter != 0.0 || (!firstLoopPassed) {
            homeScrollView.setContentOffset(CGPoint(x: screenWidth * timerCounter, y: 0), animated: true)
        } else {
            homeScrollView.setContentOffset(CGPoint(x: screenWidth * timerCounter, y: 0), animated: false)
            firstLoopPassed = false
        }
        timerCounter += 1.0
        if timerCounter == 4.0 {
            firstLoopPassed = true
            timerCounter = 0.0
        }
    }
    
    func creatSlides() -> [ScreensView] {
        
        
        let slide1:ScreensView = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)!.first as! ScreensView
        self.homeScrollView = slide1.homeScrollView
        homeScrollView.delegate = self
        homeScrollView.showsHorizontalScrollIndicator = false
        let slides:[HomeScreensView] = creatHomeSlides()
        setUpHomeSlideScrollView(slides)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
        
        let slide2:ScreensView = Bundle.main.loadNibNamed("ServicesView", owner: self, options: nil)!.first as! ScreensView
        slide2.inDetailButtom.layer.borderWidth = 2.0
        slide2.inDetailButtom.layer.borderColor = UIColorFromRGB(rgbValue: 0x313131).cgColor
        slide2.inDetailButtom.backgroundColor = UIColor.clear
        slide2.inDetailButtom.addTarget(self, action: #selector(HomeViewController.inDetailAction(_:)), for: .touchUpInside)
        
        let slide3:ScreensView = Bundle.main.loadNibNamed("DemoView", owner: self, options: nil)!.first as! ScreensView
        
        let slide4:ScreensView = Bundle.main.loadNibNamed("AboutView", owner: self, options: nil)!.first as! ScreensView
        
        
        let slide5:ScreensView = Bundle.main.loadNibNamed("ContactView", owner: self, options: nil)!.first as! ScreensView
        slide5.submitButton.layer.borderWidth = 2.0
        slide5.submitButton.layer.borderColor = UIColorFromRGB(rgbValue: 0x313131).cgColor
        slide5.submitButton.addTarget(self, action: #selector(HomeViewController.emailAction(_:)), for: .touchUpInside)
        slide5.emailButton.addTarget(self, action: #selector(HomeViewController.emailAction(_:)), for: .touchUpInside)
        slide5.phone1Button.addTarget(self, action: #selector(HomeViewController.phoneAction(_:)), for: .touchUpInside)
        slide5.phone2Button.addTarget(self, action: #selector(HomeViewController.phoneAction(_:)), for: .touchUpInside)
        
        return[slide1,slide2,slide3, slide4, slide5]
        
    }
    
    func creatHomeSlides() -> [HomeScreensView] {
        
        let slide1:HomeScreensView = Bundle.main.loadNibNamed("FirstHomeScreen", owner: self, options: nil)!.first as! HomeScreensView
        
        let slide2:HomeScreensView = Bundle.main.loadNibNamed("SecondHomeScreen", owner: self, options: nil)!.first as! HomeScreensView
        
        let slide3:HomeScreensView = Bundle.main.loadNibNamed("ThirdHomeScreen", owner: self, options: nil)!.first as! HomeScreensView
        
        let slide4:HomeScreensView = Bundle.main.loadNibNamed("FourthHomeScreen", owner: self, options: nil)!.first as! HomeScreensView
        
        
        return[slide1,slide2,slide3, slide4]
        
    }
    
    func setUpSlideScrollView(_ slides: [ScreensView]) {
        
        //        skyScrollView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 320)
        skyScrollView.contentSize = CGSize(width: screenWidth , height: self.view.frame.height  * CGFloat(slides.count))
        skyScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: 0, y: screenHeight * CGFloat(i), width: screenWidth, height: skyScrollView.frame.height)
            skyScrollView.addSubview(slides[i])
        }
        
    }
    
    func setUpHomeSlideScrollView(_ slides: [HomeScreensView]) {
        
        //        skyScrollView.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: self.view.frame.height - 320)
        homeScrollView.contentSize = CGSize(width: screenWidth * CGFloat(slides.count) , height: self.view.frame.height)
        homeScrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: screenWidth * CGFloat(i), y: 0, width: screenWidth, height: homeScrollView.frame.height)
            homeScrollView.addSubview(slides[i])
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == skyScrollView {
            if(!segmentSelected && scrollView == skyScrollView) {
                userScrolled = true
                let pageIndex = round(scrollView.contentOffset.y/(self.view.frame.height))
                segmentedControl.setCurrentSegmentIndex(Int(pageIndex), animated: false)
                userScrolled = false
            }
        }
    }
    
    
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 5
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          titleForSegmentAtIndex index: Int) -> String? {
        if index == 0 {
            return "HOME".uppercased()
        } else if index == 1 {
            return "SERVICES".uppercased()
        } else if index == 2 {
            return "PRODUCTS".uppercased()
        } else if index == 3 {
            return "ABOUT".uppercased()
        } else {
            return "CONTACT".uppercased()
        }
    }
    
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        switch index {
        case 0:
            return [UIColor.clear]
        case 1:
            return [UIColor.clear]
        case 2:
            return [UIColor.clear]
        case 3:
            return [UIColor.clear]
        case 4:
            return [UIColor.clear]
        default:
            break
        }
        return [.clear]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        switch bounce {
        case .left:
            return [UIColor.clear]
        case .right:
            return [UIColor.clear]
        }
    }
    
    @objc func inDetailAction(_: AnyObject) {

    }
    
}

// MARK: - SJFluidSegmentedControl Delegate Methods

extension HomeViewController: SJFluidSegmentedControlDelegate {
 
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didChangeFromSegmentAtIndex fromIndex: Int, toSegmentAtIndex toIndex: Int) {
        if(!userScrolled) {
            let offset = view.frame.height * CGFloat(toIndex)
            segmentSelected = true
            skyScrollView.setContentOffset(CGPoint(x: skyScrollView.contentOffset.x, y: offset), animated: false)
            segmentSelected = false
        }
    }
    
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, didScrollWithXOffset offset: CGFloat) {
        _ = segmentedControl.frame.width / CGFloat(segmentedControl.segmentsCount * (segmentedControl.segmentsCount - 1))
        var width = view.frame.width * 0.2
        //        var leftDistance = (backgroundScrollView.contentSize.width - width) * 0.2
        //        var rightDistance = (backgroundScrollView.contentSize.width - width) * 0.8
        //        let backgroundScrollViewOffset = leftDistance + ((offset / maxOffset) * (backgroundScrollView.contentSize.width - rightDistance - leftDistance))
        width = view.frame.width
        //        leftDistance = -width * 0.0001 + 10
        //        rightDistance = width * 0.8
        //        let skyScrollViewOffset = leftDistance + ((offset / maxOffset) * (skyScrollView.contentSize.width - rightDistance - leftDistance))
        //        skyScrollView.contentOffset = CGPoint(x: skyScrollViewOffset, y: 0)
        //        backgroundScrollView.contentOffset = CGPoint(x: backgroundScrollViewOffset, y: 0)
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func UIColorFromRGB(rgbValue: UInt, alpha: CGFloat) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, resposne, error) in completion(data, resposne, error)
            }.resume()
        
    }
    
    func downloadImage(url: URL, image: UIImageView) {
        print("Download Started")
        getDataFromUrl(url: url) {
            (data, response, error) in guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in image.image = UIImage(data: data)
            }
        }
    }
    
}

extension HomeViewController: MFMailComposeViewControllerDelegate {
    
    @objc func emailAction(_: AnyObject) {
    
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        
    }
    
    @objc func phoneAction(_ sender: Any) {
        
        switch (sender as! UIButton).tag {
        case 0:
            UIApplication.shared.open(URL(string: "tel://7866032313")!, options: [:], completionHandler: nil)
            break
        case 1:
            UIApplication.shared.open(URL(string: "tel://7865532225")!, options: [:], completionHandler: nil)
            break
        default:
            break
        }
        
    }
    
   
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["info@solidenvelopessystems.com"])
        mailComposerVC.setSubject("SES Inquiry:")
//        mailComposerVC.setMessageBody("How are you doing?", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}

