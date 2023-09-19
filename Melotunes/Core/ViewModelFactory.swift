import Foundation

final class ViewModelFactory {
  
  let playerController: PlayerController
  let musicService: DeezerMusicService
  
  init(playerController: PlayerController,
       musicService: DeezerMusicService) {
    self.playerController = playerController
    self.musicService = musicService
  }
  
  func chartViewModel() -> ChartViewModel {
    ChartViewModel(service: musicService)
  }
  
  func artistPageViewModel(for artist: Artist) -> ArtistPageViewModel {
    ArtistPageViewModel(artist: artist,
                        artistService: musicService,
                        tracksService: musicService)
  }
  
  func albumViewModel(for albumDescriptor: AlbumDescriptor) -> AlbumViewModel {
    AlbumViewModel(descriptor: albumDescriptor,
                   albumService: musicService)
  }
  
  func playerViewModel(artist: Artist,
                       trackList: [Track],
                       trackIndex: Int) -> PlayerViewModel {
    PlayerViewModel(artist: artist,
                    tracks: trackList,
                    currentTrackIndex: trackIndex,
                    playerController: playerController)
  }
  
}
