import UIKit

class LayoutConfigurator {
    
    struct Config {
        let parentView: UIView
        let header: UIView?
        let scrollView: UIScrollView
        let contentView: UIView
        let title: UIView?
        let isHintActive: Bool?
        let exerciseText: UITextView
        let hintWidget: UIView?
        let collectionView: UICollectionView?
        let collectionViewItemsCount: Int?
        let collectionViewItemsHeight: Int?
        let collectionViewVerticalSpacing: Int?
        let okButton: UIView?

        init(
            parentView: UIView,
            header: UIView? = nil,
            scrollView: UIScrollView,
            contentView: UIView,
            title: UIView? = nil,
            isHintActive: Bool? = nil,
            exerciseText: UITextView,
            hintWidget: UIView? = nil,
            collectionView: UICollectionView? = nil,
            collectionViewItemsCount: Int? = nil,
            collectionViewItemsHeight: Int? = 60,
            collectionViewVerticalSpacing: Int? = 10,
            okButton: UIButton? = nil
        ) {
            self.parentView = parentView
            self.header = header
            self.scrollView = scrollView
            self.contentView = contentView
            self.title = title
            self.isHintActive = isHintActive
            self.exerciseText = exerciseText
            self.hintWidget = hintWidget
            self.collectionView = collectionView
            self.collectionViewItemsCount = collectionViewItemsCount
            self.collectionViewItemsHeight = collectionViewItemsHeight
            self.collectionViewVerticalSpacing = collectionViewVerticalSpacing
            self.okButton = okButton
        }
    }

    
    static func configure(using config: Config) -> NSLayoutConstraint {
        let parent = config.parentView
        let header = config.header
        let scrollView = config.scrollView
        let contentView = config.contentView
        let exerciseText = config.exerciseText
        let title = config.title
        let isHintActive = config.isHintActive
        let hintWidget = config.hintWidget
        let collectionView = config.collectionView
        let collectionViewItemsCount = config.collectionViewItemsCount ?? 1
        let collectionViewItemsHeight = config.collectionViewItemsHeight ?? 60
        let collectionViewVerticalSpacing = config.collectionViewVerticalSpacing ?? 10
        let okButton = config.okButton
        
        var okButtonUpInstent: CGFloat
        
        // MARK: - Header
        if let header = header {
            parent.addSubview(header)
            header.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 16),
                header.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
                header.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16),
                header.heightAnchor.constraint(equalToConstant: 67)
            ])
        }
        
        // MARK: - ScrollView
        parent.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollTopAnchor = header?.bottomAnchor ?? parent.safeAreaLayoutGuide.topAnchor
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: scrollTopAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
        
        var lastBottomAnchor: NSLayoutYAxisAnchor = contentView.topAnchor
        
        // MARK: - Title
        
        if let title = config.title {
            contentView.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                title.topAnchor.constraint(equalTo: lastBottomAnchor, constant:0),
                title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])
            lastBottomAnchor = title.bottomAnchor
        }
        

        // MARK: - ExerciseText
        contentView.addSubview(exerciseText)
        exerciseText.translatesAutoresizingMaskIntoConstraints = false
        exerciseText.isScrollEnabled = false
        
        let exerciseTextHeight = exerciseText.heightAnchor.constraint(equalToConstant: 0)
        exerciseTextHeight.priority = .defaultHigh
        exerciseTextHeight.isActive = true
        
        NSLayoutConstraint.activate([
            exerciseText.topAnchor.constraint(equalTo: lastBottomAnchor, constant: 20),
            exerciseText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            exerciseText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        lastBottomAnchor = exerciseText.bottomAnchor
        
        
        // MARK: - HintWidget (optional)
        if config.isHintActive != nil, let hintWidget = config.hintWidget {
            hintWidget.isHidden = false
            contentView.addSubview(hintWidget)
            hintWidget.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                hintWidget.topAnchor.constraint(equalTo: lastBottomAnchor, constant: 40),
                hintWidget.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                hintWidget.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            ])

            lastBottomAnchor = hintWidget.bottomAnchor
        }

//        MARK: - CollectionView (optional)
        if let collectionView = config.collectionView,
           let itemCount = config.collectionViewItemsCount {
            contentView.addSubview(collectionView)
                    collectionView.translatesAutoresizingMaskIntoConstraints = false
                    
            let (layout, height) = LayoutConfigurator.createVerticalLayout(itemCount: collectionViewItemsCount, itemHeight: CGFloat(collectionViewItemsHeight), spacing: CGFloat(collectionViewVerticalSpacing))
                    collectionView.collectionViewLayout = layout
            collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
            contentView.addSubview(config.collectionView!)
            config.collectionView?.translatesAutoresizingMaskIntoConstraints = false
                            
                    NSLayoutConstraint.activate([
                        collectionView.topAnchor.constraint(equalTo: lastBottomAnchor, constant: 40),
                        collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        collectionView.heightAnchor.constraint(equalToConstant: height),
                        //collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
                    ])
            print("Collection view in LayoutConfigurator: ", height)
            okButtonUpInstent = 60
            lastBottomAnchor = collectionView.bottomAnchor
        }
        else
        {
            okButtonUpInstent = 40
        }
        
        //MARK: - OkButton
        
        if config.okButton != nil, let okButton = config.okButton {

            contentView.addSubview(okButton)
            okButton.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                okButton.topAnchor.constraint(equalTo: lastBottomAnchor, constant: okButtonUpInstent),
                okButton.heightAnchor.constraint(equalToConstant: 40),
                okButton.widthAnchor.constraint(equalToConstant: 189),
                okButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0)

            ])
            
            lastBottomAnchor = okButton.bottomAnchor
        }
        
        // MARK: - ContentView
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: lastBottomAnchor, constant: 40),
            
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: lastBottomAnchor, constant: 40), // ← ключевая строка
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)

        ])
        
         lastBottomAnchor = contentView.topAnchor
        

        return exerciseTextHeight
    }
    
    static func updateTextViewHeight(_ textView: UITextView, heightConstraint: NSLayoutConstraint) {
        let fittingSize = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let size = textView.sizeThatFits(fittingSize)
        heightConstraint.constant = size.height
    }
    
    public static func createVerticalLayout(itemCount: Int, itemHeight: CGFloat, spacing: CGFloat) -> (UICollectionViewLayout, CGFloat) {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(itemHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        let layout = UICollectionViewCompositionalLayout(section: section)

        let totalHeight = (CGFloat(itemCount) * itemHeight) + (CGFloat(itemCount - 1) * spacing)

        return (layout, totalHeight)
    }




}

