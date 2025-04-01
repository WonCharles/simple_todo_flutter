# Simple Todo Flutter

간단한 할 일 관리 애플리케이션입니다. 이 앱은 할 일 관리, 달력 기능, 월간 목표 설정 기능을 제공합니다.

## 주요 기능

- 오늘 및 내일 할 일 관리
- 할 일 추가/삭제/완료 처리
- 할 일 미루기 기능
- 달력을 통한 날짜별 할 일 관리
- 월간 목표 설정 및 관리
- 한국어 지원

## 개발 환경

- Flutter 3.0.0 이상
- Dart 3.0.0 이상
- Android Studio / VS Code

## 사용된 패키지

- provider: 상태 관리
- shared_preferences: 로컬 데이터 저장
- intl: 국제화 및 날짜 형식 지원
- flutter_slidable: 슬라이드 액션 UI
- path_provider: 파일 경로 접근

## 시작하기

1. 저장소 복제하기:
```bash
git clone https://github.com/WonCharles/simple_todo_flutter.git
```

2. 의존성 설치:
```bash
flutter pub get
```

3. 앱 실행:
```bash
flutter run
```

## 앱 구조

- `lib/models`: 데이터 모델 클래스
- `lib/providers`: 상태 관리 Provider 클래스
- `lib/screens`: 화면 UI 구현
- `lib/services`: 데이터 처리 및 저장 로직
- `lib/widgets`: 재사용 가능한 위젯 컴포넌트
