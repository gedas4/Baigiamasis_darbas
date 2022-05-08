table 50120 "Kindergarten Groups"
{

    fields
    {
        field(10; "Group No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Kindergarten No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Kindergarten."No.";

            trigger OnValidate()
            var
                "count": Integer;
            begin
                KindergartenNo := "Kindergarten No.";
                count := 0;
                Rec.SetFilter("Kindergarten No.", KindergartenNo);
                if Rec.FindSet then begin
                    repeat
                        count := count + 1;
                    until Rec.Next = 0;
                end;
                //MESSAGE('%1', count);
                if count >= 3 then
                    Error('Kindergarten can have a maximum of three groups');
            end;
        }
        field(30; "Group Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Teacher No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin
                FillTeacherInfo("Teacher No.");
            end;
        }
        field(50; "Teacher First Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Teacher Middle Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(70; "Teacher Last Name"; Text[30])
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
        key(Key1; "Group No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        "count": Integer;
        ContractSetup: Record "Contract Setup";
    begin
        if "Group No." = '' then begin
            ContractSetup.Get;
            ContractSetup.TestField("Group Nos");
            NoSeriesMgt.InitSeries(ContractSetup."Group Nos", xRec."No. Series", 0D, "Group No.", "No. Series");
        end;
    end;

    var
        KindergartenNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure FillTeacherInfo("Teacher No.": Code[20])
    var
        Teacher: Record Employee;
    begin
        Teacher.Get("Teacher No.");
        "Teacher First Name" := Teacher."First Name";
        "Teacher Middle Name" := Teacher."Middle Name";
        "Teacher Last Name" := Teacher."Last Name";
    end;
}

