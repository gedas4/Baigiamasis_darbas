report 50030 "New Periodic Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\NewPeriodicInvoice.rdlc';

    dataset
    {
        dataitem("Periodic Invoice"; "Periodic Invoice")
        {
            column(No; "Periodic Invoice"."No.")
            {
            }
            column(ContractNo; "Periodic Invoice"."Contract No.")
            {
            }
            column(ChildNo; "Periodic Invoice"."Child No.")
            {
            }
            column(Date; "Periodic Invoice".Date)
            {
            }
            column(CurrentMonthPrice; "Periodic Invoice"."Current Month Price")
            {
            }
            column(CurrentMonthDiscount; "Periodic Invoice"."Current Month Discount")
            {
            }
            column(ServicesPrice; "Periodic Invoice"."Services Price")
            {
            }
            column(ServicesDiscount; "Periodic Invoice"."Services Discount")
            {
            }
            column(TotalPrice; "Periodic Invoice"."Total Price")
            {
            }
            column(InvoiceNo; "Periodic Invoice No.")
            {
            }
            column(KindCity; KindergartenCity)
            {
            }
            column(KindName; KindergartenName)
            {
            }
            column(KindAddress; KindergartenAddress)
            {
            }
            column(ParentName; "Periodic Invoice"."Parent Name")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Kid.SetFilter(Kid."Child No.", "Periodic Invoice"."Child No.");
                if Kid.FindSet then begin
                    KindGroup.SetFilter("Group No.", Kid."Group No.");
                    if KindGroup.FindSet then begin
                        Kindergarten.SetFilter("No.", KindGroup."Kindergarten No.");
                        if Kindergarten.FindSet then begin
                            KindergartenName := Kindergarten.Name;
                            KindergartenAddress := Kindergarten.Address;
                            KindergartenCity := Kindergarten.City;
                        end;
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Periodic Invoice No."; "Periodic Invoice No.")
                {
                    TableRelation = "Periodic Invoice"."No.";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        "Periodic Invoice No.": Code[20];
        Kid: Record Childer;
        KindGroup: Record "Kindergarten Groups";
        Kindergarten: Record Kindergarten;
        KindergartenName: Text[50];
        KindergartenCity: Text[50];
        KindergartenAddress: Text[100];
}

