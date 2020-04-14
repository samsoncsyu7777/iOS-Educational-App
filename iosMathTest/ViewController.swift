import UIKit
import Foundation
import AVFoundation //for audio player
import SwiftKeychainWrapper

class ViewController: UIViewController {
    //set storage in user's device for the date of first use
    struct defaultsKeys {
        static let keyMonth = "0"
        static let keyYear = "0"
        static let keyID = "0"
    }
    
    //initialize variables
    let pagePassword = 2 // the page of inputing password
    let totalQuest = 22 //number of questions
    var questCount = 0 //count the question
    var questSubcount = 0 //count the times of doing similar questions
    var falseInSubQuest = 0 //times of false in a question
    var answered = 0 //answered a MC already? Yes-1, No-0
    var labelTag = 0 //to recognize which label is pressed
    var viewTag = 0 //to recognize which view is pressed
    var ThisIsCorrect = 0 //to record the question is correctly answered
    var oldScore: [Int] = [0, 0, 0] //start of the animation of score increase
    var newScore: [Int] = [0, 0, 0] //end of the animation of score increase
    var currentScore = 0 //current score of the animation of score increase
    var digit = 0 //which digit animating
    var wooden0Digit = 0 //number of digits of whole number
    var wooden0LastValue: Double = 1.0 //the value of last digit of whole number
    var wooden0DecNum = -1 //number of decimals of whole number

    //initialize iosMath labels but have not detected device width and height
    //5 question labels, 4 MC buttons, 5 response labels, 1 ok button, 1 start again button
    var label14: UILabel = UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))
    var label15: UILabel = UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))
    var label16: UILabel = UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))
    var label17: UILabel = UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))

    //text label for animation of score increase
    var score: [UILabel] = [UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))]
    //text label to display the input number for fill in the blank
    var woodenNumber: [UILabel] = [UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))]
    //initialize the values of answer fraction
    var woodenValue = [0.0, 0.0, 0.0]
    //which wooden board the user is inputing[0, 1, 2], 3 means not choose yet
    var woodenChosen = 3
    //text labels on the color squares for 0-9 and "."
    var squareNumber: [UILabel] = [UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))]
    //5 textviews for hyperlink
    /*var facebook: [UITextView] = [UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1))]*/
    //3 views to display wooden board of the answer fraction
    var woodenview: [UIImageView] = [UIImageView(image: UIImage(named: "woodenBoard.png")),
                                     UIImageView(image: UIImage(named: "woodenBoard.png")),
                                     UIImageView(image: UIImage(named: "woodenBoard.png"))]
    //11 color squares for 0-9 and "." and 1 back button
    var numberview: [UIImageView] = [UIImageView(image: UIImage(named: "redSquare3.png")),
                                     UIImageView(image: UIImage(named: "yellowSquare3.png")),
                                     UIImageView(image: UIImage(named: "lightgreenSquare3.png")),
                                     UIImageView(image: UIImage(named: "greenSquare3.png")),
                                     UIImageView(image: UIImage(named: "blueSquare3.png")),
                                     UIImageView(image: UIImage(named: "purpleSquare3.png")),
                                     UIImageView(image: UIImage(named: "lightpurpleSquare3.png")),
                                     UIImageView(image: UIImage(named: "redSquare3.png")),
                                     UIImageView(image: UIImage(named: "yellowSquare3.png")),
                                     UIImageView(image: UIImage(named: "lightgreenSquare3.png")),
                                     UIImageView(image: UIImage(named: "greenSquare3.png")),
                                     UIImageView(image: UIImage(named: "backButton.png"))]
    //1 big question view, 4 MC answer views
    var imageview: [UIImageView] = [UIImageView(image: UIImage(named: "greenPattern.png")),
                                    UIImageView(image: UIImage(named: "orangeButton2.png")),
                                    UIImageView(image: UIImage(named: "orangeButton2.png")),
                                    UIImageView(image: UIImage(named: "orangeButton2.png")),
                                    UIImageView(image: UIImage(named: "orangeButton2.png")),
                                    UIImageView(image: UIImage(named: "bigSquare4.png")),
                                    UIImageView(image: UIImage(named: "smallPurple.png")),
                                    UIImageView(image: UIImage(named: "smallGreen.png")), UIImageView(image: UIImage(named: "Coin2.png")), UIImageView(image: UIImage(named: "Coin2.png")), UIImageView(image: UIImage(named: "Coin2.png")), UIImageView(image: UIImage(named: "shiningstar.png")), UIImageView(image: UIImage(named: "shiningstar.png"))]
    var questionview = UIImageView(image: UIImage(named: "q0_0.png"))
    var responseview = UIImageView(image: UIImage(named: "r0_0_0.png"))
    var answerview: [UIImageView] = [UIImageView(image: UIImage(named: "a0_0_0.png")),
                                    UIImageView(image: UIImage(named: "a0_0_1.png")),
                                    UIImageView(image: UIImage(named: "a0_0_2.png")),
                                    UIImageView(image: UIImage(named: "a0_0_3.png"))]
    // image 0 for question, image 1 - 4 for answer - orange, image 5 for response, image 6 for ok, image 7 for backbutton
    var buttonFrame: [CGRect] = [CGRect(x: 0, y: 0, width: 0, height: 0),
                                 CGRect(x: 0, y: 0, width: 0, height: 0),
                                 CGRect(x: 0, y: 0, width: 0, height: 0),
                                 CGRect(x: 0, y: 0, width: 0, height: 0),
                                 CGRect(x: 0, y: 0, width: 0, height: 0)]
                                 
    var ansFormat = 1 //0 for MC, 1 for fill in the blank
    let date = Date() //variable in the form of date and time
    let calendar = Calendar.current //get current calendar
    //for checking the expired date
    var month = 0
    var year = 0
    var second = 0
    var ID = 0
    let defaults = UserDefaults.standard // for storage in device
    var savedMonth = 0
    var savedYear = 0
    var savedID = 0
    var password: Int = 0
    var passDigit: [Int] = [0,0,0,0,0,0]
    var audioFile = ""
    var DW: CGFloat = 0.0 //device width
    var DH: CGFloat = 0.0 //device height
    var goodlabel = UILabel() //for appreciation
    var trylabel = UILabel() //encourage user to try again after a false
    //set up audio player
    var responsePlayer: AVAudioPlayer? //play the response
    var clapPlayer: AVAudioPlayer? //when answer is correct
    var clickPlayer: AVAudioPlayer? // when button is pressed
    var dingPlayer: AVAudioPlayer? //after answer
    /// Maximum Count to which label will be Updated
    var maxCount : Int = 9
    /// Count which is currently displayed in Label
    var currentCount : Int = 0
    var updateTimer : Timer? //for animation of score increase
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //get device width and height
        var deviceWidth = UIScreen.main.bounds.size.width
        var deviceHeight = UIScreen.main.bounds.size.height
        if deviceWidth < deviceHeight {
            let a = deviceWidth
            deviceWidth = deviceHeight
            deviceHeight = a
        }
        DW = deviceWidth
        DH = deviceHeight
        self.view.backgroundColor = UIColor.black
        label14 = UILabel(frame: CGRect(x: DW / 20 * 13.15, y: DH / 20 * 16, width: DW / 20 * 3.0, height: DH / 20 * 3))
        label15 = UILabel(frame: CGRect(x: DW / 20 * 16.25, y: DH / 20 * 16, width: DW / 20 * 3.0, height: DH / 20 * 3))
        label16 = UILabel(frame: CGRect(x: DW / 20 * 16.5, y: DH / 20 * 18.7, width: DW / 20 * 3, height: DH / 20 * 1.5))
        label17 = UILabel(frame: CGRect(x: DW / 20 * 9.6, y: DH / 20 * 18.7, width: DW / 20 * 6, height: DH / 20 * 1.5))
        //set origin and size of 3 score labels
        score[0].frame = CGRect(x: DW / 20 * 9.08, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        score[1].frame = CGRect(x: DW / 20 * 10.41, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        score[2].frame = CGRect(x: DW / 20 * 11.74, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        //set origin and size of 5 labels of promotion
        /*facebook[0] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 1.75, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[1] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 4.25, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[2] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 6.75, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[3] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 9.25, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[4] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 11.75, width: DW / 20 * 8.5, height: DH / 20 * 2.5))*/
        //set origin and size and font of color squares and number labels
        for i in 0 ... 10 {
            squareNumber[i].frame = CGRect(x: DW / 24 * CGFloat(i), y: DH - DW / 24, width: DW / 24, height: DW / 24)
            squareNumber[i].text = String(i)
            squareNumber[i].font = UIFont.boldSystemFont(ofSize: DW / 34)
            squareNumber[i].textAlignment = .center
            numberview[i].frame = CGRect(x: DW / 24 * CGFloat(i), y: DH - DW / 24, width: DW / 24, height: DW / 24)
            view.addSubview(numberview[i])
            view.addSubview(squareNumber[i])
        }
        squareNumber[10].center.y = DH - DW / 24 * 0.75
        squareNumber[10].font = UIFont.boldSystemFont(ofSize: DW / 18)
        squareNumber[10].text = "."

        numberview[11].frame = CGRect(x: DW / 20 * 8.9, y: DH - DW / 24, width: DW / 24, height: DW / 24)
        numberview[11].center.y = DH / 20 * 15.3
        view.addSubview(numberview[11])
        //set origin and size and font of wooden board and the labels
        woodenview[0].frame = CGRect(x: DW / 20 * 4.6, y: DH / 20 * 14.5 , width: DW / 20 * 2.5, height: DH / 20 * 2)
        woodenNumber[0].frame = CGRect(x: DW / 20 * 4.6, y: DH / 20 * 14.5 , width: DW / 20 * 2.5, height: DH / 20 * 2)
        woodenview[1].frame = CGRect(x: DW / 20 * 7.2, y: DH / 20 * 13.5 , width: DW / 20 * 1.5, height: DH / 20 * 2)
        woodenNumber[1].frame = CGRect(x: DW / 20 * 7.2, y: DH / 20 * 13.5 , width: DW / 20 * 1.5, height: DH / 20 * 2)
        woodenview[2].frame = CGRect(x: DW / 20 * 7.2, y: DH / 20 * 15.6 , width: DW / 20 * 1.5, height: DH / 20 * 2)
        woodenNumber[2].frame = CGRect(x: DW / 20 * 7.2, y: DH / 20 * 15.6 , width: DW / 20 * 1.5, height: DH / 20 * 2)
        for i in 0 ... 2 {
            woodenNumber[i].text = ""
            woodenNumber[i].font = UIFont.boldSystemFont(ofSize: DW / 34)
            woodenNumber[i].textAlignment = .center
            view.addSubview(woodenview[i])
            view.addSubview(woodenNumber[i])
        }

        //set font of score labels
        for i in 0 ... 2{
        score[i].text = "0"
        score[i].font = UIFont.boldSystemFont(ofSize: DW / 34)
        score[i].center.y = DH / 20 * 17.5
        score[i].textAlignment = .center
        }
        //set origin and size of big image of question
        buttonFrame[0] = CGRect(x: DW / 20 / 8, y: DH / 20 * 0.35, width: DW / 20 * 9.2, height: DH / 20 * 12.5)
        //set origin and size of 4 MC answers. This 4 Frames will be reused later
        buttonFrame[1] = CGRect(x: DW / 20 * 0.25, y: DH / 20 * 13.25, width: DW / 20 * 4.25, height: DH / 20 * 3)
        buttonFrame[2] = CGRect(x: DW / 20 * 4.75, y: DH / 20 * 13.25, width: DW / 20 * 4.25, height: DH / 20 * 3)
        buttonFrame[3] = CGRect(x: DW / 20 * 0.25 , y: DH / 20 * 16.5, width: DW / 20 * 4.25, height: DH / 20 * 3)
        buttonFrame[4] = CGRect(x: DW / 20 * 4.75, y: DH / 20 * 16.5, width: DW / 20 * 4.25, height: DH / 20 * 3)
        imageview[0].frame = buttonFrame[0]
        questionview.frame = CGRect(x: DW / 20 * 0.25, y: DH / 20 * 6.6 - DW / 20 * 8.95 / 1.6 / 2, width: DW / 20 * 8.95, height: DW / 20 * 8.95 / 1.6)
        imageview[1].frame = buttonFrame[1]
        answerview[0].frame = buttonFrame[1]
        imageview[2].frame = buttonFrame[2]
        answerview[1].frame = buttonFrame[2]
        imageview[3].frame = buttonFrame[3]
        answerview[2].frame = buttonFrame[3]
        imageview[4].frame = buttonFrame[4]
        answerview[3].frame = buttonFrame[4]
        //set origin and size of 1 response image
        imageview[5].frame = CGRect(x: DW / 20 * 9.4, y: DH / 20 / 4, width: DW / 20 * 9.95, height: DH / 20 * 15.5)
        responseview.frame = CGRect(x: DW / 20 * 9.8, y: DH / 20 * 8 - DW / 20 * 9.15 / 1.5 / 2, width: DW / 20 * 9.15, height: DW / 20 * 9.15 / 1.5)
        //set origin and size of ok button and start again button
        imageview[6].frame = CGRect(x: DW / 20 * 13.15, y: DH / 20 * 16, width: DW / 20 * 3, height: DH / 20 * 3)
        imageview[7].frame = CGRect(x: DW / 20 * 16.25, y: DH / 20 * 16, width: DW / 20 * 3, height: DH / 20 * 3)
        //set origin and size of 3 coins for score
        imageview[8].frame = CGRect(x: DW / 20 * 9.08, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        imageview[9].frame = CGRect(x: DW / 20 * 10.41, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        imageview[10].frame = CGRect(x: DW / 20 * 11.74, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        imageview[8].center.y = DH / 20 * 17.5
        imageview[9].center.y = DH / 20 * 17.5
        imageview[10].center.y = DH / 20 * 17.5
        //set origin and size of flash light of question and response
        imageview[11].frame = CGRect(x: 0, y: 0, width: DW / 20, height: DH / 20)
        imageview[11].center = CGPoint(x: DW / 20 * 4.725, y: DH / 20 * 6.6)
        imageview[12].frame = CGRect(x: 0, y: 0, width: DW / 20, height: DH / 20)
        imageview[12].center = CGPoint(x: DW / 20 * 14.375, y: DH / 20 * 8)
        for i in 0 ... 10 {
            view.addSubview(imageview[i])
        }
        for i in 0 ... 2 {
            view.addSubview(score[i])
        }
        //for checking expired date
        month = calendar.component(.month, from: date)
        year = calendar.component(.year, from: date)
        second = calendar.component(.second, from: date)
        
        
        
        /* if defaults.integer(forKey: defaultsKeys.keyMonth) == 0 {
            defaults.set(month, forKey: defaultsKeys.keyMonth)
            defaults.set(year, forKey: defaultsKeys.keyYear)
            ID = 52 * 10000 + Int.random(in: 1019 ... 9998)
            defaults.set(ID, forKey: defaultsKeys.keyID)
        }
        else {
        }
        savedMonth = defaults.integer(forKey: defaultsKeys.keyMonth)
        savedYear = defaults.integer(forKey: defaultsKeys.keyYear)
        ID = defaults.integer(forKey: defaultsKeys.keyID) */
        
        
        
        ID = 52 * 10000 + Int.random(in: 1019 ... 9998)
        let keychain = KeychainWrapper(serviceName:"samson", accessGroup:"55G45KAS8T.com.samson.p5b")
        let IDString: String? = keychain.string(forKey: "ID")
        if IDString != nil {
            ID = Int(IDString!)!
        }
        else {
            let success: Bool = keychain.set(String(ID), forKey: "ID")
        }
        
        var IDTemp = ID
        var tens = 100000
        for i in 0 ... 5 {
            passDigit[i] = Int(IDTemp / tens)
            IDTemp -= passDigit[i] * tens
            tens = tens / 10
        }

        password = Int(pow(Double(passDigit[0]), 3) * 17 + pow(Double(passDigit[1]), 2) * 173 + pow(Double(passDigit[2]), 3) * 83 + pow(Double(passDigit[3]), 2) * 679 + Double(passDigit[4] * 2989) + pow(Double(passDigit[5]), 2) * 497)
        
        //set the interaction of labels
        let tapLabel5 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        imageview[1].isUserInteractionEnabled = true
        imageview[1].addGestureRecognizer(tapLabel5)
        imageview[1].tag = 5
        let tapLabel6 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        imageview[2].isUserInteractionEnabled = true
        imageview[2].addGestureRecognizer(tapLabel6)
        imageview[2].tag = 6
        let tapLabel7 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        imageview[3].isUserInteractionEnabled = true
        imageview[3].addGestureRecognizer(tapLabel7)
        imageview[3].tag = 7
        let tapLabel8 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        imageview[4].isUserInteractionEnabled = true
        imageview[4].addGestureRecognizer(tapLabel8)
        imageview[4].tag = 8
        let tapLabel14 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        label14.isUserInteractionEnabled = true
        label14.addGestureRecognizer(tapLabel14)
        label14.tag = 14
        let tapLabel15 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        label15.isUserInteractionEnabled = true
        label15.addGestureRecognizer(tapLabel15)
        label15.tag = 15
        
        //set the woodenview and numberview as buttons
        let tapview = [UITapGestureRecognizer(target: self, action: #selector(viewFunction)),
                       UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction))]
        for i in 0 ... 11 {
            numberview[i].isUserInteractionEnabled = true
            numberview[i].addGestureRecognizer(tapview[i])
            numberview[i].tag = i
        }
        for i in 0 ... 2 {
            woodenview[i].isUserInteractionEnabled = true
            woodenview[i].addGestureRecognizer(tapview[i + 12])
            woodenview[i].tag = i + 12
        }
        responseview.isUserInteractionEnabled = true
        responseview.addGestureRecognizer(tapview[15])
        responseview.tag = 15
        label14.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(label14)
        label15.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(label15)
        label16.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(label16)
        label17.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(label17)

        label14.textAlignment = .center
        label15.textAlignment = .center
        label16.textAlignment = .right
        label17.textAlignment = .left
        label14.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 34)
        label15.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 34)
        label16.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 40)
        label17.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 40)
        label16.textColor = UIColor.white
        label17.textColor = UIColor.white
        label14.text = "下一題"
        label15.text = "重新開始"
        label16.text = "ID:" + String(ID)
        label17.text = "請先按一下木板才按數字。"

        setText()
        
        goodlabel.frame = CGRect(x:DW / 3 * 1, y:DH / 3 * 1, width: DW / 3, height: DH / 3)
        goodlabel.center = CGPoint(x:DW / 2, y:DH / 2)
        goodlabel.textAlignment = .center
        let strokeTextAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor : UIColor.red,
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeWidth : -4.0,
            NSAttributedString.Key.font : UIFont(name: "FZZJ-ZHYBKTJW", size: DW / 40) ?? UIFont.boldSystemFont(ofSize: self.DW / 40)
            ] as [NSAttributedString.Key  : Any]
        let customizedText = NSMutableAttributedString(string: "Good!👍",
                                                       attributes: strokeTextAttributes)
        goodlabel.attributedText = customizedText
        goodlabel.textColor = UIColor.yellow
        goodlabel.layer.shadowColor = UIColor.black.cgColor
        goodlabel.layer.shadowRadius = 1.0
        goodlabel.layer.shadowOpacity = 1.0
        goodlabel.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        goodlabel.layer.masksToBounds = false
        
        trylabel.frame = CGRect(x:DW / 3 * 1, y:DH / 3 * 1, width: DW, height: DH / 8)
        trylabel.center = CGPoint(x:DW * 0.5, y:DH * -0.15)
        trylabel.textAlignment = .center
        let strokeTextAttributes2 : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor : UIColor.red,
            NSAttributedString.Key.foregroundColor : UIColor(red: 20/255, green: 160/255, blue: 20/255, alpha: 1.0),
            NSAttributedString.Key.strokeWidth : -3.0,
            NSAttributedString.Key.font : UIFont(name: "FZZJ-ZHYBKTJW", size: DW / 40) ?? UIFont.boldSystemFont(ofSize: self.DW / 40)
            ] as [NSAttributedString.Key  : Any]
        let customizedText2 = NSMutableAttributedString(string: "再算一算，你的努力助你走向成功！💪",
                                                       attributes: strokeTextAttributes2)
        trylabel.attributedText = customizedText2
        trylabel.textColor = UIColor.yellow
        trylabel.layer.shadowColor = UIColor.black.cgColor
        trylabel.layer.shadowRadius = 0.5
        trylabel.layer.shadowOpacity = 1.0
        trylabel.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        trylabel.layer.masksToBounds = false
        
        /*facebook[0].text = "恭喜你完成了以上題目,"
        facebook[1].text = "請到我們的Facebook獲取VIP"
        facebook[2].text = "密碼,再回來挑戰其他題目。"
        facebook[3].text = "我們期待再與你一同努力﹗"
        facebook[4].isEditable = false
        facebook[4].dataDetectorTypes = .link
        facebook[4].text = "https://www.facebook.com/primarymathspaper/posts/2278450288879217"
        for i in 0 ... 4 {
            facebook[i].textAlignment = .center
            facebook[i].backgroundColor = UIColor(white: 1, alpha: 0)
            facebook[i].font = UIFont.boldSystemFont(ofSize: self.DW / 34)
        }
        facebook[4].font = UIFont.boldSystemFont(ofSize: self.DW / 60)
        */
        
        do {
            if let clapSound = Bundle.main.path(forResource: "chimes", ofType:"mp3") {
                clapPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: clapSound))
            }
            else { print("")}
        }
        catch let error {
            print("")
        }

        do {
            if let clickSound = Bundle.main.path(forResource: "click", ofType:"mp3") {
                clickPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: clickSound))
            }
            else { print("")}
        }
        catch let error {
            print("")
        }

        do {
            if let dingSound = Bundle.main.path(forResource: "ding", ofType:"mp3") {
                dingPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: dingSound))
            }
            else { print("")}
        }
        catch let error {
            print("")
        }

    }
    
    //actions for numbers or woodenBoard are pressed at fill in the blank
    @objc func viewFunction(sender:UITapGestureRecognizer) {
        viewTag = sender.view!.tag
        //action only at fill in the blank
        if questCount == pagePassword && viewTag == 15 {
            /*if let url = NSURL(string: "https://www.facebook.com/primarymathspaper/posts/2278450288879217) {
                UIApplication.sharedApplication().openURL(url)
            }*/
            guard let url = URL(string: "https://www.facebook.com/primarymathspaper/posts/2278450288879217") else {
                return //be safe
            }
            UIApplication.shared.open(url, options: [:])
            
        }
        if ansFormat == 1 && answered == 0{
            //which view is pressed?
            //viewTag = sender.view!.tag
            //action when 0-9 is pressed and wooden is chosen and not 3 digits yet
            if viewTag < 10 && woodenChosen < 3 && woodenChosen > 0{
                if woodenValue[woodenChosen] < 100 {
                    woodenValue[woodenChosen] = woodenValue[woodenChosen] * 10 + Double(viewTag)
                    //not display 0 in any part of fraction
                    if woodenValue[woodenChosen] == 0 {
                        woodenNumber[woodenChosen].text = ""
                    }
                    else {
                        woodenNumber[woodenChosen].text = String(Int(woodenValue[woodenChosen]))
                    }
                }
            }
            else if viewTag < 11 && woodenChosen == 0 {
                //add digit when fewer than 7 digits
                if wooden0Digit < 6 {
                    //add decimal
                    if viewTag == 10 {
                        //add decimal only when there is none
                        if wooden0DecNum == -1 {
                            wooden0DecNum = 0
                            woodenNumber[0].text = String(Int(woodenValue[0])) + "."
                        }
                    }
                    //add number
                    else {
                        //add whole number
                        wooden0Digit += 1
                        if wooden0DecNum == -1 {
                            woodenValue[woodenChosen] = woodenValue[woodenChosen] * 10 + Double(viewTag)
                            woodenNumber[woodenChosen].text = String(Int(woodenValue[woodenChosen]))
                        }
                        //add decimal number
                        else {
                            wooden0LastValue = wooden0LastValue * 10
                            wooden0DecNum += 1
                            woodenValue[0] += Double(viewTag) / wooden0LastValue
                            woodenNumber[woodenChosen].text = String(format: "%.\(wooden0DecNum)f", woodenValue[woodenChosen])
                        }
                    }
                }
            }
            // viewTag == 10 for "."
            // when backbutton is pressed and wooden is chosen
            else if viewTag == 11 && woodenChosen == 0 {
                //back the whole number
                if wooden0DecNum < 1{
                    wooden0DecNum = -1
                    wooden0Digit -= 1
                    woodenValue[0] = Double(Int(woodenValue[0] / 10))
                    woodenNumber[0].text = String(Int(woodenValue[0]))
                    if woodenValue[0] == 0 {
                        woodenNumber[0].text = ""
                        wooden0Digit = 0
                    }
                }
                //back the decimal number
                else {
                    wooden0LastValue = wooden0LastValue / 10
                    wooden0Digit -= 1
                    wooden0DecNum -= 1
                    woodenValue[0] = Double(floor(woodenValue[0] * wooden0LastValue)) / wooden0LastValue
                    woodenNumber[0].text = String(format: "%.\(wooden0DecNum)f", woodenValue[woodenChosen])
                    if wooden0DecNum == 0 {
                        wooden0DecNum = -1
                    }
                }
            }
            //back the numbers of fraction
            else if viewTag == 11 && woodenChosen < 3 && woodenChosen > 0 {
                woodenValue[woodenChosen] = Double(Int(woodenValue[woodenChosen] / 10))
                //not display 0 in any part of fraction
                if woodenValue[woodenChosen] == 0 {
                    woodenNumber[woodenChosen].text = ""
                }
                else {
                    woodenNumber[woodenChosen].text = String(Int(woodenValue[woodenChosen]))
                }
            }
            //wooden is chosen
            else if viewTag > 11 && viewTag < 15{
                woodenChosen = viewTag - 12
                //set the chosen wood brighter
                for i in 0 ... 2 {
                    //woodenview[i].alpha = 1
                    woodenNumber[i].backgroundColor = UIColor(white: 1, alpha: 0)

                }
                //woodenview[woodenChosen].alpha = 0.5
                woodenNumber[woodenChosen].backgroundColor = UIColor(white: 1, alpha: 0.3)
            }
            
        }
    }
    
    @objc func labelFunction(sender:UITapGestureRecognizer) {
        labelTag = sender.view!.tag
        //when button[15] is pressed, back to first question
        if labelTag == 15 {
            startAgain()
        }
        //fill in blank format. when ok button is pressed, check answer
        if ansFormat == 1 {
            if labelTag == 14 {
                if answered == 0 {
                    if questCount == pagePassword {
                        
                    }
                    else {
                        answeringAction()
                    }
                    checkBlank()
                }
                else {
                    if questCount == pagePassword {
                        okButton7()
                    }
                    else {
                        okButton()
                    }
                    answered = 0
                    label14.text = "確定"
                    label14.textColor = UIColor.black
                }
            }
        }
        //MC format
        else if ansFormat == 0 {
        //if year == savedYear || year == savedYear + 1 && month <= savedMonth {
            //response to MC answer
            if answered == 0 && labelTag < 9 && questCount < totalQuest {
                answered = 1
                answeringAction()
                pressAnswer()
            }
            //press okButton to next quest or subquest
            else if answered == 1 && labelTag == 14 && questCount < totalQuest {
                answered = 0
                okButton()
            }
            else {}
        //}
        /*else {
            for i in 1 ... 15 {
                label[i].latex = ""}
            label[1].latex = "已經過了一年期限。"
        }*/
        }
    }
    func checkBlank() {
        if questCount == pagePassword {
            answered = 1
            ThisIsCorrect = 0
            label14.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 44)
            label14.text = "密碼不正確"

            if Int(woodenValue[0]) == password {
                ThisIsCorrect = 1
                label14.text = "下一題"

            }
            else{
                
            }
        }
        else {
            
        
        //var correctAnswer = dataBase().correct[questCount][questSubcount]

        answered = 1
        ThisIsCorrect = 0
        label14.text = "再算一算"
            
        responseview.image = UIImage(named: dataBase().responseview[questCount][questSubcount][3])
        do {
            if let responseSound = Bundle.main.path(forResource:  dataBase().audioFile[questCount][questSubcount][3], ofType:"mp3") {
                    responsePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: responseSound))
            }
            else { print("")}
        }
        catch let error {
            print("")
        }

        for i in 0 ... 3 {
            if woodenValue == dataBase().blankAnswer[questCount][questSubcount][i] {
                
                responseview.image = UIImage(named: dataBase().responseview[questCount][questSubcount][i])
                if i == 0 {
                    ThisIsCorrect = 1
                    label14.text = "下一題"
                }
                if questSubcount < 2 {
                    do {
                        if let responseSound = Bundle.main.path(forResource:  dataBase().audioFile[questCount][questSubcount][i], ofType:"mp3") {
                            responsePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: responseSound))
                        }
                        else { print("")}
                    }
                    catch let error {
                        print("")
                    }
                }

            }

        }
        responsePlayer?.play()

        view.addSubview(responseview)
        falseInSubQuest += (1 - ThisIsCorrect)
        }
    }

    func pressAnswer(){
        if labelTag < 9 {
            responseview.image = UIImage(named: dataBase().responseview[questCount][questSubcount][labelTag - 5])
            view.addSubview(responseview)
            label14.textColor = UIColor.black
            if labelTag == dataBase().correct[questCount][questSubcount] + 5 {
                imageview[labelTag - 4].image = UIImage(named: "blueButton2")
                imageview[labelTag - 4].frame = buttonFrame[labelTag - 4]
                view.addSubview(imageview[labelTag - 4])
                view.addSubview(answerview[labelTag - 5])
                
                label14.text = "下一題"
                
                    ThisIsCorrect = 1
            }
            else {
                imageview[labelTag - 4].image = UIImage(named: "redButton2")
                imageview[labelTag - 4].frame = buttonFrame[labelTag - 4]
                view.addSubview(imageview[labelTag - 4])
                view.addSubview(answerview[labelTag - 5])
                
                label14.text = "再算一算"
                falseInSubQuest += 1

                ThisIsCorrect = 0
            }
            if questSubcount < 2 {
                do {
                    if let responseSound = Bundle.main.path(forResource: dataBase().audioFile[questCount][questSubcount][labelTag - 5], ofType:"mp3") {
                        responsePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: responseSound))
                    }
                    else { print("")}
                }
                catch let error {
                    print("")
                }
                responsePlayer?.play()
            }
        }
    }
    
    func transition2(){
        UIView.transition(with: goodlabel,
                          duration: 1.0,
                          options: [.curveLinear],
                          animations: { () -> Void in
                            self.goodlabel.transform = CGAffineTransform(scaleX: 5.0, y:5.0)
                            self.goodlabel.transform = CGAffineTransform(rotationAngle: 0.6)
        }, completion:  {finished in self.transition3()})
    }
    func transition3(){
        UIView.transition(with: goodlabel,
                          duration: 1.0,
                          options: [.curveLinear],
                          animations: { () -> Void in
                            self.goodlabel.transform = CGAffineTransform(scaleX: 6.0, y:6.0)
                            self.goodlabel.transform = CGAffineTransform(rotationAngle: 0.0)
        }, completion:  {finished in self.transition4()})
    }
    func transition4(){
        if questCount != pagePassword {
            view.addSubview(imageview[11])
        }
        UIView.transition(with: imageview[11],
                          duration: 1.0,
                          options: [.curveLinear],
                          animations: { () -> Void in
                            self.imageview[11].transform = CGAffineTransform(scaleX: 30.0, y:30.0)
                            self.imageview[11].alpha = 0.1
        }, completion: {finished in self.imageview[11].removeFromSuperview()
            self.imageview[11].alpha = 1
            self.imageview[11].transform = CGAffineTransform(scaleX: 1.0, y:1.0)
        })
        setText()
        UIView.transition(with: goodlabel,
                          duration: 1.0,
                          options: [.curveLinear],
                          animations: { () -> Void in
                            self.goodlabel.transform = CGAffineTransform(scaleX: 5.0, y:5.0)
        }, completion:  {finished in
            self.goodlabel.center = CGPoint(x: self.DW / 2, y: self.DH / 2)
            self.transition5()})
    }
    func transition5(){
        UIView.transition(with: goodlabel,
                          duration: 1.0,
                          options: [.curveLinear],
                          animations: { () -> Void in
                            self.goodlabel.center = CGPoint(x: self.DW * 1.1, y: self.DH / 2)
        }, completion:   {finished in
            self.goodlabel.removeFromSuperview()
            self.goodlabel.center = CGPoint(x: self.DW / 2, y: self.DH / 2)
            self.goodlabel.transform = CGAffineTransform(scaleX: 1.0, y:1.0)
        })
    }
    func setText() {
        ansFormat = dataBase().answerFormat[questCount]
        responseview.image = UIImage(named: "blank.png")
        if questCount == pagePassword {
            responseview.image = UIImage(named: dataBase().responseview[questCount][questSubcount][0])
            do {
                if let responseSound = Bundle.main.path(forResource:  dataBase().audioFile[questCount][0][0], ofType:"mp3") {
                    responsePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: responseSound))
                }
                else { print("")}
            }
            catch let error {
                print("")
            }
            responsePlayer?.play()
            

        }
        if questCount == totalQuest {
            responseview.image = UIImage(named: "r23_0_0.png")
            
            do {
                if let responseSound = Bundle.main.path(forResource:  dataBase().audioFile[questCount][0][0], ofType:"mp3") {
                    responsePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: responseSound))
                }
                else { print("")}
            }
            catch let error {
                print("")
            }
            responsePlayer?.play()
            
        }
        questionview.image = UIImage(named: dataBase().questionview[questCount][questSubcount])
        self.view.addSubview(questionview)
        /*if questCount == pagePassword + 1 {
            for i in 0 ... 4 {
                facebook[i].removeFromSuperview()
            }

        }*/
        if ansFormat == 0 {
            
            //not display the sentence that tells user to press woodboard first
            //label17.alpha = 0
            label17.text = "滿分＝" + String((totalQuest - 1) * 32)
            for i in 1 ... 4 {
                imageview[i].image = UIImage(named: "orangeButton2")
                imageview[i].frame = buttonFrame[i]
                view.addSubview(imageview[i])
                answerview[i-1].image = UIImage(named: dataBase().answerview[questCount][questSubcount][i-1])
                answerview[i-1].frame = buttonFrame[i]
                view.addSubview(answerview[i-1])
                
            }
            label14.textColor = UIColor.magenta
            for i in 0 ... 10 {
                numberview[i].alpha = 0
                squareNumber[i].alpha = 0
            }
            numberview[11].alpha = 0
            for i in 0 ... 2 {
                woodenview[i].alpha = 0
                woodenNumber[i].alpha = 0
            }
            for i in 2 ... 4 {
                imageview[i].alpha = 1
                answerview[i-1].alpha = 1
                
            }
        }
        else {
            //tell user to press the woodboard first
            //label17.alpha = 1
            label17.text = "請先按一下木板才按數字。"
            wooden0LastValue = 1
            wooden0DecNum = -1
            wooden0Digit = 0
            /*if questCount == pagePassword {
                for i in 0 ... 4 {
                    self.view.addSubview(facebook[i])
                }
            }*/
            
            imageview[1].center.y = DH / 20 * 15.5
            imageview[1].image = UIImage(named: "blueButton2")
            answerview[0].center.y = DH / 20 * 15.5
            answerview[0].image = UIImage(named: dataBase().answerview[questCount][questSubcount][0])
            view.addSubview(answerview[0])
            
            label14.textColor = UIColor.black
            label14.text = "確定"
            for i in 0 ... 10 {
                numberview[i].alpha = 1
                squareNumber[i].alpha = 1
            }
            numberview[11].alpha = 1
            for i in 0 ... 2 {
                woodenview[i].alpha = 1
                woodenNumber[i].alpha = 1
            }
            for i in 2 ... 4 {
                imageview[i].alpha = 0
                answerview[i-1].alpha = 0
            }
            if dataBase().nonFraction[questCount] == 1 {
                numberview[10].alpha = 1
                squareNumber[10].alpha = 1
                numberview[11].center.x = DW / 20 * 7.7
                numberview[10].isUserInteractionEnabled = true
                woodenview[1].alpha = 0
                woodenNumber[1].alpha = 0
                woodenview[2].alpha = 0
                woodenNumber[2].alpha = 0
            }
            else {
                numberview[10].alpha = 0
                squareNumber[10].alpha = 0
                numberview[11].center.x = DW / 20 * 9.2
                numberview[10].isUserInteractionEnabled = false
                woodenview[1].alpha = 1
                woodenNumber[1].alpha = 1
                woodenview[2].alpha = 1
                woodenNumber[2].alpha = 1
            }
        }
        
    }
    
    func startAgain() {
        clickPlayer?.play()
        questCount = 0
        questSubcount = 0
        falseInSubQuest = 0
        ThisIsCorrect = 0
        answered = 0
        label14.textColor = UIColor.magenta
        currentScore = 0
        score[0].text = "0"
        score[1].text = "0"
        score[2].text = "0"
        /*for i in 0 ... 4 {
            facebook[i].removeFromSuperview()
        }*/
        woodenValue = [0.0, 0.0, 0.0]
        wooden0LastValue = 1
        wooden0DecNum = -1
        wooden0Digit = 0
        for i in 0 ... 2 {
            woodenNumber[i].text = ""
        }
        setText()

    }
    func okButton7() {
        clickPlayer?.play()
        if labelTag == 14 {
            if ThisIsCorrect == 1 {
                ThisIsCorrect = 0
                woodenValue = [0.0, 0.0, 0.0]
                wooden0LastValue = 1
                wooden0DecNum = -1
                wooden0Digit = 0
                wooden0LastValue = 1
                wooden0DecNum = -1
                wooden0Digit = 0
                for i in 0 ... 2 {
                    woodenNumber[i].text = ""
                }
                questCount += 1
                if questCount == 2 {questCount = 3}
                questSubcount = 0
                falseInSubQuest = 0
                view.addSubview(imageview[11])
                UIView.transition(with: imageview[11],
                              duration: 1.0,
                              options: [.curveLinear],
                              animations: { () -> Void in
                                self.imageview[11].transform = CGAffineTransform(scaleX: 30.0, y:30.0)
                                self.imageview[11].alpha = 0.1
                                }, completion: {finished in self.imageview[11].removeFromSuperview()
                                self.imageview[11].alpha = 1
                                self.imageview[11].transform = CGAffineTransform(scaleX: 1.0, y:1.0)
                })
                setText()
            }
            else {
                clickPlayer?.play()
                label14.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 34)
                if ansFormat == 1 {
                    woodenValue = [0.0, 0.0, 0.0]
                    wooden0LastValue = 1
                    wooden0DecNum = -1
                    wooden0Digit = 0
                    for i in 0 ... 2 {
                        woodenNumber[i].text = ""
                    }
                }
            }
        }
    }
    func okButton() {
        clickPlayer?.play()
        responsePlayer?.stop()
        goodlabel.removeFromSuperview()
        trylabel.removeFromSuperview()
        //if okButton is pressed
        if labelTag == 14 {
            label14.textColor = UIColor.magenta
            if ThisIsCorrect == 1 {
                //responsePlayer?.stop()
                clapPlayer?.play()
                
                self.view.addSubview(goodlabel)
                UIView.transition(with: goodlabel,
                                  duration: 1.0,
                                  options: [.curveLinear],
                                  animations: { () -> Void in
                                    self.goodlabel.transform = CGAffineTransform(scaleX: 4.0, y:4.0)
                                    self.goodlabel.transform = CGAffineTransform(rotationAngle: -0.6)
                }, completion: {finished in self.transition2()})
                
                oldScore[0] = Int(currentScore / 100)
                oldScore[1] = Int(currentScore / 10) - oldScore[0] * 10
                oldScore[2] = currentScore - oldScore[0] * 100 - oldScore[1] * 10
                if falseInSubQuest > 3 {falseInSubQuest = 3}
                currentScore = currentScore + 16 - falseInSubQuest * 4
                //if questSubcount == 1 || falseInSubQuest == 0 {
                if questSubcount == 1 {
                    // next Question
                    //currentScore = currentScore + 16 * (1 - questSubcount)
                    questCount += 1
                    if questCount == 2 {questCount = 3}
                    questSubcount = 0
                }
                else {
                    // next subQuestion
                    questSubcount += 1
                }
                newScore[0] = Int(currentScore / 100)
                newScore[1] = Int(currentScore / 10) - newScore[0] * 10
                newScore[2] = currentScore - newScore[0] * 100 - newScore[1] * 10
                self.maxCount = newScore[2]
                self.currentCount = oldScore[2] * 10
                digit = 0
                self.updateTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateLabel), userInfo: nil, repeats: true)
                
                falseInSubQuest = 0
                ThisIsCorrect = 0
                woodenValue = [0.0, 0.0, 0.0]
                wooden0LastValue = 1
                wooden0DecNum = -1
                wooden0Digit = 0
                for i in 0 ... 2 {
                    woodenNumber[i].text = ""
                }
            }
            else {
                clickPlayer?.play()
                if ansFormat == 1 {
                    woodenValue = [0.0, 0.0, 0.0]
                    wooden0LastValue = 1
                    wooden0DecNum = -1
                    wooden0Digit = 0
                    for i in 0 ... 2 {
                        woodenNumber[i].text = ""
                    }
                }
                self.view.addSubview(trylabel)
                UIView.transition(with: trylabel,
                                  duration: 2.0,
                                  options: [.curveLinear],
                                  animations: { () -> Void in
                                    self.trylabel.transform = CGAffineTransform(scaleX: 2.0, y:2.0)
                                    self.trylabel.center = CGPoint(x: self.DW * 0.5, y: self.DH / 8)
                }, completion: {finished in
                    UIView.transition(with: self.trylabel,
                    duration: 4.5, options: [.curveLinear],
                    animations: { () -> Void in
                    self.trylabel.center = CGPoint(x: self.DW * -0.5, y: self.DH / 8)
                }, completion:   {finished in
                    self.trylabel.removeFromSuperview()
                    self.trylabel.center = CGPoint(x: self.DW * 0.5, y: self.DH * -0.15)
                    self.trylabel.transform = CGAffineTransform(scaleX: 1.0, y:1.0)
                    
                })
                })

                
                
                
                
            }
            
        }

    }
    
    
    func answeringAction() {
        dingPlayer?.stop()
        dingPlayer?.play()
        view.addSubview(imageview[12])
        UIView.transition(with: imageview[12],
                          duration: 1.0,
                          options: [.curveLinear],
                          animations: { () -> Void in
                            self.imageview[12].transform = CGAffineTransform(scaleX: 30.0, y:30.0)
                            self.imageview[12].alpha = 0
        }, completion: {finished in self.imageview[12].removeFromSuperview()
            self.imageview[12].alpha = 1
            self.imageview[12].transform = CGAffineTransform(scaleX: 1.0, y:1.0)
        })

    }
    //score animtation
    @objc func updateLabel(_ timer: Timer) {
        currentCount += 2
        if currentCount > 95 {currentCount = 0}
        self.score[2 - digit].text = String(Int(currentCount / 10))
        self.score[2 - digit].reloadInputViews()
        if ((currentCount % 10) == 0) || ((currentCount % 10) == 6) {clickPlayer?.play()}
        if Int(currentCount / 10) == maxCount {
            switch digit {
            case 0: do {digit = 1
                currentCount = self.oldScore[1]
                maxCount = self.newScore[1]}
            case 1: do {digit = 2
                     currentCount = self.oldScore[0] * 10
                     maxCount = self.newScore[0]}
            case 2: do {timer.invalidate()
                self.updateTimer = nil}
            default:
                digit = 2
            }
        }
    }

}

