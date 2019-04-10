# Исходные коды

Исходный код проекта открыт и распространяется под лицензией [Mozilla Public License 2.0](http://mozilla.org/MPL/2.0/)

Код хостится на GitHub, в качестве системы контроля версий используется git.

[https://github.com/EvilBeaver/OneScript](https://github.com/EvilBeaver/OneScript)

## Получение исходных кодов

    git clone https://github.com/EvilBeaver/OneScript

## Сборка проекта

Сборка проекта осуществляется на базе сценария MSBuild, расположенного в корне репозитория (файл *BuildAll.csproj*)

    msbuild BuildAll.csproj /t:Build;PreparePackage;CreateInstall

При внесении доработок в проект, руководствуйтесь рекомендациями, приведеннными [в разделе для разработчиков](/dev/contribute). 
