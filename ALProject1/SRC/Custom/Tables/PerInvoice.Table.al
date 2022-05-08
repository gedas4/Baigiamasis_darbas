table 50190 "Per. Invoice"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Kindergarten No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Kindergarten."No.";
        }
        field(30; "Group No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Kindergarten Groups"."Group No." WHERE ("Kindergarten No." = FIELD ("Kindergarten No."));
        }
        field(40; "Child No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Childer."Child No." WHERE ("Group No." = FIELD ("Group No."));
        }
        field(50; "Period Date"; Date)
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
}

