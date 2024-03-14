
Данный код развернет в [Yandex Cloud](https://cloud.yandex.ru/ru/) виртуальную машину, на которой, в свою очередь, запустится игра 2048.

Для выполнения инструкций вам понадобится хост система на Linux или [WSL](https://learn.microsoft.com/ru-ru/windows/wsl/install), а так же [аккаунт в Yandex Cloud.](https://console.cloud.yandex.ru/)


![welcome](https://cs4.pikabu.ru/images/big_size_comm/2015-05_5/1432476930339.jpg)

Для начала следует создать каталог, сервисный аккаунт и назначить роли в соответствии с [документацией YC,](https://cloud.yandex.ru/ru/docs/tutorials/infrastructure-management/terraform-quickstart#before-you-begin)а так же создать авторизованный ключ для сервисного аккаунта. *В нашем случае авторизованный ключ храниться в домашнем каталоге пользователя* `/home/<user>/`.

Установить пакет *terraform*
```
sudo snap install --classic terrafofm
```
Создайте в домашнем каталоге пользователя файл `/home/<user>/.terraformrc` с содержанием:
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

Создайты пару ключей SSH `ssh-keygen -t ed25519`

Создайте копию репозитория в домашнем каталоге пользователя `/home/<user>/`, введя команду `git clone https://github.com/protasov-kun/2048-game_by_tf.git`

В файле `/home/<user>/main.tf` отредактируйте директиву:
```
locals {
  folder_id = "b1g27pnvvlliqavhq6d8"
  cloud_id  = "b1gh58hlo9our1iocsva"
}
```
указав идентификаторы вашего каталога и платежного аккаунта.

##### Если вы сохранили файл авторизованного ключа сервисного аккаунта Yandex Cloud не в домашнем каталоге пользователя
тогда в файле `/home/<user>/main.tf` в директиве:
```
provider "yandex" {
  service_account_key_file = "${file("~/authorized_key.json")}"
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
}
```
отредактируйте строку `service_account_key_file =....`, указав расположение файла.

##### Далее введите команды:

`terraform providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=linux_amd64 yandex-cloud/yandex`

`terraform init`

`terraform apply`

Применение параметров занимает около 5 минут.

Важно, что при этом консоль будут заблокирована, это связано с выполнением на ВМ команды `npm start`.

Не обращайте внимания, восле нескольих выводов зеленых *successfully* в консоль можно тестировать приложение в браузере, а это дело я скоро пофикшу и код оптимизирую.

##### При `terraform apply` команда может заканчиваться ошибкой.

Это редкий случай, просто по какой-то причине пакет git не всегда устанавливается.

Просто выполните '`terraform destroy`, а затем снова `terraform apply`.

##### Все готово
В адресной адресной строке браузера укажите
`http://<yc_vm_ip_address>`
с адресом, который получила ваша машина.

![stonks](https://i.insider.com/601448566dfbe10018e00c5d?width=700&format=jpeg&auto=webp)