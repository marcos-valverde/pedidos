unit Controller.Itens;

interface

uses Model.Item, Model.Pedido, DAO.ModuloDados, SysUtils, DB, SqlExpr, DBClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TControllerItens = class
  public
    function  Inserir(Item: TItem): Integer;
    procedure CarregarDados(Numero: Integer; Item: TItem);
    procedure Alterar(Item: TItem);
    procedure Excluir(Numero: Integer);
    procedure Listar(NumeroPedido: Integer; CD: TClientDataSet);
  end;

implementation

uses Classes, Controller.Pedidos;

{ TControllerItens }

procedure TControllerItens.Alterar(Item: TItem);
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
      SQL.Add(' UPDATE pedido_itens SET pedido_id = :Pedido,         ');
      SQL.Add('     produto_id = :Produto, quantidade = :Quantidade, ');
      SQL.Add('     valor_unitario = :Unitario, total_item = :Total  ');
      SQL.Add(' WHERE (id = :Numero)                                 ');
      ParamByName('Numero').AsInteger      := Item.Numero;
      ParamByName('Pedido').AsInteger      := Item.NumeroPedido;
      ParamByName('Produto').AsInteger     := Item.CodigoProduto;
      ParamByName('Quantidade').AsCurrency := Item.Quantidade;
      ParamByName('Unitario').AsCurrency   := Item.ValorUnitario;
      ParamByName('Total').Value           := Item.TotalItem;
    end;
    try
      ModuleConnection.TransStart;

      Query.ExecSQL(False);

      ModuleConnection.TransCommit;
    except
      on E: Exception do
      begin
        msgERRO := 'Falha ao Alterar o Item ' + IntToStr(Item.Numero);
        msgERRO := msgERRO + sLineBreak + E.Message;

        ModuleConnection.TransRollBack;
        raise Exception.Create(msgERRO);
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TControllerItens.CarregarDados(Numero: Integer; Item: TItem);
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
      SQL.Add(' SELECT id, pedido_id, produto_id,        ');
      SQL.Add('   quantidade, valor_unitario, total_item ');
      SQL.Add(' FROM pedido_itens WHERE (id = :Numero)   ');
      ParamByName('Numero').AsInteger := Numero;

      try
        ModuleConnection.TransStart;
        ModuleConnection.TransCommit;

        Open;

        Item.Numero        := FieldByName('id').AsInteger;
        Item.NumeroPedido  := FieldByName('pedido_id').AsInteger;
        Item.CodigoProduto := FieldByName('produto_id').AsInteger;
        Item.Quantidade    := FieldByName('quantidade').AsFloat;
        Item.ValorUnitario := FieldByName('valor_unitario').AsCurrency;
        Item.TotalItem     := FieldByName('total_item').AsCurrency;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Carregar Dados do Item (produto) do Pedido ';
          msgERRO := msgERRO + IntToStr(Numero) + sLineBreak + E.Message;

          ModuleConnection.TransRollBack;
          raise Exception.Create(msgERRO);
        end;
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TControllerItens.Excluir(Numero: Integer);
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
      SQL.Add(' DELETE FROM pedido_itens ');
      SQL.Add(' WHERE (id = :Numero)     ');
      ParamByName('Numero').AsInteger := Numero;

      try
        ModuleConnection.TransStart;

        ExecSQL(False);

        ModuleConnection.TransCommit;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Excluir o Item';
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

function TControllerItens.Inserir(Item: TItem): Integer;
var
  msgERRO         : string;
  Query           : TFDQuery;
  Pedido          : TPedido;
  ControllerPedido: TControllerPedido;
  TotalPedido     : Currency;
begin
  Query := TFDQuery.Create(nil);

  try
    with Query do
    begin
      Connection := ModuleConnection.Conexao;

      Close;

      SQL.Clear;
      SQL.Add(' INSERT INTO pedido_itens ( pedido_id, produto_id, ');
      SQL.Add('     quantidade, valor_unitario, total_item        ');
      SQL.Add(' ) VALUES ( :NumeroPedido, :CodigoProduto,         ');
      SQL.Add('     :Quantidade, :ValorUnitario, :ValorTotal )    ');
      ParamByName('NumeroPedido').AsInteger   := Item.NumeroPedido;
      ParamByName('CodigoProduto').AsInteger  := Item.CodigoProduto;
      ParamByName('Quantidade').AsFloat       := Item.Quantidade;
      ParamByName('ValorUnitario').AsCurrency := Item.ValorUnitario;
      ParamByName('ValorTotal').AsCurrency    := Item.TotalItem;

      try
        ModuleConnection.TransStart;

        ExecSQL(False);

        ModuleConnection.TransCommit;

        with Query do
        begin
          SQL.Clear;
          SQL.Add(' SELECT LAST_INSERT_ID() AS NewId FROM pedido_itens ');

          Open;

          Item.Numero := FieldByName('NewId').AsInteger;
        end;
      except
        on E: Exception do
        begin
          Item.Numero := -1;
          msgERRO     := 'Falha ao Adicionar Item ao Carrinho/Pedido';
          msgERRO     := msgERRO + sLineBreak + E.Message;

          ModuleConnection.TransRollBack;
          raise Exception.Create(msgERRO);
        end;
      end;
    end;
  finally
    FreeAndNil(Query);
  end;
  Result := Item.Numero;
end;

procedure TControllerItens.Listar(NumeroPedido: Integer; CD: TClientDataSet);
var
  msgERRO,
  Descricao: string;
  Query    :  TFDQuery;
  Item     : TItem;
  i        : Integer;
begin
  Query := TFDQuery.Create(nil);
  Item  := TItem.Create;

  try
    with Query do
    begin
      Connection := ModuleConnection.Conexao;

      Close;

      SQL.Clear;
      SQL.Add(' SELECT pdi.id , pdi.pedido_id, pdi.produto_id, prd.descricao,');
      SQL.Add('   pdi.quantidade, pdi.valor_unitario, pdi.total_item'         );
      SQL.Add(' FROM pedido_itens pdi                                        ');
      SQL.Add(' INNER JOIN produtos prd ON (pdi.produto_id = prd.id)         ');
      SQL.Add(' WHERE (pdi.pedido_id = :Pedido)                              ');
      ParamByName('Pedido').AsInteger := NumeroPedido;

      try
        Open;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Consultar Listagem de Itens do Pedido ';
          msgERRO := msgERRO + IntToStr(NumeroPedido) + sLineBreak + E.Message;

          raise Exception.Create(msgERRO);
        end;
      end;

      try
        DisableControls;

        CD.Close;
        CD.FieldDefs.Clear;
        { | } CD.FieldDefs.Add('Numero', ftInteger);
        { | } CD.FieldDefs.Add('Sequencia', ftInteger);
        { | } CD.FieldDefs.Add('NumeroPedido', ftInteger);
        { | } CD.FieldDefs.Add('CodigoProduto', ftInteger);
        { | } CD.FieldDefs.Add('Descricao', ftString, 50);
        { | } CD.FieldDefs.Add('Quantidade', ftFloat);
        { | } CD.FieldDefs.Add('ValorUnitario', ftCurrency);
        { | } CD.FieldDefs.Add('ValorTotal', ftCurrency);

        CD.CreateDataSet;

        CD.FieldByName('Numero').Visible                   := False;
        CD.FieldByName('Numero').Alignment                 := taCenter;
        CD.FieldByName('NumeroPedido').Visible             := False;
        CD.FieldByName('Sequencia').DisplayLabel           := 'Item '#13'Nº';
        CD.FieldByName('Sequencia').DisplayWidth           := 3;
        CD.FieldByName('Sequencia').Alignment              := taCenter;
        CD.FieldByName('CodigoProduto').DisplayLabel       := 'Código '#13'Produto';
        CD.FieldByName('CodigoProduto').DisplayWidth       := 3;
        CD.FieldByName('CodigoProduto').Alignment          := taCenter;
        CD.FieldByName('Descricao').DisplayLabel           := 'Descrição do Produto';
        CD.FieldByName('Descricao').DisplayWidth           := 30;
        CD.FieldByName('Quantidade').DisplayLabel          := 'Qtde';
        CD.FieldByName('Quantidade').Alignment             := taRightJustify;
        TFloatField(CD.FieldByName('Quantidade')).EditMask := '#,###.00';
        CD.FieldByName('ValorUnitario').DisplayLabel       := 'Vlr. Unitário';
        CD.FieldByName('ValorUnitario').Alignment          := taRightJustify;
        CD.FieldByName('ValorTotal').DisplayLabel          := 'Total do Item';
        CD.FieldByName('ValorTotal').Alignment             := taRightJustify;

        i := 1;

        while (not Eof) do
        begin
          Item.Numero         := FieldByName('id').AsInteger;
          Item.NumeroPedido   := FieldByName('pedido_id').AsInteger;
          Item.CodigoProduto  := FieldByName('produto_id').AsInteger;
          Descricao           := FieldByName('descricao').AsString;
          Item.Quantidade     := FieldByName('quantidade').AsFloat;
          Item.ValorUnitario  := FieldByName('valor_unitario').AsCurrency;
          Item.TotalItem      := FieldByName('total_item').AsCurrency;

          CD.Append;

          { } CD.FieldByName('Numero').AsInteger         := Item.Numero;
          { } CD.FieldByName('NumeroPedido').AsInteger   := Item.NumeroPedido;
          { } CD.FieldByName('Sequencia').AsInteger      := i;
          { } CD.FieldByName('CodigoProduto').AsInteger  := Item.CodigoProduto;
          { } CD.FieldByName('Descricao').AsString       := Descricao;
          { } CD.FieldByName('Quantidade').AsFloat       := Item.Quantidade;
          { } CD.FieldByName('ValorUnitario').AsCurrency := Item.ValorUnitario;
          { } CD.FieldByName('ValorTotal').AsCurrency    := Item.TotalItem;

          CD.Post;
          Inc(i);
          Next;
        end;
      except
        on E: Exception do
        begin
          msgERRO := 'Falha ao Crarregar Itens do Pedido na Tela ';
          msgERRO := msgERRO + IntToStr(NumeroPedido) + sLineBreak + E.Message;

          raise Exception.Create(msgERRO);
        end;
      end;
    end;
  finally
    FreeAndNil(Query);
    FreeAndNil(Item);
  end;
end;

end.
