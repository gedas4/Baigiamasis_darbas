table 50030 "Day Prices"
{

    fields
    {
        field(10; "Day No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Day Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Day No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

