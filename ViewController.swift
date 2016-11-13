//
//  ViewController.swift
//  Mello
//
//  Created by Aakaash, Rishab, Lawrence, Anir, Gefen on 12/11/16.
//  Copyright © 2016 CalHacks. All rights reserved.
//

import UIKit
import AVFoundation
import ToneAnalyzerV3


class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var Feeling: UILabel!
    
    
    @IBOutlet weak var SaveText: UILabel!
    
    @IBOutlet weak var Logo: UIImageView!
    
    @IBOutlet weak var WhiteBox: UITextView!
    
    @IBOutlet weak var Question: UILabel!
    
    @IBOutlet weak var Answer: UITextField!
    
    @IBOutlet weak var Next: UIButton!
    
    @IBOutlet weak var Song_Name: UILabel!
    
    @IBOutlet weak var PlayButton: UIButton!
    
    @IBOutlet weak var PauseButton: UIButton!

    @IBOutlet weak var Main: UIImageView!
    
    
    let anger_cover = "MelloAnger"
    
    let fear_cover = "MelloFear"
    
    let joy_cover = "MelloHappiness"
    
    let sadness_cover = "MelloSadness"
    
    let disgust_cover = "MelloDisgust"
    
    
    let anger_songs = ["07 Quiet Little Voices","Are You Gonna Be My Girl","LimpBizkitBreakStuff","madina_lake_never_take_us_alive (ouronlyhope.org)","Verdi_Requiem_Libera_me_das_jüngste_Gericht[MP3lucky.com]"]
    
    let fear_songs = ["01-a-nightmare","AlfredHitchcock-PsychoTheme","Ligeti - Atmosphères - HD (320  kbps)","The-Exorcist-Theme---Tubular-Bells-(Piano-Version)-Mike-Oldfield"]
    
    let joy_songs = ["moves like jagger","On Top of the World","One_Direction_-_What_Makes_You_Beautiful_1100","Sunshine, Lollipops And Rainbows. Lyrics","Tonight_Tonight_Z100_Jingle_Ball_Version-Hot_Chelle_Rae_1322500841_12628"]
    
    let sadness_songs = ["01 - Skyscraper","10 You And I","Beethoven - Moonlight Sonata (Mp3FB.com)","Enya - Only Time (mp3goo.com)","Taylor Swift Never Grow Up"]
    
    let disgust_songs = ["One Less Lonely Girl - Justin Bieber","One Time - Justin Bieber","Friday - Rebecca Black"]
    

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    var player: AVAudioPlayer!
    
    var max = 0.0, max_index = 0
    
    var lastIndex = 0
    
    var cover = ""
    var cover_songs = [String]()
    
    @IBAction func Next_Button(_ sender: UIButton) {
        
//        PauseButton.isHidden = false
//        Main.isHidden = false
//        Song_Name.isHidden = false
//        WhiteBox.isHidden = false
        
        Logo.isHidden = true
        Question.isHidden = true
        Answer.isHidden = true
        Next.isHidden = true
        
        var isComputed = false
        
        
        
        let username = "3b06ef71-356d-4f26-9a03-71694d4e13e8"
        let password = "QiL0tzryX5yY"
        let version = "2016-11-12" // use today's date for the most recent version
        let toneAnalyzer = ToneAnalyzer(username: username, password: password, version: version)
        
        let text = Answer.text
        
        
        var anger = 0.0, disgust = 0.0, fear = 0.0, joy = 0.0, sadness = 0.0
        
        
        var scores = [double_t]()
        let failure = { (error: Error) in print(error) }
        toneAnalyzer.getTone(ofText: text!, failure: failure) { tones in
            print(tones.documentTone[0])
            anger = tones.documentTone[0].tones[0].score
            disgust = tones.documentTone[0].tones[1].score
            fear = tones.documentTone[0].tones[2].score
            joy = tones.documentTone[0].tones[3].score
            sadness = tones.documentTone[0].tones[4].score
            scores = [anger, disgust, fear, joy, sadness]
            
            
            for i in 0..<5
            {
                if scores[i] > self.max {
                    self.max = scores[i]
                    self.max_index = i
                }
            }
            
            
            if(self.max_index == 0) {
                isComputed = true
            }
            else if (self.max_index == 1) {
                isComputed = true

            }
            else if(self.max_index == 2){
                isComputed = true
            }
            else if (self.max_index == 3) {
                isComputed = true
            }
            else{
                isComputed = true
            }
            
            
        }
        
        
        while(!isComputed) {
            
        }
        
        if(self.max_index == 0) {
            Feeling.text = "I think you feel angry today. Swipe to Continue"
            cover = anger_cover
            cover_songs = anger_songs
        }
        else if(self.max_index == 1) {
            Feeling.text = "I think you feel disgusted today. Swipe to Continue"
            cover = disgust_cover
            cover_songs = disgust_songs
            
        }
        else if(self.max_index == 2){
            Feeling.text = "I think you feel afraid today. Swipe to Continue"
            cover = fear_cover
            cover_songs = fear_songs
            
        }
        else if(self.max_index == 3) {
            Feeling.text = "I think you feel happy today. Swipe to Continue"
            cover = joy_cover
            cover_songs = joy_songs
            
        }
        else {
            Feeling.text = "I think you feel sad today. Swipe to Continue"
            cover = sadness_cover
            cover_songs = sadness_songs
            
        }
        
        
        
        Feeling.isHidden = false
        print(Feeling.text)
        
        // Do any additional setup after loading the view, typically from a nib.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handle_it(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.handle_it(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
    }
    @IBAction func Play(_ sender: UIButton) {
        player.play()
        PlayButton.isHidden = true
        PauseButton.isHidden = false
    }
    
    
    @IBAction func Pause(_ sender: UIButton) {
        player.pause()
        PauseButton.isHidden = true
        PlayButton.isHidden = false
        
    }
    
    
    
    

    
    
    //getting music to play
    func playBackgroundMusic( filename : String) {
        let url = Bundle.main.url(forResource: filename, withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    // Recognizing swipes
    func handle_it(_ gesture: UIGestureRecognizer) {

        let swipeGesture = gesture as? UISwipeGestureRecognizer
                PauseButton.isHidden = false
                Main.isHidden = false
                Song_Name.isHidden = false
                WhiteBox.isHidden = false
                Feeling.isHidden = true
        

        if(swipeGesture!.direction == .left){
            
            var random1 = Int(arc4random_uniform(UInt32(cover_songs.count)))
            while random1 == lastIndex{
                random1 = Int(arc4random_uniform(UInt32(cover_songs.count)))
            }
            lastIndex = random1
            Main.image = UIImage(named: cover)
            Song_Name.text = cover_songs[random1]
            playBackgroundMusic(filename: cover_songs[random1])
            PlayButton.isHidden = true
            PauseButton.isHidden = false
            SaveText.isHidden = true
        }
        
        if(swipeGesture!.direction == .right){
            var random1 = Int(arc4random_uniform(UInt32(cover_songs.count)))
            while random1 == lastIndex{
                random1 = Int(arc4random_uniform(UInt32(cover_songs.count)))
            }
            lastIndex = random1
            Main.image = UIImage(named: cover)
            Song_Name.text = cover_songs[random1]
            playBackgroundMusic(filename: cover_songs[random1])
            PlayButton.isHidden = true
            PauseButton.isHidden = false
            SaveText.isHidden = false
            
            // For duplicated entries
            var counter = 0
            for i in appDelegate.favorites{
                if i == cover_songs[random1]{
                    counter = 1
                }
            }
            if counter == 0{
            appDelegate.favorites.append(cover_songs[random1])
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Answer.delegate = self
        
        PlayButton.isHidden = true
        PauseButton.isHidden = true
        Main.isHidden = true
        Song_Name.isHidden = true
        WhiteBox.isHidden = true
        Feeling.isHidden = true
        SaveText.isHidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.Answer.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        Answer.text = textField.text
    }
    
    
}
