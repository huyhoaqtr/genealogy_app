import 'package:photo_manager/photo_manager.dart';

class MediaServices {
  Future loadAlbum(RequestType requestType) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albums = [];

    if (permission.isAuth == true) {
      albums = await PhotoManager.getAssetPathList(
        type: requestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albums;
  }

  Future loadAssets(AssetPathEntity selectedAlbum) async {
    int assetCount = await selectedAlbum.assetCountAsync;
    List<AssetEntity> assets = await selectedAlbum.getAssetListRange(
      start: 0,
      end: assetCount,
    );

    return assets;
  }
}
