import Foundation
import UIKit
import SDWebImage
import Combine

final class PlayerViewController: UIViewController {
  
  let viewModel: PlayerViewModel
  
  private let coverImageView: UIImageView
  private let titleLabel: UILabel
  private let infoLabel: UILabel
  private let albumButton: UIButton
  private let playbackProgressPanel: PlaybackProgressPanel
  private let playbackControlPanel: PlaybackControlPanel
  private let playbackModePanel: PlaybackModePanel
  
  private var cancellables = Set<AnyCancellable>()
  
  init(viewModel: PlayerViewModel) {
    self.viewModel = viewModel
    self.coverImageView = .init(autolayout: ())
    self.titleLabel = .init(autolayout: ())
    self.infoLabel = .init(autolayout: ())
    self.albumButton = .init(autolayout: ())
    self.playbackProgressPanel = .init(autolayout: ())
    self.playbackControlPanel = .init(autolayout: ())
    self.playbackModePanel = .init(autolayout: ())
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
    let fraction = recognizer.location(in: playbackProgressPanel.progressView).x / playbackProgressPanel.progressView.bounds.width
    viewModel.perform(.select(Float(fraction)))
  }
  
  @objc func didTap(_ recognizer: UITapGestureRecognizer) {
    let fraction = recognizer.location(in: playbackProgressPanel.progressView).x / playbackProgressPanel.progressView.bounds.width
    viewModel.perform(.select(Float(fraction)))
  }
  
  @objc func didTapRepeat(_ sender: UIButton) {
    viewModel.toggleRepeat()
  }
  
  @objc func didTapShuffle(_ sender: UIButton) {
    viewModel.toggleShuffle()
  }
  
  @objc func didTapAlbumButton(_ sender: UIButton) {
    viewModel.perform(.tapAlbum)
  }
  
  func setupTitleLabel() {
    titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
  }
  
  func setupInfoLabel() {
    infoLabel.font = .systemFont(ofSize: 16)
    infoLabel.textColor = .systemBlue
  }
  
  func setupButtons() {
    albumButton.setTitleColor(.systemBlue, for: .normal)
    albumButton.addTarget(self, action: #selector(didTapAlbumButton), for: .touchUpInside)
    playbackControlPanel.backwardButton.addTarget(self, action: #selector(didTapPrev), for: .touchUpInside)
    playbackControlPanel.playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    playbackControlPanel.forwardButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    playbackModePanel.repeatButton.addTarget(self, action: #selector(didTapRepeat), for: .touchUpInside)
    playbackModePanel.shuffleButton.addTarget(self, action: #selector(didTapShuffle), for: .touchUpInside)
    let swipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didSwipe))
    playbackProgressPanel.addGestureRecognizer(swipeRecognizer)
    let tapGecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    playbackProgressPanel.addGestureRecognizer(tapGecognizer)
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
    
    viewModel.info
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak albumButton] info in
        albumButton?.setTitle(info, for: .normal)
      })
      .store(in: &cancellables)
    
    viewModel.title
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: titleLabel)
      .store(in: &cancellables)
    
    viewModel.relativeProgress
      .receive(on: DispatchQueue.main)
      .sink { [weak playbackProgressPanel] progress in
        playbackProgressPanel?.progressView.setProgress(progress, animated: false)
      }
      .store(in: &cancellables)
    viewModel.elapsedTime
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: playbackProgressPanel.elapsedTimeLabel)
      .store(in: &cancellables)
    
    viewModel.timeLeft
      .receive(on: DispatchQueue.main)
      .assign(to: \.text, on: playbackProgressPanel.timeLeftLabel)
      .store(in: &cancellables)
    
    viewModel.$playbackState
      .map { state in
        switch state {
        case .pause:
          return false
        case .playing:
          return true
        }
      }
      .receive(on: DispatchQueue.main)
      .assign(to: \.isPlaying, on: playbackControlPanel)
      .store(in: &cancellables)
    
    viewModel.$isShuffleOn
      .receive(on: DispatchQueue.main)
      .sink { [weak playbackModePanel] isShuffleOn in
        playbackModePanel?.isShuffleOn = isShuffleOn
      }
      .store(in: &cancellables)
    
    viewModel.$repeatMode
      .receive(on: DispatchQueue.main)
      .sink { [weak playbackModePanel] repeatMode in
        switch repeatMode {
        case .off:
          playbackModePanel?.repeatState = .off
        case .on(single: let isSingle):
          playbackModePanel?.repeatState = .on(single: isSingle)
        }
      }
      .store(in: &cancellables)
  }
  
  func setupLayout() {
    let mainStackView = UIStackView.vStack(alignment: .center, spacing: 30) {
      [
        coverImageView,
        .vStack(alignment: .center, spacing: 6) {
          [
            titleLabel,
            albumButton,
          ]
        },
        playbackProgressPanel,
        playbackControlPanel,
        playbackModePanel,
      ]
    }
    mainStackView.distribution = .equalSpacing
    view.addSubview(mainStackView)
    mainStackView.pin(top: view.topAnchor,
                      bottom: view.safeAreaLayoutGuide.bottomAnchor,
                      leading: view.leadingAnchor,
                      trailing: view.trailingAnchor)
    NSLayoutConstraint.activate([
      playbackProgressPanel.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.9),
      coverImageView.heightAnchor.constraint(equalTo: view.widthAnchor),
    ])
  }
  
}

