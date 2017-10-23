Пароль базы Access: 96Allianc-E35
---------------------------------------------------------------------
*** Имена полей в БД ***

** Брутто **

* Локальная (VANS) *	   * Сетевая (VNDYNB) *
Номер печи (BAKE)	>> Грузоотправитель (INVOICE_SUPPLIER)
Номер выпуска (ISSUE)	>> Номер накладной (INVOICE_NUM)
Номер ковша (VANNUM)	>> Номер вагона (VANNUM)
Получатель (RECEIVER)	>> Грузополучатель (INVOICE_RECEPIENT)
Тара ДО (TAREBEFORE)	>> Тара (TARE)
Тара ПОСЛЕ (ТAREAFTER)	>> Тара по накладной (INVOICE_TARE)
Потери (вычисление)	>> Перегруз по накладной (INVOICE_OVERLOAD)
Чистый вес (вычисление)	>> Нетто по накладной (INVOICE_NETTO)

CREATE TABLE `vndynb` (
  `trnum` int(10) unsigned NOT NULL default '0',
  `scales` smallint(6) NOT NULL default '0',
  `num` smallint(5) unsigned NOT NULL default '0',
  `wtime` int(10) unsigned NOT NULL default '0',
  `bdatetime` datetime default '0000-00-00 00:00:00',
  `vannum` char(8) default '',
  `vantype` char(16) default '',
  `tare` float(16,2) default '0.00',
  `brutto` float(16,2) default '0.00',
  `netto` float(16,2) default '0.00',
  `overload` float(16,2) default '0.00',
  `velocity` float(16,2) default '0.00',
  `cargotype` char(32) default '',
  `naxis` smallint(5) unsigned NOT NULL default '0',
  `operator` char(24) default '',
  `invoice_num` char(16) default '',
  `invoice_supplier` char(32) default '',
  `invoice_recipient` char(32) default '',
  `invoice_netto` float(16,2) default '0.00',
  `invoice_tare` float(16,2) default '0.00',
  `invoice_overload` float(16,2) default '0.00',
  `tag1` int(11) default '0',
  `tag2` int(11) default '0',
  PRIMARY KEY  (`trnum`,`scales`,`num`,`wtime`),
  KEY `date_num` (`bdatetime`,`vannum`,`invoice_num`),
  KEY `num_date` (`vannum`,`bdatetime`,`invoice_num`),
  KEY `scales_wtime` (`scales`,`wtime`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;


** Номер выпуска **

* Локальная (ISSUES) = Сетевая *
Номер печи = BAKE С[32] Index
Номер выпуска = ISSUE C[16]

CREATE TABLE `issues` (
  `bake` char(32) NOT NULL default '',
  `issue` char(16) default NULL,
  PRIMARY KEY  (`bake`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

---------------------------------------------------------------------

Направление: Слева направо = True