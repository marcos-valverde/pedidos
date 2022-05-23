unit Controller.Pedidos;

interface

uses Model.Pedido, DAO.ModuloDados, SysUtils, DB, SqlExpr,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TControllerPedido = class
  private
    procedure AtualizarTotal(Numero: Integer);
  public
    function  Inserir(Pedido: TPedido): Integer;
    procedure CarregarDados(Numero: Integer; Pedido: TPedido);
    procedure Alterar(Pedido: TPedido);
    procedure Excluir(Numero: Integer);
  end;

implementation

{ TControllerPedido }

procedure TControllerPedido.Alterar(Pedido: TPedido);
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
      SQL.Add('UPDATE pedidos SET data_emissao = :DataEmissao,    ');
      SQL.Add('cliente_id = :idCliente, total_venda = :TotalVenda ');
      SQL.Add('WHERE (id = :Numero)                               ');
      ParamByName('Numero').AsInteger       := Pedido.Numero;
      ParamByName('DataEmissao').AsDateTime := Pedido.DataEmissao;
      ParamByName('idCliente').AsInteger    := Pedido.CodigoCliente;
      ParamByName('TotalVenda').AsCurrency  := Pedido.ValorTotal;

      try
        ModuleConnection.TransStart;
        Query.ExecSQL(False);
        ModuleConnection.TransCommit;
      except
        on E: Exception do
        begin
          ModuleConnection.TransRollBack;
          msgERRO := 'Falha ao Alterar o Pedido ' + IntToStr(Pedido.Numero);
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

procedure TControllerPedido.AtualizarTotal(Numero: Integer);
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
      SQL.Add(' UPDATE pedidos SET total_venda =              ');
      SQL.Add(' (SELECT SUM(quantidade * valor_unitario)      ');
      SQL.Add(' FROM pedido_itens WHERE (pedido_id = :Numero))');
      SQL.Add(' WHERE (id = :Numero)                          ');
      ParamByName('Numero').AsInteger := Numero;

      try
        ModuleConnection.TransStart;

        Query.ExecSQL(False);

        ModuleConnection.TransCommit;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Recalcular o Valor Total do Pedido [';
          msgERRO := msgERRO + IntToStr(Numero) + ']';
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

procedure TControllerPedido.CarregarDados(Numero: Integer; Pedido: TPedido);
var
  msgERRO: string;
  Query: TFDQuery;
begin
  AtualizarTotal(Numero);

  Query := TFDQuery.Create(nil);
  try
    with Query do
    begin
      Connection := ModuleConnection.Conexao;

      Close;

      SQL.Clear;
      SQL.Add(' SELECT id, data_emissao, cliente_id, total_venda  ');
      SQL.Add(' FROM pedidos WHERE (id = :Numero)                 ');
      ParamByName('Numero').AsInteger := Numero;

      try
        ModuleConnection.TransStart;
        ModuleConnection.TransCommit;

        Open;

        Pedido.Numero        := FieldByName('id').AsInteger;
        Pedido.DataEmissao   := FieldByName('data_emissao').AsDateTime;
        Pedido.CodigoCliente := FieldByName('cliente_id').AsInteger;
        Pedido.ValorTotal    := FieldByName('total_venda').AsCurrency;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Carregar Dados do Pedido ' + IntToStr(Numero);
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

procedure TControllerPedido.Excluir(Numero: Integer);
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
      SQL.Add(' DELETE FROM pedidos   ');
      SQL.Add(' WHERE (id = :Numero); ');
      ParamByName('Numero').AsInteger := Numero;

      try
        ModuleConnection.TransStart;

        Query.ExecSQL(False);

        ModuleConnection.TransCommit;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Excluir Pedido ' + IntToStr(Numero);
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

function TControllerPedido.Inserir(Pedido: TPedido): Integer;
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
      SQL.Add('INSERT INTO pedidos (data_emissao, cliente_id, total_venda');
      SQL.Add(') VALUES (:DataEmissao, :idCliente, :ValorTotal)          ');
      ParamByName('DataEmissao').AsDateTime  := Pedido.DataEmissao;
      ParamByName('idCliente').AsInteger     := Pedido.CodigoCliente;
      ParamByName('ValorTotal').AsCurrency   := Pedido.ValorTotal;

      try
        ModuleConnection.TransStart;

        Query.ExecSQL(False);

        ModuleConnection.TransCommit;

        with Query do
        begin
          SQL.Clear;
          SQL.Add(' SELECT LAST_INSERT_ID() as NewId FROM pedidos ');

          Open;

          Pedido.Numero := FieldByName('NewId').AsInteger;
        end;
      except
        on E: Exception do
        begin
          Pedido.Numero := -1;
          msgERRO       := 'Falha ao Inserir o Pedido';
          msgERRO       := msgERRO + sLineBreak + E.Message;

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
