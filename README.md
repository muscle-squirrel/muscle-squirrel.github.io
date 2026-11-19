<div align="center">

<img src="assets/img/avatar.png" width="96" alt="muscle-squirrel" />

# muscle-squirrel

**Linux · Docker 팀 스터디 기록**

매주 조금씩 공부하고, 직접 실행해 본 것만 글로 남깁니다.

[![Blog](https://img.shields.io/badge/blog-muscle--squirrel.github.io-2f6feb?style=flat-square)](https://muscle-squirrel.github.io)
[![Deploy](https://img.shields.io/github/actions/workflow/status/muscle-squirrel/muscle-squirrel.github.io/pages-deploy.yml?branch=main&style=flat-square&label=deploy)](https://github.com/muscle-squirrel/muscle-squirrel.github.io/actions/workflows/pages-deploy.yml)
[![Jekyll](https://img.shields.io/badge/jekyll-chirpy-cc0000?style=flat-square&logo=jekyll&logoColor=white)](https://github.com/cotes2020/jekyll-theme-chirpy)

</div>

## 📌 About

| | |
| :--- | :--- |
| **기간** | 2026.11.19 ~ 12.17 (0주차 + 4주) |
| **모임** | 매주 화 · 목, 브리핑 · 시연 · 질의응답 중심 |
| **진행** | 류현수 (목요일) · 이현종 (화요일) |

| 주차 | 기간 | 주제 |
| :---: | :--- | :--- |
| 0 | 11.19 | 환경 설정 |
| 1 | 11.24 – 11.26 | 리눅스 기본 조작 — 터미널과 이동, 파일, 권한, 편집기와 셸 스크립트 |
| 2 | 12.01 – 12.03 | 리눅스 실전 도구 — 로그와 검색, 프로세스와 패키지, 네트워크, 환경변수와 ssh |
| 3 | 12.08 – 12.10 | 도커 기본 — 개념, 이미지, 컨테이너 실행과 관리, 데이터 유지 |
| 4 | 12.15 – 12.17 | Dockerfile, 네트워크, Compose |

세부 커리큘럼은 블로그의 [About](https://muscle-squirrel.github.io/about/) 페이지에 있습니다.

### 🔁 한 주의 흐름

```text
목  스터디 직후     다음 주 개념 공지
목 ~ 토            각자 공부 → Markdown 정리
일 ~ 화 스터디 전   검토 · 보완 → PR 머지 = 블로그 게시
화  스터디          랜덤 발표자 브리핑 · 시연 → 총정리 → 질의응답
화 ~ 목            개인 복습
목  스터디          복습 브리핑 → 과제 도전 → 다음 주 개념 공지
```

## 👥 Members

<table>
  <tr>
    <td align="center" width="140">
      <a href="https://github.com/HyeonsuRyu">
        <img src="https://github.com/HyeonsuRyu.png" width="72" alt="HyeonsuRyu" /><br />
        <sub><b>류현수</b></sub>
      </a><br />
      <sub>목요일 진행</sub>
    </td>
    <td align="center" width="140">
      <a href="https://github.com/Navi-Up">
        <img src="https://github.com/Navi-Up.png" width="72" alt="Navi-Up" /><br />
        <sub><b>이현종</b></sub>
      </a><br />
      <sub>화요일 진행</sub>
    </td>
    <td align="center" width="140">
      <a href="https://github.com/daui1727">
        <img src="https://github.com/daui1727.png" width="72" alt="daui1727" /><br />
        <sub><b>이정빈</b></sub>
      </a>
    </td>
    <td align="center" width="140">
      <a href="https://github.com/lsl2162ai-cmyk">
        <img src="https://github.com/lsl2162ai-cmyk.png" width="72" alt="lsl2162ai-cmyk" /><br />
        <sub><b>이세림</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center" width="140">
      <a href="https://github.com/8113jsl-ui">
        <img src="https://github.com/8113jsl-ui.png" width="72" alt="8113jsl-ui" /><br />
        <sub><b>이재서</b></sub>
      </a>
    </td>
    <td align="center" width="140">
      <a href="https://github.com/SeoHyun1024">
        <img src="https://github.com/SeoHyun1024.png" width="72" alt="SeoHyun1024" /><br />
        <sub><b>이서현</b></sub>
      </a>
    </td>
    <td align="center" width="140">
      <a href="https://github.com/yewon-studio">
        <img src="https://github.com/yewon-studio.png" width="72" alt="yewon-studio" /><br />
        <sub><b>박예원</b></sub>
      </a>
    </td>
    <td width="140"></td>
  </tr>
</table>

## ✍️ 글 쓰는 법

### 1. 내 폴더에 파일 만들기

**`_posts/<내 이름표>/YYYY-MM-DD-<커리큘럼 키워드>.md`**

```text
_posts/
├── hyeonsu/      류현수     ├── serim/     이세림
├── hyeonjong/    이현종     ├── jaeseo/    이재서
├── jeongbin/     이정빈     ├── seohyun/   이서현
                             └── yewon/     박예원
```

```text
_posts/serim/2026-11-29-chmod.md        →  /posts/serim/chmod/
_posts/jaeseo/2026-11-29-chmod.md       →  /posts/jaeseo/chmod/    (같은 이름이어도 OK)
```

- 키워드는 커리큘럼의 명령어·개념을 **영어 소문자와 하이픈**으로: `pwd-ls-cd`, `chmod`, `vi-basics`, `grep-find`, `docker-volume`
- 내 폴더 안에서만 겹치지 않으면 됩니다. **작성자는 폴더에 따라 자동으로 표시**되니 `author:`는 쓰지 않아도 됩니다.

### 2. 머리말 채우기

```yaml
---
title: "권한 — rwx 읽기와 chmod"          # 한글로 자유롭게
description: "목록과 검색 결과에 보일 한두 문장 요약"
date: 2026-11-29 20:00:00 +0900          # +0900 필수
categories: [Linux, 권한]                 # 주제 (최대 2단계)
tags: [1주차, chmod, sudo]                # 주차 + 키워드 (영어 소문자)
---
```

주차별 카테고리 예시:

| 주차 | `categories` |
| :---: | :--- |
| 1 · 2 | `[Linux, 기본 조작]`, `[Linux, 권한]`, `[Linux, 네트워크]` … |
| 3 · 4 | `[Docker, 이미지]`, `[Docker, Dockerfile]`, `[Docker, Compose]` … |

| 규칙 | 이유 |
| :--- | :--- |
| 내 이름 폴더에 저장 | 작성자가 자동으로 붙고, 다른 사람과 같은 파일 이름이어도 주소가 겹치지 않습니다 |
| 파일 이름 앞에 날짜 | 날짜가 없으면 글로 인식되지 않습니다 |
| `date` 끝에 `+0900` | 빠지면 UTC로 읽혀 몇 시간 동안 글이 숨겨집니다 |
| 미래 시각 금지 | Jekyll은 미래 날짜의 글을 게시하지 않습니다 |
| 카테고리 = 주제, 태그 = 주차 | 주제별로 찾고, 주차별로 모아 보기 위해서입니다 |
| 주차 태그는 `0주차` ~ `4주차` | 태그 목록 맨 앞에 순서대로 모입니다 |

> [!NOTE]
> 새 멤버가 들어오면 `_data/authors.yml`과 `_config.yml`의 **멤버별 글 폴더** 부분에 한 줄씩 추가하고, `_posts/<이름표>/` 폴더를 만듭니다.

### 3. 본문에서 쓸 수 있는 것

````markdown
> 알아 두면 좋은 내용
{: .prompt-tip }

> 주의할 점
{: .prompt-warning }

```console
$ docker run --rm hello-world
```
````

`prompt-info`, `prompt-danger`도 쓸 수 있습니다. 전체 문법은 [Chirpy 문서](https://chirpy.cotes.page/posts/write-a-new-post/)를 참고하세요.

## 💻 로컬에서 미리 보기

**Ruby 3.1 이상, 4.0 미만**이 필요합니다.
macOS 기본 Ruby(2.6)로는 동작하지 않으니 Homebrew로 설치하세요.

```bash
brew install ruby@3.4
echo 'export PATH="/opt/homebrew/opt/ruby@3.4/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"' >> ~/.zshrc
# 터미널 다시 열기

bundle install
bundle exec jekyll serve --livereload
```

→ <http://127.0.0.1:4000>

> [!TIP]
> Ruby 설치가 번거롭다면 **VS Code + Dev Containers** 확장으로 저장소를 열고
> `Reopen in Container`를 누르면 Docker 안에서 같은 환경이 준비됩니다.

> [!NOTE]
> `_config.yml`을 수정했다면 서버를 껐다 켜야 반영됩니다. 글과 `_data/`, `_tabs/`는 저장 즉시 반영됩니다.

## 🔀 기여 흐름

```text
브랜치 생성 → 글 작성 → 로컬 확인 → PR → 리뷰 1명 승인 → main 머지 → 자동 배포
```

- 브랜치 이름: `post/<이름표>/<키워드>` (예: `post/serim/chmod`), 설정 변경은 `chore/<내용>`
- PR 제목: `[1주차] 권한 — rwx 읽기와 chmod`
- **일요일 ~ 화요일 스터디 전**까지 서로의 PR을 리뷰하고 머지합니다.
- `main`에 머지되면 GitHub Actions가 빌드와 링크 검사를 거쳐 자동으로 배포합니다.
  **깨진 링크가 있으면 배포가 실패**하니 PR에서 Actions 결과를 확인해 주세요.

## 🗂 구조

```text
.
├── _posts/<이름표>/   # 멤버별 글
├── _tabs/             # 상단 메뉴 페이지 (About 등)
├── _data/
│   ├── authors.yml    # 멤버 (글 작성자)
│   └── contact.yml    # 사이드바 아이콘
├── assets/
│   ├── css/           # 커스텀 스타일 (Pretendard 글꼴 등)
│   └── img/           # 아바타, 파비콘, 글 이미지
└── _config.yml        # 사이트 설정
```

## 📄 License

글과 코드는 [MIT License](LICENSE)를 따릅니다.
테마: [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) by Cotes Chung (MIT)
