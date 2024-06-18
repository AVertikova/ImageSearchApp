//
//  SearchResultCell.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

protocol ICellButtonsHandler {
    
    func downloadTapped(_ cell: SearchResultCell)
    func pauseTapped(_ cell: SearchResultCell)
    func resumeTapped(_ cell: SearchResultCell)
    func cancelTapped(_ cell: SearchResultCell)
}

final class SearchResultCell: UICollectionViewCell {
    
    static let identifier = String(describing: SearchResultCell.self)
    var delegate: ICellButtonsHandler?
    
    private var downloadingPaused = false
    
    private lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
//    private lazy var downloadButton: UIButton = {
//        let button = createButton()
//        button.addTarget(self, action: #selector(downloadButtonTapped),
//                         for: .touchUpInside)
//        button.setTitle("Download", for: .normal)
//        return button
//    }()
    
//    private lazy var contentStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [resultImageView, downloadButton])
//        stackView.isOpaque = true
//        stackView.layer.masksToBounds = true
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .equalSpacing
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
    
//    private lazy var pauseOrResumeButton: UIButton = {
//        let button = createButton()
//        button.addTarget(self, action: #selector(pauseOrResumeButtonTapped),
//                         for: .touchUpInside)
//        button.setTitle("Pause", for: .normal)
//        return button
//    }()
//    
//    private lazy var cancelButton: UIButton = {
//        let button = createButton()
//        button.addTarget(self, action: #selector(cancelButtonTapped),
//                         for: .touchUpInside)
//        button.setTitle("Cancel", for: .normal)
//        button.tintColor = .systemRed
//        return button
//    }()
//    
//    private var progressLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 11)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        label.widthAnchor.constraint(equalToConstant: 96).isActive = true
//        label.textColor = .label
//        label.backgroundColor = .white
//        
//        return label
//    }()
//    
//    private var progressView: UIProgressView = {
//        let view = UIProgressView(progressViewStyle: .bar)
//        view.tintColor = .darkGray
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupView()
    }
    
   
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
    
}

extension SearchResultCell {
    
    func configure(with image: UIImage, downloaded: Bool, downloadItem: DownloadItem?) {
        resultImageView.image = image
        
//        var showDownloadControl = false
//        
//        if let downloadItem = downloadItem {
//            showDownloadControl = true
//            
//            if downloadItem.isDownloading {
//                pauseOrResumeButton.setTitle("Pause", for: .normal)
//                progressLabel.text = "Downloading..."
//            } else {
//                pauseOrResumeButton.setTitle("Resume", for: .normal)
//                progressLabel.text = "Paused"
//                downloadingPaused = true
//            }
//        }
//        
//        pauseOrResumeButton.isHidden = !showDownloadControl
//        cancelButton.isHidden = !showDownloadControl
//        
//        progressView.isHidden = !showDownloadControl
//        progressLabel.isHidden = !showDownloadControl
        
//        selectionStyle = downloaded ?
//        UITableViewCell.SelectionStyle.gray :
//        UITableViewCell.SelectionStyle.none
//        
//        downloadButton.isHidden = downloaded || showDownloadControl
    }
    
    func updateProgress(progress: Float, totalSize : String) {
//        progressView.progress = progress
//        progressLabel.text = String(format: "%.1f%% of %@", progress * 100, totalSize)
    }
}

private extension SearchResultCell {
    
    func setupView() {
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addSubview(resultImageView)
//        contentView.addSubview(downloadButton)
//        contentView.addSubview(pauseOrResumeButton)
//        contentView.addSubview(cancelButton)
//        contentView.addSubview(progressLabel)
//        contentView.addSubview(progressView)
        
//        contentView.addSubview(contentStackView)
        
        
//
        
        NSLayoutConstraint.activate([
            
            resultImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            resultImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            resultImageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            
            
//            downloadButton.topAnchor.constraint(equalTo: resultImageView.bottomAnchor, constant: 24),
//            downloadButton.centerXAnchor.constraint(equalTo: resultImageView.centerXAnchor),
//            downloadButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 4)
            
//            contentStackView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
//            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
//            contentStackView.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor),
//            contentStackView.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor),
            
//            pauseOrResumeButton.leadingAnchor.constraint(equalTo: resultImageView.trailingAnchor, constant: 34),
//            pauseOrResumeButton.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
//            
//            cancelButton.leadingAnchor.constraint(equalTo: pauseOrResumeButton.trailingAnchor, constant: 4),
//            cancelButton.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
//            
//            progressLabel.centerXAnchor.constraint(equalTo: downloadButton.centerXAnchor),
//            progressLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
//            
//            progressView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -8),
//            progressView.topAnchor.constraint(equalTo: pauseOrResumeButton.bottomAnchor, constant: 8),
//            progressView.heightAnchor.constraint(equalToConstant: 8),
//            progressView.widthAnchor.constraint(equalToConstant: 150),
            
        ])
    }
}

private extension SearchResultCell {
    
    @objc func downloadButtonTapped() {
        print("Tapped")
        delegate?.downloadTapped(self)
    }
    
    @objc func pauseOrResumeButtonTapped() {
        if downloadingPaused {
            delegate?.resumeTapped(self)
        } else {
            delegate?.pauseTapped(self)
        }
        downloadingPaused.toggle()
    }
    
    @objc func cancelButtonTapped() {
        delegate?.cancelTapped(self)
    }
    
    func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.backgroundColor = .white
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 96).isActive = true
        
        return button
    }
}
