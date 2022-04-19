program ApiPizzaria;
{$MODE DELPHI}{$H+}

uses
  Classes,
  SysUtils, dac10,
  Horse,
  Horse.BasicAuthentication,
  Horse.OctetStream,
  Horse.HandleException,
  Horse.Jhonson;

const
 USER = 'Adim';
 PASS = 'AaSl@çQ*hT%vQMpvz';

function DoLogin(const AUsername, APassword: string): Boolean; // função para autenticar acesso a api
begin
   Result :=  Ausername.equals(USER) and APassword.Equals(PASS)
end;

procedure OnListen(Horse: THorse);
begin
    Writeln(Format('Server is runing on %s:%d', [Horse.Host, Horse.Port]));
end;


begin
  //Instancia Middlewares
   THorse
       .Use(HorseBasicAuthentication(DoLogin))
       .Use(OctetStream)
       .Use(HandleException)
       .Use(Jhonson);

   THorse.Listen(211, OnListen);
end.
