page 50300 "Customer Setup"
{
    PageType = List;
    UsageCategory = Lists;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            repeater(Control2)
            {
                field("No_"; "No.")
                {
                }
                field("Parent Name"; "Parent Name")
                {
                }

                field("Child Name"; "Child Name")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}