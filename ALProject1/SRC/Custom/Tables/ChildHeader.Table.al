table 50040 "Child Header"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Child No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                FillChildInfo("Child No.");
            end;
        }
        field(30; "Parent Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Type of Contract"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaptionML = LTH = 'Ilgalaikė,Trumpalaikė';
            OptionMembers = "Long-term","Short-term";
        }
        field(40; "Date From"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DateDiff: Integer;
            begin
                if ("Date From" <> 0D) and ("Date To" <> 0D) then begin
                    if "Date From" > "Date To" then
                        Error('Starting contract date connot be greater than contract ending date');
                    /*IF "Type of Contract" = 0 THEN BEGIN
                      IF "Date To" - "Date From" < 365 THEN
                        ERROR('Long-term contract must exceed one year');
                    END;*/
                    DateDiff := "Date To" - "Date From";
                    if DateDiff < 365 then begin
                        "Type of Contract" := "Type of Contract"::"Short-term";
                    end else begin
                        "Type of Contract" := "Type of Contract"::"Long-term";
                    end;
                end;
                /*IF "Type of Contract" = 0 THEN BEGIN
                  IF "Date To" - "Date From" < 365 THEN
                    ERROR('Long-term contract must exceed one year');
                END;*/
                RecalculateLines;

            end;
        }
        field(50; "Date To"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                DateDiff: Integer;
            begin
                if ("Date From" <> 0D) and ("Date To" <> 0D) then begin
                    if "Date From" > "Date To" then
                        Error('Starting contract date connot be greater than contract ending date');

                    DateDiff := "Date To" - "Date From";
                    if DateDiff < 365 then begin
                        "Type of Contract" := "Type of Contract"::"Short-term";
                    end else begin
                        "Type of Contract" := "Type of Contract"::"Long-term";
                    end;
                end;
                /*IF "Type of Contract" = 0 THEN BEGIN
                  IF "Date To" - "Date From" < 365 THEN
                    ERROR('Long-term contract must exceed one year');
                END;*/
                RecalculateLines;

            end;
        }
        field(60; "Issued By"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";
        }
        field(70; "Total Service Amount"; Decimal)
        {
            CalcFormula = Sum("Contract Lines"."Service Price" WHERE("Child Contract No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(80; "Total No. of Services"; Integer)
        {
            CalcFormula = Count("Contract Lines" WHERE("Child Contract No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(85; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Valid,Terminated;
        }
        field(90; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(110; Address; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(120; "Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(130; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(140; City; Text[30])
        {
            DataClassification = ToBeClassified;
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
            ContractSetup.TestField("Contract Nos.");
            NoSeriesMgt.InitSeries(ContractSetup."Contract Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        "Issued By" := UserId;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure FillChildInfo("Child No.": Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.Get("Child No.");
        "Parent Name" := Customer."Parent Name";
        Address := Customer.Address;
        "Address 2" := Customer."Address 2";
        "Post Code" := Customer."Post Code";
        City := Customer.City;
        "Document Date" := Today;
        "Posting Date" := Today;
    end;

    local procedure RecalculateLines()
    var
        Lines: Record "Contract Lines";
    begin
        Lines.SetFilter("Child Contract No.", "No.");
        if ("Date From" <> 0D) and ("Date To" <> 0D) then begin
            if Lines.FindSet then begin
                repeat
                    Lines.CalcServicePrice(Rec);
                    Lines.Modify;
                until Lines.Next = 0;
            end;
        end
        else begin
            if Lines.FindSet then begin
                repeat
                    Clear(Lines."Service Price");
                    Lines.Modify;
                until Lines.Next = 0;
            end;
        end;
    end;
}

