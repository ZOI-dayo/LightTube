import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

final _credentials = ServiceAccountCredentials.fromJson('''
{
  "private_key_id": ...,
  "private_key": ...,
  "client_email": ...,
  "client_id": ...,
  "type": "service_account"
}
''');

const _scopes = [YouTubeApi.youtubeReadonlyScope];
Future<void> main() async {
  final httpClient = await clientViaServiceAccount(_credentials, _scopes);
  try {
    final ytApi = YouTubeApi(httpClient);

    /*
    final buckets = await ytApi.activities.list('favorite');
    print('Received ${buckets.items.length} bucket names:');
    for (var file in buckets.items) {
      print(file.name);
    }

     */
  } finally {
    httpClient.close();
  }
}