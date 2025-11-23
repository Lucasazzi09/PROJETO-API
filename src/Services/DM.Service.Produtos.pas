unit DM.Service.Produtos;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Datasnap.Provider,
  Datasnap.DBClient,
  DM.Service.Banco;

type
  TDMServiceProdutos = class(TDataModule)
    QryProdutos: TFDQuery;
    DSprodutos: TDataSource;
    CDSProdutos: TClientDataSet;
    DSPProdutos: TDataSetProvider;
    CDSProdutosid: TIntegerField;
    CDSProdutoscodigo_interno: TIntegerField;
    CDSProdutosdescricao: TWideStringField;
    CDSProdutosestoque_atual: TIntegerField;
    CDSProdutospreco_venda: TBCDField;
    CDSProdutosdata_recebimento: TSQLTimeStampField;
    CDSProdutosstatus: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  DMServiceProdutos: TDMServiceProdutos;

implementation

{$R *.dfm}

{ TDMServiceCidades }

procedure TDMServiceProdutos.DataModuleCreate(Sender: TObject);
begin
  QryProdutos.Open;
  CDSProdutos.Open;
end;

end.
