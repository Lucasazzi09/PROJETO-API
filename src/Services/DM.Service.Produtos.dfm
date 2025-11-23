object DMServiceProdutos: TDMServiceProdutos
  OnCreate = DataModuleCreate
  Height = 212
  Width = 323
  PixelsPerInch = 96
  object QryProdutos: TFDQuery
    Active = True
    MasterSource = DSprodutos
    Connection = DMServiceBanco.ConexaoBDEcommerce
    SQL.Strings = (
      'select * from public.tab_produto_recebimento')
    Left = 39
    Top = 40
  end
  object DSprodutos: TDataSource
    DataSet = CDSProdutos
    Left = 219
    Top = 109
  end
  object CDSProdutos: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPProdutos'
    Left = 218
    Top = 36
    object CDSProdutosid: TIntegerField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object CDSProdutoscodigo_interno: TIntegerField
      FieldName = 'codigo_interno'
      Origin = 'codigo_interno'
    end
    object CDSProdutosdescricao: TWideStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 100
    end
    object CDSProdutosestoque_atual: TIntegerField
      FieldName = 'estoque_atual'
      Origin = 'estoque_atual'
    end
    object CDSProdutospreco_venda: TBCDField
      FieldName = 'preco_venda'
      Origin = 'preco_venda'
      Precision = 10
      Size = 2
    end
    object CDSProdutosdata_recebimento: TSQLTimeStampField
      FieldName = 'data_recebimento'
      Origin = 'data_recebimento'
    end
    object CDSProdutosstatus: TWideStringField
      FieldName = 'status'
      Origin = 'status'
    end
  end
  object DSPProdutos: TDataSetProvider
    DataSet = QryProdutos
    Left = 123
    Top = 38
  end
end
