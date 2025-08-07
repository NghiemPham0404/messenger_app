import 'package:pulse_chat/core/responses/object_response.dart';
import 'package:dio/dio.dart';
import 'package:pulse_chat/features/media/data/models/file_uploaded_model.dart';
import 'package:pulse_chat/features/media/data/models/image_uploaded_model.dart';
import 'package:retrofit/retrofit.dart';

part 'media_file_api.g.dart';

@RestApi()
abstract class MediaFileApiSource {
  factory MediaFileApiSource(
    Dio dio, {
    String baseUrl,
    ParseErrorLogger? errorLogger,
  }) = _MediaFileApiSource;

  @POST("/images")
  @MultiPart()
  Future<ObjectResponse<ImageUploadedModel>> postImage(
    @Body() FormData formData,
  );

  @POST("/files")
  @MultiPart()
  Future<ObjectResponse<FileUploadedModel>> postFile(@Body() FormData file);
}
