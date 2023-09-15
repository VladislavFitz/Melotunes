import Foundation
import UIKit
import SDWebImage
import Combine

final class PlayerViewController: UIViewController {
  
  private let viewModel: PlayerViewModel
  
  private let coverImageView: UIImageView
  private let titleLabel: UILabel
  private let infoLabel: UILabel
  private let backwardButton: UIButton
  private let playPauseButton: UIButton
  private let forwardButton: UIButton
  private let infinitePlaybackButton: UIButton
  private let elapsedTimeLabel: UILabel
  private let timeLeftLabel: UILabel
  private let progressView: UIProgressView
  
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: PlayerViewModel) {
    self.viewModel = viewModel
    self.coverImageView = .init(autolayout: ())
    self.titleLabel = .init(autolayout: ())
    self.infoLabel = .init(autolayout: ())
    self.backwardButton = .init(autolayout: ())
    self.playPauseButton = .init(autolayout: ())
    self.forwardButton = .init(autolayout: ())
    self.elapsedTimeLabel = .init(autolayout: ())
    self.timeLeftLabel = .init(autolayout: ())
    self.progressView = .init(autolayout: ())
    self.infinitePlaybackButton = .init(autolayout: ())
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupLayout()
    setupTitleLabel()
    setupInfoLabel()
    setupButtons()
    setupBindings()
    setupProgressView()
  }
  
}

private extension PlayerViewController {
  
  @objc func didTapPrev(_ sender: UIButton) {
    viewModel.perform(.backward)
  }
  
  @objc func didTapNext(_ sender: UIButton) {
    viewModel.perform(.forward)
  }
  
  @objc func didTapPlayPause(_ sender: UIButton) {
    viewModel.perform(.playPause)
  }
  
  @objc func didTapInfinitePlayback(_ sender: UIButton) {
    viewModel.perform(.toggleInfinitePlayback)
  }
  
  @objc func didSwipe(_ recognizer: UISwipeGestureRecognizer) {
    let fraction = recognizer.location(in: progressView).x / progressView.bounds.width
    viewModel.perform(.select(Float(fraction)))
  }
  
  func setupProgressView() {
    progressView.transform = CGAffineTransformMakeScale(1, 2)
  }
  
  func setupTitleLabel() {
    titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
  }
  
  func setupInfoLabel() {
    infoLabel.font = .systemFont(ofSize: 16)
    infoLabel.textColor = .systemBlue
  }
  
  func setupButtons() {
    backwardButton.setImage(.backImage, for: .normal)
    backwardButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
    playPauseButton.setImage(.pauseImage, for: .normal)
    playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    forwardButton.setImage(.forwardImage, for: .normal)
    forwardButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    infinitePlaybackButton.setImage(.infinitePlaybackOn, for: .normal)
    infinitePlaybackButton.addTarget(self, action: #selector(didTapInfinitePlayback), for: .touchUpInside)
  }
  
  func setupBindings() {
    viewModel.imageURL
      .sink { [weak coverImageView] url in
        coverImageView?.sd_setImage(with: url)
      }.store(in: &cancellables)
    
    viewModel.info
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: infoLabel)
      .store(in: &cancellables)
    
    viewModel.title
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: titleLabel)
      .store(in: &cancellables)
    
    viewModel.relativeProgress
      .receive(on: DispatchQueue.main)
      .sink { [weak progressView] progress in
        progressView?.setProgress(progress, animated: false)
      }
      .store(in: &cancellables)
    viewModel.elapsedTime
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: elapsedTimeLabel)
      .store(in: &cancellables)
    
    viewModel.timeLeft
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: timeLeftLabel)
      .store(in: &cancellables)
    
    viewModel.$playbackState
      .map { state in
        switch state {
        case .pause:
          return .playImage
        case .playing:
          return .pauseImage
        }
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak playPauseButton] image in
        playPauseButton?.setImage(image, for: .normal)
      }
      .store(in: &cancellables)
    
    viewModel.$isInfinitePlaybackOn
      .map { $0 ? .infinitePlaybackOn : .infinitePlaybackOff }
      .receive(on: DispatchQueue.main)
      .sink { [weak infinitePlaybackButton] image in
        infinitePlaybackButton?.setImage(image, for: .normal)
      }
      .store(in: &cancellables)
  }
  
  func setupLayout() {
    let timingsStack = UIStackView.hStack{
      [
        elapsedTimeLabel,
        .placeholder,
        timeLeftLabel,
      ]
    }
    let progressStack = UIStackView.vStack(spacing: 10) {
      [
        progressView,
        timingsStack,
      ]
    }
    let swipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didSwipe))
    progressStack.addGestureRecognizer(swipeRecognizer)
    let mainStackView = UIStackView.vStack(alignment: .center, spacing: 30) {
      [
        coverImageView,
        .vStack(alignment: .center, spacing: 6) {
          [
            titleLabel,
            infoLabel,
          ]
        },
        progressStack,
        .hStack(spacing: 50) {
          [
            .placeholder,
            backwardButton,
            playPauseButton,
            forwardButton,
            .placeholder,
          ]
        },
        infinitePlaybackButton
      ]
    }
    mainStackView.distribution = .equalSpacing
    view.addSubview(mainStackView)
    mainStackView.pin(top: view.topAnchor,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      leading: view.leadingAnchor,
                      trailing: view.trailingAnchor)
    NSLayoutConstraint.activate([
      progressStack.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.9),
      coverImageView.heightAnchor.constraint(equalTo: view.widthAnchor),
    ])
  }
  
}

private extension UIImage {
  
  private static func largeImage(systemName: String) -> UIImage {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
    return UIImage(systemName: systemName, withConfiguration: largeConfig)!
  }
  
  static let backImage = largeImage(systemName: "backward.fill")
  static let forwardImage = largeImage(systemName: "forward.fill")
  static let playImage = largeImage(systemName: "play.fill")
  static let pauseImage = largeImage(systemName: "pause.fill")
  static let infinitePlaybackOn = largeImage(systemName: "infinity.circle.fill")
  static let infinitePlaybackOff = largeImage(systemName: "infinity.circle")
  
}
