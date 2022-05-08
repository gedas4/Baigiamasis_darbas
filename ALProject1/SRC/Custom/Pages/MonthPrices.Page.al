page 50030 "Month Prices"
{
    PageType = List;
    SourceTable = "Month Price";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Month No."; "Month No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Month Price"; "Month Price")
                {
                }
            }
        }
    }

    actions
    {
    }
}

