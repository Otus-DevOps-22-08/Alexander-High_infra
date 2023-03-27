# Alexander-High_infra
Alexander-High Infra repository
=====================================
#Bastion homework
=====================================
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
=====================================
#cloud-testapp homework
=====================================
testapp_IP = 51.250.11.16
testapp_port = 9292

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

  Для развертывания ПО и создания ssh подключения используем вызов внешнего файла из metadata-from-file. в этом файле передаем содержимое всех скриптов.
=====================================
#packer-base homework
=====================================
5. Подготовка базового образа VM при помощи Packer.
Созданы файлы ubuntu16.json immutable.json и variables.json
В файле variables.json прописаны оснвые переменные билдера.
В файле immutable.json происходит вызов виртуальной магины YC, после чего на нее устанавливаются mongodb, ruby и приложение. И из этого создется образ.
Запуск на исполнение производится консольной командой:
packer build -var-file=variables.json immutable.json

=====================================
# Terraform Декларативное описание в виде кода инфраструктуры YC, требуемой для запуска тестового приложения, при помощи Terraform.
=====================================
Согласно заданий
1) Для провижинеров (connection) определена input переменная variable "private_key_path" содержащая в сее путь к .key файлу
2) Определена input переменная для задания зоны: variable "zone" description = "Zone" default = "ru-central1-a"
3) Все конфиг файлы отфарматиованы в terraform fmt
4) Создан файл  terraform.tfvars.example
Задания*
Создан файл lb.tf описываюий стандартный YC балансировшик. Разворачивается вместе с основным конфигом.
Настраивается автоматически при создании инфраструктуры. Приложение доступно, вывод весен в Output

Статически копировать конфиг не пробовал, подразумевая существование count. пробдема стаичного копирования, в отсутствии гибксти при горизонтальном масштабировании. Каждую новую машину нужно индексировать вручную. Счетчик count позволет гибко управлять количеством идентичных машин.

Переменная count имеет по умолчанию значение 1 а variables.tf
=====================================
# Terraform-2 Создание Terraform модулей для управления компонентами инфраструктуры.
=====================================
Согласно заданий
1) Скоректированы конфиг-файлы Packer и подготовлено 2 новых "золотых" образа db и app
2) Решена проблема с ошибкой првайдера при запуске Terraform с кофигурацией из моулей.

=====================================
# Ansible-1 Знакомств с Ansible
=====================================
Установлен Ansible. Добавлен конфиг ansible.cfg
Созданы файлы inventory, requirements.txt
Опробавоно конфигурирование по ssh

