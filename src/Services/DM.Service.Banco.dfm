object DMServiceBanco: TDMServiceBanco
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 180
  Width = 199
  object ConexaoBDEcommerce: TFDConnection
    Params.Strings = (
      'Server='
      'Port='
      'DriverID=PG')
    LoginPrompt = False
    Left = 83
    Top = 21
  end
  object DriverLinkPostgre: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 79
    Top = 92
  end
end
