page 50210 "Group Attendance"
{
    PageType = Document;
    SourceTable = "Kindergarten Groups";

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
            part(Control10; "Group Attendance Subform")
            {
                SubPageLink = "Group No." = FIELD("Group No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            //group(Action12)
            // {
            action("Create Group Attendance")
            {
                Image = Add;
                Promoted = true;

                trigger OnAction()
                begin
                    AttendanceCodeUnit.AddGroupDates(Rec);
                end;
            }
            //  }
        }
    }

    var
        AttendanceCodeUnit: Codeunit "Attendance date";
}

