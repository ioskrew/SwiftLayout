# Real-world Examples

This document provides complete, production-ready examples of migrating common UI components from AutoLayout to SwiftLayout.

## Table of Contents
1. [Login Screen](#login-screen)
2. [Custom Table View Cell](#custom-table-view-cell)
3. [Adaptive Dashboard](#adaptive-dashboard)
4. [Modal Presentation](#modal-presentation)

## Login Screen

A complete login screen with text fields, buttons, and keyboard handling.

### SwiftLayout Implementation

```swift
class LoginViewController: UIViewController, Layoutable {
    var activation: Activation?
    
    // UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let forgotPasswordButton = UIButton()
    let signUpButton = UIButton()
    
    @LayoutProperty var keyboardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupKeyboardObservers()
        sl.updateLayout()
    }
    
    @LayoutBuilder
    var layout: some Layout {
        view.sl.sublayout {
            scrollView.sl.anchors {
                Anchors.allSides.equalTo(view.safeAreaLayoutGuide)
            }.sublayout {
                contentView.sl.anchors {
                    Anchors.allSides.equalToSuper()
                    Anchors.width.equalToSuper()
                }.sublayout {
                    createLoginFormLayout()
                }
            }
        }
    }
    
    @LayoutBuilder
    private func createLoginFormLayout() -> some Layout {
        // Logo
        logoImageView.sl.anchors {
            Anchors.top.equalToSuper(constant: 60)
            Anchors.centerX.equalToSuper()
            Anchors.size.equalTo(width: 100, height: 100)
        }
        
        // Title
        titleLabel.sl.anchors {
            Anchors.top.equalTo(logoImageView, attribute: .bottom, constant: 30)
            Anchors.centerX.equalToSuper()
        }
        
        // Email field
        emailTextField.sl.anchors {
            Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 50)
            Anchors.horizontal.equalToSuper(constant: 30)
            Anchors.height.equalTo(constant: 50)
        }
        
        // Password field
        passwordTextField.sl.anchors {
            Anchors.top.equalTo(emailTextField, attribute: .bottom, constant: 20)
            Anchors.horizontal.equalTo(emailTextField)
            Anchors.height.equalTo(emailTextField)
        }
        
        // Login button
        loginButton.sl.anchors {
            Anchors.top.equalTo(passwordTextField, attribute: .bottom, constant: 30)
            Anchors.horizontal.equalTo(emailTextField)
            Anchors.height.equalTo(constant: 50)
        }
        
        // Forgot password
        forgotPasswordButton.sl.anchors {
            Anchors.top.equalTo(loginButton, attribute: .bottom, constant: 20)
            Anchors.centerX.equalToSuper()
        }
        
        // Sign up button
        signUpButton.sl.anchors {
            Anchors.top.equalTo(forgotPasswordButton, attribute: .bottom, constant: 40)
            Anchors.centerX.equalToSuper()
            Anchors.bottom.equalToSuper(constant: -30 - keyboardHeight)
                .priority(.init(999))
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        logoImageView.image = UIImage(systemName: "person.circle.fill")
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "Welcome Back"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 8
        loginButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.setTitleColor(.systemBlue, for: .normal)
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 14)
        
        signUpButton.setTitle("Don't have an account? Sign Up", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 16)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.keyboardHeight = keyboardFrame.height
            self.sl.updateLayout(forceLayout: true)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.keyboardHeight = 0
            self.sl.updateLayout(forceLayout: true)
        }
    }
}
```

## Custom Table View Cell

A custom table view cell with complex layout and dynamic content.

### SwiftLayout Implementation

```swift
class FeedItemCell: UITableViewCell, Layoutable {
    var activation: Activation?
    
    // UI Components
    let containerView = UIView()
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let contentTextLabel = UILabel()
    let contentImageView = UIImageView()
    let actionStackView = UIView()
    let likeButton = UIButton()
    let commentButton = UIButton()
    let shareButton = UIButton()
    
    @LayoutProperty var hasImage: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        sl.updateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @LayoutBuilder
    var layout: some Layout {
        contentView.sl.sublayout {
            containerView.sl.anchors {
                Anchors.allSides.equalToSuper(constant: 12)
            }.sublayout {
                // Avatar
                avatarImageView.sl.anchors {
                    Anchors.leading.equalToSuper(constant: 16)
                    Anchors.top.equalToSuper(constant: 16)
                    Anchors.size.equalTo(width: 48, height: 48)
                }
                
                // Name and time
                nameLabel.sl.anchors {
                    Anchors.leading.equalTo(avatarImageView, attribute: .trailing, constant: 12)
                    Anchors.top.equalTo(avatarImageView, constant: 4)
                    Anchors.trailing.lessThanOrEqualTo(timeLabel, attribute: .leading, constant: -8)
                        .priority(.defaultHigh)
                }
                
                timeLabel.sl.anchors {
                    Anchors.trailing.equalToSuper(constant: -16)
                    Anchors.centerY.equalTo(nameLabel)
                    Anchors.width.greaterThanOrEqualTo(constant: 50)
                        .priority(.init(751))
                }
                
                // Content text
                contentTextLabel.sl.anchors {
                    Anchors.top.equalTo(avatarImageView, attribute: .bottom, constant: 12)
                    Anchors.horizontal.equalToSuper(constant: 16)
                    
                    if !hasImage {
                        Anchors.bottom.equalTo(actionStackView, attribute: .top, constant: -16)
                            .priority(.init(999))
                    }
                }
                
                // Content image (conditional)
                if hasImage {
                    contentImageView.sl.anchors {
                        Anchors.top.equalTo(contentTextLabel, attribute: .bottom, constant: 12)
                        Anchors.horizontal.equalToSuper()
                        Anchors.height.equalTo(contentImageView, attribute: .width)
                            .multiplier(0.6)
                            .priority(.almostRequired)
                        Anchors.bottom.equalTo(actionStackView, attribute: .top, constant: -16)
                            .priority(.init(999))
                    }
                }
                
                // Action buttons
                actionStackView.sl.anchors {
                    Anchors.horizontal.equalToSuper()
                    Anchors.bottom.equalToSuper()
                    Anchors.height.equalTo(constant: 44)
                }.sublayout {
                    createActionButtons()
                }
            }
        }
    }
    
    @LayoutBuilder
    private func createActionButtons() -> some Layout {
        likeButton.sl.anchors {
            Anchors.leading.equalToSuper(constant: 16)
            Anchors.centerY.equalToSuper()
            Anchors.width.equalToSuper()
                .multiplier(0.3)
                .priority(.defaultHigh)
        }
        
        commentButton.sl.anchors {
            Anchors.centerX.equalToSuper()
            Anchors.centerY.equalToSuper()
            Anchors.width.equalTo(likeButton)
        }
        
        shareButton.sl.anchors {
            Anchors.trailing.equalToSuper(constant: -16)
            Anchors.centerY.equalToSuper()
            Anchors.width.equalTo(likeButton)
        }
    }
    
    private func setupViews() {
        selectionStyle = .none
        
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12
        
        avatarImageView.layer.cornerRadius = 24
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = .systemGray5
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .secondaryLabel
        
        contentTextLabel.font = .systemFont(ofSize: 15)
        contentTextLabel.numberOfLines = 0
        
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.clipsToBounds = true
        contentImageView.layer.cornerRadius = 8
        contentImageView.backgroundColor = .systemGray6
        
        [likeButton, commentButton, shareButton].forEach { button in
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.setTitleColor(.secondaryLabel, for: .normal)
        }
        
        likeButton.setTitle("Like", for: .normal)
        commentButton.setTitle("Comment", for: .normal)
        shareButton.setTitle("Share", for: .normal)
    }
    
    func configure(with item: FeedItem) {
        nameLabel.text = item.authorName
        timeLabel.text = item.timeAgo
        contentTextLabel.text = item.content
        hasImage = item.imageURL != nil
        
        if let imageURL = item.imageURL {
            // Load image
        }
        
        sl.updateLayout()
    }
}
```

## Adaptive Dashboard

A dashboard that adapts to different screen sizes and orientations.

### SwiftLayout Implementation

```swift
class DashboardViewController: UIViewController, Layoutable {
    var activation: Activation?
    
    // UI Components
    let headerView = UIView()
    let statsContainerView = UIView()
    let chartContainerView = UIView()
    let tableView = UITableView()
    
    @LayoutProperty var isCompact: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateSizeClass()
        sl.updateLayout()
    }
    
    @LayoutBuilder
    var layout: some Layout {
        view.sl.sublayout {
            // Header
            headerView.sl.anchors {
                Anchors.cap.equalTo(view.safeAreaLayoutGuide)
                Anchors.height.equalTo(constant: isCompact ? 80 : 100)
                    .priority(.almostRequired)
            }.sublayout {
                createHeaderLayout()
            }
            
            if isCompact {
                createCompactLayout()
            } else {
                createRegularLayout()
            }
        }
    }
    
    @LayoutBuilder
    private func createCompactLayout() -> some Layout {
        // Vertical stack for compact screens
        statsContainerView.sl.anchors {
            Anchors.top.equalTo(headerView, attribute: .bottom, constant: 16)
            Anchors.horizontal.equalToSuper(constant: 16)
            Anchors.height.equalTo(constant: 120)
        }
        
        chartContainerView.sl.anchors {
            Anchors.top.equalTo(statsContainerView, attribute: .bottom, constant: 16)
            Anchors.horizontal.equalToSuper(constant: 16)
            Anchors.height.equalTo(constant: 200)
        }
        
        tableView.sl.anchors {
            Anchors.top.equalTo(chartContainerView, attribute: .bottom, constant: 16)
            Anchors.horizontal.equalToSuper()
            Anchors.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @LayoutBuilder
    private func createRegularLayout() -> some Layout {
        // Side-by-side layout for regular screens
        statsContainerView.sl.anchors {
            Anchors.top.equalTo(headerView, attribute: .bottom, constant: 20)
            Anchors.leading.equalToSuper(constant: 20)
            Anchors.width.equalToSuper()
                .multiplier(0.35)
                .priority(.almostRequired)
            Anchors.bottom.equalTo(view.safeAreaLayoutGuide, constant: -20)
        }
        
        // Right side container
        let rightContainer = UIView()
        rightContainer.sl.anchors {
            Anchors.top.equalTo(statsContainerView)
            Anchors.leading.equalTo(statsContainerView, attribute: .trailing, constant: 20)
            Anchors.trailing.equalToSuper(constant: -20)
            Anchors.bottom.equalTo(statsContainerView)
        }.sublayout {
            chartContainerView.sl.anchors {
                Anchors.cap.equalToSuper()
                Anchors.height.equalToSuper()
                    .multiplier(0.4)
                    .priority(.almostRequired)
            }
            
            tableView.sl.anchors {
                Anchors.top.equalTo(chartContainerView, attribute: .bottom, constant: 20)
                Anchors.horizontal.equalToSuper()
                Anchors.bottom.equalToSuper()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.updateSizeClass()
        })
    }
    
    private func updateSizeClass() {
        let width = view.bounds.width
        isCompact = width < 600
    }
}
```

## Modal Presentation

A modal view with dynamic height and keyboard handling.

### SwiftLayout Implementation

```swift
class ModalViewController: UIViewController, Layoutable {
    var activation: Activation?
    
    // UI Components
    let containerView = UIView()
    let dragIndicator = UIView()
    let titleLabel = UILabel()
    let closeButton = UIButton()
    let contentScrollView = UIScrollView()
    let contentView = UIView()
    let textView = UITextView()
    let actionButton = UIButton()
    
    @LayoutProperty var keyboardHeight: CGFloat = 0
    @LayoutProperty var isExpanded: Bool = false
    
    @LayoutBuilder
    var layout: some Layout {
        view.sl.sublayout {
            containerView.sl.anchors {
                Anchors.horizontal.equalToSuper()
                
                if keyboardHeight > 0 {
                    Anchors.bottom.equalToSuper(constant: -keyboardHeight)
                } else {
                    Anchors.bottom.equalTo(view.safeAreaLayoutGuide)
                }
                
                if isExpanded {
                    Anchors.top.equalTo(view.safeAreaLayoutGuide, constant: 40)
                        .priority(.defaultHigh)
                } else {
                    Anchors.height.equalTo(constant: 400)
                        .priority(.defaultHigh)
                    Anchors.height.lessThanOrEqualToSuper()
                        .multiplier(0.8)
                        .priority(.required)
                }
            }.sublayout {
                createModalContent()
            }
        }
    }
    
    @LayoutBuilder
    private func createModalContent() -> some Layout {
        // Drag indicator
        dragIndicator.sl.anchors {
            Anchors.top.equalToSuper(constant: 8)
            Anchors.centerX.equalToSuper()
            Anchors.size.equalTo(width: 40, height: 4)
        }
        
        // Header
        titleLabel.sl.anchors {
            Anchors.top.equalTo(dragIndicator, attribute: .bottom, constant: 20)
            Anchors.leading.equalToSuper(constant: 20)
            Anchors.trailing.equalTo(closeButton, attribute: .leading, constant: -12)
        }
        
        closeButton.sl.anchors {
            Anchors.centerY.equalTo(titleLabel)
            Anchors.trailing.equalToSuper(constant: -20)
            Anchors.size.equalTo(width: 30, height: 30)
        }
        
        // Content
        contentScrollView.sl.anchors {
            Anchors.top.equalTo(titleLabel, attribute: .bottom, constant: 20)
            Anchors.horizontal.equalToSuper()
            Anchors.bottom.equalTo(actionButton, attribute: .top, constant: -20)
        }.sublayout {
            contentView.sl.anchors {
                Anchors.allSides.equalToSuper()
                Anchors.width.equalToSuper()
            }.sublayout {
                textView.sl.anchors {
                    Anchors.allSides.equalToSuper(constant: 20)
                    Anchors.height.greaterThanOrEqualTo(constant: 150)
                        .priority(.defaultLow)
                }
            }
        }
        
        // Action button
        actionButton.sl.anchors {
            Anchors.horizontal.equalToSuper(constant: 20)
            Anchors.bottom.equalToSuper(constant: -20)
            Anchors.height.equalTo(constant: 50)
        }
    }
}
```

## Summary

These real-world examples demonstrate:

1. **Complete Components**: Full implementations ready for production
2. **Dynamic Behavior**: Keyboard handling, size class adaptation
3. **Complex Layouts**: Multi-level hierarchies with various constraints
4. **Best Practices**: Clean code organization and reusable patterns

For migration best practices and tips, see [Best Practices](best-practices.md).