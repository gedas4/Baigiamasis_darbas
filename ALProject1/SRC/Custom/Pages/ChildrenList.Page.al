page 50120 "Children List"
{
    AutoSplitKey = false;
    PageType = List;
    SourceTable = Childer;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                }
                field("Child No."; "Child No.")
                {
                }
                field("Group No."; "Group No.")
                {
                }
                field("Child Name"; "Child Name")
                {
                }
                field("Parent Name"; "Parent Name")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
            }
        }
    }

    actions
    {
    }
}

