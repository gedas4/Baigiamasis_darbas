page 50090 "Kindergarten groups"
{
    Editable = true;
    PageType = List;
    SourceTable = "Kindergarten Groups";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Group No."; "Group No.")
                {
                }
                field("Kindergarten No."; "Kindergarten No.")
                {
                }
                field("Group Name"; "Group Name")
                {
                }
                field("Teacher No."; "Teacher No.")
                {
                }
                field("Teacher First Name"; "Teacher First Name")
                {
                }
                field("Teacher Middle Name"; "Teacher Middle Name")
                {
                }
                field("Teacher Last Name"; "Teacher Last Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

