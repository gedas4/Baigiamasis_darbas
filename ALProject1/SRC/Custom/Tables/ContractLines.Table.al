table 50050 "Contract Lines"
{

    fields
    {
        field(10; "Child Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Child Header"."No.";
        }
        field(20; "Line No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(30; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaptionML = LTH = ' ,Mėnesis,Diena,Būrelis,Maitinimas';
            OptionMembers = " ",Month,Day,Activity,Meal;

            trigger OnValidate()
            var
                ChildHeader: Record "Child Header";
            begin
                ChildHeader.Get("Child Contract No.");
                if ChildHeader."Type of Contract" = ChildHeader."Type of Contract"::"Long-term" then begin
                    if "Service Type" = "Service Type"::Day then
                        Error('Long-term contract price is calculated by months');
                end;
                if ChildHeader."Type of Contract" = ChildHeader."Type of Contract"::"Short-term" then begin
                    if "Service Type" = "Service Type"::Month then
                        Error('Short-term contract price is calculated by days');
                end;
            end;
        }
        field(40; "Service No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Service Type" = CONST(Activity)) Services."Service No."
            ELSE
            IF ("Service Type" = CONST(Month)) "Month Price"."Month No."
            ELSE
            IF ("Service Type" = CONST(Day)) "Day Prices"."Day No."
            ELSE
            IF ("Service Type" = CONST(Meal)) "Meal Prices"."Meal No.";

            trigger OnValidate()
            var
                ChildHeader: Record "Child Header";
            begin
                CheckService;
                ChildHeader.Get("Child Contract No.");
                CalcServicePrice(ChildHeader);
            end;
        }
        field(50; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(60; Amount; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ChildHeader: Record "Child Header";
            begin
                if ("Service Type" = "Service Type"::Month) or ("Service Type" = "Service Type"::Day) then begin
                    if Amount > 0 then
                        Error('Entering a quantity for months or days is not allowed');
                end;
                ChildHeader.Get("Child Contract No.");
                CalcServicePrice(ChildHeader);
                "Rem. Amount" := Amount;
            end;
        }
        field(65; "Rem. Amount"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Service Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Child Contract No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        //InitNextEntryNo;
        //"Line No." := NextEntryNo;
    end;

    var
        NextEntryNo: Integer;
        Choice: Integer;

    [Scope('OnPrem')]
    procedure CalcServicePrice(ChildHeader: Record "Child Header")
    var
        Calendar: Record Date;
        Month: Integer;
        MonthPrice: Record "Month Price";
        DateDiff: Integer;
        DayPrice: Record "Day Prices";
        ServicePrice: Record Services;
        MealPrice: Record "Meal Prices";
    begin
        if "Service Type" = "Service Type"::Month then begin
            Calendar.Reset;
            Calendar.SetRange("Period Type", Calendar."Period Type"::Month);
            Calendar.SetRange("Period Start", ChildHeader."Date From", ChildHeader."Date To");
            Month := Calendar.Count;
            MonthPrice.Get("Service No.");
            Description := MonthPrice.Description;
            Amount := Month;
            "Unit Price" := MonthPrice."Month Price";
            "Service Price" := MonthPrice."Month Price" * Month;
        end;
        if "Service Type" = "Service Type"::Day then begin
            DateDiff := ChildHeader."Date To" - ChildHeader."Date From";
            DayPrice.Get("Service No.");
            Description := DayPrice.Description;
            Amount := DateDiff;
            "Unit Price" := DayPrice."Day Price";
            "Service Price" := DayPrice."Day Price" * DateDiff;
        end;
        if "Service Type" = "Service Type"::Activity then begin
            ServicePrice.Get("Service No.");
            Description := ServicePrice."Service Name";
            "Unit Price" := ServicePrice.Price;
            "Service Price" := ServicePrice.Price * Amount;
        end;
        if "Service Type" = "Service Type"::Meal then begin
            DateDiff := ChildHeader."Date To" - ChildHeader."Date From";
            Amount := DateDiff;
            "Rem. Amount" := DateDiff;
            MealPrice.Get("Service No.");
            Description := MealPrice.Meal;
            "Unit Price" := MealPrice.Price;
            "Service Price" := MealPrice.Price * Amount;
        end;

        //MESSAGE('%1',Month);
        //MODIFY;
    end;

    local procedure InitNextEntryNo()
    begin
        Rec.LockTable;
        if Rec.FindLast then begin
            NextEntryNo := Rec."Line No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
    end;

    local procedure CheckService()
    var
        No: Code[20];
        serNo: Code[20];
        Line: Record "Contract Lines";
    begin
        No := "Child Contract No.";
        serNo := "Service No.";
        Line.SetFilter("Child Contract No.", No);
        if Line.FindSet then begin
            repeat
                if Line."Service No." = serNo then
                    Error('Selected service is already included in contract');
            until Line.Next = 0;
        end;
    end;
}

