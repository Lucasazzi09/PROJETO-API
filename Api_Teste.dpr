program Api_Teste;

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
  DataSet.Serialize,
  ULogConfig in 'src\ULogConfig.pas',
  UAuthConfig in 'src\UAuthConfig.pas',
  DM.Service.Produtos in 'src\Services\DM.Service.Produtos.pas',
  DM.Service.Banco in 'src\Services\DM.Service.Banco.pas',
  FireDAC.Comp.Client,
  Winapi.Windows;

var
  App: THorse;
  Produtos: TJSONArray;

begin
  ReportMemoryLeaksOnShutdown := True;

  if not Assigned(DMServiceBanco) then
    DMServiceBanco := TDMServiceBanco.Create(nil);

  // Difinindo o título da API
  SetConsoleTitle('API ECOMMERCE');
  App := THorse.Create;
  App.Port := 9000; // Define a porta que a API usa

  App.Use(Jhonson);
  App.Use(HandleException);

  ConfigurarAutenticacao(App);
  ConfigurarLog;

  Produtos := TJSONArray.Create;

  /// / ******** ROTA POST ******** ////

  App.Post('/produtos',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LBody: TJSONObject;
      LCodigoInterno: Integer;
      LDescricao: string;
      LEstoqueAtual: Integer;
      LPrecoVenda: Currency;
      LQuery: TFDQuery;
      LStatus: String;

    begin

      try
        LBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;

        // Extrai dados do JSON
        LCodigoInterno  := LBody.GetValue<Integer>('codigo_interno');
        LDescricao      := LBody.GetValue<string>('descricao');
        LEstoqueAtual   := LBody.GetValue<Integer>('estoque_atual');
        LPrecoVenda     := LBody.GetValue<Currency>('preco_venda');
        LStatus         := LBody.GetValue<String>('status');

        // Persiste no banco
        LQuery := TFDQuery.Create(nil);
        try
          LQuery.Connection := DMServiceBanco.ConexaoBDEcommerce;
          LQuery.SQL.Text :=
            'insert into tab_produto_recebimento (codigo_interno, descricao, estoque_atual, preco_venda, status) '
            + 'values (:codigo, :descricao, :estoque, :preco, :status)';

          LQuery.ParamByName('codigo').Value    := LCodigoInterno;
          LQuery.ParamByName('descricao').Value := LDescricao;
          LQuery.ParamByName('estoque').Value   := LEstoqueAtual;
          LQuery.ParamByName('preco').Value     := LPrecoVenda;
          LQuery.ParamByName('status').Value    := LStatus;

          LQuery.ExecSQL;

          Res.Status(201).Send(TJSONObject.Create.AddPair('status', 'success')
            .AddPair('message', 'Produto criado com sucesso')
            .AddPair('codigo_interno', LCodigoInterno.ToString));

        finally
          LQuery.Free;
        end;

      except
        on E: Exception do
          Res.Status(500).Send(TJSONObject.Create.AddPair('status', 'error')
            .AddPair('message', E.Message));
      end;
    end);

  /// / ********* ROTA GET ********    /////

  App.Get('/produtos/codigo/:codigo',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LCodigo: string;
      LQuery: TFDQuery;
      LJSON: TJSONObject;
    begin
      try
        LCodigo := Req.Params.Items['codigo'];

        LQuery := TFDQuery.Create(nil);
        try
          LQuery.Connection := DMServiceBanco.ConexaoBDEcommerce;
          LQuery.SQL.Text :=
            'select id, codigo_interno, descricao, estoque_atual, preco_venda, status '
            + 'from tab_produto_recebimento where codigo_interno = :codigo';

          LQuery.ParamByName('codigo').AsInteger := LCodigo.ToInteger;
          LQuery.Open;

          if not LQuery.IsEmpty then
          begin
            LJSON := TJSONObject.Create.AddPair('id', LQuery.FieldByName('id')
              .AsInteger).AddPair('codigo_interno',
                LQuery.FieldByName('codigo_interno').AsInteger)
              .AddPair('descricao', LQuery.FieldByName('descricao').AsString)
              .AddPair('estoque_atual', LQuery.FieldByName('estoque_atual')
              .AsInteger).AddPair('preco_venda',
                LQuery.FieldByName('preco_venda').AsFloat);

            Res.Send<TJSONObject>(LJSON);
          end
          else
            Res.Status(404).Send(TJSONObject.Create.AddPair('error',
              'Produto não encontrado'));

        finally
          LQuery.Free;
        end;

      except
        on E: Exception do
          Res.Status(500).Send(TJSONObject.Create.AddPair('error', E.Message));
      end;
    end);

  Writeln('Servidor rodando na porta 9000...');
  App.Listen; // Inicia o Servidor na porta 9000

  DMServiceBanco.Free;
  App.Free;

end.
