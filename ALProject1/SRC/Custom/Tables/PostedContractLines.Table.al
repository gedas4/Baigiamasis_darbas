table 50160 "Posted Contract Lines"
{

    fields
    {
        field(10; "Child Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Line No."; Integer)
        {
            AutoIncrement = false;
            DataClassification = ToBeClassified;
        }
        field(30; "Service Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaptionML = LTH = ' ,Mėnesis,Diena,Būrelis,Maitinimas';
            OptionMembers = " ",Month,Day,Activity,Meal;

            trigger OnValidate()
            var
                ChildHeader: Record "Child Header";
            begin
            end;
        }
        field(40; "Service No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ChildHeader: Record "Child Header";
            begin
            end;
        }
        field(50; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(60; Amount; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ChildHeader: Record "Child Header";
            begin
            end;
        }
        field(65; "Rem. Amount"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(67; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Service Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Child Contract No.", "Line No.", "Service No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

