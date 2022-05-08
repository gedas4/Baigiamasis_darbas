tableextension 50000 tableextension50000 extends Customer
{
    fields
    {
        field(9007; "Parent Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9008; "Child Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
}

