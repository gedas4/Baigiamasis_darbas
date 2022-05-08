page 50150 "Periodic Invoice Page"
{
    PageType = List;
    SourceTable = "Periodic Invoice";

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
                field("Contract No."; "Contract No.")
                {
                }
                field("Child No."; "Child No.")
                {
                }
                field("Parent Name"; "Parent Name")
                {
                }
                field(Date; Date)
                {
                }
                field("Current Month Price"; "Current Month Price")
                {
                }
                field("Current Month Discount"; "Current Month Discount")
                {
                }
                field("Services Price"; "Services Price")
                {
                }
                field("Services Discount"; "Services Discount")
                {
                }
                field("Total Price"; "Total Price")
                {
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
                action("New Periodic Invoice")
                {
                    Image = NewInvoice;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        //Rec.GET("No.");
                        //Rec.SETRECFILTER;
                        REPORT.Run(50030, true, true, Rec);
                    end;
                }
            }
        }
    }
}

