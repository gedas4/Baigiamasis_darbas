page 50190 "Contract Ledger Entry"
{
    Editable = false;
    PageType = List;
    SourceTable = "Contract Ledger Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document no."; "Document no.")
                {
                }
                field("Type of Contract"; "Type of Contract")
                {
                }
                field("Child No."; "Child No.")
                {
                }
                field("Service no."; "Service no.")
                {
                }
                field(Description; Description)
                {
                }
                field("Actual Date of Entry"; "Actual Date of Entry")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Service Price"; "Service Price")
                {
                }
                field("Total Service Amount"; "Total Service Amount")
                {
                }
            }
        }
    }

    actions
    {
    }
}

