unit Controller.Produtos;

interface

uses Model.Produto, DAO.ModuloDados, SysUtils, DB, SqlExpr,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TControllerProduto = class
  public
    procedure CarregarDados(Codigo: Integer; Produto: TProduto); overload;
    procedure CarregarDados(Descricao: string; Produto: TProduto); overload;
  end;

implementation

{ TControllerProduto }

procedure TControllerProduto.CarregarDados(Codigo: Integer; Produto: TProduto);
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
      SQL.Add(' SELECT id, descricao, valor_unitario ');
      SQL.Add(' FROM produtos WHERE (id = :codigo)   ');
      ParamByName('codigo').AsInteger := Codigo;

      try
        ModuleConnection.TransStart;
        ModuleConnection.TransCommit;

        Open;

        Produto.Codigo     := FieldByName('id').AsInteger;
        Produto.Descricao  := FieldByName('descricao').AsString;
        Produto.PrecoVenda := FieldByName('valor_unitario').AsCurrency;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Carregar Dados do Produto ' + IntToStr(Codigo);
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

procedure TControllerProduto.CarregarDados(Descricao: string; Produto: TProduto);
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
      SQL.Add('SELECT id, descricao, valor_unitario ');
      SQL.Add('FROM produtos WHERE (descricao LIKE :descricao)');
      ParamByName('descricao').AsString := '%' + Descricao + '%';

      try
        ModuleConnection.TransStart;
        ModuleConnection.TransCommit;

        Open;

        Produto.Codigo     := FieldByName('id').AsInteger;
        Produto.Descricao  := FieldByName('decricao').AsString;
        Produto.PrecoVenda := FieldByName('valor_unitario').AsCurrency;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Carregar Dados do Produto ' + Descricao;
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
