unit DM.Service.Produto;

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
  System.JSON,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  Datasnap.DBClient,
  Datasnap.Provider;

type
  TDMServiceProduto = class(TDataModule)
  private
    { Private declarations }
  public
    class function GetProdutoPorCodigo(Codigo: Integer): TJSONObject;
    class function CriarProduto(JSON: TJSONObject): TJSONObject;
    class function GetProdutos: TJSONArray;
  end;

var
  DMServiceProduto: TDMServiceProduto;

implementation

{$R *.dfm}

uses
  DM.Service.Banco;

/// / ********* ROTA GET ******** ////
class function TDMServiceProduto.GetProdutos: TJSONArray;
var
  LQuery: TFDQuery;
  LItem: TJSONObject;
begin
  Result := TJSONArray.Create;
  LQuery := TFDQuery.Create(nil);

  try
    try
      LQuery.Connection := DMServiceBanco.ConexaoBDEcommerce;
      LQuery.SQL.Text := 'SELECT ID, CODIGO_INTERNO, DESCRICAO, ESTOQUE_ATUAL,'+
      'PRECO_VENDA, STATUS FROM TAB_PRODUTO_RECEBIMENTO';

      LQuery.Open;

      while not LQuery.Eof do
      begin
        LItem := TJSONObject.Create;

        LItem.AddPair('id', TJSONNumber.Create(LQuery.FieldByName('ID')
          .AsInteger));
        LItem.AddPair('codigo_interno',
          TJSONNumber.Create(LQuery.FieldByName('CODIGO_INTERNO').AsInteger));
        LItem.AddPair('descricao', LQuery.FieldByName('DESCRICAO').AsString);
        LItem.AddPair('estoque_atual',
          TJSONNumber.Create(LQuery.FieldByName('ESTOQUE_ATUAL').AsInteger));
        LItem.AddPair('preco_venda',
          TJSONNumber.Create(LQuery.FieldByName('PRECO_VENDA').AsFloat));
        LItem.AddPair('status', LQuery.FieldByName('STATUS').AsString);

        Result.AddElement(LItem);
        LQuery.Next;
      end;
    except
      on E: Exception do
        raise Exception.Create('Erro ao buscar produto: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

class function TDMServiceProduto.GetProdutoPorCodigo(Codigo: Integer)
  : TJSONObject;
var
  LQuery: TFDQuery;
begin
  Result := nil;
  LQuery := TFDQuery.Create(nil);

  try
    try
      LQuery.Connection := DMServiceBanco.ConexaoBDEcommerce;
      LQuery.SQL.Text := 'SELECT ID, CODIGO_INTERNO, DESCRICAO, ESTOQUE_ATUAL,'
        + 'PRECO_VENDA, STATUS FROM TAB_PRODUTO_RECEBIMENTO WHERE CODIGO_INTERNO'
        + '= :CODIGO';

      LQuery.ParamByName('CODIGO').AsInteger := Codigo;
      LQuery.Open;

      if not LQuery.IsEmpty then
      begin
        Result := TJSONObject.Create;
        try
          Result.AddPair('id', TJSONNumber.Create(LQuery.FieldByName('ID')
            .AsInteger));
          Result.AddPair('codigo_interno',
            TJSONNumber.Create(LQuery.FieldByName('CODIGO_INTERNO').AsInteger));
          Result.AddPair('descricao', LQuery.FieldByName('DESCRICAO').AsString);
          Result.AddPair('estoque_atual',
            TJSONNumber.Create(LQuery.FieldByName('ESTOQUE_ATUAL').AsInteger));
          Result.AddPair('preco_venda',
            TJSONNumber.Create(LQuery.FieldByName('PRECO_VENDA').AsFloat));
          Result.AddPair('status', LQuery.FieldByName('STATUS').AsString);

        except
          Result.Free;
          raise;
        end;
      end;
    except
      on E: Exception do
        raise Exception.Create('Erro ao buscar produto: ' + E.Message);
    end;
  finally
    LQuery.Free;
  end;
end;

/// / ******** ROTA POST ******** ////
class function TDMServiceProduto.CriarProduto(JSON: TJSONObject): TJSONObject;
var
  LQuery: TFDQuery;
  LCodigoInterno: Integer;
  LDescricao: string;
  LEstoqueAtual: Integer;
  LPrecoVenda: Currency;
  LStatus: string;
begin
  Result := nil;

  try
    // Extrai dados do JSON
    if JSON.TryGetValue<Integer>('codigo_interno', LCodigoInterno) and
      JSON.TryGetValue<string>('descricao', LDescricao) and
      JSON.TryGetValue<Integer>('estoque_atual', LEstoqueAtual) and
      JSON.TryGetValue<Currency>('preco_venda', LPrecoVenda) and
      JSON.TryGetValue<string>('status', LStatus) then
    begin

      //Exceptions antes de criar o produto:
      if LPrecoVenda <= 0 then
        raise Exception.Create('Preço de venda deve ser maior que zero.');


      LQuery := TFDQuery.Create(nil);
      try
        LQuery.Connection := DMServiceBanco.ConexaoBDEcommerce;
        LQuery.SQL.Text := 'INSERT INTO TAB_PRODUTO_RECEBIMENTO ' +
          '(CODIGO_INTERNO, DESCRICAO, ESTOQUE_ATUAL, PRECO_VENDA, STATUS) ' +
          'VALUES (:CODIGO, :DESCRICAO, :ESTOQUE, :PRECO, :STATUS)';

        LQuery.ParamByName('CODIGO').Value := LCodigoInterno;
        LQuery.ParamByName('DESCRICAO').Value := LDescricao;
        LQuery.ParamByName('ESTOQUE').Value := LEstoqueAtual;
        LQuery.ParamByName('PRECO').Value := LPrecoVenda;
        LQuery.ParamByName('STATUS').Value := LStatus;

        LQuery.ExecSQL;

        // Retorna resultado de sucesso
        Result := TJSONObject.Create;
        Result.AddPair('status', 'success');
        Result.AddPair('message', 'Produto criado com sucesso');
        Result.AddPair('codigo_interno', TJSONNumber.Create(LCodigoInterno));

      finally
        LQuery.Free;
      end;
    end
    else
    begin
      raise Exception.Create('JSON inválido ou campos faltando');
    end;

  except
    on E: Exception do
    begin
      Result := TJSONObject.Create;
      Result.AddPair('status', 'error');
      Result.AddPair('message', E.Message);
    end;
  end;
end;

end.
