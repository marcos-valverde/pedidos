unit uFrmPedidosVendas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Grids, DBGrids, DateUtils,
  DB, DBClient, Model.Cliente, Model.Produto, Model.Pedido, Model.Item;

type
  TAcaoItem = (aiInserir, aiAlterar);

  TFrmPedidoVendas = class(TForm)
    pnRodape: TPanel;
    pnEsquerda: TPanel;
    pnDireita: TPanel;
    pnItens: TPanel;
    pnPedido: TPanel;
    pnProduto: TPanel;
    btnFechar: TBitBtn;
    StaticText3: TStaticText;
    lblNomeCliente: TStaticText;
    StaticText7: TStaticText;
    edtCodigoCliente: TEdit;
    btnBuscaCliente: TBitBtn;
    StaticText8: TStaticText;
    lblCidade: TStaticText;
    StaticText10: TStaticText;
    lblUF: TStaticText;
    StaticText4: TStaticText;
    StaticText9: TStaticText;
    edtCodigoProduto: TEdit;
    lblDescricao: TStaticText;
    btnBuscaProduto: TBitBtn;
    StaticText12: TStaticText;
    btnInserirItem: TBitBtn;
    StaticText14: TStaticText;
    edtQuantidade: TEdit;
    lblDicas: TStaticText;
    dbgItens: TDBGrid;
    StaticText15: TStaticText;
    Panel1: TPanel;
    lblVTotalPedido: TStaticText;
    StaticText5: TStaticText;
    cdItens: TClientDataSet;
    dsItens: TDataSource;
    Panel2: TPanel;
    btnNovoPedido: TBitBtn;
    btnExcluirPedido: TBitBtn;
    edtPrecoVenda: TEdit;
    btnGravarPedido: TBitBtn;
    StaticText1: TStaticText;
    edtNumeroPedido: TEdit;
    btnBuscaPedido: TBitBtn;
    StaticText2: TStaticText;
    dtpDataEmissao: TDateTimePicker;
    procedure btnFecharClick(Sender: TObject);
    procedure lblDicasMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnSalvarClienteMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnBuscaClienteMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnBuscaProdutoMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnFecharMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnBuscaPedidoMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnInserirItemMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnBuscaPedidoClick(Sender: TObject);
    procedure btnBuscaClienteClick(Sender: TObject);
    procedure btnNovoPedidoMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure btnExcluirPedidoMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure dbgItensDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnBuscaProdutoClick(Sender: TObject);
    procedure btnNovoPedidoClick(Sender: TObject);
    procedure btnExcluirPedidoClick(Sender: TObject);
    procedure edtCodigoClienteChange(Sender: TObject);
    procedure btnInserirItemClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure dsItensDataChange(Sender: TObject; Field: TField);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
  private
    FAcaoItem: TAcaoItem;
    procedure MostrarCliente(Cliente: TCliente);
    procedure MostarPedido(Pedido: TPedido);
    procedure MostrarProduto(Produto: TProduto);
    procedure MostrarItem(Item: TItem);
    procedure ExcluirPedido(Numero: Integer);
    procedure AlterarPedido(Numero: Integer);
    procedure AlterarItem(nItem: Integer);
    procedure InserirItem;
    procedure ExcluirItem;
    procedure SetAcaoItem(const Value: TAcaoItem);
    procedure GravarPedido(nPedido: Integer);
    property AcaoItem: TAcaoItem read FAcaoItem write SetAcaoItem;
  public
    procedure ListarItens(nPedido: Integer);
    procedure LimparDadosPedido;
    procedure LimparDadosItens;
    procedure InicializarConfiguracoes;
  end;

var
  FrmPedidoVendas: TFrmPedidoVendas;

implementation

uses Controller.Clientes, Controller.Produtos, Controller.Pedidos,
  Controller.Itens;

{$R *.dfm}

procedure TFrmPedidoVendas.btnBuscaPedidoClick(Sender: TObject);
var
  Pedido  : TPedido;
  MotorPed: TControllerPedido;
begin
  Pedido   := TPedido.Create;
  MotorPed := TControllerPedido.Create;

  try
    try
      MotorPed.CarregarDados(StrToIntDef(edtNumeroPedido.Text, -1), Pedido);
      MostarPedido(Pedido);

      btnBuscaCliente.Click;

      ListarItens(Pedido.Numero);
    except
      on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(Pedido);
    FreeAndNil(MotorPed);
  end;
end;

procedure TFrmPedidoVendas.btnBuscaPedidoMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas
    .Caption := ' Pesquisa pedido pelo Número ' + sLineBreak +
                ' e os mostra na tela ';
end;

procedure TFrmPedidoVendas.btnBuscaClienteMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Pesquisa Cliente pelo Código ';
end;

procedure TFrmPedidoVendas.btnBuscaProdutoClick(Sender: TObject);
var
  Produto  : TProduto;
  MotorProd: TControllerProduto;
begin
  Produto   := TProduto.Create;
  MotorProd := TControllerProduto.Create;

  try
    try
      Produto.Codigo := StrToIntDef(edtCodigoProduto.Text, 0);

      MotorProd.CarregarDados(Produto.Codigo, Produto);

      MostrarProduto(Produto);
    except
      on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(Produto);
    FreeAndNil(MotorProd);
  end;
end;

procedure TFrmPedidoVendas.btnBuscaProdutoMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Pesquisa Produto pelo Código ';
end;

procedure TFrmPedidoVendas.btnExcluirPedidoClick(Sender: TObject);
var
  Msg: PWChar;
begin
  btnBuscaPedido.Click;

  Msg := 'ATENÇÃO!!!' + sLineBreak +
         'Tem certeza de que deseja excluir o Pedido atual' + sLineBreak +
         'e com ele todos os itens (produtos) lançados? ';

  if (Application
        .MessageBox(Msg, 'Exclusão Pedido', MB_APPLMODAL +
          MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = 6) then
  begin
    btnExcluirPedido.Tag := StrToIntDef(edtNumeroPedido.Text, -1);

    ExcluirPedido(btnExcluirPedido.Tag);
  end;
end;

procedure TFrmPedidoVendas.btnExcluirPedidoMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Exclui o Pedido Atual e todos os Itens ';
end;

procedure TFrmPedidoVendas.btnFecharClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmPedidoVendas.btnFecharMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Fechar tela de Pedidos de Vendas ';
end;

procedure TFrmPedidoVendas.btnGravarPedidoClick(Sender: TObject);
begin
  edtNumeroPedido.Tag := StrToIntDef( edtNumeroPedido.Text, -1);

  GravarPedido(edtNumeroPedido.Tag);

  lblDicas.Caption := ' Pedido Gravado com sucesso ';
end;

procedure TFrmPedidoVendas.btnInserirItemClick(Sender: TObject);
begin
  case AcaoItem of
    aiInserir:
      begin
        InserirItem;
        btnBuscaPedido.Click;
      end;
    aiAlterar:
      begin
        AlterarItem(btnInserirItem.Tag);

        btnInserirItem.Caption := 'Inserir'#13'Item';
        AcaoItem               := aiInserir;

        btnBuscaPedido.Click;
      end;
  end;
  LimparDadosItens;
end;

procedure TFrmPedidoVendas.btnInserirItemMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Inserir item (produto) ao Pedido ';
end;

procedure TFrmPedidoVendas.btnNovoPedidoClick(Sender: TObject);
var
  Pedido  : TPedido;
  MotorPed: TControllerPedido;
  Msg     : PWChar;
begin
  edtCodigoCliente.Tag := StrToIntDef(edtCodigoCliente.Text, -1);

  if (edtCodigoCliente.Tag > 0) then
  begin
    Msg := 'ATENÇÃO!!!' + sLineBreak +
           'Quer realmente Iniciar um novo Pedido de Vendas?';

    if (Application
        .MessageBox(Msg, 'Inclusão Pedido de Venda', MB_APPLMODAL +
          MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = 6) then
    begin
      dtpDataEmissao.DateTime := Now;

      if Trim(edtCodigoCliente.Text) = EmptyStr then
        btnBuscaCliente.Click;

      Pedido   := TPedido.Create;
      MotorPed := TControllerPedido.Create;

      try
        try
          with Pedido do
          begin
            DataEmissao   := dtpDataEmissao.DateTime;
            CodigoCliente := edtCodigoCliente.Tag;
            ValorTotal    := 0;
          end;

          MotorPed.Inserir(Pedido);

          edtNumeroPedido.Text := IntToStr(Pedido.Numero);

          edtCodigoProduto.SetFocus;
          btnBuscaPedido.Click;
        except
          on E: Exception do
          begin
            raise Exception.Create(E.Message);
          end;
        end;
      finally
        FreeAndNil(Pedido);
        FreeAndNil(MotorPed);
      end;
    end;
  end;
end;

procedure TFrmPedidoVendas.btnNovoPedidoMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Começa um Novo Pedido ';
end;

procedure TFrmPedidoVendas.btnSalvarClienteMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Salva alteração de cliente no Pedido ';
end;

procedure TFrmPedidoVendas.dbgItensDrawColumnCell
  (Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if not(gdSelected in State) then
  begin
    if (Odd(TDBGrid(Sender).DataSource.DataSet.RecNo)) then
    begin
      TDBGrid(Sender).Canvas.Brush.Color := clWhite;
    end
    else
    begin
      TDBGrid(Sender).Canvas.Brush.Color := $00EEE5DB;
    end;
    TDBGrid(Sender).Canvas.Font.Color    := clBlack;
  end;

  TDBGrid(Sender).Canvas.FillRect(Rect);
  TDBGrid(Sender).DefaultDrawDataCell(Rect, Column.Field, State);
end;

procedure TFrmPedidoVendas.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Item: TItem;
  MotorItens: TControllerItens;
begin
  if (Key = VK_UP) then
  begin
    cdItens.Prior;
  end;

  if (Key = VK_DOWN) then
  begin
    cdItens.Next;
  end;

  if (Key = VK_DELETE) then
  begin
    ExcluirItem;
  end;

  if (Key = VK_RETURN) then
  begin
    AcaoItem   := aiAlterar;
    Item       := TItem.Create;
    MotorItens := TControllerItens.Create;

    try
      MotorItens.CarregarDados(cdItens.FieldByName('Numero').AsInteger, Item);

      btnInserirItem.Tag := Item.Numero;

      MostrarItem(Item);
    finally
      FreeAndNil(Item);
      FreeAndNil(MotorItens);
    end;

    btnInserirItem.Caption := 'Salvar'#13'Alteração';
  end;
end;

procedure TFrmPedidoVendas.dsItensDataChange(Sender: TObject; Field: TField);
begin
  ShowScrollBar(dbgItens.Handle, SB_VERT, True);
  ShowScrollBar(dbgItens.Handle, SB_HORZ, True);
end;

procedure TFrmPedidoVendas.ExcluirItem;
var
  Item      : TItem;
  MotorItens: TControllerItens;
  NumeroItem: Integer;
  Msg       : PWChar;
begin
  Msg        := 'ATENÇÃO!!!' + sLineBreak +
                'Tem certeza em Excluir este item do Pedido?';
  NumeroItem := cdItens.FieldByName('Numero').AsInteger;

  if (Application
        .MessageBox(Msg, 'Exclusão Pedido de Venda', MB_APPLMODAL +
          MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2) = 6) then
  begin
    Item       := TItem.Create;
    MotorItens := TControllerItens.Create;

    try
      try
        MotorItens.Excluir(NumeroItem);
      except
        on E: Exception do
        begin
          raise Exception.Create(E.Message);
        end;
      end;
    finally
      FreeAndNil(Item);
      FreeAndNil(MotorItens);
    end;
  end;

  btnBuscaPedido.Click;
end;

procedure TFrmPedidoVendas.ExcluirPedido(Numero: Integer);
var
  MotorPed: TControllerPedido;
begin
  MotorPed := TControllerPedido.Create;
  try
    MotorPed.Excluir(Numero);
    LimparDadosPedido;
  finally
    FreeAndNil(MotorPed);
  end;
end;

procedure TFrmPedidoVendas.FormActivate(Sender: TObject);
begin
  FormatSettings.shortdateformat := 'dd/mm/yyyy';

  ShowScrollBar(dbgItens.Handle, SB_VERT, True);
  ShowScrollBar(dbgItens.Handle, SB_HORZ, True);
end;

procedure TFrmPedidoVendas.FormShow(Sender: TObject);
begin
  InicializarConfiguracoes;
end;

procedure TFrmPedidoVendas.GravarPedido(nPedido: Integer);
var
  Pedido  : TPedido;
  MotorPed: TControllerPedido;
begin
  Pedido   := TPedido.Create;
  MotorPed := TControllerPedido.Create;

  try
    try
      MotorPed.CarregarDados(nPedido, Pedido);
      MotorPed.Alterar(Pedido);
    except
      on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(Pedido);
    FreeAndNil(MotorPed);
  end;

  btnBuscaPedido.Click;
end;

procedure TFrmPedidoVendas.edtCodigoClienteChange(Sender: TObject);
begin
  if (Trim(edtCodigoCliente.Text) = EmptyStr) then
  begin
    btnBuscaPedido.Visible := True;
    btnExcluirPedido.Show;

    if (edtNumeroPedido.CanFocus) then
      edtNumeroPedido.SetFocus;

    btnNovoPedido.Hide;
  end
  else
  begin
    btnBuscaPedido.Hide;
    btnExcluirPedido.Visible := False;
    btnNovoPedido.Show;
  end;
end;

procedure TFrmPedidoVendas.InicializarConfiguracoes;
begin
  AcaoItem                 := aiInserir;
  btnNovoPedido.Caption    := 'Novo'#13'Pedido';
  btnExcluirPedido.Caption := 'Excluir'#13'Pedido';
  btnInserirItem.Caption   := 'Inserir'#13'Item';
  btnGravarPedido.Caption  := 'Gravar'#13'Pedido';
  dtpDataEmissao.DateTime  := Now;

  edtCodigoCliente.SetFocus;

  if Trim(edtCodigoCliente.Text) <> EmptyStr then
    btnBuscaCliente.Click;

  KeyPreview := True;
end;

procedure TFrmPedidoVendas.InserirItem;
var
  MotorItens: TControllerItens;
  Item      : TItem;
  NumPed,
  CodProd   : Integer;
  Qtde      : Single;
  Preco     : Currency;
begin
  NumPed  := StrToIntDef(edtNumeroPedido.Text, -1);
  CodProd := StrToIntDef(edtCodigoProduto.Text, -1);
  Qtde    := StrToFloatDef(edtQuantidade.Text, -1);
  Preco   := StrToCurrDef(edtPrecoVenda.Text, -1);

  if ((CodProd > 0) and (Qtde > 0) and (Preco > 0) and (NumPed > 0)) then
  begin
    Item       := TItem.Create;
    MotorItens := TControllerItens.Create;

    try
      with Item do
      begin
        NumeroPedido  := NumPed;
        CodigoProduto := CodProd;
        Quantidade    := Qtde;
        ValorUnitario := Preco;
      end;

      try
        MotorItens.Inserir(Item);
        LimparDadosItens;
      except
        on E: Exception do
        begin
          raise Exception.Create(E.Message);
        end;
      end;
    finally
      FreeAndNil(MotorItens);
      FreeAndNil(Item);
    end;
  end;
end;

procedure TFrmPedidoVendas.lblDicasMouseMove
  (Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  lblDicas.Caption := ' Dicas de Uso ';
end;

procedure TFrmPedidoVendas.LimparDadosItens;
begin
  edtCodigoProduto.Text := EmptyStr;
  lblDescricao.Caption  := EmptyStr;
  edtPrecoVenda.Text    := EmptyStr;
  edtQuantidade.Text    := EmptyStr;

  edtCodigoProduto.SetFocus;
end;

procedure TFrmPedidoVendas.LimparDadosPedido;
begin
  edtNumeroPedido.Text    := EmptyStr;
  dtpDataEmissao.DateTime := Now;
  dtpDataEmissao.Format   := ' ';
  edtCodigoCliente.Text   := '';

  btnBuscaCliente.Click;
end;

procedure TFrmPedidoVendas.ListarItens(nPedido: Integer);
var
  MotorPed  : TControllerPedido;
  MotorItens: TControllerItens;
  Pedido    : TPedido;
  Item      : TItem;
begin
  MotorPed   := TControllerPedido.Create;
  MotorItens := TControllerItens.Create;
  Pedido     := TPedido.Create;
  Item       := TItem.Create;

  try
    try
      Pedido.Numero := StrToIntDef(edtNumeroPedido.Text, 0);

      MotorItens.Listar(Pedido.Numero, cdItens);
    except
      on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(MotorPed);
  end;
end;

procedure TFrmPedidoVendas.MostarPedido(Pedido: TPedido);
begin
  dtpDataEmissao.DateTime := Pedido.DataEmissao;

  if (Pedido.DataEmissao = 0) then
  begin
    dtpDataEmissao.Format := ' ';
  end
  else
  begin
    dtpDataEmissao.Format := EmptyStr;
  end;

  edtCodigoCliente.Text   := IntToStr(Pedido.CodigoCliente);
  lblVTotalPedido.Caption := CurrToStrF(Pedido.ValorTotal, ffCurrency, 2);

  if (Pedido.Numero <= 0) then
    edtNumeroPedido.Text := EmptyStr
  else
    edtNumeroPedido.Text := IntToStr(Pedido.Numero);

end;

procedure TFrmPedidoVendas.MostrarCliente(Cliente: TCliente);
begin
  lblNomeCliente.Caption := Cliente.Nome;
  lblCidade.Caption      := Cliente.Cidade;
  lblUF.Caption          := Cliente.Estado;

  if (Cliente.Codigo <= 0) then
    edtCodigoCliente.Text := EmptyStr
  else
    edtCodigoCliente.Text := IntToStr(Cliente.Codigo);
end;

procedure TFrmPedidoVendas.MostrarItem(Item: TItem);
begin
  edtCodigoProduto.Text := IntToStr(Item.CodigoProduto);

  btnBuscaProduto.Click;

  edtPrecoVenda.Text := CurrToStr(Item.ValorUnitario);
  edtQuantidade.Text := FloatToStr(Item.Quantidade);
end;

procedure TFrmPedidoVendas.MostrarProduto(Produto: TProduto);
begin
  lblDescricao.Caption  := Produto.Descricao;
  edtPrecoVenda.Text    := CurrToStr(Produto.PrecoVenda);
  edtQuantidade.Text    := '1';
  edtCodigoProduto.Text := IntToStr(Produto.Codigo);
end;

procedure TFrmPedidoVendas.SetAcaoItem(const Value: TAcaoItem);
begin
  FAcaoItem := Value;
end;

procedure TFrmPedidoVendas.AlterarItem(nItem: Integer);
var
  Item      : TItem;
  MotorItens: TControllerItens;
  Preco     : Currency;
begin
  Item       := TItem.Create;
  MotorItens := TControllerItens.Create;

  try
    MotorItens.CarregarDados(nItem, Item);

    Preco := StrToCurrDef(edtPrecoVenda.Text, -1);

    with Item do
    begin
      Quantidade := StrToFloatDef(edtQuantidade.Text, 1);

      if (Preco > 0) then
      begin
        ValorUnitario := Preco;
      end;
    end;

    MotorItens.Alterar(Item);
  finally
    FreeAndNil(Item);
    FreeAndNil(MotorItens);
  end;
end;

procedure TFrmPedidoVendas.AlterarPedido(Numero: Integer);
var
  Pedido: TPedido;
  MotorPed: TControllerPedido;
begin
  Pedido   := TPedido.Create;
  MotorPed := TControllerPedido.Create;

  try
    try
      MotorPed.CarregarDados(Numero, Pedido);

      edtCodigoCliente.Tag := StrToIntDef(edtCodigoCliente.Text, -1);

      btnBuscaCliente.Click; // Refresh nos dados da tela

      Pedido.CodigoCliente := edtCodigoCliente.Tag;

      MotorPed.Alterar(Pedido);
    except
      on E: Exception do
      begin
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    FreeAndNil(Pedido);
    FreeAndNil(MotorPed);
  end;
end;

procedure TFrmPedidoVendas.btnBuscaClienteClick(Sender: TObject);
var
  MotorCli: TControllerCliente;
  Cliente : TCliente;
begin
  MotorCli := TControllerCliente.Create;
  Cliente  := TCliente.Create;

  try
    MotorCli.CarregarDados(StrToInt(Trim(edtCodigoCliente.Text)), Cliente);
    MostrarCliente(Cliente);
  finally
    FreeAndNil(MotorCli);
    FreeAndNil(Cliente);
  end;
end;

end.
