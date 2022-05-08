table 50110 Kindergarten
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Address; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; City; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Name; Text[50])
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
            ContractSetup.TestField("Kindergarten Nos.");
            NoSeriesMgt.InitSeries(ContractSetup."Kindergarten Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

