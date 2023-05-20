unit ConsultaCep;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  ConsultaWSCEP_U;

type
  TFormConsultaCep = class(TForm)
    lblTitulo: TLabel;
    Label2: TLabel;
    lblInformacao: TLabel;
    EdtCep: TEdit;
    Btnconsultar: TButton;
    BtnLimpar: TButton;
    CbFormatoExibicao: TComboBox;
    MemoResultado: TMemo;
    procedure BtnconsultarClick(Sender: TObject);
    procedure BtnLimparClick(Sender: TObject);
  private
    procedure ConsultarCep;
  public
    { Public declarations }
  end;

var
  FormConsultaCep: TFormConsultaCep;

implementation

uses
  System.SysUtils;

{$R *.dfm}

procedure TFormConsultaCep.BtnconsultarClick(Sender: TObject);
begin
  lblInformacao.Caption := EmptyStr;
  if EdtCep.Text = EmptyStr then
  begin
    lblInformacao.Caption := 'CEP não informado!';
    MemoResultado.Lines.Clear;
    EdtCep.SetFocus;
    Exit;
  end;

  if StrToInt64Def(EdtCep.Text, 0) = 0 then
  begin
    lblInformacao.Caption := 'Apenas numeros no CEP';
    MemoResultado.Lines.Clear;
    EdtCep.SetFocus;
    Exit;
  end;

  if Length(Trim(EdtCep.Text)) <> 8 then
  begin
    lblInformacao.Caption := 'Informe o CEP com 8 Digitos...';
    MemoResultado.Lines.Clear;
    EdtCep.SetFocus;
    Exit;
  end;

  ConsultarCep;
end;

procedure TFormConsultaCep.BtnLimparClick(Sender: TObject);
begin
  EdtCep.Clear;
  lblInformacao.Caption := EmptyStr;
  MemoResultado.Lines.Clear;
  EdtCep.SetFocus;
end;

procedure TFormConsultaCep.ConsultarCep;
var
  ws : AtendeCliente;
  Endereco : TEndereco;
  AEnderecoSimplificado : string;
begin
  MemoResultado.Clear;

  ws := GetAtendeCliente;
  try
    Endereco := ws.consultaCEP(EdtCep.Text);

    if CbFormatoExibicao.ItemIndex = 0 then
    begin
      AEnderecoSimplificado := Endereco.bairro.Trim;
      if not Endereco.cep.Trim.IsEmpty then
        AEnderecoSimplificado := AEnderecoSimplificado + ', ' + Endereco.cep;
      if not Endereco.cidade.Trim.IsEmpty then
        AEnderecoSimplificado := AEnderecoSimplificado + ', ' + Endereco.cidade;
      if not Endereco.complemento.Trim.IsEmpty then
        AEnderecoSimplificado := AEnderecoSimplificado + ', ' + Endereco.complemento;
      if not Endereco.complemento2.Trim.IsEmpty then
        AEnderecoSimplificado := AEnderecoSimplificado + ', ' + Endereco.complemento2;
      if not Endereco.logradouro.Trim.IsEmpty then
        AEnderecoSimplificado := AEnderecoSimplificado + ', ' + Endereco.logradouro;
      if not Endereco.uf.Trim.IsEmpty then
        AEnderecoSimplificado := AEnderecoSimplificado + ', ' + Endereco.uf;
      MemoResultado.Lines.Add(AEnderecoSimplificado);
    end
    else
    begin
      MemoResultado.Lines.Add('Bairro: ' + Endereco.bairro);
      MemoResultado.Lines.Add('CEP: ' + Endereco.cep);
      MemoResultado.Lines.Add('Cidade: ' + Endereco.cidade);
      MemoResultado.Lines.Add('Complemento: ' + Endereco.complemento);
      MemoResultado.Lines.Add('Complemento2: ' + Endereco.complemento2);
      MemoResultado.Lines.Add('Logradouro: ' + Endereco.logradouro);
      MemoResultado.Lines.Add('UF: ' + Endereco.uf);
    end;
  except 
    on E: SigepClienteException do
      MemoResultado.Lines.Add(E.Message);
  end;

  lblInformacao.Caption := 'Consulta efetuada com sucesso';
end;

end.
