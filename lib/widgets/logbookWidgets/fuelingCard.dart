import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/fueling.dart';
import '../dividerLine.dart';

class FuelingCard extends StatelessWidget {
  final Fueling fueling;

  FuelingCard({@required this.fueling});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300],
            blurRadius: 8.0,
            offset: Offset(3, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gas station icon and date
              // TODO: Add real date
              Row(
                children: [
                  Icon(
                    Icons.ev_station_rounded,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Total Price
              Text(
                '\$' + fueling.totalPrice,
                style: TextStyle(
                  color: kSpringColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          DividerLine(),

          // Mileage and Fueled Volume
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(fueling.mileage + ' km - ' + fueling.fueledVolume + ' L'),
              Text(fueling.pricePerLitre + ' \$/L'),
            ],
          ),
          SizedBox(
            height: 20,
          ),

          // Car information
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.local_taxi),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                    '${fueling.car.manufacturer} ${fueling.car.model} (${fueling.car.constructionYear} / ${fueling.car.engineDisplacement}ccm)'),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),

          // Comment
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.comment),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(fueling.comment),
              ),
            ],
          ),
          DividerLine(),

          // Partial Fill-Up and Missed Previous Fill-Up
          fueling.partialFueling
              ? Row(
                  children: [
                    Icon(Icons.check),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Partial Fill-up'),
                  ],
                )
              : Container(),
          fueling.missedPreviousFueling
              ? Row(
                  children: [
                    Icon(Icons.check),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Missed Previous Fill-up'),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}