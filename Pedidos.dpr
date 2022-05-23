program Pedidos;

uses
  Vcl.Forms,
  untPrincipal in 'app\views\untPrincipal.pas' {frmPrincipal},
  Model.Cliente in 'app\Models\Model.Cliente.pas',
  Controller.Clientes in 'app\Controllers\Controller.Clientes.pas',
  Model.Produto in 'app\Models\Model.Produto.pas',
  Controller.Produtos in 'app\Controllers\Controller.Produtos.pas',
  Model.Pedido in 'app\Models\Model.Pedido.pas',
  Controller.Pedidos in 'app\Controllers\Controller.Pedidos.pas',
  Controller.Itens in 'app\Controllers\Controller.Itens.pas',
  Model.Item in 'app\Models\Model.Item.pas',
  uFrmPedidosVendas in 'app\Views\uFrmPedidosVendas.pas' {FrmPedidoVendas},
  DAO.ModuloDados in 'app\Dao\DAO.ModuloDados.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Pedido de Vendas';
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
