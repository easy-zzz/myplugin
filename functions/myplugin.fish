function myplugin -d "My package"
    # Package entry-point
    # Проверьте, нужна ли пользователю помощь.
    if begin
            not set -q argv[1]; or contains -- -h $argv; or contains -- --help $argv
        end
        test "$package" = -h
        or test "$package" = --help
        and set package ""

        myplugin.help "$package"
        return 0
    end

    if test -z "$package" -o "$package" = . -o "$package" = ..
        echo "Необходимо указать допустимое имя пакета."
        return 1
    end
end
