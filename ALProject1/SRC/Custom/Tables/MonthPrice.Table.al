table 50020 "Month Price"
{

    fields
    {
        field(10; "Month No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Month Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Month No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

