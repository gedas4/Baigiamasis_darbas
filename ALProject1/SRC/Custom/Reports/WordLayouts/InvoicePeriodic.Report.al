report 50020 "Invoice Periodic"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\InvoicePeriodic.rdlc';

    dataset
    {
        dataitem("Child Header"; "Child Header")
        {
            column(No; "Child Header"."No.")
            {
            }
            column(ChildNo; "Child Header"."Child No.")
            {
            }
            column(ParentName; "Child Header"."Parent Name")
            {
            }
            column(TypeOfContract; "Child Header"."Type of Contract")
            {
            }
            column(DateFrom; "Child Header"."Date From")
            {
            }
            column(DateTo; "Child Header"."Date To")
            {
            }
        }
        dataitem(Kindergarten; Kindergarten)
        {
        }
        dataitem("Kindergarten Groups"; "Kindergarten Groups")
        {
        }
        dataitem(Childer; Childer)
        {
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }
}

