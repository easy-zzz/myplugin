set -l cmd (basename (status -f) | cut -d '.' -f 1)
function $cmd -V cmd -d "Утилита для вывода списка установленных вручную пакетов при их установке или удалении."

    # Установить сообщения обратной связи и стиль текста
    set -l reg (set_color normal)
    set -l bld (set_color --bold)
    set -l red $reg(set_color red)
    set -l bred (set_color red --bold)
    set -l ylw $reg(set_color yellow)
    set -l bylw (set_color yellow --bold)
    set -l grn $reg(set_color green)
    set -l bgrn (set_color green --bold)
    set -l err $red"✘ "
    set -l warn $bylw"! "$ylw
    set -l win $grn"✔ "
    set -l instructions $bld"
DESCRIPTION"$reg"
Дополнительные команды для вывода списка пакетов, установленных вручную с помощью apt

"$bld"OPTIONS"$reg"
-a/--add [package] ...
Установите пакеты и добавьте их в список пакетов. Если список не существует, создайте его с предоставленными записями.

-r/--remove [package] ...
Удалите пакеты и удалите их из списка пакетов

-f/--file [directory]
Установите каталог для размещения файла списка пакетов

-l/--list
Распечатать содержимое списка пакетов

-h/--help
Отобразите эти инструкции.
"
    set -l no_list "Список пакетов в настоящее время не существует. Запустите один, установив пакеты, используя"$bld"$cmd --add"$reg"."

    #Проверить, запускается ли скрипт Termux
    set -l install 'sudo apt install'
    set -l uninstall 'sudo apt purge'
    if test (which termux-info)
        set install 'apt install'
        set uninstall 'apt purge'
    end


    switch $argv[1]
        case -a --add

            #Проверить правильность аргумента
            if not set --query argv[2]
                echo $instructions | grep -A 1 -e -a/--save
                return 1
            else if not eval $install $argv[2..-1]
                return 1
            end

            #Проверяем, существует ли список пакетов
            if not set --query package_list[1]
                test (uname -a | grep tails)
                and set -U package_list /live/persistence/TailsData_unlocked/live-additional-software.conf
                or set -U package_list $HOME/.config/package_list.bak
            end
            if not test -f $package_list
                echo "# Список, сгенерированный с помощью package_list" >$package_list
                echo $win"Список пакетов, созданный в $package_list"
            end

            # Добавляем пакеты в список пакетов
            for package in $argv[2..-1]
                test (string match $package (cat $package_list))
                or echo $package >>$package_list
            end
            tail -n +2 $package_list | sort -o $package_list
            sed -i "1i# Список, сгенерированный с помощью package_list" $package_list

        case -r --remove

            #Проверить правильность аргумента
            if not set --query argv[2]
                echo $instructions | grep -A 1 -e -r/--remove
                return 1
            else if not eval $uninstall $argv[2..-1]
                return 1
            end

            #Проверяем, существует ли список пакетов
            if not test -f $package_list
                echo $no_list
                return 1
            end
            set -l contents (cat $package_list)
            if test "$contents" = "# Список, сгенерированный с помощью package_list"
                echo $warn"Список пакетов в настоящее время пуст"
                return 1
            end

            # Удалить пакеты из списка пакетов или удалить список, если он был пуст
            for package in $argv[2..-1]
                sed -i "/$package/d" $package_list
            end
            test (count (cat $package_list)) -ne 1; or rm $package_list

        case -f --file

            # Показать местоположение списка пакетов, если аргумент отсутствует
            if not set --query argv[2]
                echo $package_list
                return
            end

            #Проверить правильность аргумента
            if test (count $argv) -gt 2 -o (not test -d $argv)
                echo $instructions | grep -A 1 -e -f/--file
                return 1
            else if test $argv[2] = $package_list
                echo $warn"Список пакетов уже установлен в этом месте"
                return 1
            else if test $argv[2] = tails
                set -l $argv[2] /live/persistence/TailsData_unlocked/live-additional-software.conf
            else if test -d $argv[2]
                set -l argv[2] (realpath -e $argv[2])/package_list.bak
            else
                return 1
            end

            # Переместить или создать список пакетов в пункте назначения
            if set --query package_list[1]
                if test -f $package_list
                    mv $package_list $argv[2]
                    echo $win"Список пакетов перемещен из"$bld"$package_list"$reg" в "$bld"$argv[2]"
                else
                    echo "# Список, сгенерированный $cmd" >$argv[2]
                    echo $win"Список пакетов, созданный в"$bld"$argv[2]"
                end

                # Перезаписать или начать использовать список пакетов, если он уже существует в месте назначения
            else if test -f $argv[2]
                echo $warn"Список пакетов уже присутствует в этом месте."
                if test -f $package_list
                    echo "Начать использовать? Переписать на свой?"
                    read -P "[1. Использовать / 2. Переписать / 3. Отменить]: " opt
                    test $opt = 2; and mv $package_list $argv[2]
                    or test $opt = 1; or return 1
                else
                    read -P "Начать использовать? [y/n]:" opt
                    if not test $opt = y -o $opt = Y
                        return 1
                    end
                end
            end

            # Установить местоположение списка пакетов
            set -U package_list $argv[2]

        case -l --list

            # Проверить правильность аргумента и вывести содержимое списка пакетов
            if set --query argv[2]
                echo $instructions | grep -A 1 -e -l/--list
                return 1
            else if not test -f $package_list
                echo $no_list
                return 1
            end
            tail -n +2 $package_list | column

        case -h --help echo $instructions
            not set --query argv[2]

        case '*'
            command apt $argv
    end
end
