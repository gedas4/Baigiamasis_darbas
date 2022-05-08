table 50010 "Meal Prices"
{

    fields
    {
        field(10; "Meal No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Meal; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Meal No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

