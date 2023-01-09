# Функция для копирования файлов и каталогов (копия .txt в .txt.20140608_195859.bak)
# (c) Ivan Yastrebov (easy.quest) <easy.quest@ya.ru>, 2022

function uncpbak --description 'Скопируйте файлы, чтобы вернуть резервные копии к обычным файлам'
  __bak_unbak uncpbak 'cp -a' $argv
end
