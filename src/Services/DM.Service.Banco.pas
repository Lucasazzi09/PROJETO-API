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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DMServiceBanco: TDMServiceBanco;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDMServiceBanco.DataModuleCreate(Sender: TObject);
begin
  ConexaoBDEcommerce.Open;
end;

end.
