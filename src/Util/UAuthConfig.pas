unit UAuthConfig;

interface

uses
  Horse,
  Horse.BasicAuthentication,
  System.SysUtils;

procedure ConfigurarAutenticacao;

implementation

procedure ConfigurarAutenticacao;
begin
  THorse.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('Lucas') and APassword.Equals('123');
    end));
end;

end.

