table 50170 "Contract Journal Line"
{

    fields
    {
        field(10; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Child No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Type of Contract"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Ilgalaikė,Trumpalaikė';
            OptionMembers = "Long-term","Short-term";
        }
        field(60; "Service No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Actual Date of Entry"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90; Amount; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(100; "Service Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(110; "Total Service Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No.")
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
        if "Document No." = '' then begin
            ContractSetup.Get;
            ContractSetup.TestField("Contract Journal Nos.");
            NoSeriesMgt.InitSeries(ContractSetup."Contract Journal Nos.", xRec."No. Series", 0D, "Document No.", "No. Series");
        end;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

