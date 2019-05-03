﻿#Использовать "model"
#Использовать configor

Процедура ПриНачалеРаботыСистемы()

	ИспользоватьСтатическиеФайлы();
	ИспользоватьСессии();
	ИспользоватьМаршруты("ОпределениеМаршрутов");
	//ИспользоватьОбработчикОшибок("/home/page404");

КонецПроцедуры

Процедура ОпределениеМаршрутов(КоллекцияМаршрутов)

	Использовать404 = Истина;

	КоллекцияМаршрутов.Добавить("ГлавнаяСтраница","{controller=home}/{action=index}");

	// Роут устарел. Надо удалить
	ПараметрыРоута = Новый Соответствие;
	ПараметрыРоута.Вставить("action","index");
	КоллекцияМаршрутов.Добавить("content", "{controller}/page/{id}", ПараметрыРоута);

	ПараметрыРоута = Новый Соответствие;
	ПараметрыРоута.Вставить("controller","downloads");
	ПараметрыРоута.Вставить("action","archive");
	КоллекцияМаршрутов.Добавить("СтраницаСборки", "downloads/archive/{build}", ПараметрыРоута);

	ПараметрыРоута = Новый Соответствие;
	ПараметрыРоута.Вставить("controller","downloads");
	ПараметрыРоута.Вставить("action","getfiledata");
	КоллекцияМаршрутов.Добавить("ЗагрузкаСборки", "downloads/{build}/{id}", ПараметрыРоута);

	ПараметрыРоута = Новый Соответствие;
	ПараметрыРоута.Вставить("controller", "content");
	ПараметрыРоута.Вставить("action", "index");
	КоллекцияМаршрутов.Добавить("Контент", "{section}", ПараметрыРоута);
	КоллекцияМаршрутов.Добавить("КонтентПодраздел", "{section}/{subsection}", ПараметрыРоута);
	КоллекцияМаршрутов.Добавить("КонтентСтраница", "{section}/{subsection}/{id}", ПараметрыРоута);

	Если Использовать404 Тогда
		ПараметрыРоута = Новый Соответствие;
		ПараметрыРоута.Вставить("controller","home");
		ПараметрыРоута.Вставить("action","page404");
		КоллекцияМаршрутов.Добавить("СтраницаНеНайдена","{*url}", ПараметрыРоута);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработчикОшибок()

КонецПроцедуры
