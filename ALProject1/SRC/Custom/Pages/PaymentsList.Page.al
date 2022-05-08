page 50270 "Payments List"
{
    CardPageID = Payment;
    Editable = false;
    PageType = List;
    SourceTable = Payments;

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
                field("Account No."; "Account No.")
                {
                }
                field("Applies-to Doc. No"; "Applies-to Doc. No")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field(Amount; Amount)
                {
                }
            }
        }
    }

    actions
    {
    }
}

