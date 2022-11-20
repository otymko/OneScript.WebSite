Перем мТокенВерсии;
Перем мВарианты;
Перем мНесуществующаяВерсия;

Процедура ПриСозданииОбъекта(Знач Токен)
	мТокенВерсии = Токен;
	мНесуществующаяВерсия = Ложь;
КонецПроцедуры

Функция ТокенВерсии() Экспорт
	Возврат мТокенВерсии;
КонецФункции

// Получает таблицу вариантов дистрибутива
// Возвращаемое значение:
//  Наименование - Строка
//  Варианты - ТаблицаЗначений
//    - Идентификатор: Строка
//    - Представление: Строка
//    - Ссылка - относительный путь файла дистрибутива
//    - ДатаФайла - дата создания файла
//
Функция ПолучитьСостав() Экспорт
	Если мВарианты = Неопределено Тогда
		ЗаполнитьДистрибутивы();
	КонецЕсли;

	Возврат мВарианты;
КонецФункции

Функция Существует() Экспорт
	ПолучитьСостав();
	Возврат мНесуществующаяВерсия = Ложь;
КонецФункции

Функция НайтиВариантСборки(ИдентификаторТипаФайла, ИдентификаторВарианта) Экспорт
	ВызватьИсключение "Не реализовано";
КонецФункции

Процедура ЗаполнитьДистрибутивы()
	
	КорневойКаталог = УправлениеКонтентом.ПолучитьКаталогСборок();
	КаталогВерсии = ОбъединитьПути(КорневойКаталог, мТокенВерсии);
	Каталог = Новый Файл(КаталогВерсии);
	
	Если Не Каталог.Существует() или Не Каталог.ЭтоКаталог() или Не СтрНачинаетсяС(Каталог.ПолноеИмя, КорневойКаталог) Тогда

		мНесуществующаяВерсия = Истина;
		мВарианты = ТаблицаВариантов();
		Возврат;

	КонецЕсли;

	Манифест = ПолучитьМанифест(КаталогВерсии);
	
	// по манифесту найти целевые файлы
	мВарианты = ТаблицаВариантов();
	
	Для Каждого ВариантСборки Из Манифест Цикл
		
		Варианты = Новый ТаблицаЗначений();
		Варианты.Колонки.Добавить("Идентификатор");
		Варианты.Колонки.Добавить("Представление");
		Варианты.Колонки.Добавить("Ссылка");
		Варианты.Колонки.Добавить("ДатаФайла");
		ЕстьФайлы = Ложь;
		Для Каждого Вариант Из ВариантСборки.variants Цикл
			Локатор = Новый ЛокаторФайла(Вариант.mask, Вариант.folder);
			Файл = Локатор.ПолучитьФайл(КаталогВерсии);
			Если Файл.Существует() Тогда
				ЕстьФайлы = Истина;
				СтрокаВариант = Варианты.Добавить();
				СтрокаВариант.Идентификатор = Вариант.key;
				СтрокаВариант.Представление = Вариант.name;
				СтрокаВариант.Ссылка = "/downloads/" + ОбъединитьПути(мТокенВерсии, Вариант.folder, Файл.Имя);
				#Если Windows Тогда
					СтрокаВариант.Ссылка = СтрЗаменить(СтрокаВариант.Ссылка, "\", "/");
				#КонецЕсли
				СтрокаВариант.ДатаФайла = Формат(Файл.ПолучитьВремяИзменения(), "ДЛФ=Д");
			КонецЕсли;
		КонецЦикла;

		Если ЕстьФайлы Тогда
			СтрокаВарианта = мВарианты.Добавить();
			СтрокаВарианта.Наименование = ВариантСборки.name;
			СтрокаВарианта.Варианты = Варианты;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьМанифест(КаталогВерсии)

	ИмяМанифеста = "manifest.json";
	ФайлМанифеста = Новый Файл(ОбъединитьПути(КаталогВерсии, ИмяМанифеста));
	Если Не ФайлМанифеста.Существует() Тогда
		Возврат МанифестПоУмолчанию();
	КонецЕсли;

	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.ОткрытьФайл(ФайлМанифеста.ПолноеИмя);
	Результат = ПрочитатьJSON(ЧтениеJSON, Ложь);
	ЧтениеJSON.Закрыть();

	Возврат Результат;

КонецФункции

Функция МанифестПоУмолчанию()
	Дистрибутивы = Новый Массив;
	Дистрибутивы.Добавить(СоздатьДистрибутив("exe", "Windows Installer (exe)", "*.exe"));
	Дистрибутивы.Добавить(СоздатьДистрибутив("zip", "Zip-архив", "*.zip"));
	Дистрибутивы.Добавить(СоздатьДистрибутив("rpm", "Fedora/CentOS (rpm)", "*.rpm", Ложь));
	Дистрибутивы.Добавить(СоздатьДистрибутив("deb", "Debian/Ubuntu (deb)", "*.deb", Ложь));
	Дистрибутивы.Добавить(СоздатьДистрибутив("vsix", "Расширение VSCode", "*.vsix", Истина, Ложь));

	Возврат Дистрибутивы;
КонецФункции

Функция СоздатьДистрибутив(
	Знач Идентификатор,
	Знач Название,
	Знач МаскаФайла,
	Знач Нужен86 = Истина,
	Знач Нужен64 = Истина)

	ВариантыСборки = Новый Массив();
	Если Нужен86 Тогда
		ВариантыСборки.Добавить(ЗаписьВариантаВМанифесте("x86", "32-bit", "", МаскаФайла));
	КонецЕсли;
	Если Нужен64 Тогда
		ВариантыСборки.Добавить(ЗаписьВариантаВМанифесте("x64", "64-bit", "x64", МаскаФайла));
	КонецЕсли;

	Возврат Новый Структура("id, name, variants", Идентификатор, Название, ВариантыСборки);

КонецФункции

Функция ТаблицаВариантов()
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить("Наименование");
	Результат.Колонки.Добавить("Варианты");
	
	Возврат Результат;
КонецФункции

Функция ЗаписьВариантаВМанифесте(Ключ, Название, Папка, Маска)
	Возврат Новый Структура("key,name,folder,mask", Ключ, Название, Папка, Маска);
КонецФункции