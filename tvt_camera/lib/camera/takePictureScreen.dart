part of tvt_camera;



class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final Function(List<String>) onBack;
  TakePictureScreen({
    Key? key,
    required this.camera,
    required this.onBack,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final _key = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> listImage = [];
  List<String> imageDoc = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
              child: Text(
            "Back",
            style: TextStyle(color: Colors.white),
          )),
        ),
        title: Text('Take a picture'),
        actions: [
          InkWell(
            onTap: () {
              widget.onBack(imageDoc);
              Navigator.pop(context);
            },
            child: Container(
                padding: EdgeInsets.only(right: 10),
                alignment: Alignment.center,
                child: Text(
                  "Done",
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomSheet: Container(
        height: 80,
        color: Colors.transparent,
        alignment: AlignmentDirectional.centerEnd,
        margin: EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () async {
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => PhotoView(
                    listPath: imageDoc,
                    onImageDeleted: (result) {
                   
                      setState(() {
                        imageDoc = result;
                      });
                    }),
              ),
            );
          },
          child: Container(
            height: 70,
            width: 50,
            child: Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                if (imageDoc.isNotEmpty)
                  Container(
                    width: 50,
                    child: Image.file(File(imageDoc[imageDoc.length - 1])),
                  ),
                if (imageDoc.length > 1)
                  Container(
                    width: 49,
                    color: Colors.black45,
                    alignment: Alignment.center,
                    child: Text(
                      "+${imageDoc.length - 1}",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.width / 2 - 50),
        child: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () async {
            final image = await _controller.takePicture();
            imageDoc.add(image.path);
            setState(() {});
          },
        ),
      ),
    );
  }
}

class PhotoView extends StatefulWidget {
  final List<String> listPath;
  final Function(List<String> imagePaths)? onImageDeleted;
  const PhotoView(
      {Key? key, required this.listPath, required this.onImageDeleted})
      : super(key: key);

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  late int currentIndex = 0;
  late List<String> imagePaths;

  late PageController pageController;
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = imagePaths[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: getImage(item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: item.hashCode),
    );
  }

  ImageProvider getImage(String path) {
    return FileImage(File(path));
  }

  @override
  void initState() {
    super.initState();
    imagePaths = widget.listPath;
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    backgroundColor: Colors.black,
    actions: [
    Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(right: 10),
    child: Text("${currentIndex+1}/${imagePaths.length}"),
    )
    ],),
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: imagePaths.length,
              loadingBuilder: (context, _) => const CircularProgressIndicator(),
              pageController: pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    removeImage(
                      currentIndex,
                      onImageDeleted: (result){
                       widget.onImageDeleted!(result);
                      },
                    );
                    if (imagePaths.isEmpty) Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text(
                          '   Xóa',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeImage(
    int index, {
    required Function(List<String>) onImageDeleted,
  }) {
    if ( imagePaths.isEmpty) return;
    if (index > imagePaths.length - 1) {
      setState(() {
        
        imagePaths.removeLast();
      });
      onImageDeleted(imagePaths);
 
      return;
    }
    setState(() {
      imagePaths.removeAt(index);
    });
     
    onImageDeleted(imagePaths);
  }
}
