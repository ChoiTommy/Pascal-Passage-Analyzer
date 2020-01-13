program function_test;
uses passageAnalyser, longStringType, stringListType;
var
    s : stringList;
    a : integerArray;
    i : Integer;
begin
    SetLength(s, 7);
    s[0] := 'Airplane';
    s[1] := 'Chris';
    s[2] := 'Egg';
    s[3] := 'Isaac';
    s[4] := 'Steven';
    s[5] := 'Sunny';
    s[6] := 'Zoo';
    //s[7] := 'n';

    //a := posOfString('a', s);
    //WriteLn(countNoOfSentences(s));
    //for i := 0 to Length(a)-1 do
    //    Write(a[i], ', ');
    WriteLn(binarySearch(s, 'Zoo', 0, 6));
    readln;

end.