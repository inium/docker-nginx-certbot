# docker-nginx-certbot

![Brief](/docs/brief.png)

Docker 기반의 NginX Reverse Proxy를 이용한 서버 설정 프로젝트 입니다.
본 프로젝트는 Docker Compose를 이용해 설정하였으며 아래 2가지 항목으로 구성되었습니다.

1. Docker를 이용한 NginX Reverse Proxy, Node.js App, MySQL, phpmyadmin 설정
2. Docker Certbot를 이용한 Let's Encrypt 인증서 발급 및 갱신 설정 및 확인

## 개요

본 프로젝트는 Docker Nginx를 이용해 Reverse Proxy를 구성한 후 이와 통신하는 Node.js App, MySQL, phpmyadmin을 구성하도록 하였습니다. 또한 Docker Certbot을 이용한 Let's Encrypt 인증서 확인, 발급 및 갱신 설정을 할 수 있도록 하였습니다.

이와 관련된 설정은 쉘 스크립트와 Docker Compose를 이용해 구현되었습니다.

## Directories

- `/app` : App 소스코드 파일 저장
- `/conf.d/mysql`: mysql 환경설정 파일 저장
- `/conf.d/nginx`: nginx  환경설정 파일 저장
- `/docs`: 본 프로젝트에서 사용한 리소스 정보 등 저장

## Docker Images

본 프로젝트에 사용한 Docker Image 정보는 아래와 같습니다.

- Reverse Proxy ([nginx:1.17.8](https://hub.docker.com/_/nginx))
- App ([node:13.12.0](https://hub.docker.com/_/node))
- DBMS ([mysql:5.7.29](https://hub.docker.com/_/mysql))
- MySQL 관리도구 ([phpmyadmin:latest](https://hub.docker.com/r/phpmyadmin/phpmyadmin))
- Let's Encrypt 인증서 발급, 갱신, 확인 ([certbot/certbot:latest](https://hub.docker.com/r/certbot/certbot))

## Docker Compose 파일

본 프로젝트는 2개의 docker compose 파일로 구성되어 있습니다.

- docker-compose.yml: .env 파일을 읽어들인 후 Nginx Reverse Proxy, App, MySQL, phpmyadmin 실행
- docker-compose-certbot.yml: .env 파일을 읽어들인 후 certbot 을 이용한 Let's Encrypt 인증서 발급, 갱신, 확인 실행

## 사용방법

### 1. Clone this repository

```bash
sudo git clone https://github.com/inium/docker-nginx-certbot.git /path/to
```

### 2. .env파일 생성 및 입력

본 프로젝트는 Docker Compose를 이용해 서버 구성을 하며 .env 파일로부터 실행에 필요한 정보를 입력받습니다. .env 파일 형식은 .env.example 파일에 정의되어 있으며 아래와 같이 .env 파일로 복사하여 사용합니다.

```bash
sudo cp .env.example .env
```

복사하여 생성한 .env 파일은 아래와 같이 구성되어 있습니다.

```bash
# URLs
APP_URL=${YOUR_APP_URL}
PHPMYADMIN_URL=${YOUR_PHPMYADMIN_URL}

# MySQL Configuration
MYSQL_ROOT_PASSWORD=${YOUR_MYSQL_ROOT_PASSWORD}

# Certbot Configuration
CERTBOT_CERT_EMAIL=${YOUR_CERTBOT_CERT_EMAIL}
CERTBOT_CERT_NAME=mycert
```

- APP_URL, PHPMYADMIN_URL: app, phpmyadmin 접속을 위한 URL
- MYSQL_ROOT_PASSWORD: mysql의 root 사용자 비밀번호
- CERTBOT_CERT_EMAIL: Let's Encrypt 인증서 발급 시 사용할 이메일 주소
- CERTBOT_CERT_NAME: APP_URL, PHPMYADMIN_URL 발급 시 사용할 certification name 으로 certbot 옵션 중 `--cert-name`와 동일. default 로 mycert 라는 이름 사용

### 3. 쉘 스크립트에 실행권한 추가

본 프로젝트는 사용의 편의를 위해 아래의 쉘 스크립트를 정의하여 사용합니다.

```bash
# 실행 스크립트 실행권한 추가
sudo chmod +x run.sh

# 재실행 스크립트 실행권한 추가
sudo chmod +x restart.sh

# Let's encrypt 갱신 스크립트 실행권한 추가
sudo chmod +x certbot-renew.sh

# (Optional) 발급된 인증서 정보 보기 스크립트 실행권한 추가
sudo chmod +x certbot-certificates.sh
```

- run.sh: Let's Encrypt 인증서를 발급받아 웹 서버(Nginx Reverse Proxy, App, MySQL, phpmyadmin)를 실행합니다.
- restart.sh: 웹 서버가 종료된 후 다시 실행합니다.
- certbot-renew.sh: 발급받은 Let's Encrypt 인증서 갱신 시 사용합니다.
- certbot-certificates.sh: 발급받은 Let's Encrypt 인증서의 정보를 확인할 때 사용합니다.

### 4. 실행

`docker-compose.yml` 에 정의된 서버들을 실행합니다. .env 파일을 이용해 서버를 실행하며 Let's Encrypt 인증서 발급이 동시에 진행됩니다.

```bash
./run.sh
```

### 5. 종료

실행중인 Container 전체를 종료합니다.

```bash
sudo docker-compose down
```

### 6. 재실행

실행했던 모든 Container를 종료한 후 다시 실행 합니다.

재실행은 https 환경설정을 포함해 `docker-compose.yml` 에 정의된 서버들을 실행합니다. 즉 `run.sh` 명령어로 실행한 서버를 종료하였을 경우에 사용 합니다.

```bash
./restart.sh
```

## Let's Encrypt 인증서 자동갱신

`certbot-renew.sh` 는 Let's Encrypt 인증서의 자동 갱신을 수행합니다. `crontab` 을 이용해 자동갱신 정보를 입력합니다. 예시는 아래와 같습니다.

ex) 한국시간 매주 일요일 02:30에 실행 but 서버시간이 UTC로 설정되어 있는 경우

```bash
# 매주 일요일 한국시간 02:30 (UTC 17:30)
30 17 * * 0 /path/to/certbot-renew.sh
```

_cf. kst to ustc converter: <https://www.worldtimebuddy.com/kst-to-utc-converter>_


## 기타

### Reverse Proxy

본 프로젝트에서는 NginX의 Reverse Proxy 를 이용합니다. 설정 파일은 `/conf.d/nginx` 디렉터리에 정의되어 있으며 실행 과정은 아래와 같습니다. 이 과정은 `run.sh` 파일에 정의되어 있습니다.

1. 최초 실행 시 Let's Encrypt 인증서 발급을 위한 http 서버 실행
    1. `/conf.d/nginx/http.template` 내용을 `/conf.d/nginx/default.template`로 생성.
        - 해당 파일은 Let's Encrypt의 ACME Challenge 대응, http to https redirect 만 구성.
    2. 실행 시 Reverse Proxy Container 내부에서는 앞서 생성된 파일 내부의 환경변수를 `envsubst` 명령어를 이용해 Container에 등록된 환경변수 값으로 치환한 후 `default.conf` 라는 파일로 생성하여 사용.
        - `envsubst` 명령어는 Container의 환경변수값 참조. 해당 값은 `docker-compose.yml` 로부터 정의. 이 값은 .env로부터 정의.
        - Let's Encrypt 인증서 발급을 담당하는 `certbot`은 webroot 모드로 동작하기 때문에 서버가 80 Port 로 동작하고 있어야 함.

2. Let's Encrypt 인증서 발급

3. 인증서 발급 완료 후 https 설정을 추가하여 서버 재실행
    1. `/conf.d/nginx/http.template`, `/conf.d/nginx/https.template` 두 파일의 내용을 순서대로 붙여(Append) `/conf.d/nginx/default.template` 로 생성 (기존파일은 Overwrite 됨).
    2. 재실행하면 1.2 의 과정 반복 (기존 `default.conf`는 Overwrite 됨).

### 인증서 확인

현재 발급되어 있는 인증서 정보를 확인할 수 있습니다.

```bash
./certbot-certificates.sh
```

### Volumes

본 프로젝트의 Container의 volume은 (Container->Host) `docker volume`을 이용하며 Container에서 사용하는 환경설정 파일들은 (Host->Container) Host Volume을 이용합니다.

### Networks

본 프로젝트는 Container의 이름으로 네트워크 통신을 하기 위해 bridge 형식으로 mynet 이라는 이름으로 정의한 `Docker Network`를 이용합니다.

해당 설정은 docker-compose.yml, docker-compose-certbot.yml 두 환경설정 파일에 공통으로 사용합니다.

## License

MIT
