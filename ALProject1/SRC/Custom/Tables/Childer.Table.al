table 50130 Childer
{

    fields
    {
        field(5; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(10; "Child No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                childHeader: Record "Posted Child Header";
                KidNo: Code[20];
            begin
                childHeader.SetFilter(childHeader."Child No.", "Child No.");
                if not childHeader.FindSet then begin
                    Error('Child cannot attend kindergarten - he/she does not have a contract');
                end else begin
                    "Contract No." := childHeader."No.";
                end;



                //KidNo := "Child No.";
                //Rec.SetFilter("Child No.", KidNo);
                //if Rec.FindSet then
                //    Error('Selected child is already added into kindergarten');
                FillChildInfo("Child No.");
            end;
        }
        field(20; "Group No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Kindergarten Groups"."Group No.";

            trigger OnValidate()
            var
                GroupNo: Code[20];
                "count": Integer;
            begin
                GroupNo := "Group No.";
                count := 0;
                Rec.SetFilter("Group No.", GroupNo);
                if Rec.FindSet then begin
                    repeat
                        count := count + 1;
                    until Rec.Next = 0;
                end;
                //MESSAGE('%1', count);
                if count >= 6 then
                    Error('Kindergarten group can have a maximum of six childer');
            end;
        }
        field(30; "Child Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Parent Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(45; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50; Address; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Post Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(80; City; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Child No.", "Group No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        KidNo: Code[20];
    begin
        KidNo := "Child No.";
        Rec.SetFilter("Child No.", KidNo);
        if Rec.FindSet then
            Error('Selected child is already added into kindergarten');

        Rec.Reset();
    end;

    trigger OnDelete()
    begin
        Rec.Reset();
    end;

    local procedure FillChildInfo("Child No.": Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.Get("Child No.");
        "Child Name" := Customer."Child Name";
        "Parent Name" := Customer."Parent Name";
        Address := Customer.Address;
        "Address 2" := Customer."Address 2";
        "Post Code" := Customer."Post Code";
        City := Customer.City;
    end;
}

