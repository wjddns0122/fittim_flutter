──────────────────────────────

🟦 FITTIM – Frontend (Flutter) README 소개글

──────────────────────────────

🎨 FITTIM Frontend (Flutter)

FITTIM은 20대 MZ세대를 위한 미니멀 패션 코디 추천 서비스로,
사용자의 옷장 정보와 오늘의 무드를 기반으로 3가지 코디를 자동 추천해주는 앱입니다.

이 레포는 해당 서비스의 **Flutter 기반 클라이언트(Frontend)**입니다.

🚀 주요 기능 (Frontend)
✔ 이메일 기반 회원가입 (3단계 플로우)
- Step 1: 이름 + 이메일 입력
- Step 2: 이메일 인증코드 입력
- Step 3: 비밀번호 설정 후 회원가입 완료
- 로그인(JWT) + 자동 로그인

✔ 옷장(Wardrobe) 관리
- 옷 등록 (카테고리, 색상, 계절, 스타일 태그)
- 옷 사진 업로드(Image Picker)
- 옷 리스트 조회 / 삭제

✔ 코디 추천(FIT Generation)
- 장소/기분/계절 선택 → 자동 코디 3개 생성
- 추천 코디 카드 UI 제공
- 최근 FIT 히스토리 확인

✔ 마이페이지
- 프로필 관리
- 로그아웃

*** 

🧩 Frontend 기술 스택
Framework & UI

- Flutter 3.38.3
- Dart
- Cupertino 디자인 시스템 (iOS 감성 UI)
- Responsive Layout

Architecture
- MVVM 패턴
- GetX 상태관리
- Feature 기반 폴더 구조

Networking
- Dio HTTP Client
- JWT 기반 인증
- Interceptor로 토큰 자동 주입

Storage
- GetStorage 또는 SharedPreferences (JWT 저장)

Media
- image_picker (옷 사진 업로드)
- multipart/form-data 전송

📁 폴더 구조
```
lib/
 ├── core/
 │     ├── network/
 │     ├── config/
 ├── data/
 │     ├── models/
 │     ├── repositories/
 ├── ui/
 │     ├── pages/
 │     ├── viewmodels/
 │     ├── widgets/
 └── main.dart
```

🔗 Backend 연동

이 FE 프로젝트는
👉 Spring Boot 기반 백엔드(FITTIM Backend 레포) 와 연동됩니다

회원가입, 로그인, 옷 관리, FIT 추천 등 모든 기능은 API 통신을 통해 처리됩니다.
