table 50000 Services
{

    fields
    {
        field(10; "Service No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Service Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Price; Decimal)
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
        field(50; "Teacher Name"; Text[30])
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
    }

    keys
    {
        key(Key1; "Service No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure FillTeacherInfo("Teacher No.": Code[20])
    var
        Teacher: Record Employee;
    begin
        Teacher.Get("Teacher No.");
        "Teacher Name" := Teacher."First Name";
        "Teacher Middle Name" := Teacher."Middle Name";
        "Teacher Last Name" := Teacher."Last Name";
    end;
}

