# Докер-контейнер с Icecast на примере радио [Утырка](https://www.youtube.com/watch?v=qjabbdtqtzo)

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

Запускать как-то так:

```
$ screen -S icecast
$ docker run -e PASSWORD=... -e HOSTNAME=ytblpka.nakilon.pro -e TITLE=Ytblpka -p 8001:8000 --name icecast --log-driver=none --rm --it ytblpka
```

#### Допольнительно

Пересобирать образ:

```
$ docker build -t ytblpka -f Icecast.Dockerfile .
```

Если вносилась правка в `entrypoint.sh`, то смотрим айдишник последнего layer и удаляем:

```
$ docker history ytblpka
$ docker rmi <ID>
```

Чтоб проверить Icecast, в контейнере делаем `curl localhost:8000`.
Чтоб проверить порты, в контейнере делаем `netstat -peanut | grep LISTEN` (предварительно установив `net-tools`, см. [докерфайл](Icecast.Dockerfile)), на хосте делаем `docker port icecast` и тоже `netstat` либо `lsof -Pn -i4 | grep LISTEN`, если macOS.

Icecast по умолчанию биндится на 127.0.0.1, то при запуске без докера работало исправно, если nginx на той же машине, но после помещения, если не сменить `sed`-ом бинд на 0.0.0.0 в xml-конфиге, то наблюдаем такую картину, что на хосте `curl localhost:8001` пишет "Empty response" -- для проверки можно в контейнере вместо радио запустить:

```
$ yum install -y ruby
$ ruby -run -ehttpd . -p8000
```

и тот же `curl` теперь отдаст http-страничку со списком файлов.
