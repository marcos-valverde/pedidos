object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 314
  object Conexao: TFDConnection
    Params.Strings = (
      'DriverID=MySQL'
      'User_Name=root'
      'Password=root')
    LoginPrompt = False
    Left = 64
    Top = 56
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'F:\pedidos\libmysql.dll'
    Left = 168
    Top = 64
  end
end
