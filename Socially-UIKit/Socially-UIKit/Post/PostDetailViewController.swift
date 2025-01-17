//
//  PostDetailViewController.swift
//  Socially-UIKit
//
//  Created by Jungman Bae on 7/26/24.
//

import UIKit

class PostDetailViewController: UIViewController {
    var post: Post
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post Detail"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupUI()
        configureWithPost()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(systemItem: .trash, primaryAction: UIAction { [weak self] _ in
                if let post = self?.post {
                    PostService.shared.deletePost(post: post) { result in
                        switch result {
                        case .success:
                            DispatchQueue.main.async {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        case .failure(let error):
                            print("error: \(error)")
                        }
                    }
                }
            }),
            UIBarButtonItem(systemItem: .edit, primaryAction: UIAction { [weak self] _ in
                let alertController = UIAlertController(title: "Edit Post", message: "Update the description", preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.text = self?.post.description
                }
                let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                    guard let self = self, let newDescription = alertController.textFields?.first?.text else { return }
                    PostService.shared.updatePost(post: self.post, newDescription: newDescription) { result in
                        switch result {
                        case .success(let updatedPost):
                            self.post = updatedPost
                            self.configureWithPost()
                        case .failure(let error):
                            print("Failed to update post: \(error.localizedDescription)")
                            // Show error alert
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(saveAction)
                alertController.addAction(cancelAction)
                self?.present(alertController, animated: true, completion: nil)
            })
        ]
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 320),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Configuration
    private func configureWithPost() {
        if let imageURLString = post.imageURL,
           let imageURL = URL(string: imageURLString) {
            imageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "photo.artframe"))
        }
        
        descriptionLabel.text = post.description
        
        nameLabel.text = post.userName
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = "Posted on " + dateFormatter.string(from: post.datePublished ?? Date())
    }

}
