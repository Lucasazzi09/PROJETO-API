unit UController.Produto;

interface

uses
  Horse;

procedure GetProdutoPorCodigo(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
procedure GetProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CriarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  DM.Service.Produto,
  System.JSON,
  System.SysUtils,
  FireDAC.Stan.Error;

procedure GetProdutoPorCodigo(Req: THorseRequest; Res: THorseResponse;
  Next: TProc);
var
  Codigo: Integer;
  Resultado: TJSONObject;
begin
  Resultado := nil;
  try

    if not TryStrToInt(Req.Params.Items['CODIGO'], Codigo) then
    begin
      Res.Status(400).Send(TJSONObject.Create.AddPair('error',
        'Código Inválido! O código não é do tipo inteiro'));
      Exit;
    end;

    Resultado := TDMServiceProduto.GetProdutoPorCodigo(Codigo);

    if Assigned(Resultado) then
      Res.Send(Resultado)
    else
      Res.Status(404).Send(TJSONObject.Create.AddPair('error',
        'Produto não encontrado'));
  finally
    Resultado.Free;
  end;
end;

procedure GetProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Produtos: TJSONArray;
begin
  try
    Produtos := TDMServiceProduto.GetProdutos;
    Res.Status(200).Send<TJSONArray>(Produtos);
  except
    on E: Exception do
      Res.Status(500).Send(TJSONObject.Create.AddPair('error',
        'Erro ao buscar produtos').AddPair('message', E.Message));
  end;

end;

procedure CriarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LBody: TJSONObject;
  LCodigoInterno: Integer;
begin
  LBody := nil;
  try
    LBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

    if not Assigned(LBody) then
    begin
      Res.Status(400).Send(TJSONObject.Create.AddPair('status', 'error')
        .AddPair('message', 'JSON inválido'));
      Exit;
    end;

    // Extrai o codigo interno do JSON
    if not LBody.TryGetValue<Integer>('codigo_interno', LCodigoInterno) then
    begin
      Res.Status(400).Send(TJSONObject.Create.AddPair('status', 'error')
        .AddPair('message', 'Campo "codigo_interno" é obrigatório'));
      Exit;
    end;

    Res.Status(201).Send(TDMServiceProduto.CriarProduto(LBody));

  except
    on E: EFDDBEngineException do
    begin
      if E.Kind = ekUKViolated then
        Res.Status(409).Send(TJSONObject.Create.AddPair('status', 'error')
          .AddPair('message',
            'Produto já cadastrado (codigo_interno duplicado)'))
    end;
  end;
end;

end.
