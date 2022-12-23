program pr_CadAlunos;

uses
  Forms,
  unit_CadastroAlunos in 'unit_CadastroAlunos.pas' {frm_CadastroAlunos},
  uEstruturaAlunos in 'uEstruturaAlunos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_CadastroAlunos, frm_CadastroAlunos);
  Application.Run;
end.
