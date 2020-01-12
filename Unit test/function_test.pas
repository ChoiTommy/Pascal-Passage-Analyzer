program function_test;
uses passageAnalyser, longStringType;
var
    s : longString;
    a : integerArray;
    i : Integer;
begin
    SetLength(s, 3); //abccab
    s[0] := 'a';
    s[1] := 'a';
    s[2] := 'a';
    //s[3] := 'c';
    //s[4] := 'a';
    //s[5] := 'b';
    //s[6] := 'e';
    //s[7] := 'n';

    a := posOfString('a', s);
    //WriteLn(countNoOfSentences(s));
    for i := 0 to Length(a)-1 do
        Write(a[i], ', ');
    readln;

end.