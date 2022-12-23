unit unit_CadastroAlunos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin, Vcl.Mask, uEstruturaAlunos;

type
    ptr = ^Tfila;

    Tfila = record
        matricula: String[20];
        aluno,
        curso: String[100];
        semestre: integer;
        valor: real;
        Telefone: String[20];
        EMAIL: String[80];
        Endereco: String[255];
        prox: ptr;
    end;

type
  Tfrm_CadastroAlunos = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btAdd: TBitBtn;
    btRetirar: TBitBtn;
    btResultado: TBitBtn;
    btSair: TBitBtn;
    Label1: TLabel;
    edMatricola: TEdit;
    Label2: TLabel;
    edAluno: TEdit;
    Label3: TLabel;
    edCurso: TEdit;
    Label4: TLabel;
    spSemestre: TSpinEdit;
    Label5: TLabel;
    mmValor: TMemo;
    mmFila: TMemo;
    Label6: TLabel;
    rgResultados: TRadioGroup;
    mkTelefone: TMaskEdit;
    Telefone: TLabel;
    edEmail: TEdit;
    Label7: TLabel;
    meEndereco: TMemo;
    Label8: TLabel;
    procedure btSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btAddClick(Sender: TObject);
    procedure btRetirarClick(Sender: TObject);
    procedure btResultadoClick(Sender: TObject);
    procedure rgResultadosClick(Sender: TObject);
  private
     Controle: TEstruturaAlunos;
         procedure limparTela;
         function ValidarDados:Boolean;
         procedure inserir;
         procedure retirar;
         procedure carregarFila;
         procedure carregarDadosMemo(aux: ptr);
         procedure liberarFila;

         procedure buscarNome(sNome:String);
         procedure buscarCurso(sCurso: String);
         procedure buscarCursoSemestre(sCurso: String; iSemestre:Integer);
         procedure buscarValorCurso(sCurso: String);
         procedure buscarMaiorMensalidade;

  public
       primeiro, ultimo, nodo: ptr;
  end;

var
  frm_CadastroAlunos: Tfrm_CadastroAlunos;

implementation

{$R *.dfm}

procedure Tfrm_CadastroAlunos.btAddClick(Sender: TObject);
begin
     inserir;
end;

procedure Tfrm_CadastroAlunos.btResultadoClick(Sender: TObject);
begin
    case (rgResultados.ItemIndex) of
       0: buscarNome(edAluno.Text);
       1: buscarCurso(edCurso.Text);
       2: buscarCursoSemestre(edCurso.Text, StrToInt(spSemestre.Text));
       3: buscarValorCurso(edCurso.Text);
       4: buscarMaiorMensalidade;
       5: carregarFila;
    end;
end;

procedure Tfrm_CadastroAlunos.rgResultadosClick(Sender: TObject);
begin
     if (rgResultados.ItemIndex = 4) then
       buscarMaiorMensalidade
     else
     if (rgResultados.ItemIndex = 5) then
       carregarFila;
end;

procedure Tfrm_CadastroAlunos.btRetirarClick(Sender: TObject);
begin
     retirar;
     carregarFila;
end;

procedure Tfrm_CadastroAlunos.btSairClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure Tfrm_CadastroAlunos.buscarCurso(sCurso: String);
{Var
    aux : Ptr;}
Begin
     mmFila.Clear;
     mmFila.Lines.AddStrings(Controle.buscarCurso(sCurso));
     if mmFila.Lines.Count < 1 then
       ShowMessage('Elemento n�o foi encontrado');
  {   Aux := primeiro;
     While aux <> nil do
         begin
             if aux^.curso = sCurso then
               carregarDadosMemo(aux);

             aux := aux^.prox;
         end;

     if mmFila.Text = '' then
        ShowMessage('Elemento n�o foi encontrado');}
end;

procedure Tfrm_CadastroAlunos.buscarMaiorMensalidade;
begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.buscarMaiorMensalidade());
{Var
    aux, auxmaior : Ptr;
    valorMaior: Real;
Begin
     mmFila.Clear;
     Aux := primeiro;
     auxmaior := aux;
     valorMaior :=  aux^.valor;
     While aux <> nil do
         begin
             if (aux^.valor > valorMaior) then
               begin
                    valorMaior := aux^.valor;
                    auxmaior := aux;
               end;

             aux := aux^.prox;
         end;

     mmFila.Lines.Add('Aluno com maior valor de Mensalidades');
     carregarDadosMemo(auxmaior); }
end;

procedure Tfrm_CadastroAlunos.buscarValorCurso(sCurso: String);
var
    valor: Real;
begin
     mmFila.Clear;
     valor := Controle.buscarValorCurso(sCurso);
{Var
    aux : Ptr;
    valor: Real;
Begin
     mmFila.Clear;
     valor := 0;
     Aux := primeiro;
     While aux <> nil do
         begin
             if (aux^.curso = sCurso) then
               valor := valor + aux^.valor;

             aux := aux^.prox;
         end;}

     if (valor = 0) then
        ShowMessage('Elemento n�o foi encontrado')
     else
         mmFila.Text := 'Valor de Mensalidades do curso ' + sCurso + ': ' + FormatFloat('###,##0.00', valor);
end;

procedure Tfrm_CadastroAlunos.buscarCursoSemestre(sCurso: String;  iSemestre: Integer);
{Var
    aux : Ptr;}
Begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.buscarCursoSemestre(sCurso, iSemestre));
  if mmFila.Lines.Count < 1 then
     ShowMessage('Elemento n�o foi encontrado');

{     mmFila.Clear;
     Aux := primeiro;
     While aux <> nil do
         begin
             if (aux^.curso = sCurso) and (aux^.semestre = iSemestre) then
               carregarDadosMemo(aux);

             aux := aux^.prox;
         end;

     if mmFila.Text = '' then
        ShowMessage('Elemento n�o foi encontrado'); }
end;

procedure Tfrm_CadastroAlunos.buscarNome(sNome: String);
begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.buscarNome(sNome));
  if mmFila.Lines.Count < 1 then
     ShowMessage('Elemento n�o foi encontrado');
{Var
    aux : Ptr;
Begin
     mmFila.Clear;
     Aux := primeiro;
     While aux <> nil do
         begin
             if aux^.aluno = sNome then
               begin
                    carregarDadosMemo(aux);
                    break;
               end
                  else
                      aux := aux^.prox;
         end;

     if aux = nil then
        ShowMessage('Elemento n�o foi encontrado');}
end;

procedure Tfrm_CadastroAlunos.FormActivate(Sender: TObject);
begin
     limparTela;
     mmFila.Clear;
     edMatricola.SetFocus;
end;

procedure Tfrm_CadastroAlunos.FormCreate(Sender: TObject);
begin
     primeiro := nil;
     ultimo := nil;
     Controle := TEstruturaAlunos.Create();
end;

procedure Tfrm_CadastroAlunos.FormDestroy(Sender: TObject);
begin
     liberarFila;
end;

procedure Tfrm_CadastroAlunos.inserir;
begin
     if (not ValidarDados) then
       exit;

    { new(nodo);
     nodo^.matricula := edMatricola.Text;
     nodo^.aluno := edAluno.Text;
     nodo^.curso := edCurso.Text;
     nodo^.semestre := StrToInt(spSemestre.Text);
     nodo^.valor := StrToFloat(mmValor.Text);
     nodo^.EMAIL := edEmail.Text;
     nodo^.Telefone := mkTelefone.Text;
     nodo^.Endereco := meEndereco.Lines.Text;

     nodo^.prox := nil;

     if primeiro = nil then
       primeiro := nodo
     else
        ultimo^.prox := nodo;

     ultimo := nodo;

     carregarFila;
     limparTela;
     edMatricola.SetFocus;   }

     Controle.IncluiAluno(edAluno.Text, StrToIntDef(edMatricola.Text,0), edCurso.Text, spSemestre.Value, StrToFloatDef(mmValor.Lines.Text,0), mkTelefone.Text, edEmail.Text, meEndereco.Text);
     mmFila.Clear;
     mmFila.Lines.AddStrings(Controle.carregarAlunos);
     limparTela;
     edMatricola.SetFocus;
end;

procedure Tfrm_CadastroAlunos.carregarDadosMemo(aux: ptr);
begin
     mmFila.Lines.Add('Matr�cula: ' + aux^.matricula + ' Aluno: ' + aux^.aluno);
     mmFila.Lines.Add('Telefone: ' + aux^.Telefone);
     mmFila.Lines.Add('E-MAIL: ' + aux^.EMAIL);
     mmFila.Lines.Add('Endere�o: ' + aux^.Endereco);
     mmFila.Lines.Add('Curso: ' + aux^.curso + ' Semestre: ' + IntToStr(aux^.semestre));
     mmFila.Lines.Add('Valor: ' + FormatFloat('###,##0.00', aux^.valor));
     mmFila.Lines.Add('------------------------------------------');
end;

procedure Tfrm_CadastroAlunos.carregarFila;
{var
   aux: ptr;}
begin
  mmFila.Clear;
  mmFila.Lines.AddStrings(Controle.carregarAlunos);

     {if (primeiro = nil) then
       exit;

     aux := primeiro;
     while (aux <> nil) do
         begin
              carregarDadosMemo(aux);
              aux:= aux^.prox;
         end;}
end;

procedure Tfrm_CadastroAlunos.retirar;
{var
   aux: ptr;}
begin
{     if (primeiro = nil) then
       exit;

     aux := primeiro;
     primeiro := primeiro^.prox;
     Dispose(aux);}
     Controle.RemoveAluno;
end;

procedure Tfrm_CadastroAlunos.liberarFila;
begin
{     while (primeiro <> nil) do
        retirar;}
   Controle.RemoveTodosAlunos();
end;

procedure Tfrm_CadastroAlunos.limparTela;
begin
     edMatricola.Clear;
     edAluno.Clear;
     edCurso.Clear;
     spSemestre.Text := '1';
     mmValor.Clear;
     mkTelefone.Clear;
     meEndereco.Lines.Clear;
     edEmail.Clear;
end;

function Tfrm_CadastroAlunos.ValidarDados: Boolean;
begin
     result := true;

     if (edMatricola.Text = '') then
       begin
            ShowMessage('Informe a matr�cula!');
            edMatricola.SetFocus;
            result := false;
            exit;
       end;

     if (edAluno.Text = '') then
       begin
            ShowMessage('Informe o aluno!');
            edAluno.SetFocus;
            result := false;
            exit;
       end;

     if (edCurso.Text = '') then
       begin
            ShowMessage('Informe o curso!');
            edCurso.SetFocus;
            result := false;
            exit;
       end;

     if (spSemestre.Text = '') then
       begin
            ShowMessage('Informe o semestre!');
            spSemestre.SetFocus;
            result := false;
            exit;
       end;

     if (mmValor.Text = '') then
       begin
            ShowMessage('Informe o valor!');
            mmValor.SetFocus;
            result := false;
            exit;
       end;

     if (mkTelefone.Text = '') then
       begin
            ShowMessage('Informe o telefone!');
            mkTelefone.SetFocus;
            result := false;
            exit;
       end;

     if (edEmail.Text = '') then
       begin
            ShowMessage('Informe o E-MAIL!');
            edEmail.SetFocus;
            result := false;
            exit;
       end;

     if (meEndereco.Lines.Text = '') then
       begin
            ShowMessage('Informe o Endere�o!');
            meEndereco.SetFocus;
            result := false;
            exit;
       end;

     try
        StrToFloat(mmValor.Text);
     except
           on e:Exception do
             begin
                  ShowMessage('Informe um valor correto!');
                  mmValor.SetFocus;
                  result := false;
                  exit;
             end;
     end;
end;

end.
