page 50160 "Posted Child Contract Subform"
{
    AutoSplitKey = false;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Posted Contract Lines";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Child Contract No."; "Child Contract No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Service Type"; "Service Type")
                {
                }
                field("Service No."; "Service No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Service Price"; "Service Price")
                {
                }
            }
        }
    }

    actions
    {
    }
}

