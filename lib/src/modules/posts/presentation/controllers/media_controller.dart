import 'package:app_tcareer/src/modules/posts/data/models/media_state.dart';
import 'package:app_tcareer/src/modules/posts/usecases/media_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaController extends StateNotifier<MediaState> {
  final MediaUseCase mediaUseCase;
  MediaController(this.mediaUseCase) : super(MediaState());

  Future<void> requestPermission() async {
    state = state.copyWith(isLoading: true);
    final permissionGranted = await mediaUseCase.requestPermission();
    state =
        state.copyWith(permissionGranted: permissionGranted, isLoading: false);
  }

  Future<void> getAlbums() async {
    state = state.copyWith(isLoading: true);
    final albums = await mediaUseCase.getAlbums();
    state = state.copyWith(albums: albums, isLoading: false);
    print(">>>>>>>albums: ${state.albums}");
  }

  Future<void> getMediaFromAlbum(AssetPathEntity album) async {
    state = state.copyWith(isLoading: true);
    final media = await mediaUseCase.getMediaFromAlbum(album: album);
    state = state.copyWith(media: media, isLoading: false);
  }
}
