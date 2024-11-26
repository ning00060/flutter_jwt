import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Dio _dio = Dio();

  bool _isLoading = false; // 로딩 상태 관리
  String? _errorMessage; // 에러 메시지 관리

  // 로그인 요청 함수
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // 유효성 검사
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = '이메일과 비밀번호를 모두 입력해주세요.';
        _isLoading = false;
      });
      return;
    }

    try {
      // API 요청
      final response = await _dio.post(
        'https://your-api-url.com/login', // 서버 로그인 엔드포인트
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final String token = response.data['token']; // JWT 토큰 추출
        print('로그인 성공! 토큰: $token');
        // 토큰 저장 또는 다음 화면 이동 로직 추가
      } else {
        setState(() {
          _errorMessage = '로그인 실패: ${response.data['message']}';
        });
      }
    } on DioError catch (e) {
      setState(() {
        _errorMessage = '에러 발생: ${e.response?.data['message'] ?? e.message}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
