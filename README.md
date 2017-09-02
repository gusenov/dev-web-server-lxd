# Назначение скрипта [dev-web-server.sh](dev-web-server.sh)

Данный скрипт предназначен для быстрого развертывания виртуальной серверной среды для веб-разработки.

LXC-контейнер создаётся на базе Ubuntu и следующего программного обеспечения для веб-серверов:

- Apache HTTP Server 2
- MySQL Server
- PHP 7

# Примеры использования

Все три нижеприведенные команды эквивалентны и создадут LXC-контейнер с наименованием *devel-web-server*.

```bash
$ ./dev-web-server.sh
$ ./dev-web-server.sh -n=devel-web-server
$ ./dev-web-server.sh --name=devel-web-server
```

# Ссылки

- [digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu)
- [serversforhackers.com/c/installing-mysql-with-debconf](https://serversforhackers.com/c/installing-mysql-with-debconf)
