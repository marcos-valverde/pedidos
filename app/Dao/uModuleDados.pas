unit uModuleDados;

interface

uses
  SysUtils, Classes, WideStrings, DBXMySql, DB, SqlExpr, FMTBcd, MidasLib,
  DBXCommon, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDataModule1 = class(TDataModule)
    Conexao: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  try
    with Conexao do
    begin
      Params.Values['DriverID']  := 'MySQL';
      Params.Values['User_Name'] := 'root';
      Params.Values['Password']  := 'root';
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Conexão Falhou:' + sLineBreak + e.Message);
    end;
  end;

end;

end.
