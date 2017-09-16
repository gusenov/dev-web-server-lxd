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

MySQL:

- [serversforhackers.com/c/installing-mysql-with-debconf](https://serversforhackers.com/c/installing-mysql-with-debconf)

MySQL Secure Installation:

- [stackoverflow.com/questions/24270733/automate-mysql-secure-installation-with-echo-command-via-a-shell-script](https://stackoverflow.com/questions/24270733/automate-mysql-secure-installation-with-echo-command-via-a-shell-script)
- [stackoverflow.com/questions/36301100/how-do-i-turn-off-the-mysql-password-validation](https://stackoverflow.com/questions/36301100/how-do-i-turn-off-the-mysql-password-validation)
- [Change MySQL password policy level](http://qiita.com/liubin/items/3722ab10a73154863bd4)


Запросы к MySQL из терминала:

- [stackoverflow.com/questions/1636977/bash-script-select-from-database-into-variable](https://stackoverflow.com/questions/1636977/bash-script-select-from-database-into-variable)
- [stackoverflow.com/questions/16101495/how-can-i-suppress-column-header-output-for-a-single-sql-statement](https://stackoverflow.com/a/20887040/2289640)
- [stackoverflow.com/questions/20751352/suppress-warning-messages-using-mysql-from-within-terminal-but-password-written](https://stackoverflow.com/a/20854048/2289640)

grep:

- [unix.stackexchange.com/questions/48535/can-grep-return-true-false-or-are-there-alternative-methods](https://unix.stackexchange.com/a/48536/40014)

expect:

- [thegeekstuff.com/2011/01/expect-expressions-loops-conditions](http://www.thegeekstuff.com/2011/01/expect-expressions-loops-conditions/)

bash:

- [stackoverflow.com/questions/2500436/how-does-cat-eof-work-in-bash](https://stackoverflow.com/a/2500451/2289640)
- [stackoverflow.com/questions/1298066/check-if-a-package-is-installed-and-then-install-it-if-its-not](https://stackoverflow.com/a/32526445/2289640)
