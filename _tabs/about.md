---
# the default layout is 'page'
icon: fas fa-info-circle
order: 5
---

> **muscle-squirrel**은 4주 동안 Linux와 Docker를 공부하고,
> 매주 정리한 개념을 이 블로그에 남기는 팀 스터디입니다.
{: .prompt-info }

## 🗓 진행 방식

| 항목 | 내용 |
| :--- | :--- |
| 기간 | 2026.11.19 ~ 2026.12.17 (0주차 + 4주) |
| 모임 | 매주 **화 · 목** 주 2회 |
| 진행 | **류현수** (목요일) · **이현종** (화요일) |
| 방식 | 브리핑 · 시연 · 질의응답 중심 |

## 🔁 한 주의 흐름

| 언제 | 무엇을 |
| :--- | :--- |
| **목** 스터디 직후 | 다음 주 공부할 개념 공지 |
| 목 ~ **토** | 각자 공부하고 개념을 Markdown으로 정리 |
| **일** ~ 화 스터디 전 | 정리한 글 검토·보완 후 블로그에 게시 |
| **화** 스터디 | 개념별 발표자 랜덤 배정 → 개인별 브리핑·시연 → 진행 담당 총정리 → 질의응답 |
| 화 ~ 목 | 개인 복습 |
| **목** 스터디 | 복습용 브리핑 → 화요일 내용 기반 과제 도전 → 다음 주 개념 공지 |

> 발표자는 화요일에 **랜덤으로** 정해집니다. 내가 맡지 않은 개념도 설명할 수 있게 준비해 오세요.
{: .prompt-tip }

## 📚 커리큘럼

### 0주차 · 환경 설정 <small>11.19 (목)</small>

### 1주차 · 리눅스 기본 조작 <small>11.24 – 11.26</small>

| 파트 | 주제 | 내용 |
| :---: | :--- | :--- |
| 1 | 터미널과 이동 | 터미널과 셸, Tab 자동완성·`history`·`clear`, `pwd`·`ls`·`cd`, 절대/상대 경로 |
| 2 | 파일 다루기 | `mkdir`, `touch`, `cp -r`, `mv`, `rm`, `cat` |
| 3 | 권한 | `rwx` 읽기, `chmod 755`·`u+x`, `sudo` |
| 4 | 편집기와 셸 스크립트 | nano, vi 기본·편집 명령, vi와 vim, `.sh`·변수·`if`·`for`·`./` 실행 |

### 2주차 · 리눅스 실전 도구 <small>12.01 – 12.03</small>

| 파트 | 주제 | 내용 |
| :---: | :--- | :--- |
| 1 | 로그 보기와 검색 | `head`, `tail -n/-f`, 파이프 <code>&#124;</code>, `grep -r/-i/-n`, `find` |
| 2 | 프로세스와 패키지 | `ps -ef`, `kill`, `free -h`, `apt update/install` |
| 3 | 네트워크 | IP와 포트, `curl`, `nc -zv`, `ss -tlnp`, `localhost` vs `0.0.0.0` |
| 4 | 환경변수와 ssh | `echo $HOME`, `export`, `ssh-keygen`, 공개키·개인키, `ssh 사용자@호스트` |

### 3주차 · 도커 기본 <small>12.08 – 12.10</small>

| 파트 | 주제 | 내용 |
| :---: | :--- | :--- |
| 1 | 도커 개념 | 도커가 필요한 이유, VM vs 컨테이너, namespace·cgroup |
| 2 | 이미지 | 이미지와 컨테이너, 레이어 구조, `pull`·`images`·`rmi` |
| 3 | 컨테이너 실행과 관리 | `run`·`ps -a`·`stop`·`rm`, `-d`, `-p 8080:80`, `logs`, `exec -it` |
| 4 | 데이터 유지 | 볼륨 `-v`, 볼륨 vs 바인드 마운트 |

### 4주차 · Dockerfile, 네트워크, Compose <small>12.15 – 12.17</small>

| 파트 | 주제 | 내용 |
| :---: | :--- | :--- |
| 1 | Dockerfile 작성 | `FROM`·`WORKDIR`·`COPY`·`RUN`·`CMD`, CMD vs ENTRYPOINT, `docker build -t`, 바로 꺼질 때 원인 찾기 |
| 2 | 빌드 최적화와 배포 | 레이어 캐시, `.dockerignore`, Docker Hub `login`·`tag`·`push` |
| 3 | 도커 네트워크 | 기본 bridge vs 사용자 정의 네트워크, 서비스 이름 통신(내장 DNS) |
| 4 | Docker Compose | `services`·`build`·`ports`·`volumes`·`environment`, `up -d`·`down`·`logs`, `.env`, `depends_on`·`healthcheck` |

## 👥 멤버

| 이름 | GitHub | 담당 |
| :--- | :--- | :--- |
| 류현수 | [@HyeonsuRyu](https://github.com/HyeonsuRyu) | 목요일 진행 |
| 이현종 | [@Navi-Up](https://github.com/Navi-Up) | 화요일 진행 |
| 이정빈 | [@daui1727](https://github.com/daui1727) | 스터디원 |
| 이세림 | [@lsl2162ai-cmyk](https://github.com/lsl2162ai-cmyk) | 스터디원 |
| 이재서 | [@8113jsl-ui](https://github.com/8113jsl-ui) | 스터디원 |
| 이서현 | [@SeoHyun1024](https://github.com/SeoHyun1024) | 스터디원 |
| 박예원 | [@yewon-studio](https://github.com/yewon-studio) | 스터디원 |

## ✍️ 글쓰기 규칙

- 글은 **내 이름 폴더**(`_posts/<이름표>/`)에 씁니다. 작성자는 폴더에 따라 자동으로 표시됩니다.
- **카테고리는 주제**, **태그는 주차**로 나눕니다. 예: `categories: [Linux, 권한]`, `tags: [1주차, chmod]`
- 주차 태그는 `0주차` ~ `4주차`, 나머지 태그는 영어 소문자로 씁니다.
- 직접 실행해 본 명령어와 결과를 함께 남깁니다.
- 참고한 자료는 글 끝에 출처를 적습니다.

> 오타나 잘못된 내용을 발견하면 글 하단의 **수정하기** 버튼으로 바로 PR을 보내 주세요.
{: .prompt-tip }
