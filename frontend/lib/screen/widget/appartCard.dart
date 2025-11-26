import 'package:flutter/material.dart';
import 'package:frontend/config/colorParams.dart';

// pour les cartes d'hotels
class HomeCards extends StatelessWidget {
  final Map homeData;
  HomeCards(this.homeData);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 230,
      // si le contenu du child est vide continue d'afficher
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: AssetImage(homeData['image']),
                // pour que l'image prenne toute la place assignéé
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  right: -15,
                  child: MaterialButton(
                    onPressed: () {},
                    color: Colors.white,
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.favorite_outline_rounded,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 20,
                  child: Container(
                    height: 20,
                    width: 70,

                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "A vendre",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homeData['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.local_library,
                          size: 12,
                          color: Colors.grey[700],
                        ),
                        SizedBox(width: 4),
                        Text(
                          homeData['adresse'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // 01
                        Row(
                          children: [
                            Icon(
                              Icons.bed_outlined,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              homeData['chambre'].toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        //02
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.bathroom_outlined,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              homeData['toilette'].toString(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        //03
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.space_dashboard_sharp,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              homeData['surface'].toString() + " m²",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      homeData['prix'].toString() + " FCFA",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
