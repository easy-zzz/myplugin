# Функция для копирования файлов и каталогов (копия .txt в .txt.20140608_195859.bak)
# (c) Ivan Yastrebov (easy.quest) <easy.quest@ya.ru>, 2022

function cpbak --description 'Скопируйте файлы для создания резервных копий'
    __bak cpbak 'cp -a' $argv
end
