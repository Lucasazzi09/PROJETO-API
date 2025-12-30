Program API;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.JSON,
  System.SysUtils,
  Horse.BasicAuthentication,
  Horse.Compression,
  Horse.HandleException,
  Horse.Paginate,
  DataSet.Serialize,
  FireDAC.Comp.Client,
  Winapi.Windows,
  DM.Service.Produto in 'src\Services\DM.Service.Produto.pas',
  DM.Service.Banco in 'src\Services\DM.Service.Banco.pas',
  UAuthConfig in 'src\Util\UAuthConfig.pas',
  ULogConfig in 'src\Util\ULogConfig.pas',
  UController.Produto in 'src\Controller\UController.Produto.pas',
  URouter.Produto in 'src\Routers\URouter.Produto.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  // Difinindo o titulo da API
  SetConsoleTitle('API ECOMMERCE');

  if not Assigned(DMServiceBanco) then
    DMServiceBanco := TDMServiceBanco.Create(nil);

  if not DMServiceBanco.ConectarBD then
    begin
      Writeln('');
      Writeln('Não foi possível conectar no banco. API não será iniciada');
      Writeln('Pressione ENTER para sair');
      Readln;
      Exit;
    end;

  //Se conectado no banco, API funciona normalmente
  Writeln('Conectado no banco com sucesso');

  THorse.Create;

 // Middlewares
  Thorse
   .Use(Jhonson)
   .Use(Paginate);


  // Autenticacao e Configuracao do Log
  ConfigurarAutenticacao;
  ConfigurarLog;

  // Registrar rotas
  RegistrarRotasProduto;

  Writeln('Servidor rodando na porta 9000...');
  Thorse.Listen(9000); // Inicia o Servidor na porta 9000

end.
