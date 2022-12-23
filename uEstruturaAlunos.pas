unit uEstruturaAlunos;

interface

uses System.Classes, System.SysUtils;

type
  PointAluno = ^TAluno;
  TAluno = record
    Matricula: Integer;
    Nome: String[100];
    Curso: String[200];
    Semestre: Integer;
    Mensalidade: Real;
    Telefone: String[20];
    EMAIL: String[80];
    Endereco: String[255];
    Proximo: PointAluno;
  end;

  TEstruturaAlunos = class
  private
    primeiro: PointAluno;
    ultimo: PointAluno;
    Nodo: PointAluno;
    function carregarDados(aux: PointAluno): TStrings;
  public
    constructor Create();
    destructor Destroy();

    function IncluiAluno(PNome: String; PMatricula: Integer; PCurso: String; PSemestre: Integer; PMensalidade: Real; Telefone, EMAIL, Endereco: String): Boolean;
    function RemoveAluno(): Boolean;
    function RemoveTodosAlunos(): Boolean;
    function carregarAlunos: TStrings;

    function buscarNome(PNome:String): TStrings;
    function buscarCurso(PCurso: String): TStrings;
    function buscarCursoSemestre(PCurso: String;  PSemestre: Integer): TStrings;
    function buscarValorCurso(PCurso: String): Real;
    function buscarMaiorMensalidade: TStrings;
  end;

implementation


{ TEstruturaAlunos }

function TEstruturaAlunos.buscarCurso(PCurso: String): TStrings;
Var
  aux : PointAluno;
Begin
  Result := TStringList.Create;
  Aux := primeiro;
  While aux <> nil do
  begin
    if AnsiUpperCase(aux^.Curso) = AnsiUpperCase(PCurso) then
    begin
      Result.AddStrings(carregarDados(aux));
      break;
    end
    else
      aux := aux^.Proximo;
  end;
end;

function TEstruturaAlunos.buscarCursoSemestre(PCurso: String;  PSemestre: Integer): TStrings;
Var
  aux : PointAluno;
Begin
  Result := TStringList.Create;
  Aux := primeiro;
  While aux <> nil do
  begin
    if (AnsiUpperCase(aux^.Curso) = AnsiUpperCase(PCurso)) and (aux^.Semestre = PSemestre) then
    begin
      Result.AddStrings(carregarDados(aux));
      break;
    end
    else
      aux := aux^.Proximo;
  end;
end;

function TEstruturaAlunos.buscarMaiorMensalidade: TStrings;
Var
    aux, auxmaior : PointAluno;
    valorMaior: Real;
Begin
  Result := TStringlist.Create;
  Aux := primeiro;
  auxmaior := aux;
  valorMaior :=  aux^.Mensalidade;
  While aux <> nil do
  begin
    if (aux^.Mensalidade > valorMaior) then
    begin
      valorMaior := aux^.Mensalidade;
      auxmaior := aux;
    end;
    aux := aux^.Proximo;
  end;
  Result.Add('Aluno com maior valor de Mensalidades');
  Result.AddStrings(carregarDados(auxmaior));
end;

function TEstruturaAlunos.buscarNome(PNome: String): TStrings;
Var
  aux : PointAluno;
Begin
  Result := TStringlist.Create;
  Aux := primeiro;
  While aux <> nil do
  begin
    if AnsiUpperCase(aux^.Nome) = AnsiUpperCase(PNome) then
    begin
      Result.AddStrings(carregarDados(aux));
      break;
    end
    else
      aux := aux^.Proximo;
  end;
end;

function TEstruturaAlunos.buscarValorCurso(PCurso: String): Real;
Var
  aux : PointAluno;
Begin
  Result := 0;
  Aux := primeiro;
  While aux <> nil do
  begin
    if (AnsiUpperCase(aux^.Curso) = AnsiUpperCase(PCurso)) then
      Result := Result + aux^.Mensalidade
    else
      aux := aux^.Proximo;
  end;
end;

function TEstruturaAlunos.carregarAlunos: TStrings;
var
   aux: PointAluno;
begin
  Result := TStringList.Create;
  if (primeiro <> nil) then
  begin
    aux := primeiro;
    while (aux <> nil) do
    begin
        Result.AddStrings(carregarDados(aux));
        aux:= aux^.Proximo;
    end;
  end;
end;

function TEstruturaAlunos.carregarDados(aux: PointAluno): TStrings;
begin
   Result := TStringList.Create;
   Result.Add('Matrícula: ' + IntToStr(aux^.matricula) + ' Aluno: ' + aux^.nome);
   Result.Add('Telefone: ' + aux^.Telefone);
   Result.Add('E-MAIL: ' + aux^.EMAIL);
   Result.Add('Endereço: ' + aux^.Endereco);
   Result.Add('Curso: ' + aux^.curso + ' Semestre: ' + IntToStr(aux^.Semestre));
   Result.Add('Valor: ' + FormatFloat('###,##0.00', aux^.Mensalidade));
   Result.Add('------------------------------------------');
end;

constructor TEstruturaAlunos.Create;
begin
  primeiro := nil;
  ultimo   := nil;
  Nodo     := nil;
end;

destructor TEstruturaAlunos.Destroy;
begin
  RemoveTodosAlunos();
end;

function TEstruturaAlunos.IncluiAluno(PNome: String; PMatricula: Integer; PCurso: String; PSemestre: Integer; PMensalidade: Real; Telefone, EMAIL, Endereco: String): Boolean;
begin
  try
    new(Nodo);
    Nodo^.Matricula := PMatricula;
    Nodo^.Nome := PNome;
    Nodo^.Curso := PCurso;
    Nodo^.Semestre := PSemestre;
    Nodo^.Mensalidade := PMensalidade;
    Nodo^.Telefone := Telefone;
    Nodo^.EMAIL := EMAIL;
    Nodo^.Endereco := Endereco;
    Nodo^.Proximo := nil;
    ultimo := Nodo;
    if primeiro = nil then
      primeiro := Nodo
    else
      ultimo^.Proximo := Nodo;
    Result := true;
  except
    Result := false;
  end;
end;

function TEstruturaAlunos.RemoveAluno: Boolean;
var
  Aux: PointAluno;
begin
  Result := False;
  if primeiro <> nil then
  begin
    aux := primeiro;
    primeiro := primeiro^.Proximo;
    Dispose(aux);
    Result := true;
  end;
end;

function TEstruturaAlunos.RemoveTodosAlunos: Boolean;
begin
     while (primeiro <> nil) do
        RemoveAluno;
end;

end.
