unit WMRStrings;

interface
                                                             
resourcestring
  rsCopyright = '� �.�. ������, ��������� �����, ����, 2004-2023|�� ��������� �������� ���������� ��������������� � ������';
  rsAddComp   = '� ���� ������ Access, �������� � ������ Microsoft� Office,'#13#10 +
                '  � ���������� ����������, 2003.'#13#10 +
                '� MySQL ODBC 3.51, � MySQL AB, 2005.'#13#10 +
                '� Async Professional 4.07,'#13#10 +
                '  � TurboPower Software Company, 2002.';

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

  rsStateManual  = '������ �����������';
  rsStateAuto    = '�������������� �����������';
  rsStateLtR     = '����� ������� >>>';
  rsStateRtL     = '������ ������ <<<';
  rsStateEdit    = '��������������';
  rsStateView    = '��������';

  rsTrainsEdit   = '��������';
  rsTrainsView   = '����������';

  rsNo              = '���';
  rsUnknownReceiver = '����������';

  rsSendYes   = '+';
  rsSendNo    = '-';

  rsTotal        = '�����:';
  rsUserName     = '��������: ';
  rsCountData    = '�� ������������ ���������� CI6000A ��������: ';
  rsAllRecords   = '��� ������';
  rsFilterApply  = '������� ������';

  rsServerOFF    = '������ ��������';

  rsFilterTrains = 'Filter';

  rsShowFilterAllDate  = '�����';
  rsShowFilterDate     = '� %s �� %s';

  rsRecords         = '������';
  rsNoRecords       = '� ���� ������ ����������� ������ ��� ������� �������';
  rsRecordCount     = '����� �������: %d';
  rsRecordCountSel  = '�������� �������: %d';

  rsReportAllVans   = '������ �� �������';
  rsReportTrain     = '��������';
  rsReportSpeed     = '�������� ��������: %s ��/�';

  rsVescomStateNoConnect  = '��� ����� � �������';
  rsVescomStateNoTerminal = '��� ����� � ����������';
  rsVescomStateWait       = '�������� �������';
  rsVescomStateWeight     = '��� �����������';
  rsVescomStateEndWork    = '������ �������';

  rsProgressInLAN         = ' (������)';
  rsProgressDataRead      = ' (������)';
  rsProgressConnection    = '���������� � �����';
  rsProgressScaleInfoSave = '���������� ������ � �����';
  rsProgressUserNameSave  = '���������� ����� ������������';
  rsProgressIssueSave     = '���������� ������ �������';
  rsProgressIssueLoad     = '������ ������ �������';
  rsProgressTaresSave     = '���������� ����';
  rsProgressTaresLoad     = '������ ����';
  rsProgressVans          = '���� �� �������';
  rsProgressTrainSave     = '���������� ������';
  rsProgressTrainLoad     = '������ ������';
  rsProgressDelVans       = '�������� �������';
  rsProgressReport        = '�������� ������';
  rsProgressExcel         = '������ Microsoft Excel';
  rsProgressFormat        = '�������������� ������';

  rsServerChangeUser      = '����� ���������';

  rsQuestionSave1         = '��������� ���������� ��������?';
  rsQuestionSave2         = '��������� ��������� ���������?';
  rsQuestionDelete        = '������� ���������� %s?'#13#10 +
                            '������ ������� �������� ����������';
  rsQuestionCloseProgram  = '������� ���������?';

  rsQuestionTaresSave     = '��� "���� ��" ����� ������ �� �������� �� ���� ������,'#13#10 +
                            '� ��� "���� �����" ������ ������ ���� "������" � ����� ������� � ����';
  rsQuestionTaresLoad     = '��� "���� ��" ��� "���� �����"'#13#10 +
                            '(� ����������� �� ������) ' +
                            '����� ������ �� �������� �� ���� ������';
  rsQuestionContinueTares = '.'#13#10#13#10'����������?';
  rsQuestionVescomNewTrain= '� ���� ������ "������" ��������� ������������ ������. ������� ��� ��� ��������������?';

  rsMessageNoRecord = '��� �������';

  rsError           = '������';

  rsErrorLocalNotExists   = '��������� ���� ������ �� ���������� ��� ���������� � ������ ������';
  rsErrorVescomDBNotExists= '���� ������ "������" (%s) �� ���������� ��� ���������� � ������ ������';
  rsErrorVescomNotExists  = '������ ����������� "������" (%s) �� ���������� ��� ���������� � ������ ������';
  rsErrorAvitekNotExists  = '������ �������� "������" (%s) �� ���������� ��� ���������� � ������ ������';
  rsErrorServerNotExists  = '��������� ������ �� ����� �������� ������� ���� ������:'#13#10 +
                           '"%s".'#13#10#13#10 +
                           '��� ��������� ��������� ����� ��������� � ��������� ���� ������ � ������ ���������� ������� �������������';
  rsErrorSettingsNotExists= '���� � ����������� �� ����������';
  rsErrorLocalOpen        = '��������� ������ �� ����� �������� ��������� ���� ������:'#13#10 +
                           '"%s"';
  rsErrorVescomOpen       = '��������� ������ �� ����� �������� ���� ������ "������":'#13#10 +
                           '"%s"';
  rsErrorSettingsBad      = '���� � ����������� ��������';
  rsErrorCloseApp         = '.'#13#10#13#10'������ ���� ���������� ��� ������, ������� ��������� �����������';

  rsErrorOpenPort      = '��� ������� � ����� COM%d.'#13#10'�������� �� ����� ������ ���������';
  rsErrorNumber        = '���������� ������ ������������� �����';
  rsErrorServerRead    = '���������� ������ ������ ����� ����� �������, ��� ���� ������ ������� ����� ������ �����';
  rsErrorString        = '���������� ������ ������';
  rsErrorSelectUser    = '�������� ������������';
  rsErrorNeedUser      = '������� ��� ������������';
  rsErrorExistsUser    = '������������ � ������ "%s" ��� ����������';
  rsErrorCheckPass     = '�������� ������ �� ���������. ��������� ���� ������ ������ � ��� ������������';
  rsErrorPassword      = '������ ������?'#13#10#13#10 +
                         '������� ������ ������.'#13#10 +
                         '��������� ������������ ������������� �������� � ��������� ����������';
  rsErrorCheckVanNums  = '�� ������� ������ �������, ���� ������� ����������';
  rsErrorCheckPath     = '����� "%s" �� ����������';

  rsErrorSaveLoad      = '�� ������� %s, ��� ��� ��������� ������:'#13#10#13#10'%s';
  rsErrorSave          = '��������� %s � %s ���� ������';
  rsErrorLoad          = '��������� %s �� %s ���� ������';
  rsErrorDelete        = '������� %s �� %s ���� ������';
  rsErrorLocalDB       = '���������';
  rsErrorServerDB      = '�������';
  rsErrorVescomDB      = '"������������"';
  rsErrorSLSettings    = '���������';
  rsErrorSLIssues      = '������ ��������';
  rsErrorSLVans        = '������';
  rsErrorSLTrain       = '�����';
  rsErrorSLTrains      = '������';
  rsErrorSLTares       = '����';
  rsErrorSLScaleInfo   = '������ � �����';
  rsErrorSLUserName    = '��� ������������';

  rsErrorNoExcel    = '��� ���������� ������ ��������� Microsoft� Office Excel';

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
