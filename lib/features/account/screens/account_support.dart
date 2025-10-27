import 'package:flutter/material.dart';

class AccountSupport extends StatelessWidget {
  const AccountSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hỗ trợ khách hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin liên hệ
            const Text(
              'Liên hệ với chúng tôi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text('HTTech-support@gmail.com'),
                subtitle: const Text('Email hỗ trợ 24/7'),
              ),
            ),
            const SizedBox(height: 16),

            // FAQ
            const Text(
              'Câu hỏi thường gặp (FAQ)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: const Text('Làm sao để đặt lại mật khẩu?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Tui cũng hong biết nữa bạn tự cứu mình i 😭',
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: const Text('Tôi không nhận được email xác thực.'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tui cũng hong biết luôn 😭',
                      ),
                      Text(
                        'Pro tips: Vui lòng kiểm tra thư mục Spam hoặc chờ vài phút trước khi thử lại.',
                      ),
                    ],
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: const Text('Làm sao để liên hệ với bộ phận kỹ thuật?'),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Bạn có thể gửi email tới HTTech-support@gmail.com để được hỗ trợ nhanh nhất.',
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),

            // Gửi yêu cầu hỗ trợ
            const Text(
              'Gửi yêu cầu hỗ trợ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Nhập tiêu đề vấn đề...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Mô tả chi tiết vấn đề bạn gặp phải...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Yêu cầu hỗ trợ đã được gửi thành công.'),
                    ),
                  );
                },
                icon: const Icon(Icons.send),
                label: const Text('Gửi yêu cầu'),
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
