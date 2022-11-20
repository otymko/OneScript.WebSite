#Использовать "../../model"

Перем ИдентификаторСекции;
Перем Заголовок;

Функция Index() Экспорт
	
	УправлениеКонтентом.УстановитьЗаголовокСтраницы(ЭтотОбъект, "OneScript - Архив версий");
	
	СписокСборок = УправлениеКонтентом.ПолучитьСписокСборок();
	ПараметрыПредставления = Новый Структура;
	ПараметрыПредставления.Вставить("СписокСборок", СписокСборок);
	ПараметрыПредставления.Вставить("АктуальнаяСборка", УправлениеКонтентом.ПолучитьСоставСборки("latest"));
	ПараметрыПредставления.Вставить("СтабильнаяВерсия", УправлениеКонтентом.ПолучитьСоставСборки("current"));
	ПараметрыПредставления.Вставить("НочнаяСборка", УправлениеКонтентом.ПолучитьСоставСборки("night-build"));
	
	ПараметрыПредставления.Вставить("ЛокальнаяНавигация", Новый Массив);
	
	ЛокальныеПараметры = Новый ЛокальныеПараметрыСтраницы(Заголовок, Истина, "/downloads/");
	ПараметрыПредставления.ЛокальнаяНавигация.Добавить(ЛокальныеПараметры);
	
	Возврат Представление("index", ПараметрыПредставления);
	
КонецФункции

Функция Archive() Экспорт
	
	УправлениеКонтентом.УстановитьЗаголовокСтраницы(ЭтотОбъект, "OneScript - Архив версий");
	
	Сборка = ЭтотОбъект.ЗначенияМаршрута.Получить("build");
	Если Сборка = Неопределено Тогда
		Возврат ОтдатьСтраницу404();
	КонецЕсли;
	
	СодержимоеСтраницы = УправлениеКонтентом.ПолучитьСодержимоеСтраницыКонтента(ИдентификаторСекции, Сборка);
	ТекущаяСборка = УправлениеКонтентом.ПолучитьСоставСборки(Сборка);
	Если Не ТекущаяСборка.Существует() и Не СодержимоеСтраницы.MDСуществует Тогда
		Возврат ОтдатьСтраницу404();
	КонецЕсли;
	
	ПараметрыПредставления = Новый Структура;
	ПараметрыПредставления.Вставить("Содержимое", СодержимоеСтраницы.Значение);
	ПараметрыПредставления.Вставить("ТекущаяСборка", ТекущаяСборка);
	
	ПараметрыПредставления.Вставить("ЛокальнаяНавигация", Новый Массив);
	
	ЛокальныеПараметры = Новый ЛокальныеПараметрыСтраницы(Заголовок, Ложь, "/downloads/");
	ПараметрыПредставления.ЛокальнаяНавигация.Добавить(ЛокальныеПараметры);
	
	Если ТекущаяСборка <> Неопределено Тогда
		ВерсияСборки = СтрЗаменить(ТекущаяСборка.ТокенВерсии(), "_", ".");
		ЛокальныеПараметры = Новый ЛокальныеПараметрыСтраницы("Версия " + ВерсияСборки, Истина);
		ПараметрыПредставления.ЛокальнаяНавигация.Добавить(ЛокальныеПараметры);
		
		УправлениеКонтентом.УстановитьЗаголовокСтраницы(ЭтотОбъект, "Описание версии " + ВерсияСборки);
	КонецЕсли;
	
	Возврат Представление("build-detail", ПараметрыПредставления);
	
КонецФункции

Функция Getfiledata() Экспорт
	
	Сборка = ЭтотОбъект.ЗначенияМаршрута.Получить("build");
	Идентификатор = ЭтотОбъект.ЗначенияМаршрута.Получить("id");
	Разрядность = МодульОбщегоНазначения.ПолучитьБитностьИзКонтроллера(ЭтотОбъект);
	
	КаталогСборок = УправлениеКонтентом.ПолучитьКаталогСборок();
	ПутьФайла = ОбъединитьПути(КаталогСборок, Сборка, Разрядность, Идентификатор);
	Файл = Новый Файл(ПутьФайла);
	Если Файл.Существует() И Файл.ЭтоФайл() И СтрНачинаетсяС(Файл.ПолноеИмя, КаталогСборок) Тогда
		Возврат Файл(Файл.ПолноеИмя, "application/octet-stream", Файл.Имя);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Разрядность) Тогда
		Разрядность = "x86";
	КонецЕсли;
	
	ДистрибутивыВерсии = УправлениеКонтентом.ПолучитьСоставСборки(Сборка);
	Если ДистрибутивыВерсии.Существует() Тогда
		ВариантДистрибутива = ДистрибутивыВерсии.НайтиВариантСборки(Идентификатор, Разрядность);
		Если ВариантДистрибутива <> Неопределено Тогда
			Возврат Файл(ВариантДистрибутива.ПутьФайла, "application/octet-stream", ДистрибутивыВерсии.ТокенВерсии());
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОтдатьСтраницу404();
	
КонецФункции

Функция Getexample() Экспорт
	
	Идентификатор = ЭтотОбъект.ЗначенияМаршрута.Получить("id");
	ПутьКФайлу = УправлениеКонтентом.ПутьКФайлуПримераСкрипта(Идентификатор);
	
	Файл = Новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		Возврат Файл(ПутьКФайлу, "application/octet-stream", Файл.Имя);
	КонецЕсли;
	
	Возврат ОтдатьСтраницу404();
	
КонецФункции

Функция ОтдатьСтраницу404()
	Представление = Представление("page404");
	Представление.КодСостояния = 404; // Иначе будет 200
	Возврат Представление;
КонецФункции

ИдентификаторСекции = "archive";
Заголовок = "Скачать";