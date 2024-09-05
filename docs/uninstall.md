### Удаление приложения

#### На Windows
Приложение можно удалить через "Панель управления", меню удаления программ. Удаление приложения не удаляет файлы и
загруженные отчеты брокера. Это нужно для корректного обновления. Файлы приложения можно удалить в папке `investbook`
домашней папки пользователя:
- файл базы данных - `investbook2.mv.db`;
- отчеты брокера и логи в папке `report-backups`.

#### На Mac и Linux
Удалите директорию, в которую вы распаковывали zip-архив, например
```
rm -rf /opt/investbook-<version>
``` 
Удаление приложения не удаляет файлы и загруженные отчеты брокера. Это нужно для корректного обновления.
Файлы приложения можно удалить в домашней директории пользователя:
- файл базы данных - `~/investbook/investbook2.mv.db`;
- отчеты брокера и логи в директории `~/investbook/report-backups`.