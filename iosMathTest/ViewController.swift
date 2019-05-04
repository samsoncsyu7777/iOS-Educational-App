//
//  ViewController.swift
//  iosMathTest
//
//  Created by Admin on 14/2/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import iosMath
import Foundation
import AVFoundation //for audio player


class ViewController: UIViewController {
    //set storage in user's device for the date of first use
    struct defaultsKeys {
        static let keyMonth = "0"
        static let keyYear = "0"
    }
    
    //initialize variables
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
    //initialize iosMath labels but have not detected device width and height
    //5 question labels, 4 MC buttons, 5 response labels, 1 ok button, 1 start again button
    var label14: UILabel = UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))
    var label15: UILabel = UILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))
    var label: [MTMathUILabel] = [MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1)),
                                  MTMathUILabel(frame: CGRect(x:0, y: 0, width: 1, height: 1))]  //label[0-15]
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
    var facebook: [UITextView] = [UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)), UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1)),UITextView(frame: CGRect(x:0, y: 0, width: 1, height: 1))]
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
                                     UIImageView(image: UIImage(named: "greenSquare3.png")),
                                     UIImageView(image: UIImage(named: "blueSquare3.png")),
                                     UIImageView(image: UIImage(named: "backButton.png"))]
    //1 big question view, 4 MC answer views
    var imageview: [UIImageView] = [UIImageView(image: UIImage(named: "greenPattern.png")),
                                    UIImageView(image: UIImage(named: "orangeButton.png")),
                                    UIImageView(image: UIImage(named: "orangeButton.png")),
                                    UIImageView(image: UIImage(named: "orangeButton.png")),
                                    UIImageView(image: UIImage(named: "orangeButton.png")),
                                    UIImageView(image: UIImage(named: "bigSquare3.png")),
                                    UIImageView(image: UIImage(named: "smallPurple.png")),
                                    UIImageView(image: UIImage(named: "smallGreen.png")), UIImageView(image: UIImage(named: "Coin2.png")), UIImageView(image: UIImage(named: "Coin2.png")), UIImageView(image: UIImage(named: "Coin2.png")), UIImageView(image: UIImage(named: "shiningstar.png")), UIImageView(image: UIImage(named: "shiningstar.png"))]
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
    let defaults = UserDefaults.standard // for storage in device
    var savedMonth = 0
    var savedYear = 0
    var audioFile = ""
    var DW: CGFloat = 0.0 //device width
    var DH: CGFloat = 0.0 //device height
    var goodlabel = UILabel() //for appreciation
    var trylabel = UILabel() //encourage user to try again after a false
    //set up audio player
    //var responsePlayer: AVAudioPlayer? //play the response
    var clapPlayer: AVAudioPlayer? //when answer is correct
    var clickPlayer: AVAudioPlayer? // when button is pressed
    var dingPlayer: AVAudioPlayer? //after answer
    /// MAximum Count to which label will be Updated
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
        //set the origin and size of 5 question labels, 4 MC labels, 5 response labels, 1 ok button and 1 start again button
        label[0] = MTMathUILabel(frame: CGRect(x: DW / 20 / 4, y: DH / 20 * 0.25, width: DW / 20 * 9.5, height: DH / 20 * 2.5))
        label[1] = MTMathUILabel(frame: CGRect(x: DW / 20 / 4, y: DH / 20 * 2.75, width: DW / 20 * 9.5, height: DH / 20 * 2.5))
        label[2] = MTMathUILabel(frame: CGRect(x: DW / 20 / 4, y: DH / 20 * 5.25, width: DW / 20 * 9.5, height: DH / 20 * 2.5))
        label[3] = MTMathUILabel(frame: CGRect(x: DW / 20 / 4, y: DH / 20 * 7.75, width: DW / 20 * 9.5, height: DH / 20 * 2.5))
        label[4] = MTMathUILabel(frame: CGRect(x: DW / 20 / 4, y: DH / 20 * 10.25, width: DW / 20 * 9.5, height: DH / 20 * 2.5))
        label[5] = MTMathUILabel(frame: CGRect(x: DW / 20 * 0.25, y: DH / 20 * 13.25, width: DW / 20 * 4.25, height: DH / 20 * 3))
        label[6] = MTMathUILabel(frame: CGRect(x: DW / 20 * 4.75, y: DH / 20 * 13.25, width: DW / 20 * 4.25, height: DH / 20 * 3))
        label[7] = MTMathUILabel(frame: CGRect(x: DW / 20 * 0.25, y: DH / 20 * 16.5, width: DW / 20 * 4.25, height: DH / 20 * 3))
        label[8] = MTMathUILabel(frame: CGRect(x: DW / 20 * 4.75, y: DH / 20 * 16.5, width: DW / 20 * 4.25, height: DH / 20 * 3))
        label[9] = MTMathUILabel(frame: CGRect(x: DW / 20 * 9.4, y: DH / 20 * 1.75, width: DW / 20 * 9.95, height: DH / 20 * 2.5))
        label[10] = MTMathUILabel(frame: CGRect(x: DW / 20 * 9.4, y: DH / 20 * 4.25, width: DW / 20 * 9.95, height: DH / 20 * 2.5))
        label[11] = MTMathUILabel(frame: CGRect(x: DW / 20 * 9.4, y: DH / 20 * 6.75, width: DW / 20 * 9.95, height: DH / 20 * 2.5))
        label[12] = MTMathUILabel(frame: CGRect(x: DW / 20 * 9.4, y: DH / 20 * 9.25, width: DW / 20 * 9.95, height: DH / 20 * 2.5))
        label[13] = MTMathUILabel(frame: CGRect(x: DW / 20 * 9.4, y: DH / 20 * 11.75, width: DW / 20 * 9.95, height: DH / 20 * 2.5))
        label14 = UILabel(frame: CGRect(x: DW / 20 * 13.15, y: DH / 20 * 16, width: DW / 20 * 3.0, height: DH / 20 * 3))
        label15 = UILabel(frame: CGRect(x: DW / 20 * 16.25, y: DH / 20 * 16, width: DW / 20 * 3.0, height: DH / 20 * 3))
        //set origin and size of 3 score labels
        score[0].frame = CGRect(x: DW / 20 * 9.08, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        score[1].frame = CGRect(x: DW / 20 * 10.41, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        score[2].frame = CGRect(x: DW / 20 * 11.74, y: DH / 20 * 16, width: DW / 20 * 1.33, height: DW / 20 * 1.33)
        //set origin and size of 5 labels of promotion
        facebook[0] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 1.75, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[1] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 4.25, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[2] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 6.75, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[3] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 9.25, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        facebook[4] = UITextView(frame: CGRect(x: DW / 20 * 10.15, y: DH / 20 * 11.75, width: DW / 20 * 8.5, height: DH / 20 * 2.5))
        //set origin and size and font of color squares and number labels
        for i in 0 ... 9 {
            squareNumber[i].frame = CGRect(x: DW / 24 * CGFloat(i), y: DH - DW / 24, width: DW / 24, height: DW / 24)
            squareNumber[i].text = String(i)
            squareNumber[i].font = UIFont.boldSystemFont(ofSize: DW / 34)
            squareNumber[i].textAlignment = .center
            numberview[i].frame = CGRect(x: DW / 24 * CGFloat(i), y: DH - DW / 24, width: DW / 24, height: DW / 24)
            view.addSubview(numberview[i])
            view.addSubview(squareNumber[i])
        }
        numberview[11].frame = CGRect(x: DW / 24 * 10, y: DH - DW / 24, width: DW / 24, height: DW / 24)
        view.addSubview(numberview[11])
        //set origin and size and font of wooden board and the labels
        woodenview[0].frame = CGRect(x: DW / 20 * 4.6, y: DH / 20 * 14.5 , width: DW / 20 * 2, height: DH / 20 * 2)
        woodenNumber[0].frame = CGRect(x: DW / 20 * 4.6, y: DH / 20 * 14.5 , width: DW / 20 * 2, height: DH / 20 * 2)
        woodenview[1].frame = CGRect(x: DW / 20 * 6.7, y: DH / 20 * 13.5 , width: DW / 20 * 2, height: DH / 20 * 2)
        woodenNumber[1].frame = CGRect(x: DW / 20 * 6.7, y: DH / 20 * 13.5 , width: DW / 20 * 2, height: DH / 20 * 2)
        woodenview[2].frame = CGRect(x: DW / 20 * 6.7, y: DH / 20 * 15.6 , width: DW / 20 * 2, height: DH / 20 * 2)
        woodenNumber[2].frame = CGRect(x: DW / 20 * 6.7, y: DH / 20 * 15.6 , width: DW / 20 * 2, height: DH / 20 * 2)
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
        imageview[1].frame = buttonFrame[1]
        imageview[2].frame = buttonFrame[2]
        imageview[3].frame = buttonFrame[3]
        imageview[4].frame = buttonFrame[4]
        //set origin and size of 1 response image
        imageview[5].frame = CGRect(x: DW / 20 * 9.4, y: DH / 20 / 4, width: DW / 20 * 9.95, height: DH / 20 * 15.5)
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
        if defaults.integer(forKey: defaultsKeys.keyMonth) == 0 {
            defaults.set(month, forKey: defaultsKeys.keyMonth)
            defaults.set(year, forKey: defaultsKeys.keyYear)
        }
        else {
        }
        savedMonth = defaults.integer(forKey: defaultsKeys.keyMonth)
        savedYear = defaults.integer(forKey: defaultsKeys.keyYear)
        
        //set the interaction of labels
        let tapLabel5 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        label[5].isUserInteractionEnabled = true
        label[5].addGestureRecognizer(tapLabel5)
        label[5].tag = 5
        let tapLabel6 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        label[6].isUserInteractionEnabled = true
        label[6].addGestureRecognizer(tapLabel6)
        label[6].tag = 6
        let tapLabel7 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        label[7].isUserInteractionEnabled = true
        label[7].addGestureRecognizer(tapLabel7)
        label[7].tag = 7
        let tapLabel8 = UITapGestureRecognizer(target: self, action: #selector(labelFunction))
        label[8].isUserInteractionEnabled = true
        label[8].addGestureRecognizer(tapLabel8)
        label[8].tag = 8
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
                       UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction)), UITapGestureRecognizer(target: self, action: #selector(viewFunction))]
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

        for i in 0 ... 13 {
            label[i].fontSize = DW / 34
            label[i].backgroundColor = UIColor(white: 1, alpha: 0)
            self.view.addSubview(label[i])
        }
        label14.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(label14)
        label15.backgroundColor = UIColor(white: 1, alpha: 0)
        self.view.addSubview(label15)


        for i in 5 ... 8 {
            label[i].textAlignment = MTTextAlignment.center
            label[i].fontSize = DW / 52
        }
        label[9].textAlignment = MTTextAlignment.center
        label[10].textAlignment = MTTextAlignment.center
        label[11].textAlignment = MTTextAlignment.center
        label[12].textAlignment = MTTextAlignment.center
        label[13].textAlignment = MTTextAlignment.center
        label14.textAlignment = .center
        label15.textAlignment = .center
        label14.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 34)
        label15.font = UIFont(name: "AR PL KaitiM Big5", size: DW / 34)
        label14.text = "下一題"
        label15.text = "重新開始"
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
        //goodlabel.layer.shadowColor = UIColor(red: 255/255, green: 20/255, blue: 0/255, alpha: 1.0).cgColor
        goodlabel.layer.shadowColor = UIColor.black.cgColor
        goodlabel.layer.shadowRadius = 1.0
        goodlabel.layer.shadowOpacity = 1.0
        goodlabel.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        goodlabel.layer.masksToBounds = false
        
        trylabel.frame = CGRect(x:DW / 3 * 1, y:DH / 3 * 1, width: DW, height: DH / 8)
        trylabel.center = CGPoint(x:DW * 0.5, y:DH * -0.15)
        trylabel.textAlignment = .center
        //trylabel.backgroundColor =  UIColor(red: 255/255, green: 230/255, blue: 230/255, alpha: 0.8)
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
        //goodlabel.layer.shadowColor = UIColor(red: 255/255, green: 20/255, blue: 0/255, alpha: 1.0).cgColor
        trylabel.layer.shadowColor = UIColor.black.cgColor
        trylabel.layer.shadowRadius = 0.5
        trylabel.layer.shadowOpacity = 1.0
        trylabel.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        trylabel.layer.masksToBounds = false
        
        facebook[0].text = "請到我們的FACEBOOK:"
        facebook[1].isEditable = false
        facebook[1].dataDetectorTypes = .link
        facebook[1].text = "https://www.facebook.com/primarymathspaper"
        facebook[2].text = "支持我們。"
        facebook[3].text = "並留意我們最新的"
        facebook[4].text = "「呈分試系列」發佈。"
        for i in 0 ... 4 {
            facebook[i].textAlignment = .center
            facebook[i].backgroundColor = UIColor(white: 1, alpha: 0)
            facebook[i].font = UIFont.boldSystemFont(ofSize: self.DW / 34)
        }
        facebook[1].font = UIFont.boldSystemFont(ofSize: self.DW / 64)
        
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
        //action only at fill in the blank
        if ansFormat == 1 && answered == 0{
            //which view is pressed?
            viewTag = sender.view!.tag
            //action when 0-9 is pressed and wooden is chosen and not 3 digits yet
            if viewTag < 10 && woodenChosen < 3 {
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
            // viewTag == 10 for "."
            // when backbutton is pressed and wooden is chosen
            else if viewTag == 11 && woodenChosen < 3 {
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
            else if viewTag > 11 {
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
                    answeringAction()
                    checkBlank()
                }
                else {
                    okButton()
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
            if answered == 0 && labelTag < 9 && questCount < 18 {
                answered = 1
                answeringAction()
                pressAnswer()
            }
            //press okButton to next quest or subquest
            else if answered == 1 && labelTag == 14 && questCount < 18 {
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
        var correctAnswer = dataBase().correct[questCount][questSubcount]
        label[9].latex = dataBase().response[questCount][questSubcount][correctAnswer][0]
        label[10].latex = dataBase().response[questCount][questSubcount][correctAnswer][1]
        label[11].latex = dataBase().response[questCount][questSubcount][correctAnswer][2]
        label[12].latex = dataBase().response[questCount][questSubcount][correctAnswer][3]
        label[13].latex = dataBase().response[questCount][questSubcount][correctAnswer][4]
        
        answered = 1
        ThisIsCorrect = 0
        label14.text = "再算一算"

        for i in 0 ... 3 {
            if woodenValue == dataBase().blankAnswer[questCount][questSubcount][i] {
                label[9].latex = dataBase().response[questCount][questSubcount][i][0]
                label[10].latex = dataBase().response[questCount][questSubcount][i][1]
                label[11].latex = dataBase().response[questCount][questSubcount][i][2]
                label[12].latex = dataBase().response[questCount][questSubcount][i][3]
                label[13].latex = dataBase().response[questCount][questSubcount][i][4]
                if i == dataBase().correct[questCount][questSubcount] {
                    ThisIsCorrect = 1
                    label14.text = "下一題"
                    label[9].latex = "你算對了!欣賞你" + dataBase().response[questCount][questSubcount][i][0]
                }
                /*if questSubcount == 0 {
                    do {
                        if let responseSound = Bundle.main.path(forResource: dataBase().audioFile[questCount][i], ofType:"mp3") {
                            responsePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: responseSound))
                        }
                        else { print("")}
                    }
                    catch let error {
                        print("")
                    }
                    responsePlayer?.play()
                }*/



            }

        }
        falseInSubQuest += (1 - ThisIsCorrect)
    }

    func pressAnswer(){
        if labelTag < 9 {
            label[9].latex = dataBase().response[questCount][questSubcount][labelTag - 5][0]
            label[10].latex = dataBase().response[questCount][questSubcount][labelTag - 5][1]
            label[11].latex = dataBase().response[questCount][questSubcount][labelTag - 5][2]
            label[12].latex = dataBase().response[questCount][questSubcount][labelTag - 5][3]
            label[13].latex = dataBase().response[questCount][questSubcount][labelTag - 5][4]
            label14.textColor = UIColor.black
            if labelTag == dataBase().correct[questCount][questSubcount] + 5 {
                imageview[labelTag - 4].image = UIImage(named: "blueButton")
                imageview[labelTag - 4].frame = buttonFrame[labelTag - 4]
                view.addSubview(imageview[labelTag - 4])
                self.view.addSubview(label[labelTag])
                label14.text = "下一題"
                
                    ThisIsCorrect = 1
            }
            else {
                imageview[labelTag - 4].image = UIImage(named: "redButton")
                imageview[labelTag - 4].frame = buttonFrame[labelTag - 4]
                view.addSubview(imageview[labelTag - 4])
                self.view.addSubview(label[labelTag])
                label14.text = "再算一算"
                falseInSubQuest += 1

                ThisIsCorrect = 0
            }
            /*if questSubcount == 0 {
                do {
                    if let responseSound = Bundle.main.path(forResource: dataBase().audioFile[questCount][labelTag - 5], ofType:"mp3") {
                        responsePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: responseSound))
                    }
                    else { print("")}
                }
                catch let error {
                    print("")
                }
                responsePlayer?.play()
            }*/
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
        label[0].latex = dataBase().question[questCount][questSubcount][0]
        label[1].latex = dataBase().question[questCount][questSubcount][1]
        label[2].latex = dataBase().question[questCount][questSubcount][2]
        label[3].latex = dataBase().question[questCount][questSubcount][3]
        label[4].latex = dataBase().question[questCount][questSubcount][4]
        label[9].latex = ""
        label[10].latex = ""
        label[11].latex = ""
        label[12].latex = ""
        label[13].latex = ""
        if questCount == 18 {
            for i in 0 ... 4 {
                self.view.addSubview(facebook[i])
            }
        }
        if ansFormat == 0 {
            label[5].center.y = DH / 20 * 14.75
            for i in 1 ... 4 {
                imageview[i].image = UIImage(named: "orangeButton")
                imageview[i].frame = buttonFrame[i]
                view.addSubview(imageview[i])
                self.view.addSubview(label[i + 4])
            }
            label14.textColor = UIColor.magenta
            if questCount == 18 {
                label[5].fontSize = DW / 38
                label[6].fontSize = DW / 38
                label[7].fontSize = DW / 38
                label[8].fontSize = DW / 38
                label[5].latex = dataBase().answer[questCount][questSubcount][0]
                label[6].latex = dataBase().answer[questCount][questSubcount][1]
                label[7].latex = dataBase().answer[questCount][questSubcount][2]
                label[8].latex = dataBase().answer[questCount][questSubcount][3]
            }
            else {
                label[5].latex = "" + dataBase().answer[questCount][questSubcount][0]
                label[6].latex = "" + dataBase().answer[questCount][questSubcount][1]
                label[7].latex = "" + dataBase().answer[questCount][questSubcount][2]
                label[8].latex = "" + dataBase().answer[questCount][questSubcount][3]
            }

            for i in 0 ... 9 {
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
                label[i + 4].alpha = 1
            }
        }
        else {
            label[5].center.y = DH / 20 * 15.5
            imageview[1].center.y = DH / 20 * 15.5
            imageview[1].image = UIImage(named: "blueButton")
            label[5].latex = dataBase().label5[questCount][questSubcount]
            label14.textColor = UIColor.black
            label14.text = "確定"
            for i in 0 ... 9 {
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
                label[i + 4].alpha = 0
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
        for i in 0 ... 4 {
            facebook[i].removeFromSuperview()
        }
        woodenValue = [0.0, 0.0, 0.0]
        for i in 0 ... 2 {
            woodenNumber[i].text = ""
        }
        setText()

    }
    
    func okButton() {
        clickPlayer?.play()
        goodlabel.removeFromSuperview()
        trylabel.removeFromSuperview()
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
                currentScore = currentScore + 24 - falseInSubQuest * 6
                if questSubcount == 1 || falseInSubQuest == 0 {
                    // next Question
                    currentScore = currentScore + 24 * (1 - questSubcount)
                    questCount += 1
                    questSubcount = 0
                }
                else {
                    // next subQuestion
                    questSubcount += 1
                }
                newScore[0] = Int(currentScore / 100)
                newScore[1] = Int(currentScore / 10) - newScore[0] * 10
                newScore[2] = currentScore - newScore[0] * 100 - newScore[1] * 10
                //for i in 0 ... 2 {
                self.maxCount = newScore[2]
                self.currentCount = oldScore[2] * 10
                //score[2 - i].text = String(self.maxCount)
                digit = 0
                self.updateTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.updateLabel), userInfo: nil, repeats: true)
                
                //}
                falseInSubQuest = 0
                ThisIsCorrect = 0
                woodenValue = [0.0, 0.0, 0.0]
                for i in 0 ... 2 {
                    woodenNumber[i].text = ""
                }
                //setText()
            }
            else {
                clickPlayer?.play()
                if ansFormat == 1 {
                    woodenValue = [0.0, 0.0, 0.0]
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
            /// Release All Values
            //timer.invalidate()
            //self.updateTimer = nil
        }
    }

}

