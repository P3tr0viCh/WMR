unit WMRStrings;

interface
                                                             
resourcestring
  rsCopyright = '© К.П. Дураев, Уральская Сталь, ЦВТС, 2004-2023|По возникшим вопросам обращаться непосредственно к автору';
  rsAddComp   = '• База данных Access, входящая в состав Microsoft® Office,'#13#10 +
                '  © Корпорация Майкрософт, 2003.'#13#10 +
                '• MySQL ODBC 3.51, © MySQL AB, 2005.'#13#10 +
                '• Async Professional 4.07,'#13#10 +
                '  © TurboPower Software Company, 2002.';

  rsConnectionLocal  = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False;User ID=Admin;Jet OLEDB:Database Password="%s";';
  rsConnectionVescom = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False;User ID=Admin;Jet OLEDB:Database Password="";';
  rsConnectionServer = 'DRIVER={MySQL ODBC 3.51 Driver};SERVER=%s;PORT=%s;DATABASE=wdb3;USER=%s;PASSWORD=%s;OPTION=3;';

  rsHelpFile = 'Help.chm';

  rsVescomDynModule  = 'RWSDynamic.exe';
  rsVescomLoadModule = 'RWSLoader.exe';
  rsVescomDataBase   = 'RailWeight.mdb';

  rsDateTimeFormatSQL  = 'yyyy"-"mm"-"dd" "hh":"nn":"ss';
  rsDateTimeFormat1    = 'dd.mm.yy hh:nn:ss';
  rsDateTimeFormat2    = 'dd.mm.yy hh:nn';
  rsDateTimeFormatLog  = 'yyyy"-"mm"-"dd" "hh":"nn":"ss';

  rsStateManual  = 'Ручное взвешивание';
  rsStateAuto    = 'Автоматическое взвешивание';
  rsStateLtR     = 'слева направо >>>';
  rsStateRtL     = 'справа налево <<<';
  rsStateEdit    = 'Редактирование';
  rsStateView    = 'Просмотр';

  rsTrainsEdit   = 'Изменить';
  rsTrainsView   = 'Посмотреть';

  rsNo              = 'Нет';
  rsUnknownReceiver = 'Неизвестен';

  rsSendYes   = '+';
  rsSendNo    = '-';

  rsTotal        = 'Итого:';
  rsUserName     = 'Оператор: ';
  rsCountData    = 'До перезагрузки индикатора CI6000A осталось: ';
  rsAllRecords   = 'Все записи';
  rsFilterApply  = 'Включён фильтр';

  rsServerOFF    = 'Сервер отключен';

  rsFilterTrains = 'Filter';

  rsShowFilterAllDate  = 'Любая';
  rsShowFilterDate     = 'С %s по %s';

  rsRecords         = 'записи';
  rsNoRecords       = 'В базе данных отсутствуют вагоны для данного состава';
  rsRecordCount     = 'Всего записей: %d';
  rsRecordCountSel  = 'Выделено записей: %d';

  rsReportAllVans   = 'Данные по вагонам';
  rsReportTrain     = 'Провеска';
  rsReportSpeed     = 'Скорость движения: %s км/ч';

  rsVescomStateNoConnect  = 'Нет связи с модулем';
  rsVescomStateNoTerminal = 'Нет связи с терминалом';
  rsVescomStateWait       = 'Ожидание состава';
  rsVescomStateWeight     = 'Идёт взвешивание';
  rsVescomStateEndWork    = 'Чтение состава';

  rsProgressInLAN         = ' (сервер)';
  rsProgressDataRead      = ' (запрос)';
  rsProgressConnection    = 'Соединение с базой';
  rsProgressScaleInfoSave = 'Сохранение данных о весах';
  rsProgressUserNameSave  = 'Сохранение имени пользователя';
  rsProgressIssueSave     = 'Сохранение номера выпуска';
  rsProgressIssueLoad     = 'Чтение номера выпуска';
  rsProgressTaresSave     = 'Сохранение тары';
  rsProgressTaresLoad     = 'Чтение тары';
  rsProgressVans          = 'База по вагонам';
  rsProgressTrainSave     = 'Сохранение поезда';
  rsProgressTrainLoad     = 'Чтение поезда';
  rsProgressDelVans       = 'Удаление вагонов';
  rsProgressReport        = 'Создание отчёта';
  rsProgressExcel         = 'Запуск Microsoft Excel';
  rsProgressFormat        = 'Форматирование отчёта';

  rsServerChangeUser      = 'Смена оператора';

  rsQuestionSave1         = 'Сохранить результаты провески?';
  rsQuestionSave2         = 'Сохранить сделанные изменения?';
  rsQuestionDelete        = 'Удалить выделенные %s?'#13#10 +
                            'Отмена данного действия невозможна';
  rsQuestionCloseProgram  = 'Закрыть программу?';

  rsQuestionTaresSave     = 'Вес "Тары до" будет заменён на значение из базы ковшей,'#13#10 +
                            'а вес "Тары после" станет равным весу "Брутто" и будет сохранён в базе';
  rsQuestionTaresLoad     = 'Вес "Тары до" или "Тары после"'#13#10 +
                            '(в зависимости от выбора) ' +
                            'будет заменён на значение из базы ковшей';
  rsQuestionContinueTares = '.'#13#10#13#10'Продолжить?';
  rsQuestionVescomNewTrain= 'В базе данных "Веском" находится несохранённый состав. Открыть его для редактирования?';

  rsMessageNoRecord = 'Нет записей';

  rsError           = 'Ошибка';

  rsErrorLocalNotExists   = 'Локальная база данных не существует или недоступна в данный момент';
  rsErrorVescomDBNotExists= 'База данных "Веском" (%s) не существует или недоступна в данный момент';
  rsErrorVescomNotExists  = 'Модуль взвешивания "Веском" (%s) не существует или недоступен в данный момент';
  rsErrorAvitekNotExists  = 'Модуль передачи "Авитек" (%s) не существует или недоступен в данный момент';
  rsErrorServerNotExists  = 'Произошла ошибка во время открытия сетевой базы данных:'#13#10 +
                           '"%s".'#13#10#13#10 +
                           'Все сделанные изменения будут храниться в локальной базе данных и станут недоступны сетевым пользователям';
  rsErrorSettingsNotExists= 'Файл с настройками не существует';
  rsErrorLocalOpen        = 'Произошла ошибка во время открытия локальной базы данных:'#13#10 +
                           '"%s"';
  rsErrorVescomOpen       = 'Произошла ошибка во время открытия базы данных "Веском":'#13#10 +
                           '"%s"';
  rsErrorSettingsBad      = 'Файл с настройками повреждён';
  rsErrorCloseApp         = '.'#13#10#13#10'Данная база необходима для работы, поэтому программа закрывается';

  rsErrorOpenPort      = 'Нет доступа к порту COM%d.'#13#10'Возможно он занят другим процессом';
  rsErrorNumber        = 'Необходимо ввести положительное число';
  rsErrorServerRead    = 'Необходимо ввести номера весов через запятую, при этом нельзя вводить номер данных весов';
  rsErrorString        = 'Необходимо ввести строку';
  rsErrorSelectUser    = 'Выберите пользователя';
  rsErrorNeedUser      = 'Введите имя пользователя';
  rsErrorExistsUser    = 'Пользователь с именем "%s" уже существует';
  rsErrorCheckPass     = 'Введённые пароли не совпадают. Повторите ввод нового пароля и его подверждения';
  rsErrorPassword      = 'Забыли пароль?'#13#10#13#10 +
                         'Введите пароль заново.'#13#10 +
                         'Проверьте правильность используемого регистра и раскладки клавиатуры';
  rsErrorCheckVanNums  = 'Не введены номера вагонов, либо имеются совпадения';
  rsErrorCheckPath     = 'Папка "%s" не существует';

  rsErrorSaveLoad      = 'Не удалось %s, так как произошла ошибка:'#13#10#13#10'%s';
  rsErrorSave          = 'сохранить %s в %s базе данных';
  rsErrorLoad          = 'прочитать %s из %s базы данных';
  rsErrorDelete        = 'удалить %s из %s базы данных';
  rsErrorLocalDB       = 'локальной';
  rsErrorServerDB      = 'сетевой';
  rsErrorVescomDB      = '"Вескомовской"';
  rsErrorSLSettings    = 'настройки';
  rsErrorSLIssues      = 'номера выпусков';
  rsErrorSLVans        = 'вагоны';
  rsErrorSLTrain       = 'поезд';
  rsErrorSLTrains      = 'поезда';
  rsErrorSLTares       = 'тары';
  rsErrorSLScaleInfo   = 'данные о весах';
  rsErrorSLUserName    = 'имя пользователя';

  rsErrorNoExcel    = 'Для сохранения данных необходим Microsoft® Office Excel';

  rsTableLocalVans        = 'vans';
  rsTableLocalTares       = 'tares';

  rsTableServerVans       = 'vndynb';
  rsTableServerTares      = 'vndynt';
  rsTableServerScalesInfo = 'scalesinfo';
  rsTableServerWeightStep = 'heap_weighstep';

  rsTableIssues           = 'issues';

  rsTableVescomTrains     = 'trains';
  rsTableVescomVans       = 'cars';

  rsSQLServerScalesInfo   = 'scales, ctime, cdatetime, ipaddr, type, sclass, dclass, place, tag1';
  rsSQLServerWeightStep   = 'num, scales, wtime, wdatetime, step, operator, opdatetime, message';

  rsSQLLocalVans          = 'trnum, num, wtime, bdatetime, bake, issue, vannum, vantype, cargotype, brutto, tarebefore, ' +
                           'tareafter, receiver, velocity, operator, send';
  rsSQLServerVansSave     = 'trnum, scales, num, wtime, bdatetime, vannum, vantype, tare, brutto, netto, ' +
                           'velocity, cargotype, naxis, operator, invoice_num, ' +
                           'invoice_supplier, invoice_recipient, invoice_netto, invoice_tare, invoice_overload';
  rsSQLServerVansLoad     = 'trnum, num, wtime, bdatetime, invoice_supplier, invoice_num, ' +
                           'vannum, vantype, cargotype, brutto, tare, invoice_tare, invoice_recipient, ' +
                           'velocity, operator';
  rsSQLServerAllVansLoad  = '%0:s.trnum, %0:s.num, %0:s.wtime, %0:s.bdatetime, %0:s.invoice_supplier, %0:s.invoice_num, ' +
                           '%0:s.vannum, %0:s.vantype, %0:s.cargotype, %0:s.brutto, %0:s.tare, %0:s.invoice_tare, ' +
                           '%0:s.invoice_recipient, %0:s.velocity, %0:s.operator, %1:s.place, %0:s.scales';
  rsSQLVescomVansLoad     = 'AxisNumber, Weight, Velocity';

  rsSQLTaresLoad          = 'tare';
  rsSQLLocalAllTaresLoad  = 'vannum, tare, bdatetime, index';
  rsSQLServerAllTaresLoad = '%0:s.vannum, %0:s.tare, %0:s.bdatetime, %1:s.place, %0:s.scales, %0:s.wtime';
  rsSQLLocalTaresSave     = 'bdatetime, vannum, tare, velocity, operator';
  rsSQLServerTaresSave    = 'scales, num, wtime, bdatetime, vannum, vantype, tare, velocity, naxis, operator';

  rsSQLIssues             = 'bake, issue';

  rsSQLVescomTrain        = 'TrainCode, DTWeigh, Direction';

  rsSQLScalesPlace        = '(%s.scales=%s.scales)';
  rsSQLLocalNotSend       = '(send=false)';

  rsSQLInsert    = 'INSERT INTO %s (%s) VALUES (%s)';
  rsSQLUpdate    = 'UPDATE %s SET %s WHERE %s';
  rsSQLDelete    = 'DELETE FROM %s';
  rsSQLSelect    = 'SELECT %s FROM %s';
  rsSQLWhere     = ' WHERE ';
  rsSQLOrder     = ' ORDER BY ';
  rsSQLLimitOne  = ' LIMIT 1';
  rsSQLOrderDesc = ' DESC';
  rsSQLCount     = 'COUNT(*)';

  rsNameEqualValue = '%s=%s';

  rsIndex              = 'index';
  rsTrainIndex         = 'trnum';
  rsScalesIndex        = 'scales';
  rsVanNumIndex        = 'vannum';
  rsWTimeIndex         = 'wtime';
  rsVescomTrainIndex   = 'TrainCode';

  rsBakeIndex    = 'bake';
  rsIssueName    = 'issue';

  rsFilterAnd    = ' AND ';

  rsFilterDate1  = '(%0:s.bdatetime>=%1:s)';
  rsFilterDate2  = '((%0:s.bdatetime>=%1:s) AND (%0:s.bdatetime<=%2:s))';

  rsLOGStartProgram    = '<><><><><><><>< START PROGRAM WMR %s ><><><><><><><>';
  rsLOGStopProgram     = 'STOP PROGRAM';
  rsLOGError           = 'ERROR: ';
  rsLOGScaleInfoSave   = 'save scale info';
  rsLOGUserNameSave    = 'save user name';
  rsLOGSettingsSave    = 'save settings';
  rsLOGIssueLoad       = 'load issue';
  rsLOGTrainLoad       = 'load train';
  rsLOGTrainLoadVescom = 'load train from vescom: trainindex = ';
  rsLOGTrainLoadCount  = ' (%d)';
  rsLOGTareSave        = 'save tare';
  rsLOGTareLoad        = 'load tare';
  rsLOGTareDelete      = 'delete tare';
  rsLOGTrainSave1      = 'save train open';
  rsLOGTrainSave2      = 'save train delete old';
  rsLOGTrainSave       = 'save train';
  rsLOGBruttoLoad      = 'load brutto';
  rsLOGVanDelete       = 'delete van';
  rsLOGFormTrain       = 'train';
  rsLOGFormBrutto      = 'brutto';
  rsLOGFormTare        = 'tare';
  rsLOGFormTareLoad    = 'load tare';
  rsLOGFormIssue       = 'issue';
  rsLOGFormAuto        = 'start auto';
  rsLOGFormVescom      = 'start vescom';
  rsLOGFormOptions     = 'options';
  rsLOGFormFilter      = 'filter';
  rsLOGFilterClear     = 'filter clear';
  rsLOGFilterApply     = 'filter apply';
  rsLOGFilterAll       = 'all';
  rsLOGTareBefore      = '(before)';
  rsLOGTareAfter       = '(after)';
  rsLOGCancel          = '(cancel)';
  rsLogGross           = 'gross = ';
  rsLogAddGross        = '>>> add';
  rsLogSplit           = 'split';

  rsLOGVescomRunModule       = 'start vescom module';
  rsLOGVescomEndWork         = 'vescom work end: trainindex = ';
  rsLOGVescomStateNoConnect  = 'no connect with module';
  rsLOGVescomStateNoTerminal = 'no connect with terminal';
  rsLOGVescomStateWait       = 'waiting';
  rsLOGVescomStateWeight     = 'weight';

  rsLOGAvitekRunModule       = 'start avitek module';
  rsLOGAvitekNewData         = 'avitek new data';
  rsLOGAvitekOpenSession     = 'avitek open session';
  rsLOGAvitekCloseSession    = 'avitek close session';
  rsLOGAvitekCloseServer     = 'avitek close server';

implementation

end.
