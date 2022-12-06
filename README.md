# Alexander-High_infra
Alexander-High Infra repository

Bastion homework
Разворачиваем первую ВМ (bastion host)и подключаемся с перенаправлением агента ssh:

ssh -i ~/.ssh/appuser -A appuser@51.250.25.127
appuser@bastion:~$ hostname
bastion
appuser@bastion:~$ cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.4 LTS (Focal Fossa)"
ID=ubuntu
...

Разворачиваем вторую ВМ (someinternal host):

ssh 10.129.0.35
appuser@someinternalhost:~$ hostname
someinternalhost
appuser@someinternalhost:~$ cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.4 LTS (Focal Fossa)"
ID=ubuntu
...

Подключение командой в одну строку к хосту someinternalhost используя proxy-jump

ssh -i ~/.ssh/appuser -y -J appuser@51.250.25.127 appuser@10.129.0.35

➜  ~ ssh -i ~/.ssh/appuser -y -J appuser@51.250.25.127 appuser@10.129.0.35
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Mon Sep 19 22:37:01 2022 from 10.129.0.29
appuser@someinternalhost:~$ hostname
someinternalhost

Перед установкой останавливаем bastion-host. Добавляем ему 1,5Гб ОЗУ и увеличиваем долю vCPU до 20% чтобы снизить врем обработки дальнейших команд с 40 минут до 10 сек
Добавляем недостающую > в набор команд скрипта и собираем файл со скриптом на ВМ bastion-host
appuser@bastion:~$ sudo pritunl setup-key
8af6324675b34d41a407fcae651977c9

appuser@bastion:~$ sudo pritunl default-password
[undefined][2022-09-19 23:11:53,316][INFO] Getting default administrator password
Administrator default password:
  username: "pritunl"
  password: "AiOyEMHpFBUH"

Производим настройку согласно инструкции.

Подключаем VPN, импортируем туда полученный конфиг и запускам. вводим PIN. Далее пробуем подключиться к someinternalhost

Alexander-High_infra git:(cloud-bastion) ssh -i ~/.ssh/appuser appuser@10.129.0.35
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-124-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

Last login: Mon Sep 19 22:54:57 2022 from 10.129.0.29
appuser@someinternalhost:~$ hostname
someinternalhost

bastion_IP = 51.250.25.127
someinternalhost_IP = 10.129.0.29

Через web-интерфейс pritnl заходим в settings, далее в поле Lets Encrypt Domain вставлем https://51.250.25.127.sslip.io реализуем использоваание валидного сертификата

Копируем с bastion-host файл скрипта утилитой scp
scp appuser@51.250.25.127:/home/appuser/setupvpn.sh ~/Alexander-High_infra

cloud-testapp homework

Указываем в формате YA CLI основные параметры для создания WM:
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --core-fraction=20 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=0 \
  --metadata-from-file user-data=/home/alex/Alexander-High_infra/metadata.yaml

  Для развертывания ПО и создания ssh подключения используем вызов внешнего файла из metadata-from-file.

  testapp_IP = 51.250.88.57
  testapp_port = 9292
