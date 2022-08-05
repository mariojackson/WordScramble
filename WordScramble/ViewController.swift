//
//  ViewController.swift
//  WordScramble
//
//  Created by Mario Jackson on 8/5/22.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    private var errorTitle: String = ""
    private var errorMessage: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") else {
            allWords = ["silkworm"]
            return
        }
        
        if let startWords = try? String(contentsOf: startWordsURL) {
            allWords = startWords.components(separatedBy: "\n")
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(promptForAnswer)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(startGame)
        )
    
        startGame()
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func submit(_ answer: String) {
        if !isWordValid(word: answer) {
            showError()
            return
        }
        
        usedWords.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else {
            return false
        }
            
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(where: { $0.lowercased() == word })
    }
    
    func isReal(word: String) -> Bool {
        if word.utf16.count <= 1 {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isWordValid(word: String) -> Bool {
        let lowerCasedAnswer = word.lowercased()
        var valid = true
        
        if !isPossible(word: lowerCasedAnswer) {
            errorTitle = "Word not possible"
            errorMessage = "Your can't spell that word from \(title ?? "invalid word given")"
            valid = false
        }
        
        if valid && !isOriginal(word: lowerCasedAnswer) {
            errorTitle = "Word used already"
            errorMessage = "Let your creativity flow more!"
            valid = false
        }
        
        if valid && !isReal(word: lowerCasedAnswer) {
            errorTitle = "Word not reconized"
            errorMessage = "You can't just make them up, you know!"
            valid = false
        }
        
        return valid
    }
    
    func showError() {
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    @objc func promptForAnswer() {
        let alertController = UIAlertController(
            title: "Enter answer",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alertController] action in
            guard let answer = alertController?.textFields?[0].text else {
                return
            }
            
            self?.submit(answer)
        }
        
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    // Mark - Method Overrides
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}


