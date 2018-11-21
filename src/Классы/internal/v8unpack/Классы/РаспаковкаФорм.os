#Использовать "../../bindata"
#Использовать logos

Перем КомпонентаГотова;
Перем Лог;
Перем ПутьКФайлу;

// Производит распаковку формы .bin
//
// Параметры:
//   ПутьКФайлуФормы - Строка - Путь к файлу form.bin
//   ПутьККаталогуФормы - Строка - Путь к каталогу распаковки
//
Процедура Распаковать(Знач ПутьКФайлуФормы, Знач ПутьККаталогуФормы) Экспорт
	
	Если Не КомпонентаГотова Тогда
		ПодготовитьКомпоненту();
	КонецЕсли;

	dllРаспаковать(ПутьКФайлуФормы, ПутьККаталогуФормы);

КонецПроцедуры

Процедура ПриСозданииОбъекта()
	КомпонентаГотова = Ложь;
КонецПроцедуры

Процедура dllРаспаковать(Знач ФайлРаспаковки, Знач КаталогРаспаковки)
		
	Распаковщик = Новый ЧтениеФайла8(ФайлРаспаковки);
	Распаковщик.ИзвлечьВсе(КаталогРаспаковки, Истина);
	
КонецПроцедуры

Процедура ПодготовитьКомпоненту()
	
	ЗагрузчикДвоичныхДанных = Новый ЗагрузчикЗапакованныхФайловGitsyncPlugins;
	ПутьКФайлу = ЗагрузчикДвоичныхДанных.ПолучитьПутьКФайлу("v8unpack.dll");
	//Лог.Отладка("Выполняю подключение <v8unpack.dll> из файла <%1>", ПутьКФайлу);
	ПодключитьВнешнююКомпоненту(ПутьКФайлу);
	КомпонентаГотова = Истина;

КонецПроцедуры

//Лог = Логирование.ПолучитьЛог("oscript.lib.gitsync.plugins.unpackForm");



