//
//  BookAddViewController.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

protocol BookAddViewControllerDelegate : class {

    func bookAddViewController(controller:BookAddViewController, didSuccessfullyAddWithBook book: Book?, user : User?)
}

class BookAddViewController: UIViewController {
    @IBOutlet weak var categoryPickerView: UIPickerView!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var ratingView: BookRatingView!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var bookNameTextField: UITextField!
    @IBOutlet weak var AuthorNameTextField: UITextField!
    @IBOutlet weak var rateThisLabel: UILabel!
    var viewModel = BookAddingViewModel()

    weak var delegate : BookAddViewControllerDelegate?

    private var category = Book.Category.None
    private var rating = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.hidden = true
        detailTextView.delegate = self
        detailTextView.layer.cornerRadius = 2.0
        categoryButton.layer.cornerRadius = 2.0
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        scrollView.delegate = self
        ratingView.delegate = self
//        ratingView.initialRatings = 
        addShadowToTheTextfields()
    }

    private func addShadowToTheTextfields() {

        bookNameTextField.layer.shadowRadius = 2.0
        bookNameTextField.layer.shadowOpacity = 0.5

        AuthorNameTextField.layer.shadowRadius = 2.0
        AuthorNameTextField.layer.shadowOpacity = 0.5
        
    }

    @IBAction func categoryButtonDidClick(sender: AnyObject) {
        view.endEditing(true)
        categoryPickerView.hidden = false
        categoryPickerView.alpha = 0.0
        UIView.animateWithDuration(0.5) {
            self.categoryPickerView.alpha = 1.0
        }

        view.bringSubviewToFront(categoryPickerView)
    }
    
    @IBAction func cancelButtonDidClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveButtonDidClick(sender: AnyObject) {
        if let bookName = bookNameTextField.text, authorName = AuthorNameTextField.text {
            viewModel.updateTheBook(bookName, authorName: authorName, category: category, details: detailTextView.text, rating: Float(rating), update : false, completion: {
                Async.main{
                    self.alert("New Book is added successfully", title: "Book Added", okayCompeltion: { 
                        self.delegate?.bookAddViewController(self,didSuccessfullyAddWithBook: self.viewModel.book, user: self.viewModel.user)
                    })
                }
            })
        }
    }
}

extension BookAddViewController : UIPickerViewDataSource {
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Book.Category.allItems.count
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension BookAddViewController : UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UIView.animateWithDuration(0.3) {
            self.categoryPickerView.alpha = 0.0
            self.categoryPickerView.hidden = true
        }
        category = Book.Category.allItems[row]
        categoryButton.setTitle(Book.Category.allItems[row].rawValue, forState: .Normal)
    }

    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let category = Book.Category.allItems[row]
        let attributedString = NSAttributedString(string: category.rawValue, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
        return attributedString
    }
}

extension BookAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0,y:200), animated: true)
    }
    func textViewDidChange(textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0,y:200), animated: true)
    }
}

extension BookAddViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        categoryPickerView.hidden = true
    }
}
extension BookAddViewController : BookRatingViewDelegate {
    func bookRatingViewDidSelectRatingButtonsUptoIndex(ratingIndex: Int) {
        rating = ratingIndex
    }
}
extension UIViewController {
    func alert(message: String, title: String, okayCompeltion : ViewModelCompletion) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            okayCompeltion()
        }
        controller.addAction(okAction)

        self.presentViewController(controller, animated: true, completion: nil)
    }
}