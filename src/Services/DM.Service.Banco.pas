unit DM.Service.Banco;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.ConsoleUI.Wait,
  FireDAC.Phys.PGDef,
  FireDAC.Phys.PG,
  Data.DB,
  FireDAC.Comp.Client;

type
  TDMServiceBanco = class(TDataModule)
    ConexaoBDEcommerce: TFDConnection;
    DriverLinkPostgre: TFDPhysPgDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ConectarBD: Boolean;
  end;

var
  DMServiceBanco: TDMServiceBanco;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

function TDMServiceBanco.ConectarBD: Boolean;
begin
  try
    Result := False;

    if not ConexaoBDEcommerce.Connected then
      ConexaoBDEcommerce.Connected := True;

    Result := ConexaoBDEcommerce.Connected;

  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

procedure TDMServiceBanco.DataModuleCreate(Sender: TObject);
begin
    ConexaoBDEcommerce.Params.DriverID := 'PG';
    ConexaoBDEcommerce.Params.Database := 'ECOMMERCE';
    ConexaoBDEcommerce.Params.UserName := 'postgres';
    ConexaoBDEcommerce.Params.Password := '@Dm1N';
    ConexaoBDEcommerce.Params.Add('Server=localhost');
    ConexaoBDEcommerce.Params.Add('Port=5432');
    ConexaoBDEcommerce.Params.Add('CharacterSet=UTF8');
    ConexaoBDEcommerce.LoginPrompt := False;
end;

procedure TDMServiceBanco.DataModuleDestroy(Sender: TObject);
begin
  if ConexaoBDEcommerce.Connected then
   ConexaoBDEcommerce.Connected := False;
end;

end.
