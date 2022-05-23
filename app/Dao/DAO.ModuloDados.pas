unit DAO.ModuloDados;

interface

uses
  SysUtils, Classes, WideStrings, DBXMySql, DB, SqlExpr, FMTBcd, MidasLib,
  DBXCommon, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TModuleConnection = class(TDataModule)
    FConnection: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    Transacao: TFDTransaction;

  public
    procedure TransStart;
    procedure TransCommit;
    procedure TransRollBack;
  published
    function Conexao: TFDConnection;
  end;

var
  ModuleConnection: TModuleConnection;

implementation

{$R *.dfm}

function TModuleConnection.Conexao: TFDConnection;
begin
  if (not Assigned(FConnection)) then
    FConnection := TFDConnection.Create(Self);

  Result := FConnection;
end;

procedure TModuleConnection.DataModuleCreate(Sender: TObject);
begin
  try
    with Conexao do
    begin
      Close;

      Params.Values['Database']     := 'wkvendas';
      Params.Values['CharacterSet'] := 'utf8mb4';
      Params.Values['Server']       := '127.0.0.1';
      Params.Values['User_Name']    := 'root';
      Params.Values['Password']     := 'root';
      Params.Values['DriverID']     := 'MySQL';

      Open;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Conexão Falhou:' + sLineBreak + E.Message);
    end;
  end;
end;

procedure TModuleConnection.TransCommit;
begin
  Conexao.CommitRetaining;
end;

procedure TModuleConnection.TransRollBack;
begin
  Conexao.RollbackRetaining;
end;

procedure TModuleConnection.TransStart;
begin
  Conexao.StartTransaction;
end;

end.
