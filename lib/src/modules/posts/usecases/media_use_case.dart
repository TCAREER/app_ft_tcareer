import 'dart:typed_data';

import 'package:app_tcareer/src/modules/posts/data/repositories/media_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaUseCase {
  final MediaRepository mediaRepository;
  MediaUseCase(this.mediaRepository);

  Future<bool> requestPermission() async =>
      await mediaRepository.requestPermission();

  Future<List<AssetPathEntity>> getAlbums() async =>
      await mediaRepository.getAlbums();

  Future<List<AssetEntity>> getMediaFromAlbum(
          {required AssetPathEntity album, int page = 0, int? size}) async =>
      await mediaRepository.getMediaFromAlbum(
          album: album, page: page, size: size);

  Future<List<Uint8List>?> pickImageWeb() async {
    return await mediaRepository.pickImageWeb();
  }

  Future<Uint8List?> pickVideoWeb() async {
    return await mediaRepository.pickVideoWeb();
  }
}

final mediaUseCaseProvider =
    Provider((ref) => MediaUseCase(ref.watch(mediaRepository)));
