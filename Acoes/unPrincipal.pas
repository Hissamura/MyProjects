unit unPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.OleCtrls, SHDocVw, Vcl.Grids, Vcl.DBGrids, ActiveX, Axctrls,
  ZAbstractConnection, ZConnection, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, URLMon, ZSqlUpdate, Vcl.ExtDlgs, Vcl.ComCtrls, Vcl.ExtCtrls,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    qryIndicadores: TZQuery;
    qryIndicadoresID: TIntegerField;
    qryIndicadoresIDPapel: TIntegerField;
    qryIndicadoresCodPapel: TWideStringField;
    qryIndicadoresCotacao: TFloatField;
    qryIndicadoresPrecoLucro: TFloatField;
    qryIndicadoresPrecoVlrPratinomial: TFloatField;
    qryIndicadoresPrecoReceitaLiquida: TFloatField;
    qryIndicadoresDiv_Yield: TFloatField;
    qryIndicadoresPrecoAtivo: TFloatField;
    qryIndicadoresPrecoCapGiro: TFloatField;
    qryIndicadoresPrecoEBIT: TFloatField;
    qryIndicadoresPrecoAtivCircLiq: TFloatField;
    qryIndicadoresEVEbit: TFloatField;
    qryIndicadoresEVEBITIDA: TFloatField;
    qryIndicadoresMrgEbit: TFloatField;
    qryIndicadoresMargLiq: TFloatField;
    qryIndicadoresLiqCorrente: TFloatField;
    qryIndicadoresROIC: TFloatField;
    qryIndicadoresROE: TFloatField;
    qryIndicadoresLiq2Meses: TFloatField;
    qryIndicadoresPatrimLiq: TFloatField;
    qryIndicadoresDivBrutaPatrimLiq: TFloatField;
    qryIndicadoresCrescRec5a: TFloatField;
    ZConnection1: TZConnection;
    dsrIndicadores: TDataSource;
    DlgArquivo: TOpenTextFileDialog;
    qryPapeis: TZQuery;
    dsrPapeis: TDataSource;
    qryIndicadoresDataImportacao: TDateTimeField;
    uptIndicadores: TZUpdateSQL;
    uptPapeis: TZUpdateSQL;
    qryPapeisID: TIntegerField;
    qryPapeisCodigo: TWideStringField;
    qryPapeisDescricao: TWideStringField;
    qryPesquisa: TZReadOnlyQuery;
    Panel1: TPanel;
    edtURL: TEdit;
    btnExtrair: TBitBtn;
    BitBtn1: TBitBtn;
    edtCaminho: TEdit;
    btnCarregar: TBitBtn;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    ProgressBar1: TProgressBar;
    qryIndicadoresArquivo: TWideStringField;
    btnGravar: TBitBtn;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    edtLinkAcao: TEdit;
    btnDetalhes: TBitBtn;
    Panel6: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    qryIndicadoresLPA: TFloatField;
    qryIndicadoresVPA: TFloatField;
    qryIndicadoresMargem_Bruta: TFloatField;
    qryIndicadoresEBIT_Ativo: TFloatField;
    qryIndicadoresLiquidez_Corr: TFloatField;
    qryIndicadoresGiro_Ativos: TFloatField;
    edtCotacoes: TEdit;
    btnCotacoes: TBitBtn;
    qryIndicadoresDataUltCot: TDateTimeField;
    qryIndicadoresVolMed2Meses: TFloatField;
    edtPapel: TEdit;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    BitBtn2: TBitBtn;
    Memo3: TMemo;
    edtBuscarPapel: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCarregarClick(Sender: TObject);
    procedure btnExtrairClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnDetalhesClick(Sender: TObject);
    procedure btnCotacoesClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
    function MaxIdPapeis:integer;
    function MaxIdIndicadores:integer;
    procedure ValidaArquivo;
  public
    { Public declarations }
    vgsNomeArquivo : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
var vlsArquivo : String;
  vlscsv : TStringList;
begin

  vlsArquivo := DateToStr(Date) + ' '+ TimeToStr(Time);

  vlsArquivo := StringReplace(vlsArquivo, '\', '', [rfReplaceAll, rfIgnoreCase]);
  vlsArquivo := StringReplace(vlsArquivo, '/', '', [rfReplaceAll, rfIgnoreCase]);
  vlsArquivo := StringReplace(vlsArquivo, ':', '', [rfReplaceAll, rfIgnoreCase]);

  URLDownloadToFile(nil, PChar(EdtUrl.Text), PChar(edtCaminho.Text + '\'+ vlsArquivo+'.txt'), 0, nil);

  vlscsv := TStringList.Create;

  vlscsv.LoadFromFile(edtCaminho.Text + '\'+ vlsArquivo+'.txt');

  memo1.Text := vlscsv.Text;

  showmessage('Download Concluido com sucesso!')

end;

procedure TForm1.btnExtrairClick(Sender: TObject);
var vlsHtml : TStringList;
  vliI, vliCampo, vliMaxIdIndicadores : Integer;
  vlsCodPapel, vlsValor : String;
  vlfValor : double;
begin

  ValidaArquivo;

  vlsHtml := TStringList.Create;

  vlsHtml.text := memo1.Text;

  ProgressBar1.Max := vlsHtml.Count -1;

  vliMaxIdIndicadores := MaxIdIndicadores;

  for vliI := 0 to vlsHtml.Count -1 do
  begin

    if pos('<td', vlsHtml.Strings[vliI]) > 0 then
    begin
      if pos('res_papel', vlsHtml.Strings[vliI]) > 0 then
      begin

        vliCampo := 0;

        vlsCodPapel := vlsHtml.Strings[vliI];

        vlsCodPapel := Copy(vlsCodPapel, Pos('papel=', vlsCodPapel)+6, 15);

        vlsCodPapel := copy(vlsCodPapel, 0, Pos('"', vlsCodPapel)-1);


        qryPapeis.close;
        qryPapeis.open;

        if not qryPapeis.Locate('Codigo', vlsCodPapel, [loCaseInsensitive]) then
        begin

          qryPapeis.Append;
          qryPapeisID.AsInteger := MaxIdPapeis;
          qryPapeisCodigo.AsString := vlsCodPapel;
          qryPapeis.Post;

        end;

        qryIndicadores.Append;
        qryIndicadoresID.AsInteger := vliMaxIdIndicadores;
        qryIndicadoresDataImportacao.AsDateTime := Date;
        qryIndicadoresIDPapel.AsInteger := qryPapeisID.AsInteger;
        qryIndicadoresCodPapel.AsString := vlsCodPapel;
        qryIndicadoresArquivo.AsString := vgsNomeArquivo;
        qryIndicadores.post;

        vliMaxIdIndicadores := vliMaxIdIndicadores +1;

      end
      else
      begin

        vlsValor := vlsHtml.Strings[vliI];
        vlsValor := copy(vlsValor, Pos('<td>', vlsValor)+4, Pos('</td>', vlsValor) - (Pos('<td>', vlsValor)+4));
        vlsValor := StringReplace(vlsValor, '.', '', [rfReplaceAll]);
        vlsValor := StringReplace(vlsValor, '%', '', [rfReplaceAll]);

        qryIndicadores.Edit;

        case vliCampo of
          0 : qryIndicadoresCotacao.AsFloat :=  StrToFloat(vlsValor);
          1 : qryIndicadoresPrecoLucro.AsFloat :=  StrToFloat(vlsValor);
          2 : qryIndicadoresPrecoVlrPratinomial.AsFloat :=  StrToFloat(vlsValor);
          3 : qryIndicadoresPrecoReceitaLiquida.AsFloat :=  StrToFloat(vlsValor);
          4 : qryIndicadoresDiv_Yield.AsFloat :=  StrToFloat(vlsValor);
          5 : qryIndicadoresPrecoAtivo.AsFloat :=  StrToFloat(vlsValor);
          6 : qryIndicadoresPrecoCapGiro.AsFloat :=  StrToFloat(vlsValor);
          7 : qryIndicadoresPrecoEBIT.AsFloat :=  StrToFloat(vlsValor);
          8 : qryIndicadoresPrecoAtivCircLiq.AsFloat :=  StrToFloat(vlsValor);
          9 : qryIndicadoresEVEbit.AsFloat :=  StrToFloat(vlsValor);
          10 : qryIndicadoresEVEBITIDA.AsFloat :=  StrToFloat(vlsValor);
          11 : qryIndicadoresMrgEbit.AsFloat :=  StrToFloat(vlsValor);
          12 : qryIndicadoresMargLiq.AsFloat :=  StrToFloat(vlsValor);
          13 : qryIndicadoresLiqCorrente.AsFloat :=  StrToFloat(vlsValor);
          14 : qryIndicadoresROIC.AsFloat :=  StrToFloat(vlsValor);
          15 : qryIndicadoresROE.AsFloat :=  StrToFloat(vlsValor);
          16 : qryIndicadoresLiq2Meses.AsFloat :=  StrToFloat(vlsValor);
          17 : qryIndicadoresPatrimLiq.AsFloat :=  StrToFloat(vlsValor);
          18 : qryIndicadoresDivBrutaPatrimLiq.AsFloat :=  StrToFloat(vlsValor);
          19 : qryIndicadoresCrescRec5a.AsFloat :=  StrToFloat(vlsValor);

        end;

        qryIndicadores.Post;

        vliCampo := vliCampo +1;

      end;

    end;

    ProgressBar1.Position := ProgressBar1.Position + 1;

  end;

  ProgressBar1.Position := 0;

end;

procedure TForm1.btnGravarClick(Sender: TObject);
begin

  if qryIndicadores.UpdatesPending then
  begin

    qryIndicadores.ApplyUpdates;

    ShowMessage('Indicadores gravados com sucesso!');

  end;


end;

procedure TForm1.btnDetalhesClick(Sender: TObject);
var vlscsv : TStringList;
  vliI : Integer;
  vlsTag, vlsValor : String;
  vlcValor : double;
  vldValor : TDateTime;
begin

  qryIndicadores.Close;
  qryIndicadores.ParamByName('Arquivo').AsString := vgsNomeArquivo;
  qryIndicadores.Open;

  qryIndicadores.first;

  while not(qryIndicadores.eof) do
  begin

    URLDownloadToFile(nil, PChar(edtLinkAcao.text + qryIndicadoresCodPapel.AsString), PChar(edtCaminho.Text + '\Ativos\' + qryIndicadoresCodPapel.AsString+'.txt'), 0, nil);

    vlscsv := TStringList.Create;

    vlscsv.LoadFromFile(edtCaminho.Text + '\Ativos\' + qryIndicadoresCodPapel.AsString+'.txt');

    memo2.Text := vlscsv.Text;

    vlsTag := '';

    for vliI := 120 to vlscsv.Count -1 do
    begin

      if vlsTag <> '' then
      begin

        vlsValor := vlscsv.Strings[vliI] + vlscsv.Strings[vliI+1];
        vlsValor := copy(vlsValor, Pos('"txt">',vlsValor)+6, Pos('</span>',vlsValor) - (Pos('"txt">',vlsValor)+6));
        vlsValor := StringReplace(vlsValor, '.', '', [rfReplaceAll]);
        vlsValor := StringReplace(vlsValor, '%', '', [rfReplaceAll]);

        if (vlsTag <> 'Data últ cot') and not(TryStrToFloat(vlsValor, vlcValor)) then
          vlsValor := '0';

        FormatSettings.ShortDateFormat := 'dd/mm/yyyy';

        if (vlsTag = 'Data últ cot') then
          TryStrToDateTime(vlsValor, vldValor);

        FormatSettings.ShortDateFormat := 'yyyy/mm/dd';

        qryIndicadores.Edit;

        if vlsTag = 'LPA' then
          qryIndicadoresLPA.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'VPA' then
          qryIndicadoresVPA.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'Marg. Bruta' then
          qryIndicadoresMargem_Bruta.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'EBIT / Ativo' then
          qryIndicadoresEBIT_Ativo.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'Liquidez Corr' then
          qryIndicadoresLiquidez_Corr.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'Giro Ativos' then
          qryIndicadoresGiro_Ativos.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'Data últ cot' then
          qryIndicadoresDataUltCot.AsDateTime := vldValor
        else
        if vlsTag = 'Vol $ méd (2m)' then
          qryIndicadoresVolMed2Meses.AsFloat := StrToFloat(vlsValor);

        qryIndicadores.Post;

        vlsTag := ''

      end;


      if (pos('>LPA<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'LPA'
      else
      if (pos('>VPA<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'VPA'
      else
      if (pos('>Marg. Bruta<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Marg. Bruta'
      else
      if (pos('>EBIT / Ativo<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'EBIT / Ativo'
      else
      if (pos('>Liquidez Corr<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Liquidez Corr'
      else
      if (pos('>Giro Ativos<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Giro Ativos'
      else
      if (pos('>Data últ cot<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Data últ cot'
      else
      if (pos('>Vol $ méd (2m)<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Vol $ méd (2m)';

    end;

    qryIndicadores.next;

  end;

  qryIndicadores.Filtered := False;

end;

procedure TForm1.BitBtn2Click(Sender: TObject);

begin

  memo3.Clear;
  RESTClient.BaseURL := 'https://brapi.dev/api/quote/' + edtBuscarPapel.text;
  RESTRequest.Execute;

  memo3.Lines.Add(RESTRequest.Response.JSONText);

end;

procedure TForm1.btnCarregarClick(Sender: TObject);
begin

  if DlgArquivo.Execute then
  begin

    vgsNomeArquivo := DlgArquivo.FileName;

    Memo1.Lines.LoadFromFile(vgsNomeArquivo);

  end;

end;

procedure TForm1.btnCotacoesClick(Sender: TObject);
var vlscsv : TStringList;
  vliI : Integer;
  vlsTag, vlsValor : String;
  vlcValor : double;
begin

  qryIndicadores.Close;
  qryIndicadores.ParamByName('Arquivo').AsString := vgsNomeArquivo;
  qryIndicadores.Open;

  qryIndicadores.Filtered := false;
  qryIndicadores.Filter := ' CodPapel = ' + QuotedStr(edtPapel.text);
  qryIndicadores.Filtered := True;

  qryIndicadores.first;

{  while not(qryIndicadores.eof) do
  begin
}
    URLDownloadToFile(nil, PChar(edtCotacoes.text + qryIndicadoresCodPapel.AsString), PChar(edtCaminho.Text + '\Cotacoes\' + qryIndicadoresCodPapel.AsString+'.txt'), 0, nil);

    vlscsv := TStringList.Create;

    vlscsv.LoadFromFile(edtCaminho.Text + '\Cotacoes\' + qryIndicadoresCodPapel.AsString+'.txt');

    memo2.Text := vlscsv.Text;

    {vlsTag := '';

    for vliI := 176 to vlscsv.Count -1 do
    begin

      if vlsTag <> '' then
      begin

        vlsValor := vlscsv.Strings[vliI] + vlscsv.Strings[vliI+1];
        vlsValor := copy(vlsValor, Pos('"txt">',vlsValor)+6, Pos('</span>',vlsValor) - (Pos('"txt">',vlsValor)+6));
        vlsValor := StringReplace(vlsValor, '.', '', [rfReplaceAll]);
        vlsValor := StringReplace(vlsValor, '%', '', [rfReplaceAll]);

        if not(TryStrToFloat(vlsValor, vlcValor)) then
          vlsValor := '0';

        qryIndicadores.Edit;

        if vlsTag = 'LPA' then
          qryIndicadoresLPA.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'VPA' then
          qryIndicadoresVPA.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'Marg. Bruta' then
          qryIndicadoresMargem_Bruta.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'EBIT / Ativo' then
          qryIndicadoresEBIT_Ativo.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'Liquidez Corr' then
          qryIndicadoresLiquidez_Corr.AsFloat := StrToFloat(vlsValor)
        else
        if vlsTag = 'Giro Ativos' then
          qryIndicadoresGiro_Ativos.AsFloat := StrToFloat(vlsValor);

        qryIndicadores.Post;

        vlsTag := ''

      end;


      if (pos('>LPA<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'LPA'
      else
      if (pos('>VPA<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'VPA'
      else
      if (pos('>Marg. Bruta<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Marg. Bruta'
      else
      if (pos('>EBIT / Ativo<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'EBIT / Ativo'
      else
      if (pos('>Liquidez Corr<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Liquidez Corr'
      else
      if (pos('>Giro Ativos<', vlscsv.Strings[vliI]) > 0) then
        vlsTag := 'Giro Ativos';

    end;

    qryIndicadores.next;

  end;      }

  qryIndicadores.Filtered := False;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  FormatSettings.ShortDateFormat := 'yyyy/mm/dd';

  qryIndicadores.Close;
  qryIndicadores.Open;

end;

function TForm1.MaxIdIndicadores: integer;
begin

  qryPesquisa.Close;
  qryPesquisa.SQL.Clear;
  qryPesquisa.SQL.Add('select ISNULL(MAX(ISNULL(ID,0)),0) +1 ID from Indicadores');
  qryPesquisa.Open;

  result := qryPesquisa.FieldByName('ID').AsInteger;

end;

function TForm1.MaxIdPapeis: integer;
begin

  qryPesquisa.Close;
  qryPesquisa.SQL.Clear;
  qryPesquisa.SQL.Add('select ISNULL(MAX(ISNULL(ID,0)),0) +1 ID from Papeis');
  qryPesquisa.Open;

  result := qryPesquisa.FieldByName('ID').AsInteger;

end;

procedure TForm1.ValidaArquivo;
begin

  qryPesquisa.Close;
  qryPesquisa.SQL.Clear;
  qryPesquisa.Sql.Add('select 0 from Indicadores ');
  qryPesquisa.Sql.Add('where Arquivo =:Arquivo');
  qryPesquisa.ParamByName('Arquivo').AsString := vgsNomeArquivo;
  qryPesquisa.Open;

  if not(qryPesquisa.IsEmpty) then
  begin

    if Application.MessageBox('Já existe importação para esse arquivo. Deseja continuar', 'Arquivo já Importado', MB_YESNO) = mrYes then
    begin

      qryPesquisa.Close;
      qryPesquisa.Sql.Add('delete Indicadores ');
      qryPesquisa.Sql.Add('where Arquivo =:Arquivo');
      qryPesquisa.ParamByName('Arquivo').AsString := vgsNomeArquivo;
      qryPesquisa.ExecSql;

    end
    else
    begin

      qryIndicadores.Close;
      qryIndicadores.ParamByName('Arquivo').AsString := vgsNomeArquivo;
      qryIndicadores.Open;

      abort;

    end;

  end;

end;

end.
