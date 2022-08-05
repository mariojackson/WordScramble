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
    
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    func submit(_ answer: String) {
        let lowerCasedAnswer = answer.lowercased()
        
        if isPossible(word: lowerCasedAnswer) &&
            isOriginal(word: lowerCasedAnswer) &&
            isReal(word: lowerCasedAnswer) {
            
            usedWords.insert(answer, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func isPossible(word: String) -> Bool {
        return true
    }
    
    func isOriginal(word: String) -> Bool {
       return true
    }
    
    func isReal(word: String) -> Bool {
        return true
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


