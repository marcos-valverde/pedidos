object ModuleConnection: TModuleConnection
  Left = 0
  Top = 0
  ClientHeight = 111
  ClientWidth = 397
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  PixelsPerInch = 96
  TextHeight = 13
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
