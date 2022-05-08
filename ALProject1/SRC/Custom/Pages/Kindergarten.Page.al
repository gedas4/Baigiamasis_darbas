page 50080 Kindergarten
{
    PageType = Document;
    SourceTable = "Kindergarten Groups";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("Group No."; "Group No.")
                {
                    Editable = false;
                }
                field("Kindergarten No."; "Kindergarten No.")
                {
                    Editable = false;
                }
                field("Group Name"; "Group Name")
                {
                    Editable = false;
                }
                field("Teacher No."; "Teacher No.")
                {
                    Editable = false;
                }
                field("Teacher First Name"; "Teacher First Name")
                {
                    Editable = false;
                }
                field("Teacher Middle Name"; "Teacher Middle Name")
                {
                    Editable = false;
                }
                field("Teacher Last Name"; "Teacher Last Name")
                {
                    Editable = false;
                }
            }
            part("<Kindergarten Subform>"; "Kindergarten Sub")
            {
                SubPageLink = "Group No." = FIELD ("Group No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Add New Child ")
            {
                Image = AddContacts;
                Promoted = true;

                trigger OnAction()
                begin
                    PAGE.Run(50240, Rec);
                end;
            }
            action("Mark Group Attendance")
            {
                Image = Register;
                Promoted = true;

                trigger OnAction()
                begin
                    PAGE.Run(50210, Rec);
                end;
            }
        }
    }
}

