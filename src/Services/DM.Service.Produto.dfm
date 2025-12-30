object DMServiceProduto: TDMServiceProduto
  Height = 140
  Width = 288
  object DSprodutos: TDataSource
    DataSet = CDSProdutos
    Left = 219
    Top = 29
  end
  object CDSProdutos: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DSPProdutos'
    Left = 130
    Top = 35
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
    Left = 35
    Top = 32
  end
end
