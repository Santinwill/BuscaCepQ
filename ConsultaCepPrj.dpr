program ConsultaCepPrj;

uses
  Vcl.Forms,
  ConsultaCep in 'ConsultaCep.pas' {FormConsultaCep},
  ConsultaWSCEP_U in 'ConsultaWSCEP_U.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormConsultaCep, FormConsultaCep);
  Application.Run;
end.
