unit FastConsole;
{Fast console output trick}
{$MODE DELPHI}

interface

uses
  Classes, CRT, StreamIO, Windows;

implementation

type

  TSuperFastConsoleStream = class(TStream)
  protected
    function Write(const ABuffer; ACount: longint): longint; override;
  end;

function TSuperFastConsoleStream.Write(const ABuffer; ACount: longint): longint;
var
  LNumberOfCharsToWritten: longword;
  LStdHandle: HANDLE;
begin
  LNumberOfCharsToWritten := 0;
  LStdHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(LStdHandle, TextAttr);
  WriteConsole(LStdHandle, @ABuffer, ACount, LNumberOfCharsToWritten, nil);
  Result := LNumberOfCharsToWritten;
end;

initialization

  AssignStream(Output, TSuperFastConsoleStream.Create);
  Rewrite(Output);

end.