table 50140 "Periodic Invoice"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Posted Child Header"."No.";

            trigger OnValidate()
            var
                childHeader: Record "Posted Child Header";
            begin
                childHeader.Get("Contract No.");
                if childHeader."Type of Contract" = 1 then
                    Error('Periodic invoices can be generated only for Long-term contract');
                "Child No." := childHeader."Child No.";
                "Parent Name" := childHeader."Parent Name";
                //Date := TODAY;
                if Date <> 0D then
                    Rec.Validate(Date);
                //CalcInvoicePrices("Contract No.");
            end;
        }
        field(30; "Child No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Parent Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(40; Date; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CalcInvoicePrices("Contract No.");
            end;
        }
        field(50; "Current Month Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Current Month Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Services Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Services Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90; "Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        ContractSetup: Record "Contract Setup";
    begin
        if "No." = '' then begin
            ContractSetup.Get;
            ContractSetup.TestField("Periodic Nos.");
            NoSeriesMgt.InitSeries(ContractSetup."Periodic Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure CalcInvoicePrices("Contract No.": Code[20])
    var
        Line: Record "Posted Contract Lines";
        MonthPrice: Record "Month Price";
        TotalServicesPrice: Decimal;
        AttendanceLine: Record "Child Attendance";
        CurrMonth: Integer;
        AttendMonth: Integer;
        countService: Integer;
        OneServicePrice: Decimal;
        OneMealPrice: Decimal;
        countMeal: Integer;
        absence: Integer;
        MonthDisc: Decimal;
        ServiceDisc: Decimal;
    begin
        countService := 0;
        countMeal := 0;
        absence := 0;
        CurrMonth := Date2DMY(Date, 2);
        Line.SetFilter("Child Contract No.", "Contract No.");
        if Line.FindSet then begin
            repeat
                if Line."Service Type" = 1 then begin
                    "Current Month Price" := Line."Service Price" / Line.Amount;
                    MonthDisc := Line."Service Price" / Line.Amount;
                end;

                if Line."Service Type" = 3 then begin
                    OneServicePrice := Line."Service Price" / Line.Amount;
                    AttendanceLine.SetFilter(AttendanceLine."Child No.", "Child No.");
                    if AttendanceLine.FindSet then begin
                        repeat
                            AttendMonth := Date2DMY(AttendanceLine.Date, 2);
                            if (CurrMonth = AttendMonth) and (AttendanceLine.Participation = 0) and (AttendanceLine.Activity <> '') and (AttendanceLine.Activity = Line."Service No.") then begin
                                countService := countService + 1;
                            end;
                        until AttendanceLine.Next = 0;
                    end;
                end;

                if Line."Service Type" = 4 then begin
                    OneMealPrice := Line."Service Price" / Line.Amount;
                    AttendanceLine.SetFilter(AttendanceLine."Child No.", "Child No.");
                    if AttendanceLine.FindSet then begin
                        repeat
                            AttendMonth := Date2DMY(AttendanceLine.Date, 2);
                            if (CurrMonth = AttendMonth) and (AttendanceLine.Participation = 0) and (Line.Description = 'Breakfast') then begin
                                if AttendanceLine.Breakfast = true then
                                    countMeal := countMeal + 1;
                            end;
                            if (CurrMonth = AttendMonth) and (AttendanceLine.Participation = 0) and (Line.Description = 'Brunch') then begin
                                if AttendanceLine.Brunch = true then
                                    countMeal := countMeal + 1;
                            end;
                            if (CurrMonth = AttendMonth) and (AttendanceLine.Participation = 0) and (Line.Description = 'Lunch') then begin
                                if AttendanceLine.Lunch = true then
                                    countMeal := countMeal + 1;
                            end;
                            if (CurrMonth = AttendMonth) and (AttendanceLine.Participation = 0) and (Line.Description = 'Dinner') then begin
                                if AttendanceLine.Dinner = true then
                                    countMeal := countMeal + 1;
                            end;
                        until AttendanceLine.Next = 0;
                    end;
                end;

            until Line.Next = 0;
        end;
        TotalServicesPrice := (OneMealPrice * countMeal) + (OneServicePrice * countService);
        "Services Price" := TotalServicesPrice;

        AttendanceLine.SetFilter(AttendanceLine."Child No.", "Child No.");
        if AttendanceLine.FindSet then begin
            repeat
                AttendMonth := Date2DMY(AttendanceLine.Date, 2);
                if (CurrMonth = AttendMonth) and (AttendanceLine.Participation = 1) then
                    absence := absence + 1;
            until AttendanceLine.Next = 0;
        end;

        //MESSAGE('%1',absence);
        if (MonthDisc > 0) then begin
            MonthDisc := (MonthDisc / 30) * absence;
            if ((MonthDisc / "Current Month Price") * 100) <= 45 then
                "Current Month Discount" := MonthDisc;
        end;

        ServiceDisc := (OneMealPrice * (20 - countMeal)) + (OneServicePrice * (5 - countService));
        //IF ServiceDisc > 0 THEN
        //  "Services Discount" := ServiceDisc;
        if "Current Month Price" > 0 then begin
            if ServiceDisc > 0 then
                "Services Discount" := ServiceDisc;
            "Total Price" := ("Current Month Price" + "Services Price") - "Current Month Discount" - "Services Discount";
        end
        else begin
            "Total Price" := TotalServicesPrice;
        end;
    end;
}

