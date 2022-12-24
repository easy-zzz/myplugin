function myplugin.help -a package
    test $_ = myplugin
    and set -l command "myplugin <package>"
    or set -l command "$_ myplugin"

    test -z "$package"
    and set -l package "shell package"

    echo "Получить и установить конфигурацию $package.

Применение
  $command (-l|--list) [<options>]
  $command (-g|--get) <key> [<options>]
  $command (-q|--query) <key> [<options>]
  $command (-s|--set) <key> [<value>] [<options>]
  $command (-u|--unset) <key> [<options>]

Действия
  --list      Список всех ключей и значений конфигурации
  --get       Получить значение ключа конфигурации
  --query     Проверьте, установлен ли ключ
  --set       Установить значение ключа конфигурации
  --unset     Удалить ключ и значение конфигурации

Параметры
  -e|--edit     Изменить значение с помощью редактора
  -d|--default  Укажите значение для использования, если ключ не установлен
"
end
