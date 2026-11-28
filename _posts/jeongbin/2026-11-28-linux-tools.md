---
title: "리눅스 실전 도구: 로그 검색부터 SSH 접속까지"
description: "로그 검색, 프로세스와 패키지 관리, 네트워크 점검, 환경변수와 SSH까지 서버에서 자주 마주치는 네 가지 상황을 명령어로 해결하는 방법을 정리합니다."
date: 2026-11-28 09:00:00 +0900
categories: [Linux, 실전 도구]
tags: [2주차, log, grep, process, apt, network, ssh]
---

2주차는 명령어를 하나씩 외우기보다 **서버에서 실제로 마주치는 상황**을 기준으로 공부했습니다. 이 글도 네 가지 상황 순서로 정리합니다.

| 상황 | 하고 싶은 일 | 주로 쓰는 명령 |
| :---: | :--- | :--- |
| 1 | 오류가 난 기록을 로그에서 찾기 | `head`, `tail`, `grep`, `find`, 파이프 |
| 2 | 실행 중인 프로그램을 확인하고 끄거나, 필요한 프로그램 설치하기 | `ps`, `kill`, `free`, `apt` |
| 3 | 서버가 켜져 있는지, 밖에서 접속할 수 있는지 확인하기 | `curl`, `nc`, `ss` |
| 4 | 실행 환경을 설정하고 원격 서버에 안전하게 접속하기 | `export`, `echo $변수`, `ssh` |

실습은 Ubuntu 터미널(WSL 또는 리눅스 서버) 기준입니다.

## 상황 1. 로그에서 필요한 줄만 찾기

### 로그는 서버가 남기는 기록장

로그는 프로그램이 실행되면서 **언제, 무슨 일이 있었는지** 남기는 기록입니다. 예를 들어 문서를 검색해 답변하는 AI 챗봇 서버라면 요청을 받고, 문서를 찾고, 모델에 전달하고, 답을 돌려주는 각 단계가 로그로 남습니다.

```text
2026-11-27 14:00:01 INFO Server started
2026-11-27 14:00:05 INFO User request received
2026-11-27 14:00:06 INFO Searching documents
2026-11-27 14:00:07 ERROR Database connection failed
2026-11-27 14:00:08 ERROR Request failed
```

한 줄은 보통 `시각 + 수준(INFO, WARNING, ERROR) + 내용`으로 이루어집니다. 위 로그에서는 문서 검색 직후 `ERROR`가 찍혔으니 데이터베이스 연결에서 문제가 시작됐다고 추측할 수 있습니다. 실제 로그는 수만 줄씩 쌓이기 때문에 처음부터 읽기보다 **필요한 줄만 골라 보는 방법**이 중요합니다.

### 파일의 앞과 끝만 보기 — `head`, `tail`

긴 파일을 `cat`으로 전부 출력하면 화면이 넘쳐 버립니다. 앞부분이나 끝부분만 필요할 때는 `head`와 `tail`을 씁니다. 둘 다 옵션이 없으면 10줄을 보여 줍니다.

| 명령 | 보여 주는 것 |
| :--- | :--- |
| `head server.log` | 처음 10줄 |
| `head -n 5 server.log` | 처음 5줄 (`-n`은 줄 수 지정) |
| `tail server.log` | 마지막 10줄 |
| `tail -n 20 server.log` | 마지막 20줄 |
| `tail -f server.log` | 마지막 부분을 보여 준 뒤, **새로 추가되는 줄을 계속 출력** |

로그는 새 기록이 파일 끝에 붙기 때문에 실무에서는 `tail`을 더 자주 씁니다. 특히 `tail -f`의 `-f`는 **f**ollow, 즉 파일 변화를 따라간다는 뜻입니다. 한 터미널에서 서버를 실행하고 다른 터미널에서 `tail -f`를 켜 두면, 요청이 들어올 때마다 로그가 실시간으로 올라옵니다. 멈출 때는 <kbd>Ctrl</kbd>+<kbd>C</kbd>를 누릅니다.

### 명령을 이어 붙이는 파이프 `|`

파이프는 **앞 명령의 출력을 뒤 명령의 입력으로 넘기는** 연결 통로입니다. 작은 명령을 여러 개 이어서 원하는 결과만 남길 수 있습니다.

```text
ls ──(파일 목록)──▶ grep ".log" ──▶ .log가 들어간 이름만 출력
```

```console
$ ls | grep ".log"
```

세 개 이상 이을 수도 있습니다. 아래 명령은 왼쪽부터 차례로 처리됩니다.

```console
$ cat server.log | grep ERROR | tail -n 5
```

1. `cat server.log` — 로그 전체를 출력하고
2. `grep ERROR` — 그중 `ERROR`가 들어간 줄만 남긴 뒤
3. `tail -n 5` — 마지막 5줄만 보여 줍니다.

`grep`은 파일 이름을 직접 받을 수 있으므로 `cat`을 빼고 `grep ERROR server.log | tail -n 5`로 줄여 쓰는 편이 더 깔끔합니다.

### 내용은 `grep`, 파일은 `find`

`grep`은 **파일 안의 내용**에서 특정 문자열이 들어간 줄을 찾습니다.

```text
grep [옵션] "검색어" 파일명
```

| 옵션 | 뜻 | 예 |
| :--- | :--- | :--- |
| `-i` | 대소문자 구분 없이 (**i**gnore case) | `grep -i "error" server.log` |
| `-n` | 줄 번호 함께 표시 (**n**umber) | `grep -n "ERROR" server.log` |
| `-r` | 하위 디렉터리까지 모두 검색 (**r**ecursive) | `grep -r "ERROR" .` |

옵션은 합쳐 쓸 수 있어서 `grep -in "error" server.log`는 대소문자를 가리지 않고 찾으면서 줄 번호까지 보여 줍니다. `grep -r "ERROR" .`의 `.`은 현재 디렉터리이므로, 현재 위치 아래의 모든 파일을 뒤집니다.

반면 `find`는 **파일이나 디렉터리 자체**를 이름 등으로 찾습니다.

```console
$ find . -name "*.log"     # 현재 위치 아래에서 이름이 .log로 끝나는 파일 찾기
```

| 명령 | 찾는 대상 | 답해 주는 질문 |
| :--- | :--- | :--- |
| `find` | 파일·디렉터리 | "로그 파일이 **어디에** 있지?" |
| `grep` | 파일 안의 줄 | "로그 **안에** ERROR가 있나?" |

### 실습 1. 가상의 서버 로그 분석하기

실습용 디렉터리를 만들고 로그 파일을 준비합니다.

```console
$ mkdir linux_week2
$ cd linux_week2
```

```bash
cat > server.log << 'EOF'
2026-11-27 09:00:01 INFO Server started
2026-11-27 09:01:05 INFO User login
2026-11-27 09:02:10 ERROR Database connection failed
2026-11-27 09:03:15 INFO Request received
2026-11-27 09:04:20 WARNING Slow response
2026-11-27 09:05:25 ERROR API timeout
2026-11-27 09:06:30 INFO Server running
2026-11-27 09:07:35 ERROR Authentication failed
2026-11-27 09:08:40 INFO Request completed
2026-11-27 09:09:45 ERROR Database connection failed
EOF
```

`cat > server.log`는 키보드로 입력한 내용을 `server.log`에 저장하고, `<< 'EOF'`는 `EOF`라고 적힌 줄이 나올 때까지를 입력으로 받는다는 뜻입니다.

이제 아래 문제를 직접 풀어 봅니다.

1. 처음 5줄 출력하기
2. 마지막 3줄 출력하기
3. `ERROR`가 들어간 줄만 출력하기
4. `ERROR`가 들어간 줄을 줄 번호와 함께 출력하기
5. `warning`을 대소문자 구분 없이 검색하기
6. `ERROR`가 들어간 줄 중 마지막 2개만 출력하기

| 문제 | 명령 | 결과 확인 포인트 |
| :---: | :--- | :--- |
| 1 | `head -n 5 server.log` | `09:04:20 WARNING`까지 5줄 |
| 2 | `tail -n 3 server.log` | `09:07:35`부터 끝까지 3줄 |
| 3 | `grep ERROR server.log` | 4줄 |
| 4 | `grep -n ERROR server.log` | 줄 번호 3, 6, 8, 10 |
| 5 | `grep -i warning server.log` | `WARNING Slow response` 1줄 |
| 6 | `grep ERROR server.log` → 파이프 → `tail -n 2` | `Authentication failed`, `Database connection failed` |

6번은 한 줄로 쓰면 다음과 같습니다.

```console
$ grep ERROR server.log | tail -n 2
2026-11-27 09:07:35 ERROR Authentication failed
2026-11-27 09:09:45 ERROR Database connection failed
```

> 명령을 실행한 뒤 결과가 예상과 같은지 직접 비교해 보는 것이 핵심입니다. 줄 수가 다르면 로그 파일이 제대로 만들어졌는지 `cat server.log`로 먼저 확인합니다.
{: .prompt-tip }

## 상황 2. 프로그램 확인하고, 끄고, 설치하기

### 프로그램과 프로세스

디스크에 저장된 `app.py`는 그냥 저장된 **프로그램** 파일입니다. `python app.py`로 실행하는 순간 메모리에 올라가 동작하는 **프로세스**가 됩니다. Python 서버, 브라우저, 데이터베이스, 방금 입력한 터미널 명령까지 실행 중이라면 모두 프로세스입니다.

서버를 운영할 때는 "내 서버가 정말 떠 있나?", "멈춰 버린 프로그램은 어떤 것이고 어떻게 끄지?"를 확인해야 하므로 프로세스를 다루는 법이 필요합니다.

### 실행 중인 프로세스 보기 — `ps -ef`

`ps -ef`는 시스템에서 실행 중인 모든(**e**very) 프로세스를 자세한(**f**ull) 형식으로 보여 줍니다.

| 열 | 뜻 |
| :--- | :--- |
| `UID` | 프로세스를 실행한 사용자 |
| `PID` | 프로세스 번호 (**P**rocess **ID**) |
| `PPID` | 이 프로세스를 실행한 부모 프로세스의 번호 |
| `C` | CPU 사용량 관련 값 |
| `STIME` | 시작 시각 |
| `CMD` | 실행한 명령 |

이 중 가장 중요한 값은 **PID**입니다. 프로세스를 끄거나 상태를 확인할 때 이 번호로 대상을 지정합니다. 목록이 길기 때문에 보통 파이프와 `grep`으로 걸러 봅니다.

```console
$ ps -ef | grep python
ubuntu  1234  1000  0 14:00 pts/0  00:00:01 python app.py
ubuntu  1301  1290  0 14:05 pts/1  00:00:00 grep --color=auto python
```

마지막 줄처럼 방금 실행한 `grep python` 자신도 결과에 섞여 나올 수 있습니다. 이 줄은 무시하면 됩니다.

### 프로세스 끄기 — `kill`

`kill`은 이름과 달리 프로세스에 **신호(signal)를 보내는** 명령입니다. 어떤 신호를 보내느냐에 따라 동작이 달라집니다.

| 명령 | 보내는 신호 | 의미 | 사용 순서 |
| :--- | :--- | :--- | :---: |
| `kill 1234` | `SIGTERM` (15) | "정리하고 종료해 줘"라는 요청 | 먼저 |
| `kill -9 1234` | `SIGKILL` (9) | 정리할 기회 없이 강제 종료 | 안 될 때만 |

> `kill -9`는 프로그램이 파일 저장이나 연결 정리를 끝내지 못한 채 종료되므로 데이터가 손상될 수 있습니다. 일반 `kill`로 꺼지지 않을 때만 사용합니다.
{: .prompt-warning }

### 메모리 확인 — `free -h`

서버가 느려졌을 때 먼저 메모리 상태를 봅니다. `-h`는 사람이 읽기 쉬운(**h**uman-readable) 단위(Ki, Mi, Gi)로 보여 준다는 뜻입니다.

```console
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           7.7Gi       3.1Gi       1.2Gi       200Mi       3.4Gi       4.2Gi
Swap:          2.0Gi          0B       2.0Gi
```

| 열 | 뜻 |
| :--- | :--- |
| `total` | 전체 메모리 |
| `used` | 사용 중인 메모리 |
| `free` | 아무 데도 쓰이지 않는 메모리 |
| `shared` | 여러 프로세스가 공유하는 메모리 |
| `buff/cache` | 리눅스가 버퍼·캐시로 활용 중인 메모리 |
| `available` | 새 프로그램이 쓸 수 있는 메모리의 추정치 |

리눅스는 남는 메모리를 캐시로 적극 활용하기 때문에 `free` 값이 작아도 정상일 수 있습니다. 실제로 여유가 있는지는 **`available`** 값을 보고 판단합니다.

### 프로그램 설치와 제거 — `apt`

패키지는 프로그램을 설치하는 데 필요한 파일과 정보를 묶어 놓은 단위이고, Ubuntu에서는 `apt`로 패키지를 관리합니다. 시스템을 바꾸는 작업이므로 1주차에 배운 `sudo`를 붙여 관리자 권한으로 실행합니다.

| 명령 | 하는 일 |
| :--- | :--- |
| `sudo apt update` | 설치할 수 있는 **패키지 목록**을 최신으로 갱신 |
| `sudo apt install curl` | `curl` 설치 |
| `sudo apt remove curl` | `curl` 제거 |

> `apt update`는 설치된 프로그램을 업데이트하는 명령이 아니라, 어떤 버전을 받을 수 있는지 **목록만 새로 받아 오는** 명령입니다. 그래서 설치 전에는 `update` → `install` 순서로 실행합니다.
{: .prompt-info }

### 실습 2. 프로세스를 직접 띄우고 종료하기

1\. 첫 번째 터미널에서 300초 동안 기다리기만 하는 프로세스를 실행합니다. 터미널이 멈춘 것처럼 보이는 것이 정상이니 그대로 둡니다.

```console
$ sleep 300
```

2\. 두 번째 터미널을 열고 `sleep` 프로세스를 찾아 PID를 확인합니다.

```console
$ ps -ef | grep sleep
ubuntu  12345  1000  0 14:00 pts/1  00:00:00 sleep 300
```

3\. 확인한 PID로 종료합니다. `12345`는 예시이므로 내 화면에 나온 번호를 사용합니다.

```console
$ kill 12345
```

4\. 다시 `ps -ef | grep sleep`을 실행해 `sleep 300`이 사라졌는지 확인합니다. 첫 번째 터미널에는 `Terminated`가 표시되고 프롬프트가 돌아옵니다.

마지막으로 `free -h`로 내 컴퓨터의 메모리 상태도 확인해 봅니다.

## 상황 3. 서버가 살아 있는지, 밖에서 닿는지 확인하기

FastAPI, Flask, Gradio로 만든 서비스도 결국 네트워크로 요청을 주고받습니다. "서버는 켰는데 접속이 안 된다"는 문제를 풀려면 아래 개념과 명령이 필요합니다.

### IP는 건물 주소, 포트는 호수

**IP 주소**는 네트워크에서 컴퓨터를 찾는 주소이고, **포트**는 그 컴퓨터 안에서 어떤 프로그램에 요청을 전달할지 정하는 번호입니다. 아파트에 비유하면 IP는 건물 주소, 포트는 호수입니다.

```text
http://192.168.0.10:8000
└┬─┘   └────┬─────┘ └┬─┘
 │          │        └ 포트: 컴퓨터 안의 어느 프로그램인지
 │          └ IP 주소: 어느 컴퓨터인지
 └ 프로토콜: 어떤 방식으로 통신할지
```

| 포트 | 자주 쓰는 프로그램 |
| :---: | :--- |
| 22 | SSH |
| 80 / 443 | 웹 서버 (HTTP / HTTPS) |
| 3306 | MySQL |
| 5432 | PostgreSQL |
| 8000 | FastAPI 개발 서버 (uvicorn 기본값) |

### 요청을 보내고 응답 보기 — `curl`

`curl`은 터미널에서 URL로 요청을 보내고 응답을 출력합니다. 브라우저 없이 서버가 응답하는지 바로 확인할 수 있습니다.

```console
$ curl https://example.com       # 응답 본문 출력
$ curl -I https://example.com    # 응답 헤더만 출력 (상태 코드 확인용)
```

응답 헤더 첫 줄의 **상태 코드**로 결과를 판단합니다. 앞자리 숫자만 기억해도 대부분 구분할 수 있습니다.

| 앞자리 | 의미 | 예 |
| :---: | :--- | :--- |
| 2xx | 성공 | `200` 요청 성공, `201` 새 리소스 생성 |
| 3xx | 다른 곳으로 이동 | `301` 영구 이동 |
| 4xx | **요청한 쪽**의 문제 | `400` 잘못된 요청, `401` 인증 필요, `403` 권한 없음, `404` 없는 페이지 |
| 5xx | **서버 쪽**의 문제 | `500` 서버 내부 오류 |

### 특정 포트에 닿는지 확인 — `nc -zv`

`nc`(netcat)는 네트워크 연결을 시험하는 도구입니다. 데이터베이스에 연결이 안 될 때처럼, 상대 서버의 포트가 열려 있는지부터 확인하고 싶을 때 씁니다.

```console
$ nc -zv google.com 443
Connection to google.com 443 port [tcp/https] succeeded!
```

- `-z` — 데이터는 보내지 않고 연결 가능 여부만 확인
- `-v` — 결과를 자세히(**v**erbose) 출력

### 내 컴퓨터에서 열린 포트 확인 — `ss -tlnp`

`nc`가 **상대방**의 포트를 두드려 보는 명령이라면, `ss`는 **내 컴퓨터**에서 어떤 포트가 요청을 기다리고 있는지 보여 줍니다.

| 옵션 | 뜻 |
| :--- | :--- |
| `-t` | TCP 연결만 |
| `-l` | 요청을 기다리는(**l**istening) 포트만 |
| `-n` | 이름 대신 숫자로 표시 (`http` 대신 `80`) |
| `-p` | 어떤 프로세스가 사용 중인지 표시 |

```console
$ ss -tlnp
State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port  Process
LISTEN  0       2048        127.0.0.1:8000       0.0.0.0:*      users:(("uvicorn",pid=2345,fd=6))
```

`Local Address:Port`가 `127.0.0.1:8000`이면 8000번 포트가 열려 있고, **내 컴퓨터 안에서 오는 요청만** 받고 있다는 뜻입니다.

> 다른 사용자가 실행한 프로세스 정보까지 `-p`로 보려면 `sudo ss -tlnp`처럼 관리자 권한이 필요합니다.
{: .prompt-tip }

### `127.0.0.1`과 `0.0.0.0`은 무엇이 다를까

서버를 실행할 때 `--host`에 어떤 주소를 주느냐에 따라 **누구의 요청을 받을지**가 달라집니다. "서버는 정상인데 다른 컴퓨터에서 접속이 안 된다"의 가장 흔한 원인입니다.

| `--host` 값 | 요청을 받는 범위 | 다른 컴퓨터에서 접속 |
| :--- | :--- | :--- |
| `127.0.0.1` (`localhost`) | 내 컴퓨터 자신 | 불가 |
| `0.0.0.0` | 컴퓨터의 **모든** 네트워크 인터페이스 | 방화벽·네트워크 설정이 허용하면 가능 |

```console
$ uvicorn main:app --host 127.0.0.1 --port 8000   # 내 컴퓨터에서만 접속
$ uvicorn main:app --host 0.0.0.0 --port 8000     # 외부 접속까지 허용
```

> `0.0.0.0`은 서버가 **어디서 오는 요청을 받을지** 정하는 값이지, 브라우저에 입력하는 주소가 아닙니다. 다른 컴퓨터에서는 서버의 실제 IP 주소(예: `http://192.168.0.10:8000`)로 접속합니다.
{: .prompt-warning }

### 실습 3. FastAPI 서버를 띄우고 네트워크로 확인하기

1\. 필요한 도구를 설치합니다.

```console
$ sudo apt update
$ sudo apt install curl
$ pip install fastapi uvicorn
```

> 최근 Ubuntu(23.04 이후)에서는 시스템 Python에 `pip install`을 바로 하면 `externally-managed-environment` 오류가 날 수 있습니다. 이때는 `python3 -m venv .venv`로 가상환경을 만들고 `source .venv/bin/activate`로 켠 뒤 설치합니다.
{: .prompt-info }

2\. `nano main.py`로 파일을 만들고 아래 코드를 입력한 뒤 저장합니다.

```python
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def home():
    return {"message": "Hello Linux!"}
```

3\. 서버를 실행합니다. 이 터미널은 서버가 차지하므로 켜 둡니다.

```console
$ uvicorn main:app --host 127.0.0.1 --port 8000
```

4\. 새 터미널에서 요청을 보내 응답을 확인합니다.

```console
$ curl http://127.0.0.1:8000
{"message":"Hello Linux!"}
```

5\. `ss -tlnp`로 `127.0.0.1:8000`이 목록에 있는지 찾습니다.

6\. 서버 터미널에서 <kbd>Ctrl</kbd>+<kbd>C</kbd>로 종료합니다.

**추가 도전:** `--host 0.0.0.0`으로 다시 실행한 뒤 `ss -tlnp`를 보면 주소가 `0.0.0.0:8000`으로 바뀐 것을 확인할 수 있습니다.

## 상황 4. 실행 환경 설정하고 원격 서버에 접속하기

### 환경변수는 코드 밖에 두는 설정값

환경변수는 운영체제와 프로그램이 실행될 때 참고하는 **이름 = 값** 형태의 설정입니다. 예를 들어 AI 서비스의 API 키를 코드에 직접 적으면, 코드를 GitHub에 올리는 순간 키도 함께 공개됩니다.

```python
api_key = "sk-xxxxxxxx"   # 이렇게 코드에 적으면 저장소와 함께 노출됨
```

그래서 비밀값은 환경변수에 두고, 코드는 실행할 때 그 값을 읽어 오도록 만듭니다. 환경변수는 이름 앞에 `$`를 붙여 값을 꺼냅니다.

| 명령 | 하는 일 | 결과 예 |
| :--- | :--- | :--- |
| `echo $HOME` | 내 홈 디렉터리 출력 | `/home/ubuntu` |
| `echo $PATH` | 명령어 실행 파일을 찾는 디렉터리 목록 출력 | `/usr/local/bin:/usr/bin:/bin:...` |
| `export MY_NAME="Linux Student"` | 환경변수 만들기 | |
| `echo $MY_NAME` | 값 확인 | `Linux Student` |
| `unset MY_NAME` | 환경변수 지우기 | 이후 `echo`하면 빈 줄 |

`PATH`는 `python`, `curl`처럼 명령 이름만 입력했을 때 셸이 실행 파일을 찾아보는 디렉터리 목록입니다. 1주차에 스크립트를 `./hello.sh`처럼 실행해야 했던 이유도 현재 디렉터리가 `PATH`에 없기 때문이었습니다.

### 설정을 계속 유지하려면 `~/.bashrc`

`export`로 만든 환경변수는 **현재 셸과 그 셸에서 실행한 프로그램**에만 전달되고, 터미널을 닫으면 사라집니다. 계속 쓰고 싶다면 셸이 시작할 때마다 읽는 설정 파일에 적어 둡니다.

```console
$ nano ~/.bashrc                         # 파일 맨 끝에 아래 한 줄 추가
export MY_NAME="Linux Student"
$ source ~/.bashrc                       # 지금 열린 터미널에도 바로 적용
```

> API 키나 DB 비밀번호를 `.env` 파일로 관리한다면 `.gitignore`에 `.env`를 꼭 등록해 GitHub에 올라가지 않도록 합니다.
{: .prompt-warning }

### SSH로 원격 서버 접속하기

SSH(**S**ecure **Sh**ell)는 내 컴퓨터에서 다른 컴퓨터에 **암호화된 연결로** 접속하는 방법입니다. AWS 같은 클라우드 서버에서 서비스를 돌린다면, SSH로 접속해 프로그램을 실행하고 로그를 확인합니다.

```text
내 컴퓨터 (Local) ══ 암호화된 연결 ══▶ 원격 서버 (Remote)
   명령 입력 ─────────────────────────▶ 실행
   결과 확인 ◀───────────────────────── 출력
```

```console
$ ssh ubuntu@192.168.0.10            # 사용자명@서버주소
$ ssh -p 2222 ubuntu@192.168.0.10    # 기본 포트 22가 아닐 때 -p로 지정
```

`ubuntu`는 **원격 서버**에 있는 계정 이름이고, `192.168.0.10`은 그 서버의 IP 주소입니다.

### 비밀번호 대신 키로 인증하기

SSH는 비밀번호 대신 **한 쌍의 키**로 로그인할 수 있습니다. 두 키는 함께 만들어지지만 보관하는 곳과 다루는 방법이 정반대입니다.

| 구분 | 파일 (기본 이름) | 보관 위치 | 공유 |
| :--- | :--- | :--- | :--- |
| **개인키** | `~/.ssh/id_ed25519` | 내 컴퓨터 | **절대 금지** |
| **공개키** | `~/.ssh/id_ed25519.pub` | 원격 서버의 `~/.ssh/authorized_keys` | 가능 |

인증은 다음 순서로 이루어집니다.

1. 내 컴퓨터에서 개인키·공개키 한 쌍을 만든다.
2. 공개키를 원격 서버의 `~/.ssh/authorized_keys`에 등록한다.
3. 접속을 시도하면 서버는 등록된 공개키로 확인할 수 있는 문제를 낸다.
4. 내 컴퓨터가 개인키로 답해 "이 키의 주인"임을 증명하면 접속된다.

```console
$ ssh-keygen -t ed25519              # 키 만들기 (저장 위치와 암호 입력 안내가 나옴)
$ cat ~/.ssh/id_ed25519.pub          # 공개키 내용 확인 → 서버에 등록
$ ssh ubuntu@192.168.0.10            # 키로 접속
```

`ed25519`는 SSH 키에 쓰는 암호 알고리즘 중 하나입니다. `ssh-keygen`만 입력하면 OpenSSH 버전에 따라 다른 종류(예: RSA)의 키가 만들어질 수 있으므로 `-t ed25519`로 종류를 명시했습니다. 1주차에 Vagrant 접속 문제를 해결하며 만든 키도 같은 방식입니다.

> 개인키(`id_ed25519`, `.pub`이 없는 파일)는 다른 사람에게 보내거나 GitHub 저장소에 올리면 안 됩니다. 유출되면 그 키로 서버에 누구나 접속할 수 있습니다.
{: .prompt-danger }

## 실습하며 확인하기

- [ ] `server.log`를 만들고 `head`, `tail`, `grep` 문제 6개 풀기
- [ ] `find . -name "*.log"`와 `grep -r "ERROR" .`의 결과 차이 설명하기
- [ ] `sleep 300`을 띄운 뒤 `ps -ef | grep sleep`으로 PID를 찾아 `kill`로 종료하기
- [ ] `free -h`에서 `available` 값 읽어 보기
- [ ] FastAPI 서버를 `127.0.0.1`과 `0.0.0.0`으로 각각 실행하고 `ss -tlnp` 결과 비교하기
- [ ] `curl -I`로 상태 코드 확인하기
- [ ] `export`로 환경변수를 만들고 `echo`로 확인한 뒤 `unset`으로 지우기
- [ ] 개인키와 공개키가 각각 어디에 있어야 하는지 설명하기

## 참고 자료

- `man grep`, `man ps`, `man kill`, `man ss`, `man ssh` — 터미널에서 보는 명령 설명서
- [GNU grep 매뉴얼](https://www.gnu.org/software/grep/manual/grep.html)
- [FastAPI 공식 문서](https://fastapi.tiangolo.com/ko/)
