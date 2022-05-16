program ApiPizzaria;
{$MODE DELPHI}{$H+}

uses
  Classes,
  SysUtils,FileInfo,
  Horse,
  Horse.CORS,
  Horse.BasicAuthentication,
  Horse.HandleException,
  Horse.Jhonson,
  controller.root,
  controllers.logins,
  controllers.pizzas,
  controllers.post.pizzas, controllers.cadastros;

const
 USER = 'Admin';
 PASS = 'AaSl@çQ*hT%vQMpvz';

function DoLogin(const AUsername, APassword: string): Boolean; // função para autenticar acesso a api
begin
   Result :=  Ausername.equals(USER) and APassword.Equals(PASS)
end;

procedure OnListen(Horse: THorse);
var
  LFileVersionInfo      : TFileVersionInfo;
  LVersionDate,LVersion : string;

begin
 LFileVersionInfo   := TFileVersionInfo.Create(nil);
 try
  LFileVersionInfo.ReadFileInfo;
  LVersion        := LFileVersionInfo.VersionStrings.Values['FileVersion'];
  LVersionDate    := {$I %DATE%} + ' ' + {$I %TIME%};
  Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
  WriteLn('Version: ' + LVersion);
  WriteLn('Date:' + LVersionDate);
 finally
   FreeAndNil(LFileVersionInfo);
 end;
end;


{$R *.res}

begin
  //Instancia Middlewares
     HorseCORS
     .AllowedOrigin('*')
     .AllowedCredentials(true)
     .AllowedHeaders('*')
     .AllowedMethods('*')
     .ExposedHeaders('*');

   THorse
       .Use(CORS)
       .Use(HorseBasicAuthentication(DoLogin))
       .Use(HandleException)
       .Use(Jhonson);

   TRoot.registry;
   TLogin.registry;
   TPizzas.registry;
   TPostPizzas.registry;

   THorse.Listen(9000, OnListen);
end.
