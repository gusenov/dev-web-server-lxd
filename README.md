# Назначение скрипта [dev-web-server.sh](dev-web-server.sh)

Данный скрипт предназначен для быстрого развертывания виртуальной серверной среды для веб-разработки.

LXC-контейнер создаётся на базе Ubuntu и следующего программного обеспечения для веб-серверов:

- Apache HTTP Server 2
- MySQL Server
- PHP 7

# Примеры использования

Нижеприведенные команды эквивалентны и создадут LXC-контейнер с наименованием *devel-web-server*.

```bash
$ "./dev-web-server.sh" -c="devel-web-server" -u="root" -p="Enter-Your-Password-Here"
$ "./dev-web-server.sh" --container="devel-web-server" --user="root" --password="Enter-Your-Password-Here"
```
