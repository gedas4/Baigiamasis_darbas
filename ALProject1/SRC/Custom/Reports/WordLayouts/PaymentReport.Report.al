report 50040 "Payment Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\PaymentReport.rdlc';

    dataset
    {
        dataitem("Child Header"; "Child Header")
        {
            column(KindName; KindergartenName)
            {
            }
            column(KindCity; KindergartenCity)
            {
            }
            column(KindAddress; KindergartenAddress)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Child No."; "Child No.")
                {
                    TableRelation = Customer."No.";
                }
                field("Date From"; "Date From")
                {
                }
                field("Date To"; "Date To")
                {
                }
            }
        }

        actions
        {
        }

        trigger OnAfterGetRecord()
        begin
            Kid.SetFilter(Kid."Child No.", "Child No.");
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

    labels
    {
    }

    var
        "Child No.": Code[20];
        "Date To": Date;
        "Date From": Date;
        Kid: Record Childer;
        KindGroup: Record "Kindergarten Groups";
        Kindergarten: Record Kindergarten;
        KindergartenName: Text[50];
        KindergartenCity: Text[50];
        KindergartenAddress: Text[100];
}

