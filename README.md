# OneScript.WebSite

## Описание проекта

Git-репозиторий официального сайта http://oscript.io, разработанный на Oscript.Web. В проекте содержится контент и исходные коды сайта.

* Проект **[OneScript](https://github.com/EvilBeaver/OneScript)**
* Проект **[OneScript.Web](https://github.com/EvilBeaver/OneScript.Web)**

## Развитие сайта

Информацию можно изучить [CONTRIBUTING.md](CONTRIBUTING.md).

### Быстрый старт

#### Используя docker

1. Устанавливаем docker (не важно для Unix или Windows). Официальный сайт [docker.com](https://www.docker.com/).
2. Клонируем текущий проект.
3. Редактируем переменные среды или конфигурацию приложения
   * В docker-compose.yml добавляем:
```yml
osweb:
...
environment:
    - OS_CONTENT_DIRECTORY=/path/to/content
    - OS_DOWNLOAD_DIRECTORY=/path/to/downloads
```
   * В файле src/config.json редактируем:
```json
"Разработка": {
        "КаталогКонтента": "path/to/content",
        "КаталогСборок": "path/to/downloads"
    }
```
4. В каталоге проекта выполняем
```
docker-compose up
```
или (если нужно отключить контейнер от консоли запуска):
```
docker-compose up -d
```
При успешном старте будет в логах:
```
***  | Hosting environment: Production
***  | Content root path: /app
***  | Now listening on: http://0.0.0.0:5000
***  | Application started. Press Ctrl+C to shut down.
```
Сайт будет доступен по порту 8081.

#### Через cmd в Windows

1. Устанавливаем OneScript. Либо с официального сайта [oscript.io](http://oscript.io), либо через менеджер пакетов [Chocolatey](https://chocolatey.org/):
```
choco install onescript
```
2. Устанавливаем актуальную версию движка [OneScript.Web](https://github.com/EvilBeaver/OneScript.Web/releases).
3. Клонируем текущий проект.
4. В каталоге src проекта загружаем зависимости от библиотек 1script.
```
opm install -l
```
5. Редактируем скрипт manual-run.bat
```
cd /path/to/project/src
SET OS_CONTENT_DIRECTORY=/path/to/project/src/content
SET OS_DOWNLOAD_DIRECTORY=/path/to/downloads
/path/to/oscriptweb/OneScript.WebHost.exe
```
6. Запускаем скрипт manual-run.bat

При успешном старте будет в логах:
```
Hosting environment: Production
Content root path: /app
Now listening on: http://localhost:5000
Application started. Press Ctrl+C to shut down.
```
Сайт будет доступен по порту 5000.