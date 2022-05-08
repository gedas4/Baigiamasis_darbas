page 50010 "Meal Prices"
{
    PageType = List;
    SourceTable = "Meal Prices";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Meal No."; "Meal No.")
                {
                }
                field(Meal; Meal)
                {
                }
                field(Price; Price)
                {
                }
            }
        }
    }

    actions
    {
    }
}

