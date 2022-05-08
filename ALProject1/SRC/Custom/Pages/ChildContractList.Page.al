page 50060 "Child Contract List"
{
    CardPageID = "Child Contract";
    Editable = false;
    PageType = List;
    SourceTable = "Child Header";
    UsageCategory = Documents;

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
                field("Child No."; "Child No.")
                {
                }
                field("Parent Name"; "Parent Name")
                {
                }
                field("Type of Contract"; "Type of Contract")
                {
                }
                field("Date From"; "Date From")
                {
                }
                field("Date To"; "Date To")
                {
                }
                field("Issued By"; "Issued By")
                {
                }
                field("Total Service Amount"; "Total Service Amount")
                {
                }
                field("Total No. of Services"; "Total No. of Services")
                {
                }
                field(Status; Status)
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
            }
        }
    }

    /*actions
    {
        area(processing)
        {
            group(Action16)
            {
                action("Add Periodic Invoice")
                {
                    Image = Invoice;
                    Promoted = true;
                    RunObject = Page "Periodic Invoice Page";
                }
                action("Payment Report")
                {
                    Image = "Report";
                    Promoted = false;
                    RunObject = Report "Report of Payment";
                }
            }
        }
    }*/
}

