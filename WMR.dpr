program WMR;

uses
  Windows,
  Forms,
  Utils_Misc,
  WMRMain in 'WMRMain.pas' {Main},
  WMRTrain in 'WMRTrain.pas' {frmTrain},
  WMREdits in 'WMREdits.pas' {frmValueEdit},
  WMRStrings in 'WMRStrings.pas',
  WMRLogin in 'WMRLogin.pas' {frmLogin},
  WMRAdd in 'WMRAdd.pas',
  WMROptions in 'WMROptions.pas' {frmOptions},
  WMRProgress in 'WMRProgress.pas' {frmProgress},
  WMRFilter in 'WMRFilter.pas' {frmFilter},
  WMRWeightParams in 'WMRWeightParams.pas' {frmWeightParams},
  WMRAllTrains in 'WMRAllTrains.pas' {frmAllTrains},
  WMRAllLists in 'WMRAllLists.pas' {frmAllLists},
  WMRTaresLoad in 'WMRTaresLoad.pas' {frmTaresLoad},
  WMRVescom in 'WMRVescom.pas' {frmVescom};

{$R *.res}
{$R WMRAdd.res}

function FirstInstance: Boolean;
var
  AppHandle: THandle;
begin
  AppHandle := FindWindow(PChar('TApplication'), PChar('Весовое ПО (МР)'));
  Result := AppHandle = 0;
  if not Result then SwitchToThisWindow(AppHandle, True);
end;

begin
  {$IFNDEF DEBUG}
  if FirstInstance then
  {$ENDIF}
    begin
      Application.Initialize;
      Application.ShowMainForm := False;
      Application.Title := 'Весовое ПО (МР)';
      Application.CreateForm(TMain, Main);
  Application.Run;
    end;
end.
