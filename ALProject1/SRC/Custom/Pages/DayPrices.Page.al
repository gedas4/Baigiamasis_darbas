page 50020 "Day Prices"
{
    PageType = List;
    SourceTable = "Day Prices";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Day No."; "Day No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Day Price"; "Day Price")
                {
                }
            }
        }
    }

    actions
    {
    }
}

