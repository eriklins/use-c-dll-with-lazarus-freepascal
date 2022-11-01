program MathClient;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp, MathLibrary
  { you can add units after this };

type

  { TMathClient }

  TMathClient = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMathClient }

procedure TMathClient.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { here comes the part using the DLL functions! }
  fibonacci_init(1, 1);
  repeat
    writeln(IntToStr(fibonacci_index()) + ':' + IntToStr(fibonacci_current()));
  until not fibonacci_next();

  // stop program loop
  Terminate;
end;

constructor TMathClient.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMathClient.Destroy;
begin
  inherited Destroy;
end;

procedure TMathClient.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TMathClient;
begin
  Application:=TMathClient.Create(nil);
  Application.Title:='MathClient';
  Application.Run;
  Application.Free;
end.

