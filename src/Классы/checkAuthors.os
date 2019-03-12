#Использовать logos

Перем Лог;
Перем Обработчик;
Перем МассивНомеровВерсий;
Перем КаталогРабочейКопии;

#Область Интерфейс_плагина

// Возвращает версию плагина
//
//  Возвращаемое значение:
//   Строка - текущая версия плагина
//
Функция Версия() Экспорт
	Возврат "1.0.5";
КонецФункции

// Возвращает приоритет выполнения плагина
//
//  Возвращаемое значение:
//   Число - приоритет выполнения плагина
//
Функция Приоритет() Экспорт
	Возврат 0;
КонецФункции

// Возвращает описание плагина
//
//  Возвращаемое значение:
//   Строка - описание функциональности плагина
//
Функция Описание() Экспорт
	Возврат "Плагин добавляет функциональность проверки автора версии в хранилище и файла AUTHORS";
КонецФункции

// Возвращает подробную справку к плагину 
//
//  Возвращаемое значение:
//   Строка - подробная справка для плагина
//
Функция Справка() Экспорт
	Возврат "Справка плагина";
КонецФункции

// Возвращает имя плагина
//
//  Возвращаемое значение:
//   Строка - имя плагина при подключении
//
Функция Имя() Экспорт
	Возврат "check-authors";
КонецФункции 

// Возвращает имя лога плагина
//
//  Возвращаемое значение:
//   Строка - имя лога плагина
//
Функция ИмяЛога() Экспорт
	Возврат "oscript.lib.gitsync.plugins.check-authors";
КонецФункции

#КонецОбласти

#Область Подписки_на_события

Процедура ПриАктивизации(СтандартныйОбработчик) Экспорт

	Лог.Отладка("Активизация плагина <%1>", Имя());
	Обработчик = СтандартныйОбработчик;
	МассивНомеровВерсий = Неопределено;

КонецПроцедуры

Процедура ПередНачаломВыполнения(ПутьКХранилищу, ВходящийКаталогРабочейКопии) Экспорт

	Лог.Отладка("Начата работа плагина <%1>", Имя());
	КаталогРабочейКопии = ВходящийКаталогРабочейКопии;

КонецПроцедуры

Процедура ПередНачаломЦиклаОбработкиВерсий(ТаблицаИсторииХранилища, ТекущаяВерсия, СледующаяВерсия, МаксимальнаяВерсияДляРазбора) Экспорт

	ПутьКФайлуСопоставления = ОбъединитьПути(КаталогРабочейКопии, Обработчик.ИмяФайлаАвторов());
	ТаблицаСопоставления = Обработчик.ПрочитатьФайлАвторовГитВТаблицуПользователей(ПутьКФайлуСопоставления);

	КоличествоВерсий = 0;

	Для Каждого СтрокаВерсии Из ТаблицаИсторииХранилища Цикл

		Если СтрокаВерсии.НомерВерсии < ТекущаяВерсия Тогда
			Продолжить;
		КонецЕсли;

		СтрокаПользователя = ТаблицаСопоставления.Найти(СтрокаВерсии.Автор, "Автор");
		
		Если СтрокаПользователя = Неопределено Тогда

			Лог.Отладка("Проверяю строку: "+ СтрокаВерсии.НомерВерсии);
			СтрокаОшибки = СтрШаблон("Нашли версию <%1>, а автор <%2> не сопоставлен пользователь git.", 
									СтрокаВерсии.НомерВерсии,
									СтрокаВерсии.Автор);
			Лог.КритичнаяОшибка(СтрокаОшибки);
			КоличествоВерсий = КоличествоВерсий + 1;
		
		КонецЕсли;

	КонецЦикла;

	Если КоличествоВерсий > 0  Тогда

		СтрокаОшибки = СтрШаблон("В таблице истории версий найдены авторы (количество %1), которые не сопоставлены в AUTHORS", 
						КоличествоВерсий);

		ВызватьИсключение СтрокаОшибки;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

Процедура Инициализация()

	Лог = Логирование.ПолучитьЛог(ИмяЛога());
	КомандыПлагина = Новый Массив;
	КомандыПлагина.Добавить("sync");

КонецПроцедуры

Инициализация();
