
//{$DEFINE NOCOMPORT}  // Не включать COM-порт

{$IFDEF DEBUG} // Режим отладки

  {$DEFINE FORCECLOSE} // Не выводить сообщение с подтверждением при закрытии

  {$DEFINE FORCELOGON} // Не показывать окно выбора пользователя

{$ENDIF}
