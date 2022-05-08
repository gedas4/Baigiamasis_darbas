page 50070 "Kindergarten facilities"
{
    PageType = List;
    SourceTable = Kindergarten;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field(Address; Address)
                {
                }
                field(City; City)
                {
                }
                field(Name; Name)
                {
                }
            }
        }
    }

    actions
    {
    }
}

