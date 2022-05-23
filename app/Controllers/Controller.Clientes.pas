unit Controller.Clientes;

interface

uses Model.Cliente, DAO.ModuloDados, SysUtils, DB, SqlExpr,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TControllerCliente = class
  private

  public
    procedure CarregarDados(Codigo: Integer; Cliente: TCliente); overload;
    procedure CarregarDados(Nome: string; Cliente: TCliente); overload;
  end;

implementation

{ TControllerCliente }

procedure TControllerCliente.CarregarDados(Codigo: Integer; Cliente: TCliente);
var
  msgERRO: string;
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);

  try
    with Query do
    begin
      Connection := ModuleConnection.Conexao;

      Close;

      SQL.Clear;
      SQL.Add('SELECT id, nome, cidade, estado');
      SQL.Add('FROM clientes WHERE (id = :Codigo)');
      ParamByName('Codigo').AsInteger := Codigo;

      try
        ModuleConnection.TransStart;
        ModuleConnection.TransCommit;

        Open;

        Cliente.Codigo := FieldByName('id').AsInteger;;
        Cliente.Nome   := FieldByName('nome').AsString;
        Cliente.Cidade := FieldByName('cidade').AsString;
        Cliente.Estado := FieldByName('estado').AsString;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Carregar Dados do Cliente ' + IntToStr(Codigo);
          msgERRO := msgERRO + sLineBreak + E.Message;

          ModuleConnection.TransRollBack;
          raise Exception.Create(msgERRO);
        end;
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TControllerCliente.CarregarDados(Nome: string; Cliente: TCliente);
var
  msgERRO: string;
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);

  try
    with Query do
    begin
      Connection := ModuleConnection.Conexao;
      Close;
      SQL.Clear;
      SQL.Add('SELECT id, nome, cidade, estado');
      SQL.Add('FROM clientes WHERE (nome LIKE :nome)');
      ParamByName('nome').AsString := '%' + Nome + '%';

      try
        ModuleConnection.TransStart;
        ModuleConnection.TransCommit;

        Open;

        Cliente.Codigo := FieldByName('codigo').AsInteger;
        Cliente.Nome   := FieldByName('nome').AsString;
        Cliente.Cidade := FieldByName('cidade').AsString;
        Cliente.Estado := FieldByName('estado').AsString;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Carregar Dados do Cliente ' + Nome;
          msgERRO := msgERRO + sLineBreak + E.Message;

          ModuleConnection.TransRollBack;
          raise Exception.Create(msgERRO);
        end;
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

end.
