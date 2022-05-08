table 50060 "Child Attendance"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(20; "Child No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Childer."Child No.";

            trigger OnValidate()
            var
                childHeader: Record "Posted Child Header";
                Child: Record Childer;
            begin
                TerminationCheck;
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then
                    "Contract No." := childHeader."No.";

                Child.SetFilter(Child."Child No.", "Child No.");
                if Child.FindSet then begin
                    "Child Name" := Child."Child Name";
                    "Group No." := Child."Group No.";
                end;
            end;
        }
        field(23; "Child Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Group No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Date; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                childHeader: Record "Posted Child Header";
                AttendLine: Record "Child Attendance";
                KidNo: Code[20];
            begin
                TerminationCheck;
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    if Date < childHeader."Date From" then
                        Error('Date must be higher than contract starting date');
                    if Date > childHeader."Date To" then
                        Error('Contract is expired - date must be lower than contract ending date');
                end;

                KidNo := "Child No.";
                AttendLine.SetFilter("Child No.", KidNo);
                if AttendLine.FindSet then begin
                    repeat
                        if AttendLine.Date = Date then
                            Error('Selected date is already marked in attendance');
                    until AttendLine.Next = 0;
                end;
            end;
        }
        field(35; Participation; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaptionML = LTH = 'Atvyko,Neatvyko';
            OptionMembers = Present,Absent;
        }
        field(40; Attendance; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Breakfast; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Line: Record "Posted Contract Lines";
                childHeader: Record "Posted Child Header";
                txt: Text;
                "count": Integer;
                currAm: Integer;
            begin
                TerminationCheck;
                if (Participation = Participation::Absent) and (Breakfast = true) then
                    Error('Child is absent');

                count := 0;
                currAm := 0;
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    repeat
                        Line.SetFilter("Child Contract No.", childHeader."No.");
                        if Line.FindSet then begin
                            repeat
                                if Line.Description = 'Breakfast' then
                                    currAm := Line."Rem. Amount";
                                if Breakfast = true then begin
                                    if Line.Description = 'Breakfast' then begin
                                        if (Line."Rem. Amount" <= 0) then begin
                                            Error('Ordered breakfast amount has been consumed');
                                        end else begin
                                            Line."Rem. Amount" := Line."Rem. Amount" - 1;
                                            Line.Modify;
                                        end;
                                        count := count + 1;
                                    end;
                                end else begin
                                    if Line.Description = 'Breakfast' then begin
                                        if (currAm > 0) and (Participation = Participation::Present) then begin
                                            Line."Rem. Amount" := Line."Rem. Amount" + 1;
                                            Line.Modify;
                                        end;
                                    end;
                                end;
                            until Line.Next = 0;
                        end;
                    until childHeader.Next = 0;
                    //MESSAGE('%1', txt);
                end;

                if (count = 0) and (Breakfast = true) then
                    Error('Breakfast is not included in contracts');
            end;
        }
        field(60; Brunch; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                "count": Integer;
                childHeader: Record "Posted Child Header";
                Line: Record "Posted Contract Lines";
                currAm: Integer;
            begin
                TerminationCheck;
                if (Participation = Participation::Absent) and (Brunch = true) then
                    Error('Child is absent');

                count := 0;
                currAm := 0;
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    repeat
                        Line.SetFilter("Child Contract No.", childHeader."No.");
                        if Line.FindSet then begin
                            repeat
                                if Line.Description = 'Brunch' then
                                    currAm := Line."Rem. Amount";
                                if Brunch = true then begin
                                    if Line.Description = 'Brunch' then begin
                                        if (Line."Rem. Amount" <= 0) then begin
                                            Error('Ordered brunch amount has been consumed');
                                        end else begin
                                            Line."Rem. Amount" := Line."Rem. Amount" - 1;
                                            Line.Modify;
                                        end;
                                        count := count + 1;
                                    end;
                                end else begin
                                    if Line.Description = 'Brunch' then begin
                                        if (currAm > 0) and (Participation = Participation::Present) then begin
                                            Line."Rem. Amount" := Line."Rem. Amount" + 1;
                                            Line.Modify;
                                        end;
                                    end;
                                end;
                            until Line.Next = 0;
                        end;
                    until childHeader.Next = 0;
                    //MESSAGE('%1', txt);
                end;

                if (count = 0) and (Brunch = true) then
                    Error('Brunch is not included in contracts');
            end;
        }
        field(70; Lunch; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                "count": Integer;
                childHeader: Record "Posted Child Header";
                Line: Record "Posted Contract Lines";
                currAm: Integer;
            begin
                TerminationCheck;
                if (Participation = Participation::Absent) and (Lunch = true) then
                    Error('Child is absent');

                count := 0;
                currAm := 0;
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    repeat
                        Line.SetFilter("Child Contract No.", childHeader."No.");
                        if Line.FindSet then begin
                            repeat
                                if Line.Description = 'Lunch' then
                                    currAm := Line."Rem. Amount";
                                if Lunch = true then begin
                                    if Line.Description = 'Lunch' then begin
                                        if (Line."Rem. Amount" <= 0) then begin
                                            Error('Ordered lunch amount has been consumed');
                                        end else begin
                                            Line."Rem. Amount" := Line."Rem. Amount" - 1;
                                            Line.Modify;
                                        end;
                                        count := count + 1;
                                    end;
                                end else begin
                                    if Line.Description = 'Lunch' then begin
                                        if (currAm > 0) and (Participation = Participation::Present) then begin
                                            Line."Rem. Amount" := Line."Rem. Amount" + 1;
                                            Line.Modify;
                                        end;
                                    end;
                                end;
                            until Line.Next = 0;
                        end;
                    until childHeader.Next = 0;
                    //MESSAGE('%1', txt);
                end;

                if (count = 0) and (Lunch = true) then
                    Error('Lunch is not included in contracts');
            end;
        }
        field(80; Dinner; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                "count": Integer;
                childHeader: Record "Posted Child Header";
                Line: Record "Posted Contract Lines";
                currAm: Integer;
            begin
                TerminationCheck;
                if (Participation = Participation::Absent) and (Dinner = true) then
                    Error('Child is absent');

                count := 0;
                currAm := 0;
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    repeat
                        Line.SetFilter("Child Contract No.", childHeader."No.");
                        if Line.FindSet then begin
                            repeat
                                if Line.Description = 'Dinner' then
                                    currAm := Line."Rem. Amount";
                                if Dinner = true then begin
                                    if Line.Description = 'Dinner' then begin
                                        if (Line."Rem. Amount" <= 0) then begin
                                            Error('Ordered dinner amount has been consumed');
                                        end else begin
                                            Line."Rem. Amount" := Line."Rem. Amount" - 1;
                                            Line.Modify;
                                        end;
                                        count := count + 1;
                                    end;
                                end else begin
                                    if Line.Description = 'Dinner' then begin
                                        if (currAm > 0) and (Participation = Participation::Present) then begin
                                            Line."Rem. Amount" := Line."Rem. Amount" + 1;
                                            Line.Modify;
                                        end;
                                    end;
                                end;
                            until Line.Next = 0;
                        end;
                    until childHeader.Next = 0;
                    //MESSAGE('%1', txt);
                end;

                if (count = 0) and (Dinner = true) then
                    Error('Dinner is not included in contracts');
            end;
        }
        field(90; Activity; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Posted Contract Lines"."Service No." WHERE("Child Contract No." = FIELD("Contract No."),
                                                                         "Service Type" = CONST(Activity));

            trigger OnValidate()
            var
                "count": Integer;
                childHeader: Record "Posted Child Header";
                Line: Record "Posted Contract Lines";
                Service: Record Services;
            begin
                TerminationCheck;
                if (Participation = Participation::Absent) then begin
                    Error('Child is absent');
                end;

                count := 0;
                Service.Get(Activity);
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    repeat
                        Line.SetFilter("Child Contract No.", childHeader."No.");
                        if Line.FindSet then begin
                            repeat
                                if Line."Service No." = Activity then begin
                                    if Line."Rem. Amount" <= 0 then begin
                                        Error('%1 activity amount has been consumed', Line.Description);
                                    end else begin
                                        Line."Rem. Amount" := Line."Rem. Amount" - 1;
                                        Line.Modify;
                                    end;
                                    count := count + 1;
                                end;
                            until Line.Next = 0;
                        end;
                    until childHeader.Next = 0;
                    //MESSAGE('%1', txt);
                end;

                if (count = 0) then
                    Error('%1 is not included in contracts', Service."Service Name");
            end;
        }
        field(91; Activity2; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Posted Contract Lines"."Service No." WHERE("Child Contract No." = FIELD("Contract No."),
                                                                         "Service Type" = CONST(Activity));

            trigger OnValidate()
            var
                "count": Integer;
                Line: Record "Posted Contract Lines";
                childHeader: Record "Posted Child Header";
                Service: Record Services;
            begin
                TerminationCheck;
                if (Participation = Participation::Absent) then begin
                    Error('Child is absent');
                end;

                count := 0;
                Service.Get(Activity2);
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    repeat
                        Line.SetFilter("Child Contract No.", childHeader."No.");
                        if Line.FindSet then begin
                            repeat
                                if Line."Service No." = Activity2 then begin
                                    if Line."Rem. Amount" <= 0 then begin
                                        Error('%1 activity amount has been consumed', Line.Description);
                                    end else begin
                                        Line."Rem. Amount" := Line."Rem. Amount" - 1;
                                        Line.Modify;
                                    end;
                                    count := count + 1;
                                end;
                            until Line.Next = 0;
                        end;
                    until childHeader.Next = 0;
                    //MESSAGE('%1', txt);
                end;

                if (count = 0) then
                    Error('%1 is not included in contracts', Service."Service Name");
            end;
        }
        field(95; Activity3; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Posted Contract Lines"."Service No." WHERE("Child Contract No." = FIELD("Contract No."),
                                                                         "Service Type" = CONST(Activity));

            trigger OnValidate()
            var
                "count": Integer;
                childHeader: Record "Posted Child Header";
                Line: Record "Posted Contract Lines";
                Service: Record Services;
            begin
                TerminationCheck;
                if (Participation = Participation::Absent) then begin
                    Error('Child is absent');
                end;

                count := 0;
                Service.Get(Activity3);
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if childHeader.FindSet then begin
                    repeat
                        Line.SetFilter("Child Contract No.", childHeader."No.");
                        if Line.FindSet then begin
                            repeat
                                if Line."Service No." = Activity3 then begin
                                    if Line."Rem. Amount" <= 0 then begin
                                        Error('%1 activity amount has been consumed', Line.Description);
                                    end else begin
                                        Line."Rem. Amount" := Line."Rem. Amount" - 1;
                                        Line.Modify;
                                    end;
                                    count := count + 1;
                                end;
                            until Line.Next = 0;
                        end;
                    until childHeader.Next = 0;
                    //MESSAGE('%1', txt);
                end;

                if (count = 0) then
                    Error('%1 is not included in contracts', Service."Service Name");
            end;
        }
        field(100; Comment; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Child No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Child: Record Childer;
    begin
        //InitNextEntryNo;
        //"Entry No." := NextEntryNo;
    end;

    var
        NextEntryNo: Integer;

    local procedure InitNextEntryNo()
    begin
        //Rec.LOCKTABLE;
        if Rec.FindLast then begin
            NextEntryNo := Rec."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
    end;

    local procedure TerminationCheck()
    var
        postedHeader: Record "Posted Child Header";
        text10000: Label 'Child''s contract has been terminated - attendance cannot be marked';
    begin
        postedHeader.SetRange("No.", Rec."Contract No.");
        if postedHeader.FindSet then begin
            if postedHeader.Status = postedHeader.Status::Terminated then
                Error(text10000);
        end;
    end;
}

