import UIKit

class LayoutConfigurator {
    
    struct Config {
        let parentView: UIView
        let header: UIView?
        let scrollView: UIScrollView
        let contentView: UIView
        let exerciseText: UITextView
        let isHintActive: Bool
        let hintWidget: UIView
        let collectionView: UICollectionView
        let collectionViewItemsCount: Int
    }
    
    static func configure(using config: Config) -> NSLayoutConstraint {
        let parent = config.parentView
        let header = config.header
        let scrollView = config.scrollView
        let contentView = config.contentView
        let exerciseText = config.exerciseText
        let isHintActive = config.isHintActive
        let hintWidget = config.hintWidget
        let collectionView = config.collectionView
        let collectionViewItemsCount = config.collectionViewItemsCount
        
        // MARK: - Header
        if let header = header {
            parent.addSubview(header)
            header.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                header.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: 16),
                header.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 16),
                header.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -16),
                header.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
        
        // MARK: - ScrollView
        parent.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollTopAnchor = header?.bottomAnchor ?? parent.safeAreaLayoutGuide.topAnchor
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: scrollTopAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
        
        
        // MARK: - ExerciseText
        contentView.addSubview(exerciseText)
        exerciseText.translatesAutoresizingMaskIntoConstraints = false
        exerciseText.isScrollEnabled = false
        
        let exerciseTextHeight = exerciseText.heightAnchor.constraint(equalToConstant: 0)
        exerciseTextHeight.priority = .defaultHigh
        exerciseTextHeight.isActive = true
        
        NSLayoutConstraint.activate([
            exerciseText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            exerciseText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            exerciseText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        var lastBottomAnchor = exerciseText.bottomAnchor
        
        // MARK: - HintWidget (optional)
        if isHintActive {
            hintWidget.isHidden = false
            contentView.addSubview(hintWidget)
            hintWidget.translatesAutoresizingMaskIntoConstraints = false
            
            hintWidget.setContentHuggingPriority(.required, for: .vertical)
            hintWidget.setContentCompressionResistancePriority(.required, for: .vertical)
            
            NSLayoutConstraint.activate([
                hintWidget.topAnchor.constraint(equalTo: lastBottomAnchor, constant: 40),
                hintWidget.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                hintWidget.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
                // ❗️ Не задаём heightAnchor — пусть Auto Layout сам решает
            ])
            
            lastBottomAnchor = hintWidget.bottomAnchor
        } else {
            hintWidget.isHidden = true
        }
        
        
        // MARK: - CollectionView (dynamic height)
        //contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let (layout, height) = LayoutConfigurator.createVerticalLayout(itemCount: collectionViewItemsCount)
        collectionView.collectionViewLayout = layout
collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        contentView.addSubview(config.collectionView)
         config.collectionView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: lastBottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: height),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        // MARK: - ContentView
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        

        return exerciseTextHeight
    }
    
    static func updateTextViewHeight(_ textView: UITextView, heightConstraint: NSLayoutConstraint) {
        let fittingSize = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        let size = textView.sizeThatFits(fittingSize)
        heightConstraint.constant = size.height
    }
    
    public static func createVerticalLayout(itemCount: Int, itemHeight: CGFloat = 60, spacing: CGFloat = 10) -> (UICollectionViewLayout, CGFloat) {
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

