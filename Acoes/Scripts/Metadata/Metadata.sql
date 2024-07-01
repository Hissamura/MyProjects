create table Papeis (
  ID int not null,
  Codigo char(10) not null,
  Descricao char(250) null,

  constraint PK_Papeis primary key (id)

)

create table Indicadores (
  ID int not null,
  DataImportacao smalldatetime not null,
  Arquivo varchar(200) null,
  IDPapel int not null,
  CodPapel char(10) null,
  Cotacao decimal (19,10) null,
  PrecoLucro decimal (19,10) null,
  PrecoVlrPratinomial decimal (19,10) null,
  PrecoReceitaLiquida decimal (19,10) null,
  Div_Yield decimal (19,10) null,
  PrecoAtivo decimal (19,10) null,
  PrecoCapGiro decimal (19,10) null,
  PrecoEBIT decimal (19,10) null,
  PrecoAtivCircLiq decimal (19,10) null,
  EVEbit decimal (19,10) null,
  EVEBITIDA decimal (19,10) null,
  MrgEbit decimal (19,10) null,
  MargLiq decimal (19,10) null,
  LiqCorrente decimal (19,10) null,
  ROIC decimal (19,10) null,
  ROE decimal (19,10) null,
  Liq2Meses decimal (19,10) null,
  PatrimLiq decimal (19,10) null,
  DivBrutaPatrimLiq decimal (19,10) null,
  CrescRec5a decimal (19,10) null,
  DataUltCot smalldatetime null,

  constraint PK_Indicadores primary key (id),
  constraint FK_Papeis foreign key (IDPapel)
    references Papeis(ID)

)

alter table Indicadores
add LPA decimal (19,10) null

alter table Indicadores
add VPA decimal (19,10) null

alter table Indicadores
add Margem_Bruta decimal (19,10) null

alter table Indicadores
add EBIT_Ativo decimal (19,10) null

alter table Indicadores
add Liquidez_Corr decimal (19,10) null

alter table Indicadores
add Giro_Ativos decimal (19,10) null

alter table Indicadores
add smalldatetime null

alter table Indicadores
add VolMed2Meses decimal (19,10) null







