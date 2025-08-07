import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:pulse_chat/features/media/data/datasource/local/media_file_local.dart';
import 'package:pulse_chat/features/media/data/datasource/network/media_file_api.dart';
import 'package:pulse_chat/features/media/data/media_file_repo_impl.dart';
import 'package:pulse_chat/features/media/domain/repository/media_file_repo.dart';
import 'package:pulse_chat/features/media/domain/usecase/check_existence_file.dart';
import 'package:pulse_chat/features/media/domain/usecase/download_media_file.dart';
import 'package:pulse_chat/features/media/domain/usecase/upload_image_file.dart';
import 'package:pulse_chat/features/media/domain/usecase/upload_media_file.dart';

import '../../../core/network/api_client.dart';

final List<SingleChildWidget> mediaFileProviders = [
  //---API SERVICE & SOURCE -----------------------------------------------------------
  Provider<MediaFileApiSource>(
    create: (context) => context.read<ApiClient>().mediaFileApi,
  ),

  Provider<MediaFileLocalSource>(create: (context) => MediaFileLocalSource()),

  // REPOSITORY ------------------------------------------------------------------------------
  Provider<MediaFileRepo>(
    create:
        (context) => MediaFileRepoImpl(
          fileLocalSource: context.read<MediaFileLocalSource>(),
          mediaFileApiSource: context.read<MediaFileApiSource>(),
        ),
  ),

  // USES CASE
  Provider<UploadImageFile>(
    create:
        (context) =>
            UploadImageFile(mediaFileRepo: context.read<MediaFileRepo>()),
  ),
  Provider<UploadMediaFile>(
    create:
        (context) =>
            UploadMediaFile(mediaFileRepo: context.read<MediaFileRepo>()),
  ),
  Provider<DownloadMediaFile>(
    create:
        (context) =>
            DownloadMediaFile(mediaFileRepo: context.read<MediaFileRepo>()),
  ),
  Provider<CheckExistenceFile>(
    create:
        (context) =>
            CheckExistenceFile(mediaFileRepo: context.read<MediaFileRepo>()),
  ),
];
