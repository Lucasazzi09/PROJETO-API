unit ULogConfig;

interface

uses
  Horse,
  Horse.Logger,
  Horse.Logger.Provider.LogFile,
  System.SysUtils;

procedure ConfigurarLog;

implementation

procedure ConfigurarLog;
var
  LogFileConfig: THorseLoggerLogFileConfig;
begin
  LogFileConfig := THorseLoggerLogFileConfig.New.SetLogFormat
    ('[${time}] ${response_status} - ${request_method}' +
    ' ${request_path_info}')
    .SetDir('C:\Delphi_Projetos\API_REST_HORSE\logs_api');

  THorseLoggerManager.RegisterProvider
    (THorseLoggerProviderLogFile.New(LogFileConfig));
  THorse.Use(THorseLoggerManager.HorseCallback);
end;

end.
