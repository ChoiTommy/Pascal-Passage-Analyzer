program abc;
uses ui;
begin
    drawButton(3,3, 21, 5, 'Normal', 0);
    ReadLn;
    drawButton(50,3, 21, 5, 'Selected', 1);
    ReadLn;
    drawButton(90,3, 21, 5, 'Clicked', 2);

    drawMsgBox(3, 10, 27, 5, 'DFFFFFF', 3);
    drawInputBox(3, 17, 20, 'Name', 'Kaij');
    drawTab(3, 25, 23, 5, 'ABC');
    ReadLn;
end.