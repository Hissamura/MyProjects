program backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses Horse, System.JSON, Horse.Jhonson, Horse.Commons, System.SysUtils, Horse.BasicAuthentication, Horse.Compression,
  Horse.HandleException{, Horse.JWT};

var vloApp : THorse;
  vloUsuarios : TJSONArray;

begin

  vloApp := THorse.Create(9000);

  vloApp.Use(Compression());
  vloApp.Use(Jhonson);
  vloApp.Use(HandleException);
  {vloApp.Use(HorseJWT('jwt-secret'));

  vloApp.Post('/JWT',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Req.Session<TJSONObject>; //Default Payload is JSON
    end);}

  vloApp.Use(HorseBasicAuthentication(
    function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('user') and APassword.Equals('password');
    end));

  vloUsuarios := TJSONArray.Create;

  vloApp.Get('/exception',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LConteudo: TJSONObject;
    begin

        raise EHorseException.Create('Error Message teste');
        LConteudo := TJSONObject.Create;
        LConteudo.AddPair('nome', 'guilherme');
        Res.Send(LConteudo);


    end);

  vloApp.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      I: Integer;
      LPong: TJSONArray;
    begin
      LPong := TJSONArray.Create;
      for I := 0 to 1000 do
        LPong.Add(TJSONObject.Create(TJSONPair.Create('ping', 'pong')));
      Res.Send(LPong);
    end);


  vloApp.Get('/usuarios',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send<TJSONAncestor>(vloUsuarios.Clone);
    end);

  vloApp.Post('/usuarios',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var vloUsuario : TJSONObject;
    begin
      vloUsuario := Req.Body<TJSONObject>.Clone as TJSONObject;
      vloUsuarios.AddElement(vloUsuario);
      Res.Send<TJSONAncestor>(vloUsuario.Clone).Status(THTTPStatus.Created);
    end);

  vloApp.Delete('/usuarios/:id',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var vliId: Integer;
    begin
      vliID := Req.Params.Items['id'].ToInteger;
      vloUsuarios.Remove(Pred(vliId)).Free;
      Res.Send<TJSONAncestor>(vloUsuarios.Clone).Status(THTTPStatus.NoContent);
    end);

  vloApp.Start;

end.
