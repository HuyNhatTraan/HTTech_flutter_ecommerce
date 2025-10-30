import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationSystems extends StatefulWidget {
  const NotificationSystems({super.key});

  @override
  State<NotificationSystems> createState() => _NotificationSystemsState();
}

class _NotificationSystemsState extends State<NotificationSystems> {
  int notiCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf6f6f6),
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        title: Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text('Thông báo hệ thống ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('0', style: TextStyle(color: Colors.white, fontSize: 12),);
                }

                final count = snapshot.data!.size; // <-- số lượng document nè
                return Text((count > 9)?'9+':'(${count.toString()})', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),textAlign: TextAlign.center,);

              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
        
                if (snapshot.hasError) {
                  notiCount = 0;
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                }
        
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: const [
                      Icon(
                        Icons.notifications_active_outlined,
                        size: 64,
                        color: Color(0xFF3c81c6),
                      ),
                      Text(
                        'Không có thông báo nào.',
                        style: TextStyle(
                          color: Color(0xFF3c81c6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }
        
                final items = snapshot.data!.docs;
        
                notiCount = items.length;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color(0xFFadadad),
                                width: 1,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsetsGeometry.all(0),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  Image(
                                    image: NetworkImage(
                                      'https://www.gstatic.com/mobilesdk/240501_mobilesdk/firebase_28dp.png',
                                    ),
                                    width: 35,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['title'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(item['body']),
                                        Text(
                                          (() {
                                            final t = item['time'];
                                            if (t == null) return '';
                                            final d = (t as Timestamp)
                                                .toDate();
                                            return '${d.day.toString().padLeft(2, '0')}/'
                                                '${d.month.toString().padLeft(2, '0')}/'
                                                '${d.year} '
                                                '${d.hour.toString().padLeft(2, '0')}:'
                                                '${d.minute.toString().padLeft(2, '0')}:'
                                                '${d.second.toString().padLeft(2, '0')}';
                                          })(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
