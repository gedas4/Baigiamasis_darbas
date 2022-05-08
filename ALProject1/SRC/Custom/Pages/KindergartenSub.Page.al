page 50110 "Kindergarten Sub"
{
    AutoSplitKey = false;
    CardPageID = Attendance;
    Editable = false;
    PageType = ListPart;
    SourceTable = Childer;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field("Child No."; "Child No.")
                {
                    Visible = false;
                }
                field("Group No."; "Group No.")
                {
                    Visible = false;
                }
                field("Child Name"; "Child Name")
                {
                    Editable = false;
                }
                field("Parent Name"; "Parent Name")
                {
                    Editable = false;
                }
                field(Address; Address)
                {
                    Editable = false;
                }
                field("Address 2"; "Address 2")
                {
                    Editable = false;
                }
                field("Post Code"; "Post Code")
                {
                    Editable = false;
                }
                field(City; City)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action13)
            {
                action("New Child")
                {
                    Image = AddContacts;
                    Promoted = true;
                    RunObject = Page "Children List";
                }
            }
        }
    }
}

