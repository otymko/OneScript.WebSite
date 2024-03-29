
#Использовать xml-parser
#Использовать semver

// TODO: разобрать модуль на мелкие составляющие.

Функция ПолучитьСодержимоеСтраницыКонтента(Знач ИдентификаторСекции, Знач ИдентификаторСтраницы) Экспорт
	
	Перем Значение;
	
	Заголовок = "";
	ЭтоMD = Ложь;
	
	ИдентификаторСекции = ?(ИдентификаторСекции = Неопределено, "docs", ИдентификаторСекции);
	ИдентификаторСтраницы = ?(ИдентификаторСтраницы = Неопределено, "index", ИдентификаторСтраницы);
	
	Если ИдентификаторСтраницы = "index" И Не ИдентификаторСекции = "dev" И Не ИдентификаторСекции = "syntax" Тогда
		Значение = "index"; 
	Иначе
		
		ЭтоMD = Истина;
		ПутьКФайлу = ПолучитьПутьККонтентуMD(ИдентификаторСекции, ИдентификаторСтраницы);
		
		Попытка
			ТекстКонтента = МодульОбщегоНазначения.ПолучитьСодержимоеMDФайла(ПутьКФайлу, КодировкаТекста.UTF8);
			Значение = МодульОбщегоНазначения.ПреобразоватьMDВHTML(ТекстКонтента);
			Заголовок = ПолучитьЗаголовокИзMD(Значение);
			MDСуществует = Истина;
		Исключение
			Значение = ""; // пока так
			Заголовок = "";
			MDСуществует = Ложь;
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат Новый Структура("Заголовок, Значение, ЭтоMD, MDСуществует", Заголовок, Значение, ЭтоMD, MDСуществует);
	
КонецФункции

Функция ПолучитьЗаголовокИзMD(ТекстКонтента)
	
	Результат = "";
	
	Регулярное = Новый РегулярноеВыражение("\<h1(.*|)\>([^\<]+)\<\/h1\>");
	Регулярное.ИгнорироватьРегистр = Истина;
	Регулярное.Многострочный = Истина;
	
	Совпадения = Регулярное.НайтиСовпадения(ТекстКонтента);
	
	Если Совпадения.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПервыйЭлементСовпадения = Совпадения[0];
	Если ПервыйЭлементСовпадения.Группы.Количество() > 1 Тогда 
		Результат = ПервыйЭлементСовпадения.Группы[ПервыйЭлементСовпадения.Группы.Количество() - 1].Значение;
	Иначе
		Результат = ПервыйЭлементСовпадения.Значение; 
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция ПолучитьПутьККонтентуMD(ИдентификаторСекции, ИдентификаторСтраницы)
	
	Если ИдентификаторСекции = "syntax" И ИдентификаторСтраницы <> "index" Тогда
		Секция = ОбъединитьПути(ИдентификаторСекции, "stdlib");	
	Иначе
		Секция = ИдентификаторСекции;	
	КонецЕсли; 
	
	Каталог = ПолучитьКаталогКонтента();
	Возврат ОбъединитьПути(Каталог, "markdown", Секция, ИдентификаторСтраницы + ".md");
	
КонецФункции

Функция ПолучитьЭкземплярНавигационногоМеню(ИдентификаторСекции) Экспорт
	
	// хранение реализовать через json файл, для удобства редактирования?
	// только будет неудобно получать ссылку на страницу
	
	НавигационноеМеню = Новый НавигационноеМеню();
	НавигационноеМеню.Заголовок = ПолучитьЗаголовокПоИдентификаторуСекции(ИдентификаторСекции);
	
	Если ИдентификаторСекции = Неопределено Тогда
		
		БазовыйURL = "/docs/page/"; 
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"install", 
		"Установка и развертывание", 
		"Установка и развертывание", 
		БазовыйURL + "install");	
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"running", 
		"Запуск сценариев", 
		"Запуск сценариев", 
		БазовыйURL + "running");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"libraries", 
		"Организация библиотек", 
		"Организация библиотек", 
		БазовыйURL + "libraries");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"http", 
		"HTTP-сервисы (модуль ISAPI)", 
		"HTTP-сервисы (модуль ISAPI)", 
		БазовыйURL + "http");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"annotations", 
		"Аннотации", 
		"Аннотации", 
		БазовыйURL + "annotations");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"testing", 
		"Тестирование", 
		"Тестирование", 
		БазовыйURL + "testing");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"examples", 
		"Примеры скриптов", 
		"Примеры скриптов", 
		БазовыйURL + "examples");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"language", 
		"Отличия от платформы 1С", 
		"Отличия от платформы 1С", 
		БазовыйURL + "language");

		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"enterprise", 
		"Информация для организаций", 
		"Информация для организаций", 
		БазовыйURL + "enterprise");
		
	ИначеЕсли ИдентификаторСекции = "library" Тогда
		
		БазовыйURL = "/library/page/";
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"asserts", 
		"asserts", 
		"asserts", 
		БазовыйURL + "asserts");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"cmdline", 
		"cmdline", 
		"cmdline", 
		БазовыйURL + "cmdline");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"gitsync", 
		"gitsync", 
		"gitsync", 
		БазовыйURL + "gitsync");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"logos", 
		"logos", 
		"logos", 
		БазовыйURL + "logos");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"tool1cd", 
		"tool1cd", 
		"tool1cd", 
		БазовыйURL + "tool1cd");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"v8runner", 
		"v8runner", 
		"v8runner", 
		БазовыйURL + "v8runner");
		
	ИначеЕсли ИдентификаторСекции = "dev" Тогда 
		
		БазовыйURL = "/dev/page/";
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"getting-started", 
		"С чего начать", 
		"С чего начать", 
		БазовыйURL + "getting-started");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"Как устроен проект", 
		"Как устроен проект", 
		"Как устроен проект", 
		БазовыйURL + "Как устроен проект");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"Как добавить класс", 
		"Как добавить класс", 
		"Как добавить класс", 
		БазовыйURL + "Как добавить класс");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"Глобальный контекст", 
		"Как добавить глобальный контекст", 
		"Как добавить глобальный контекст", 
		БазовыйURL + "Глобальный контекст");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"components", 
		"Как создать внешнюю компоненту", 
		"Как создать внешнюю компоненту", 
		БазовыйURL + "components");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"contribute", 
		"Помощь проекту", 
		"Помощь проекту", 
		БазовыйURL + "contribute");
		
		НавигационноеМеню.ДобавитьНавигационнуюСсылку(
		"sources", 
		"Исходные коды", 
		"Исходные коды", 
		БазовыйURL + "sources");
		
	КонецЕсли;
	
	Возврат НавигационноеМеню;
	
КонецФункции

Функция ПолучитьЗаголовокПоИдентификаторуСекции(ИдентификаторСекции)
	
	Значение = "Оглавление";
	
	Если ИдентификаторСекции = Неопределено Или ИдентификаторСекции = "docs" Тогда
		Значение = "Документация";
	ИначеЕсли ИдентификаторСекции = "library" Тогда	
		Значение = "Библиотеки";
	ИначеЕсли ИдентификаторСекции = "dev" Тогда	
		Значение = "Разработка";
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

Функция ПолучитьПараметрыСтраницыКонтента(ИдентификаторСтраницы, ИдентификаторСекции) Экспорт
	
	СодержимоеСтраницы = ПолучитьСодержимоеСтраницыКонтента(ИдентификаторСекции, ИдентификаторСтраницы);
	
	// Через контроллер
	//Если СодержимоеСтраницы.ЭтоMD И СодержимоеСтраницы.Значение = Неопределено Тогда 
	//	Возврат ПеренаправлениеНаДействие("page404", "home");
	//КонецЕсли;
	
	ПараметрыСтраницы = Новый ПараметрыСтраницыКонтекта();
	ПараметрыСтраницы.Заголовок = СодержимоеСтраницы.Заголовок;
	ПараметрыСтраницы.Содержимое = СодержимоеСтраницы.Значение;
	ПараметрыСтраницы.ЭтоMD = СодержимоеСтраницы.ЭтоMD;
	ПараметрыСтраницы.ИдентификаторСекции = ИдентификаторСекции;
	ПараметрыСтраницы.НавигационноеМеню = ПолучитьЭкземплярНавигационногоМеню(ИдентификаторСекции);
	
	Возврат ПараметрыСтраницы;
	
КонецФункции

// так и просится все держать в какой-нибудь бд
Функция ПолучитьСписокСборок() Экспорт
	
	СписокИменИсключений = ПолучитьИменаИсключенияСборокДляОбщегоСписка();
	
	КаталогПоиска = ОбъединитьПути(ПолучитьКаталогКонтента(), "markdown", "archive");
	Файлы = НайтиФайлы(КаталогПоиска, "*.md");
	
	СписокСборок = Новый Массив;
	ВременныйМассив = Новый Массив;
	Соответствие = Новый Соответствие;
	Для Каждого Файл Из Файлы Цикл
		
		ИмяВерсии = Файл.ИмяБезРасширения;
		
		Если СписокИменИсключений.Найти(нРег(ИмяВерсии)) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеВФорматеВерсии = СтрЗаменить(ИмяВерсии, "_", ".");
		ВременныйМассив.Добавить(ЗначениеВФорматеВерсии);
		Соответствие.Вставить(ЗначениеВФорматеВерсии, ИмяВерсии);
		
	КонецЦикла;
	
	Версии.СортироватьВерсии(ВременныйМассив, "УБЫВ");
	
	Для Каждого ЭлементМассива Из ВременныйМассив Цикл
		
		ЗначениеИзСоответвия = Соответствие.Получить(ЭлементМассива); 
		
		ТекущаяСборка = Новый Сборка();
		ТекущаяСборка.Ссылка = "/downloads/archive/" + ЗначениеИзСоответвия;
		ТекущаяСборка.Заголовок = ЭлементМассива;	
		
		СписокСборок.Добавить(ТекущаяСборка);	
		
	КонецЦикла;
	
	Возврат СписокСборок;
	
КонецФункции

Функция ПолучитьЗначениеПараметраИзКонфигурации(ИмяПараметра)
	
	// todo: в отдельный класс?
	МенеджерПараметров = Новый МенеджерПараметров();
	МенеджерПараметров.ИспользоватьПровайдерJSON();
	МенеджерПараметров.УстановитьФайлПараметров(ОбъединитьПути(СтартовыйСценарий().Каталог, "config.json"));
	МенеджерПараметров.Прочитать();
	
	РежимЗапуска = МенеджерПараметров.Параметр("РежимЗапуска");
	Значение = МенеджерПараметров.Параметр(РежимЗапуска + "." + ИмяПараметра);
	Возврат Значение;
	
КонецФункции

Функция ПолучитьКаталогКонтента() Экспорт
	
	Файл = Новый Файл(ЗначениеКонфигурацииПриложения(
		"OS_CONTENT_DIRECTORY", 
		"КаталогКонтента", 
		ОбъединитьПути(СтартовыйСценарий().Каталог, "content")));

	Возврат Файл.ПолноеИмя;
	
КонецФункции

Функция ПолучитьКаталогСборок() Экспорт
	
	Файл = Новый Файл(ЗначениеКонфигурацииПриложения(
		"OS_DOWNLOAD_DIRECTORY", 
		"КаталогСборок", 
		ОбъединитьПути(СтартовыйСценарий().Каталог, "download")));

	Возврат Файл.ПолноеИмя;
	
КонецФункции

Функция ЗначениеКонфигурацииПриложения(ПеременнаяСреды, ИмяПараметраКонфигурации, ДефолтноеЗначение)

	Значение = ПолучитьПеременнуюСреды(ПеременнаяСреды);
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Значение = ПолучитьЗначениеПараметраИзКонфигурации(ИмяПараметраКонфигурации);
		Если Не ЗначениеЗаполнено(Значение) Тогда
			Значение = ДефолтноеЗначение;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Значение;

КонецФункции

Функция ПолучитьСоставСборки(ИмяСборки) Экспорт
	
	Возврат Новый СоставВерсии(ИмяСборки);
	
КонецФункции

Функция ПутьКФайлуПримераСкрипта(Идентификатор) Экспорт

	ПутьКФайлу = ОбъединитьПути(ПолучитьКаталогКонтента(), "examples", Идентификатор);
	Файл = Новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		Возврат Файл.ПолноеИмя;
	КонецЕсли;

	Возврат "";
	
КонецФункции

Функция ПолучитьИменаИсключенияСборокДляОбщегоСписка()
	
	Результат = Новый Массив;
	Результат.Добавить("latest");
	Результат.Добавить("night-build");
	Возврат Результат;
	
КонецФункции

Процедура ДополнитьПараметрыСтраницыХлебнымиКрошками(ПараметрыСтраницы, Заголовок, Ссылка, ИдентификаторСтраницы) Экспорт

	ЛокальныеПараметры = Новый ЛокальныеПараметрыСтраницы(Заголовок, ИдентификаторСтраницы = Неопределено, Ссылка);
	ПараметрыСтраницы.ЛокальнаяНавигация.Добавить(ЛокальныеПараметры);
	Если ЗначениеЗаполнено(ИдентификаторСтраницы) Тогда		
		ЛокальныеПараметры = Новый ЛокальныеПараметрыСтраницы(
			?(ПустаяСтрока(ПараметрыСтраницы.Заголовок), ИдентификаторСтраницы, ПараметрыСтраницы.Заголовок), 
			Истина);

		ПараметрыСтраницы.ЛокальнаяНавигация.Добавить(ЛокальныеПараметры);
	КонецЕсли;

КонецПроцедуры

Процедура УстановитьЗаголовокСтраницы(Контроллер, Заголовок) Экспорт
	Контроллер.ДанныеПредставления["Title"] = Заголовок;
КонецПроцедуры

Процедура УстановитьПризнакСтраницы(Контроллер, Значение) Экспорт
	Контроллер.ДанныеПредставления["Url"] = Значение;
КонецПроцедуры

Функция ПолучитьМанифест() Экспорт
	
	МанифестПоискаФайлов = Новый МанифестПоискаФайлов();
	МанифестПоискаФайлов.СоздатьДистрибутив("exe", "Windows Installer (exe)")
		.ДобавитьФайл(Архитектуры.Арх86, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх86), "*.exe")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.exe");

	МанифестПоискаФайлов.СоздатьДистрибутив("zip", "Zip-архив")
		.ДобавитьФайл(Архитектуры.Арх86, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх86), "OneScript-1.*.zip")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "OneScript-1.*.zip")
		.ДобавитьФайл(Архитектуры.Арх86, "", "*-fdd-x86.zip", Истина) // для совместимости с ovm install dev
		.ДобавитьФайл(Архитектуры.Арх64, "", "*-fdd-x64.zip", Истина);

	МанифестПоискаФайлов.СоздатьДистрибутив("rpm", "Fedora/CentOS (rpm)")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.rpm");

	МанифестПоискаФайлов.СоздатьДистрибутив("deb", "Debian/Ubuntu (deb)")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.deb");
	
	МанифестПоискаФайлов.СоздатьДистрибутив("vsix", "Расширение VSCode")
		.ДобавитьФайл(Архитектуры.Арх64, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх64), "*.vsix")
		.ДобавитьФайл(Архитектуры.Арх86, Архитектуры.ПодкаталогАрхитектуры(Архитектуры.Арх86), "*.vsix");
	
	МанифестПоискаФайлов.СоздатьДистрибутив("fdd", "Требующий установки .NET (FDD)")
		.ДобавитьФайл(Архитектуры.Арх86, "", "*-fdd-x86.zip")
		.ДобавитьФайл(Архитектуры.Арх64, "", "*-fdd-x64.zip");

	МанифестПоискаФайлов.СоздатьДистрибутив("scd-win", "Независимый дистрибутив (Windows)")
		.ДобавитьФайл(Архитектуры.Арх86, "", "*-win-x86.zip")
		.ДобавитьФайл(Архитектуры.Арх64, "", "*-win-x64.zip");

	МанифестПоискаФайлов.СоздатьДистрибутив("scd-lin", "Независимый дистрибутив (Linux)")
		.ДобавитьФайл(Архитектуры.Универсальная, "", "*-linux-x64.zip");

	МанифестПоискаФайлов.СоздатьДистрибутив("osx-x64", "Независимый дистрибутив (MacOS Intel)")
		.ДобавитьФайл(Архитектуры.Универсальная, "", "*-osx-x64.zip");

	МанифестПоискаФайлов.СоздатьДистрибутив("osx-arm64", "Независимый дистрибутив (Mac OS ARM)")
		.ДобавитьФайл(Архитектуры.Универсальная, "", "*-osx-arm64.zip");

	Возврат МанифестПоискаФайлов;
КонецФункции