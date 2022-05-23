unit Model.Cliente;

interface

type
  TCliente = class
  private
    FEstado: string;
    FCodigo: Integer;
    FNome  : string;
    FCidade: string;
    procedure SetCidade(const Value: string);
    procedure SetCodigo(const Value: Integer);
    procedure SetNome  (const Value: string);
    procedure SetEstado(const Value: string);
  public
    property Codigo: Integer read FCodigo write SetCodigo;
    property Nome  : string  read FNome   write SetNome;
    property Cidade: string  read FCidade write SetCidade;
    property Estado: string  read FEstado write SetEstado;
  end;

implementation

{ TCliente }

procedure TCliente.SetCidade(const Value: string);
begin
  FCidade := Value;
end;

procedure TCliente.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TCliente.SetNome(const Value: string);
begin
  FNome  := Value;
end;

procedure TCliente.SetEstado(const Value: string);
begin
  FEstado := Value;
end;

end.
