# docker-nginx-certbot

![Brief](/docs/brief.png)

Docker 기반의 NginX Reverse Proxy를 이용한 서버 설정 프로젝트 입니다.
본 프로젝트는 Docker Compose를 이용해 아래 2가지 항목으로 구성되었습니다.

1. Docker를 이용한 Reverse Proxy(NginX), App (PHP), MySQL, phpmyadmin 설정
2. Docker Certbot를 이용한 Let's Encrypt 인증서 확인, 발급 및 갱신 설정

## 개요

본 프로젝트는 Docker Nginx를 이용해 Reverse Proxy를 구성한 후 이와 통신하는 App (PHP), 데이터베이스 (MySQL), 데이터베이스 관리도구(phpmyadmin)를 구성하도록 하였습니다. 또한 Certbot을 이용한 Let's Encrypt 인증서 확인, 발급 및 갱신 설정을 할 수 있도록 하였습니다.

이와 관련된 설정은 쉘 스크립트와 Docker Compose를 이용해 구현되었습니다.

## Directories

- `/app` : App 소스코드 파일 저장
- `/conf.d/mysql`: mysql 환경설정 파일 저장
- `/conf.d/nginx`: nginx  환경설정 파일 저장
- `/docs`: 본 프로젝트에서 사용한 리소스 정보 등 저장

## Docker Containers

본 프로젝트에 사용한 Docker Container 정보는 아래와 같습니다.

- Reverse Proxy ([nginx:1.17.8](https://hub.docker.com/_/nginx))
- App ([php:7.4.3](https://hub.docker.com/_/php))
- 데이터베이스 ([mysql:5.7.29](https://hub.docker.com/_/mysql))
- 데이터베이스 관리도구 ([phpmyadmin:latest](https://hub.docker.com/r/phpmyadmin/phpmyadmin))
- Let's Encrypt 인증서 발급, 갱신 ([certbot/certbot:latest](https://hub.docker.com/r/certbot/certbot))

## 사용방법

### 1. Clone this repository

```bash
sudo git clone https://github.com/inium/docker-nginx-certbot.git /path/to
```

### 2. .env파일 생성 및 입력

본 프로젝트는 Docker Compose를 실행해 서버 구성을 하며 .env 파일로부터 실행에 필요한 정보를 입력받습니다. .env 파일 형식은 .env.example 파일에 정의되어 있으며 아래와 같이 .env 파일로 복사하여 사용합니다.

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

- APP_URL, PHPMYADMIN_URL: app, phpmyadmin 접속을 위한 URL 입력
- MYSQL_ROOT_PASSWORD: mysql의 root 사용자 비밀번호 입력
- CERTBOT_CERT_EMAIL: Let's Encrypt 인증서 발급 시 사용할 이메일 주소
- CERTBOT_CERT_NAME: APP_URL, PHPMYADMIN_URL 발급 시 사용할 certification name 으로 certbot 옵션 중 `--cert-name`와 동일
  - default 로 mycert 라는 이름 사용

### 3. 쉘 스크립트에 실행권한 추가

본 프로젝트는 사용의 편의를 위해 아래의 쉘 스크립트를 정의하여 사용합니다.

```bash
# 실행 스크립트 실행권한 추가
sudo chmod +x run.sh

# Let's encrypt 갱신 스크립트 실행권한 추가
sudo chmod +x certbot-renew.sh

# (Optional) 발급된 인증서 정보 보기 스크립트 실행권한 추가
sudo chmod +x certbot-certificates.sh
```

### 4. 실행

.env 설정이 완료되었으면 `run.sh` 를 실행합니다.

```bash
./run.sh
```

## Let's Encrypt 인증서 자동갱신

`certbot-renew.sh`는 Let's Encrypt 인증서의 자동 갱신을 수행합니다. `crontab` 을 이용해 자동갱신 정보를 입력합니다. 예시는 아래와 같습니다.

ex) 한국시간 매주 일요일 02:30에 실행 but 서버시간이 UTC로 설정되어 있는 경우

```bash
# 매주 일요일 한국시간 02:30 (UTC 17:30)
30 17 * * 0 /path/to/certbot-renew.sh
```

_cf. kst to ustc converter: <https://www.worldtimebuddy.com/kst-to-utc-converter>_

## Docker Compose 파일

본 프로젝트는 2개의 docker compose 파일로 구성되어 있습니다.

- docker-compose.yml: .env 파일을 읽어들인 후 reverse proxy, app, mysql, phpmyadmin 실행
- docker-compose-certbot.yml: .env 파일을 읽어들인 후 certbot 을 이용한 인증서 발급, 갱신, 확인 실행

## 기타

### Reverse Proxy

본 프로젝트에서는 NginX의 Reverse Proxy 를 이용합니다. 설정 파일은 `/conf.d/nginx` 디렉터리에 정의되어 있습니다.

- 최초 실행 시 `/conf.d/nginx/mysite.template` 에 정의된 변수를 `envsubst` 명령어를 이용해 .env에 정의된 값으로 치환한 후 `default.conf` 라는 파일로 생성하여 실행합니다.

- 이후 인증서 발급이 완료되면 `/conf.d/nginx/https.template` 파일을 앞의 `mysite.template` 뒤에 붙여(append) 재실행 하면 앞에서 언급한 것과 같이 .env에 정의된 값으로 치환하여 `default.conf` 라는 파일로 생성하여 실행합니다.

Let's Encrypt 인증서를 미리 발급받았다면, `run.sh`를 실행하지 말고 Project Root에서 아래의 절차대로 실행하기 바랍니다.

```bash
# mysite.template 에 https.template을 append.
> cat ./conf.d/nginx/https.template | sudo tee -a ./conf.d/nginx/mysite.template

# docker-compose 실행
> sudo docker-compose up -d
```

### App

docker-compose.yml에 정의된 app은 docker 공식 이미지인 php:7.4.3을 이용합니다. 본 이미지는 데이터베이스 연결을 위한 PDO 가 설치되어 있지 않기 때문에 docker-compose.yml의 command 항목에 PDO를 설치하여 사용합니다.

_cf. app 컨테이너는 /app/index.php를 실행하며 해당 파일은 pdo connection, phpinfo() 만을 출력합니다._

### 인증서 확인

현재 발급되어 있는 인증서 정보를 확인하기 위해 아래와 같이 인증서 정보 보기 스크립트를 실행합니다.

```bash
./certbot-certificates.sh
```

### Volumes

본 프로젝트의 container의 volume은 `docker volume`을 이용합니다.

## License

MIT
