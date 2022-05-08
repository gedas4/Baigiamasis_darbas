page 50040 "Child Contract Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Contract Lines";

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

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Service Price"; "Service Price")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

