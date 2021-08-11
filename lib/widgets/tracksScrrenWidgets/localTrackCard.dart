import 'package:flutter/material.dart';

import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import '../../constants.dart';
import '../../models/track.dart';
import '../../utils/snackBar.dart';
import '../../screens/trackDetailsScreen.dart';
import '../../providers/localTracksProvider.dart';

class LocalTrackCard extends StatelessWidget {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      printTime: true,
    ),
  );

  final Track track;
  final int index;

  LocalTrackCard({@required this.track, @required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth * 0.9,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 3.0,
            spreadRadius: 1.0,
            offset: const Offset(-2, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kSpringColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(deviceWidth * 0.018), topRight: Radius.circular(deviceWidth * 0.018)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Track ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kWhiteColor,
                      ),
                      children: [
                        TextSpan(
                          text: track.begin.toUtc().toString().replaceFirst('.000Z', ''),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  child: PopupMenuButton(
                    enabled: true,
                    onSelected: (int menuIndex) {
                      if (menuIndex == 0) {
                        _logger.i('Going to track details screen');
                        Navigator.of(context).pushNamed(
                          TrackDetailsScreen.routeName,
                          arguments: track,
                        );
                      }
                      else if (menuIndex == 1) {
                        final localTracksProvider = Provider.of<LocalTracksProvider>(context, listen: false);
                        localTracksProvider.deleteLocalTrack(track, index);
                        displaySnackBar('Track ${track.id} deleted successfully!');
                      }
                      else if (menuIndex == 2) {
                        final localTracksProvider = Provider.of<LocalTracksProvider>(context, listen: false);
                        localTracksProvider.uploadTrack(context, index);
                      }
                      else if (menuIndex == 3) {
                        // TODO: function to export track
                        debugPrint('export track tapped');
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Text(
                          'Show Details',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Text(
                          'Delete Track',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text(
                          'Upload Track as Open Data',
                        ),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Text(
                          'Export Track',
                        ),
                      ),
                    ],
                    child: const Icon(
                      Icons.more_vert_outlined,
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _logger.i('Going to track details screen');
              Navigator.of(context).pushNamed(
                TrackDetailsScreen.routeName,
                arguments: track,
              );
            },
            // TODO: replace the placeholder map image with map widget
            child: Image.asset(
              'assets/images/map_placeholder.png',
              fit: BoxFit.cover,
              height: deviceHeight * 0.2,
              width: double.infinity,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                TrackDetailsScreen.routeName,
                arguments: track,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        track.end
                            .difference(track.begin)
                            .toString()
                            .replaceFirst('.000000', ''),
                        style: const TextStyle(
                          color: kSpringColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${track.length.toStringAsFixed(2)}km',
                        style: const TextStyle(
                          color: kSpringColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'Distance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
