program READTXT_test;
(*Current problems:
* - '!', '?', ':', and many other punctuation marks are not considered
* - many memory spaced are wasted
* - structure is quite complicated (passage[] : paragraph; passage[][] : sentence; passage[][].word[] : word;...)
* - dependent on the format of the txt file (each line in a txt file is a paragraph, no. of lines : no. of paragraphs)
*)
const file_path = 'Text files/test.txt';
type sentence = record
                    word : array[1..50] of string;
                    punctuation : Char;
                end;
     paragraph = array[1..50] of sentence;
     passage = array[1..50] of paragraph;

var passage_test : passage;
    t : text;
    c : Char;
    s : string;
    i, x, a, k, j : Integer;

{procedure readParagraph();
begin

end;

procedure readPassage();
begin

end;

procedure writePassage();
begin

end;}

begin
    //a : paragraph counter
    //x : sentence counter
    //i : word counter
    Assign(t, file_path);
    Reset(t);
    a := 1;

    WriteLn('Hello world');
    ReadLn;

    {Process the txt file}
    while not eof(t) do
    begin
        x := 1;
        while not eoln(t) do
        begin
            i := 1;
            Read(t, c);
            while not ((c = ',') or (c = '.') or (c = ' ')) do
            begin
                s := '';
                while (c <> ' ') and (c <> ',') and (c <> '.') do
                begin
                    s := s + c;
                    Read(t, c);
                end;
                passage_test[a][x].word[i] := s;
                i := i + 1;
                if (c = ',') or (c = '.') then
                    passage_test[a][x].punctuation := c
                else
                    Read(t, c);
            end;
            x := x + 1;
        end;
        a := a + 1;
        readln(t);
    end;

    WriteLn('Bye');
    ReadLn;

    {Output results}
    for i := 1 to 50 do
        if passage_test[i][1].word[1] <> '' then
            for j := 1 to 50 do
                if passage_test[i][j].word[1] <> '' then
                begin
                    for k := 1 to 50 do
                        if passage_test[i][j].word[k] <> '' then
                            writeln(passage_test[i][j].word[k]);
                    WriteLn(passage_test[i][j].punctuation);
                end;
    readln;
end.