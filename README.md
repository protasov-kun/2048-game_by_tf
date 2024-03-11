# Инициализация провайдера

Для начала следует создать каталог и сервисный аккаунт в соответствии с [документацией YC,](https://cloud.yandex.ru/ru/docs/tutorials/infrastructure-management/terraform-quickstart#before-you-begin)а так же создать авторизованный ключ для сервисного аккаунта. *Ключ следует сохранить на хост системе.*

Установить пакет *terraform*
```
sudo snap install --classic terrafofm
```
Создайте в домашнем каталоге пользователя `.terraformrc` файл с содержанием:
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

Создайте копию репозитория на вашей системе `git clone https://github.com/protasov-kun/terraform_init_with_yc.git`
##### Если вы сохранили файл авторизованного ключа не в домашнем каталоге пользователя
nогда файле *main.tf*  в директиве:
```
provider "yandex" {
  service_account_key_file = "${file("~/authorized_key.json")}"
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
}
```
отредактируйте строку `service_account_key_file =....`.

Далее введите команды:
`terraform providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=linux_amd64 yandex-cloud/yandex`
`terraform init`
`terraform apply`