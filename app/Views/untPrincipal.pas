unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, dxGDIPlusClasses, uFrmPedidosVendas;

type
  TfrmPrincipal = class(TForm)
    imgLogo: TImage;
    Panel1: TPanel;
    btnLancarPedidos: TBitBtn;
    pnRodape: TPanel;
    btnFechar: TBitBtn;
    procedure btnFecharClick(Sender: TObject);
    procedure btnLancarPedidosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.btnFecharClick(Sender: TObject);
begin
  if (fsModal in FormState) then
    ModalResult := mrClose
  else
    Close;
end;

procedure TfrmPrincipal.btnLancarPedidosClick(Sender: TObject);
begin
  Application.CreateForm(TFrmPedidoVendas, FrmPedidoVendas);
  FrmPedidoVendas.ShowModal;
  FrmPedidoVendas.Release;
  FrmPedidoVendas.Free;
end;

end.
