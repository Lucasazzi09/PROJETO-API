object DMServiceBanco: TDMServiceBanco
  OnCreate = DataModuleCreate
  Height = 180
  Width = 199
  PixelsPerInch = 96
  object ConexaoBDEcommerce: TFDConnection
    Params.Strings = (
      'Database=ECOMMERCE'
      'User_Name=postgres'
      'Password=@Dm1N'
      'Server='
      'DriverID=PG')
    Connected = True
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
