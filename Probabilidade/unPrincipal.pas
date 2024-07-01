unit unPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet2: TClientDataSet;
    ClientDataSet2Sequencia: TIntegerField;
    ClientDataSet2QtdeVezes: TIntegerField;
    Timer1: TTimer;
    Edit1: TEdit;
    Label1: TLabel;
    BitBtn2: TBitBtn;
    Timer2: TTimer;
    Edit2: TEdit;
    BitBtn3: TBitBtn;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    vliNumeroSorteado, NumeroAnterior, vliQtdeVezes, qtdeSorteios : integer;
    vlbReset : boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin

  Timer1.Interval := StrToint(Edit1.text);

  Timer1.Enabled := not(Timer1.Enabled);

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  Timer2.Interval := StrToint(Edit2.text);

  Timer2.Enabled := not(Timer2.Enabled);
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var vliI : integer;
begin


  for vlii := 0 to 100000 do
  begin

    Randomize;

    vliNumeroSorteado := Random(2);

    //Memo1.Lines.Add(IntToStr(vliNumeroSorteado));

    qtdeSorteios := qtdeSorteios+1;

    Label1.Caption := 'Qtd Sorteios: ' + IntToStr(qtdeSorteios);

    if (NumeroAnterior <> -1) and (vliNumeroSorteado = NumeroAnterior) then
    begin

      vliQtdeVezes := vliQtdeVezes +1;

    end
    else
    begin

      if ClientDataSet2.Locate('Sequencia', vliQtdeVezes, [loCaseInsensitive]) then
      begin

        ClientDataSet2.Edit;
        ClientDataSet2QtdeVezes.AsInteger := ClientDataSet2QtdeVezes.AsInteger +1;
        ClientDataSet2.post;

      end
      else
      begin

        ClientDataSet2.append;
        ClientDataSet2Sequencia.AsInteger := vliQtdeVezes;
        ClientDataSet2QtdeVezes.AsInteger := 1;
        ClientDataSet2.post;

      end;

      vliQtdeVezes := 1;

    end;


    NumeroAnterior := vliNumeroSorteado;
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  NumeroAnterior := -1;
  vlbReset := false;
  vliQtdeVezes := 1;
  qtdeSorteios := 0;

  ClientDataSet2.CreateDataSet;

  ClientDataSet2.IndexFieldNames := 'Sequencia';

end;

procedure TForm1.Timer1Timer(Sender: TObject);

begin

  Randomize;

  vliNumeroSorteado := Random(36);

  Memo1.Lines.Add(IntToStr(vliNumeroSorteado));

  qtdeSorteios := qtdeSorteios+1;

  Label1.Caption := 'Qtd Sorteios: ' + IntToStr(qtdeSorteios);

  if (NumeroAnterior <> -1) and (((vliNumeroSorteado mod 2) = (NumeroAnterior mod 2)) or (vliNumeroSorteado = 0)) then
  begin

    vliQtdeVezes := vliQtdeVezes +1;

  end
  else
  begin

    if ClientDataSet2.Locate('Sequencia', vliQtdeVezes, [loCaseInsensitive]) then
    begin

      ClientDataSet2.Edit;
      ClientDataSet2QtdeVezes.AsInteger := ClientDataSet2QtdeVezes.AsInteger +1;
      ClientDataSet2.post;

    end
    else
    begin

      ClientDataSet2.append;
      ClientDataSet2Sequencia.AsInteger := vliQtdeVezes;
      ClientDataSet2QtdeVezes.AsInteger := 1;
      ClientDataSet2.post;

    end;

    vliQtdeVezes := 1;

  end;


  NumeroAnterior := vliNumeroSorteado;


end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin


  Randomize;

  vliNumeroSorteado := Random(2);

  //Memo1.Lines.Add(IntToStr(vliNumeroSorteado));

  qtdeSorteios := qtdeSorteios+1;

  Label1.Caption := 'Qtd Sorteios: ' + IntToStr(qtdeSorteios);

  if (NumeroAnterior <> -1) and (vliNumeroSorteado = NumeroAnterior) then
  begin

    vliQtdeVezes := vliQtdeVezes +1;

  end
  else
  begin

    if ClientDataSet2.Locate('Sequencia', vliQtdeVezes, [loCaseInsensitive]) then
    begin

      ClientDataSet2.Edit;
      ClientDataSet2QtdeVezes.AsInteger := ClientDataSet2QtdeVezes.AsInteger +1;
      ClientDataSet2.post;

    end
    else
    begin

      ClientDataSet2.append;
      ClientDataSet2Sequencia.AsInteger := vliQtdeVezes;
      ClientDataSet2QtdeVezes.AsInteger := 1;
      ClientDataSet2.post;

    end;

    vliQtdeVezes := 1;

  end;


  NumeroAnterior := vliNumeroSorteado;


end;

end.
