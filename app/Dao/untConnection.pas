unit untConnection;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.FB, System.SysUtils, FireDAC.DApt, FireDAC.VCLUI.Wait;

type
  TConnection = class
  private
    FConnection: TFDConnection;

    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor Destroy; override;

    function GetConnection: TFDConnection;
    function CriarQuery: TFDQuery;
  end;

implementation

{ TConnection }

procedure TConnection.ConfigurarConexao;
begin
  with FConnection do
  begin
    Params.DriverID := 'MySql';
    Params.Database := 'wkvendas';
    Params.UserName := 'root';
    Params.Password := '';
    LoginPrompt     := False;
  end;
end;

constructor TConnection.Create;
begin
  FConnection := TFDConnection.Create(nil);

  Self.ConfigurarConexao();
end;

function TConnection.CriarQuery: TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := TFDQuery.Create(nil);
  VQuery.Connection := FConnection;

  Result := VQuery;
end;

destructor TConnection.Destroy;
begin
  FConnection.Free;

  inherited;
end;

function TConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
