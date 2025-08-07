import 'package:pulse_chat/data/models/upload_file_model.dart';
import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'media_file_service.g.dart';

@RestApi()
abstract class MediaFileService {
  factory MediaFileService(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _MediaFileService;

  @POST("/images")
  @MultiPart()
  Future<ObjectResponse<ImageUploaded>> postImage(@Body() FormData formData);

  @POST("/files")
  @MultiPart()
  Future<ObjectResponse<FileUploaded>> postFile(@Body() FormData file);
}
