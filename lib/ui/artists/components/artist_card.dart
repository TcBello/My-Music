import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_music/components/image_gridview.dart';
import 'package:my_music/components/style.dart';
import 'package:my_music/provider/song_query.dart';
import 'package:provider/provider.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard({this.imageGrid, this.artistName});

  final imageGrid;
  final String artistName;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageGrid,
          Expanded(
            // height: MediaQuery.of(context).size.height * 0.05,
            // color: Colors.green,
            child: Container(
              // color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                artistName,
                overflow: TextOverflow.ellipsis,
                style: cardTitleTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// class ArtistCard extends StatefulWidget {
//   const ArtistCard({this.imageGrid, this.artistName});

//   final imageGrid;
//   final String artistName;

//   @override
//   _ArtistCardState createState() => _ArtistCardState();
// }

// class _ArtistCardState extends State<ArtistCard> {
//   dynamic imageArtWork;

//   @override
//   void initState() {
//     initArtwork();
//     super.initState();
//   }

//   void initArtwork() async{
//     final songQueryProvider = context.read<SongQueryProvider>();
//     final artWork  = await songQueryProvider.artistArtwork(widget.artistName);
//     final isSdk28Below = songQueryProvider.androidDeviceInfo.version.sdkInt < 29;
    
//     // if(isSdk28Below){}
//     if(File(artWork).existsSync()){
//       setState(() {
//         imageArtWork = ImageGridFile(artWork, "artist");
//         // widget.imageGrid = ImageGridFile(artWork, "artist");
//       });
//     }
//     else{
//       setState(() {
//         imageArtWork = ImageGridFile(songQueryProvider.defaultAlbum, "artist");
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // widget.imageGrid,
//           imageArtWork,
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Text(
//               widget.artistName,
//               overflow: TextOverflow.ellipsis,
//               style: cardTitleTextStyle,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }