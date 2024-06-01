# BookFriends_Spring

## 소개
**BookFriends**는 독서가들이 이용할 수 있는 웹사이트입니다. 서평 공유, 독서 모임 모집, 자유게시판, 실시간 채팅, 도서관 검색, 중고 도서 거래/교환 기능을 제공합니다.

## 프로젝트 개요
BookFriends는 독서 커뮤니티를 위한 플랫폼으로, 사용자들이 서평을 공유하고, 독서 모임을 조직하며, 다양한 독서 관련 활동을 할 수 있도록 돕기 위해 개발되었습니다. 

## 목차
- [소개](#소개)
- [프로젝트 개요](#프로젝트-개요)
- [개발환경](#개발환경)
- [주요 기능](#주요-기능)
- [ERD](#ERD)
- [프로젝트 설정](#프로젝트-설정)
- [설치 및 실행 방법](#설치-및-실행-방법)
- [테스트](#테스트)
- [연락처](#연락처)
- [업데이트 로그](#업데이트-로그)

## 개발환경
- **Frontend**: HTML, CSS, JavaScript
- **Backend**: JDK 17, Spring Framework, Redis
- **IDE**: IntelliJ IDEA, Eclipse
- **Database**: MySQL
- **Server**: Apache Tomcat 9.0.89
- **Libraries**:
  - Spring Boot 2.6.x
  - Spring Data JPA
  - Spring Security
  - Redis 6.x
  - jQuery 3.7.1
  - Bootstrap 4.6.2
  - Popper 1.16.1
  - Java Mail 1.4.7
  - Java Activation Framework 1.1.1
  - Apache Commons Lang 3.14.0
  - Apache Commons Text 1.12.0
  - Apache Commons FileUpload 1.5
  - Apache Commons IO 2.16.1
  - MySQL Connector J 8.0.33

## 주요 기능
### 사용자 관리
- **회원가입**: 이메일 인증 기능 포함
- **로그인/로그아웃**: 사용자 인증 및 세션 관리 (Spring Security 적용)
- **프로필 관리**: 사용자 프로필 수정 및 업데이트

### 서평
- **등록**: 도서에 대한 평가 등록
- **수정 & 삭제**: 사용자에 의한 서평 수정 및 삭제
- **추천**: 서평 추천 기능 (중복 추천 방지)
- **조회**: 도서구분별 조회, 최신순/추천순 조회

### 자유게시판
- **등록**: 게시글 등록
- **수정 & 삭제**: 작성자만 게시글 수정 및 삭제 가능
- **추천**: 게시글 추천 기능 (중복 추천 방지)
- **조회**: 카테고리별 조회, 최신순/추천순/조회수순 조회

### 신고
- **이메일 전송**: 부적절한 콘텐츠 신고 시 관리자에게 이메일 전송

### 검색
- **검색 기능**: 강의 평가, 게시글 등 검색

### 댓글
- **등록**: 댓글 등록
- **수정 & 삭제**: 작성자만 댓글 수정 및 삭제 가능
- **추천**: 댓글 추천 기능 (중복 추천 방지)

### 채팅
- **게시글 작성자와 채팅**: 게시글에서 작성자 정보란을 클릭하면 채팅 페이지 링크로 이동하는 내비게이션 클릭
- **채팅 목록**: 채팅 목록(클릭시 해당 사용자와의 채팅 페이지로 이동함
- **실시간 채팅**: 실시간 사용자 간의 채팅

### 미완성 기능 (추후 구현 예정)
- **채팅**: 새 메시지 알림 기능, 채팅 메인 화면-타유저와의 최신 메시지 목록
- **도서관 검색**: 국립중앙도서관 API 이용
- **중고 도서 거래**

## ERD
#### Entity-Relationship Diagram
![BookFriendsERD](https://github.com/ehyunseok/BookFriends_JSP/assets/121013391/0e080643-1fed-4497-ac4e-df01209a872d)


## 프로젝트 설정
### 환경 설정
1. **IntelliJ IDEA 또는 Eclipse 설치 및 설정**: Spring Framework 개발을 위한 IDE 설정
2. **Apache Tomcat 설치**: 웹 서버로 Apache Tomcat 9.0 설정
3. **MySQL 설치**: 데이터베이스 설정 및 초기화
4. **Redis 설치**: 캐시 및 세션 관리를 위한 Redis 설정
5. **라이브러리 설치**: 라이브러리 설치 및 설정 (Spring Boot Starter, Spring Data JPA, Spring Security 등)

### 데이터베이스 설정
1. MySQL 데이터베이스 생성
2. 필요한 테이블 생성 및 초기 데이터 입력 (스키마 및 데이터 정의서 참고)

## 설치 및 실행 방법
1. 프로젝트를 클론합니다.
   ```bash
   git clone https://github.com/yourusername/BookFriends_Spring.git
   ```

2. 필요한 라이브러리를 설치합니다.
   ```bash
   mvn install
  ```

3. 데이터베이스 설정 파일을 업데이트합니다.
   - `src/main/resources/application.properties` 파일을 열어 데이터베이스 연결 정보를 업데이트합니다.

  ```properties
  spring.datasource.url=jdbc:mysql://localhost:3306/yourdatabase
  spring.datasource.username=yourusername
  spring.datasource.password=yourpassword
  ```

4. Redis 설정 파일을 업데이트합니다.
   - `src/main/resources/application.properties` 파일을 열어 Redis 연결 정보를 업데이트합니다.
  ```properties
  spring.redis.host=localhost
  spring.redis.port=6379
  ```

5. 애플리케이션을 실행합니다.
   ```bash
   mvn spring-boot:run
   ```

6. 브라우저에서 `http://localhost:8080`에 접속하여 애플리케이션을 확인합니다.

## 테스트
- **테스트 프레임워크**: JUnit, Mockito
- **테스트 실행 방법**:
  ```bash
  mvn test
  ```

## 연락처
프로젝트 관련 문의 사항이 있으면 yhdaneys@gmail.com으로 연락해 주세요.

## 업데이트 로그
- 2024.05.25
  - 사용자 입력 부분 XSS 방지
  - 사용자 비밀번호 암호화
  - 회원가입 아이디 중복 확인 기능 추가
- 2024.05.26
  - 프로젝트 주제 변환 - 재학생 커뮤니티 -> 독서 커뮤니티
  - 서평 메인/서평 상세페이지 UI, 서평 등록/수정/삭제 구현
  - 독서모임 메인 UI
  - 자유게시판 상세페이지 댓글 리스트 수정
- 2024.05.28
  - 독서모임 모집글 작성, 수정(Quill 에디터 적용), 삭제 구현
  - CSP 보안 적용(독서모임)
- 2024.05.30
  - 채팅 UI, 실시간 채팅 기능 1차 구현 완료
  - 자유게시판 카테고리 수정
- 2024.06.01
  - Spring Framework로 리팩토링 계획
  - Redis 적용 및 세션 관리 개선 추가할 예정

