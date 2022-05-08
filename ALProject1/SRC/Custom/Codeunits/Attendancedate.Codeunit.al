codeunit 50010 "Attendance date"
{

    trigger OnRun()
    var
        "count": Integer;
        test: Integer;
        test2: Integer;
    begin
        /*test := 0;
        test2 := 5;
        FOR count := 0 TO 29 DO BEGIN
          test := test + 1;
          test2 := test2 + 1;
        END;
        MESSAGE('%1, %2', test, test2);*/

    end;

    var
        NextEntryNo: Integer;

    [Scope('OnPrem')]
    procedure AddDates(Child: Record Childer)
    var
        Date: Date;
        AttendanceLine: Record "Child Attendance";
        "count": Integer;
        KidNo: Code[20];
        childHeader: Record "Posted Child Header";
        date1: Date;
        date2: Date;
    begin
        //MESSAGE('%1',Child."Child No.");
        KidNo := Child."Child No.";
        Date := Today;
        childHeader.SetFilter("Child No.", KidNo);
        if childHeader.FindSet then begin
            //MESSAGE('%1 %2',childHeader."Date From",childHeader."Date To");
            date1 := childHeader."Date From";
            date2 := childHeader."Date To";
        end;
        for count := 0 to 29 do begin
            if (Date >= date1) and (Date <= date2) then begin
                AttendanceLine.SetFilter("Child No.", KidNo);
                if AttendanceLine.FindSet then begin
                    repeat
                        if AttendanceLine.Date = Date then
                            Error('It is not allowed to add the same dates - some dates already exists');
                    until AttendanceLine.Next = 0;
                end;

                InitNextEntryNo;
                AttendanceLine.Init;
                AttendanceLine."Entry No." := NextEntryNo;
                AttendanceLine."Child No." := Child."Child No.";
                AttendanceLine.Validate("Child No.");
                AttendanceLine.Date := Date;
                AttendanceLine.Insert;
            end;
            Date := Date + 1;
        end;
    end;

    local procedure InitNextEntryNo()
    var
        AttLine: Record "Child Attendance";
    begin
        AttLine.LockTable;
        if AttLine.FindLast then begin
            NextEntryNo := AttLine."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
    end;

    [Scope('OnPrem')]
    procedure AddGroupDates(Group: Record "Kindergarten Groups")
    var
        Child: Record Childer;
        KidNo: Code[20];
        "count": Integer;
        AttendanceLine: Record "Child Attendance";
        Date: Date;
        childHeader: Record "Posted Child Header";
        date1: Date;
        date2: Date;
    begin
        Child.SetFilter("Group No.", Group."Group No.");
        if Child.FindSet then begin
            repeat
                KidNo := Child."Child No.";
                Date := Today;
                childHeader.SetFilter("Child No.", KidNo);
                if childHeader.FindSet then begin
                    date1 := childHeader."Date From";
                    date2 := childHeader."Date To";
                end;
                for count := 0 to 29 do begin
                    if (Date >= date1) and (Date <= date2) then begin
                        AttendanceLine.SetFilter("Child No.", KidNo);
                        if AttendanceLine.FindSet then begin
                            repeat
                                if AttendanceLine.Date = Date then
                                    Error('It is not allowed to add the same dates - some dates already exists');
                            until AttendanceLine.Next = 0;
                        end;

                        InitNextEntryNo;
                        AttendanceLine.Init;
                        AttendanceLine."Entry No." := NextEntryNo;
                        AttendanceLine."Child No." := Child."Child No.";
                        AttendanceLine.Validate("Child No.");
                        AttendanceLine.Date := Date;
                        AttendanceLine.Insert;
                    end;
                    Date := Date + 1;
                end;
            until Child.Next = 0;
        end;
    end;
}

