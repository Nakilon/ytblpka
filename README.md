# Докер-контейнеры для интернет-радио на примере радио [Утырка](https://www.youtube.com/watch?v=qjabbdtqtzo)

В nginx.conf на хостовой машине добавить нечто такое:

```
server {
  listen 80;
  server_name ytblpka.nakilon.pro;
  location / {
    proxy_pass http://127.0.0.1:8001;
  }
}
```

Мне лень в композ, поэтому делаем `docker network create radio`.

### [`nakilonishe/ytblpka-icecast`](https://hub.docker.com/r/nakilonishe/ytblpka-icecast/tags/) -- это "сервер", в который идут слушатели

Контейнер с Icecast запускать как-то так:

```
$ docker run -e PASSWORD=... -e HOSTNAME=ytblpka.nakilon.pro -e TITLE=Ytblpka -p 8001:8000 --name icecast --net radio --log-driver=none --rm -d nakilonishe/ytblpka-icecast
```

После чего по адресу http://localhost:8001/ покажется Icecast с опциональным HTML5-плеером по адресу http://localhost:8001/player.htm

### [`nakilonishe/ytblpka-ices`](https://hub.docker.com/r/nakilonishe/ytblpka-ices/tags/) -- это "стример"

Для контейнера с Ices нужно создать директорию `music`, положить в нее музло (песен должно быть хотя бы две, иначе после первого трека выругается в лог "Cannot play same file twice in a row, skipping" и закроется -- закрытие стрима "/stream" также можно будет видеть и в логах Icecast-а) и файл-плейлист:

```
$ ls -1 music/* > playlist.txt
$ docker run -v $(pwd)/ices-logs:/var/log/ices -v $(pwd)/playlist.txt:/playlist.txt -v $(pwd)/music:/music -e NAME="Ytblpka radio" -e GENRE=Shanson -e DESCRIPTION=privchedel -e PASSWORD=... --name ices --net radio --log-driver=none --rm -d nakilonishe/ytblpka-ices
```

Ices имеет свойство неинформативно segfault-иться, например, если докер замаунитит `playlist.txt` как директорию (он вообще маунтит файл только если предварительно его `touch`-нуть). Или, например, просто молча отказывается запускаться, если порт не тот.

Ну или запускайте это все не через `docker run --log-driver=none -d`, а через `screen -S` и `docker run -it`, как хотите.

### Дополнительно

Пересобирать образы:

```
$ docker build --no-cache -t ytblpka-icecast -f Icecast.Dockerfile .
$ docker build --no-cache -t ytblpka-ices -f Ices.Dockerfile .
```

#### Icecast

Чтоб проверить веб-морду, в контейнере делаем `curl localhost:8000`.
Чтоб проверить порты, в контейнере делаем `netstat -peanut | grep LISTEN` (предварительно установив `net-tools`, см. закомментированную строчку в [докерфайле](Icecast.Dockerfile)), на хосте делаем `docker port icecast` и тоже `netstat` либо `lsof -Pn -i4 | grep LISTEN`, если macOS.

Icecast по умолчанию биндится на 127.0.0.1 -- при разворачивании обоих приложений без докера это работает исправно, если nginx на той же машине, но после помещения в контейнеры, если не сменить бинд на 0.0.0.0 в xml-конфиге, то на хосте `curl localhost:8001` будет писать "Empty response". Для примера можно в контейнере вместо радио запустить:

```
$ yum install -y ruby
$ ruby -run -ehttpd . -p8000
```

и тот же `curl` будет исправно отдавать http-страничку, потому что такая штука биндится на 0.0.0.0

### TODO

Привести пример конвертации Youtube-видео в ogg-файл. Или сделать еще один докер-контейнер с правильно скомпилированными youtube-dl и ffmpeg.

### Для тех, кто дочитал до конца

Можете вообще полезть на https://github.com/xiph, погуглить, и м.б. где-то там найдете решения для развертывания этих Ice-ов удобней моего, а я это делал для себя, чтоб на новую машину перенести нормально, потому что Icecast хочет запускаться под `sudo`.
