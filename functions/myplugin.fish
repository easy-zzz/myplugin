function myplugin -d "My package"
    # Package entry-point
    echo "Hello World!"
    echo "echo print"
    # Проверьте, нужна ли пользователю помощь.
    if begin
            not set -q argv[1]; or contains -- -h $argv; or contains -- --help $argv
        end
        myplugin.help
        return 0
    end

    # if test -z "$package" -o "$package" = . -o "$package" = ..
    # echo "Необходимо указать допустимое имя пакета."
    # return 1
    # end
end
