report 50060 "Report of Payment"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\ReportofPayment.rdlc';

    dataset
    {
        dataitem("Posted Child Header"; "Posted Child Header")
        {
            column(No; "Posted Child Header"."No.")
            {
            }
            column(ChildNo; "Posted Child Header"."Child No.")
            {
            }
            column(TypeOfContract; "Posted Child Header"."Type of Contract")
            {
            }
            column(DateFrom; "Posted Child Header"."Date From")
            {
            }
            column(DateTo; "Posted Child Header"."Date To")
            {
            }
            column(KindName; Kindergarten.Name)
            {
            }
            column(KindCity; Kindergarten.City)
            {
            }
            column(KindAddress; Kindergarten.Address)
            {
            }
            column(Kidno; ChildCode)
            {
            }
            column(DateOne; Date1)
            {
            }
            column(DateTwo; Date2)
            {
            }
            dataitem("Posted Contract Lines"; "Posted Contract Lines")
            {
                DataItemLink = "Child Contract No." = FIELD("No.");
                column(ServiceType; "Service Type")
                {
                }
                column(ServiceNo; "Service No.")
                {
                }
                column(ServiceAmount; Amount)
                {
                }
                column(UnitPrice; "Unit Price")
                {
                }
                column(ServicePrice; "Service Price")
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                PostedHeader: Record "Posted Child Header";
            begin
                Kid.SetFilter(Kid."Child No.", "Posted Child Header"."Child No.");
                if Kid.FindSet then begin
                    KindGroup.SetFilter("Group No.", Kid."Group No.");
                    if KindGroup.FindSet then begin
                        Kindergarten.SetFilter("No.", KindGroup."Kindergarten No.");
                        if Kindergarten.FindSet then;
                    end;
                end else begin
                    Kindergarten.FindFirst;
                    if Kindergarten.FindSet then;
                end;
                PostedHeader.SetFilter(PostedHeader."Child No.", "Posted Child Header"."Child No.");
                if PostedHeader.FindSet then begin
                    Date1 := PostedHeader."Date From";
                    repeat
                        Date2 := PostedHeader."Date To";
                    until PostedHeader.Next = 0;
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
                field("Child No."; ChildCode)
                {
                    TableRelation = Childer."Child No.";
                    Visible = false;
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
        ChildCode: Code[20];
        Date1: Date;
        Date2: Date;
        Kid: Record Childer;
        KindGroup: Record "Kindergarten Groups";
        Kindergarten: Record Kindergarten;
}

