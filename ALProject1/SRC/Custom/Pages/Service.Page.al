page 50000 Service
{
    PageType = List;
    SourceTable = Services;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Service No."; "Service No.")
                {
                }
                field("Service Name"; "Service Name")
                {
                }
                field(Price; Price)
                {
                }
                field("Teacher No."; "Teacher No.")
                {
                }
                field("Teacher Name"; "Teacher Name")
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

