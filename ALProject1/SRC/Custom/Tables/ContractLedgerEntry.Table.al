table 50180 "Contract Ledger Entry"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(20; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Document no."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Type of Contract"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Ilgalaikė,Trumpalaikė';
            OptionMembers = "Long-term","Short-term";
        }
        field(50; "Child No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Service no."; Code[20])
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
        field(110; "Total Service Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

