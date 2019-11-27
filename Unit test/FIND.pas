program FIND;
{*
 *           Pascal Passage Analyser
 * This program is created for analysing a passage
 * in a text file. Since the program is in its
 * early stage, its features are limited. It can
 * count the number of paragraphs, number of words,
 * number of sentences, reading time, number of
 * unique words in a passage.
 *}
uses longStringType, stringListType, crt, FastConsole, sysutils;

var textFileName, target : string;
    fileExist : Boolean;
    t : Text;
    passage : longString;
    n : Integer;

begin
    Write('Enter the name of your text file (test.txt): ');
    readln(textFileName);
    if textFileName = '' then textFileName := 'test.txt';
    WriteLn;

	fileExist := FileExists(textFileName);

	if fileExist then
	begin
		Assign(t, textFileName);
		Reset(t);
		readLongString(t, passage);

		setScreenWidth(70);

        ClrScr;
		writeLongString(passage);

        WriteLn;

        GotoXY(75, 1);
        Write('Search: ');
        Readln(target);

        GotoXY(1,1);
        writeLongString(passage, target, n);
        GotoXY(75, 3);
        Write('There are ', n , ' ''', target, ''' in the passage.');
        ReadLn;
    end;

end.