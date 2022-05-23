object ModuleConnection: TModuleConnection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 413
  object FConnection: TFDConnection
    ConnectionName = 'mysql'
    Params.Strings = (
      'Database=wkvendas'
      'CharacterSet=utf8mb4'
      'Server=127.0.0.1'
      'User_Name=root'
      'Password=root'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    DriverID = 'MySQL'
    VendorLib = 'F:\pedidos\libmysql.dll'
    Left = 144
    Top = 16
  end
end
