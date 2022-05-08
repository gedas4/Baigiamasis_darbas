table 50150 "Posted Child Header"
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
        }
        field(50; "Date To"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Issued By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Total Service Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(75; "Total Paid Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(80; "Total No. of Services"; Integer)
        {
            FieldClass = Normal;
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
    end;
}

