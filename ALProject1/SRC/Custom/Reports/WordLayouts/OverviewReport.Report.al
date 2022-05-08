report 50100 "Overview Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\OverviewReport.rdlc';

    dataset
    {
        dataitem(Kindergarten; Kindergarten)
        {
            column(KindergartenNo; Kindergarten."No.")
            {
            }
            column(KindAdress; Kindergarten.Address)
            {
            }
            column(KindCity; Kindergarten.City)
            {
            }
            column(KindName; Kindergarten.Name)
            {
            }
            column(Df; DateFrom)
            {
            }
            column(Dt; DateTo)
            {
            }
            column(showDet; showDetails)
            {
            }
            column(showDet2; showDetails2)
            {
            }
            dataitem("Kindergarten Groups"; "Kindergarten Groups")
            {
                DataItemLink = "Kindergarten No." = FIELD("No.");
                column(GroupNo; "Kindergarten Groups"."Group No.")
                {
                }
                dataitem(Childer; Childer)
                {
                    DataItemLink = "Group No." = FIELD("Group No.");
                    column(ChildName; Childer."Child Name")
                    {
                    }
                    dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Customer No." = FIELD("Child No.");
                        column(PostingDate; "Cust. Ledger Entry"."Posting Date")
                        {
                        }
                        column(DocumentNo; "Cust. Ledger Entry"."Document No.")
                        {
                        }
                        column(PaidAmount; "Cust. Ledger Entry"."Amount (LCY)")
                        {
                        }
                        column(PaidCustAmount; "Cust. Ledger Entry".Amount)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            //"Cust. Ledger Entry".SETRANGE("Document Type","Cust. Ledger Entry"."Document Type"::Payment);
                            //IF "Cust. Ledger Entry".FINDSET THEN;
                        end;

                        trigger OnPreDataItem()
                        begin
                            "Cust. Ledger Entry".SetFilter("Document No.", '%1', 'PAYM' + '*');
                            if "Cust. Ledger Entry".FindSet then;

                            if (DateFrom = 0D) and (DateTo = 0D) then
                                DateTo := WorkDate;

                            case true of
                                (DateFrom <> 0D) and (DateTo <> 0D):
                                    "Cust. Ledger Entry".SetRange("Posting Date", DateFrom, DateTo);
                                (DateFrom <> 0D):
                                    "Cust. Ledger Entry".SetFilter("Posting Date", '%1..', DateFrom);
                                else
                                    "Cust. Ledger Entry".SetRange("Posting Date", 0D, DateTo);
                            end;
                        end;
                    }
                }
            }

            trigger OnAfterGetRecord()
            begin
                if kindergartenNo <> '' then begin
                    Kindergarten.SetRange("No.", kindergartenNo);
                    if Kindergarten.FindSet then;
                end else begin
                    Kindergarten.FindFirst;
                    if Kindergarten.FindSet then;
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
                field(Kindergarten; kindergartenNo)
                {
                    TableRelation = Kindergarten."No.";
                }
                field("Date From"; DateFrom)
                {

                    trigger OnValidate()
                    begin
                        if (DateFrom <> 0D) and (DateTo <> 0D) then begin
                            if DateFrom > DateTo then
                                Error('Starting date cannot be greater than ending date');
                        end;
                    end;
                }
                field("Date To"; DateTo)
                {

                    trigger OnValidate()
                    begin
                        if (DateFrom <> 0D) and (DateTo <> 0D) then begin
                            if DateFrom > DateTo then
                                Error('Starting date cannot be greater than ending date');
                        end;
                    end;
                }
                field("Show Group Details"; showDetails2)
                {
                }
                field("Show Child Details"; showDetails)
                {

                    trigger OnValidate()
                    begin
                        if showDetails2 = false then
                            showDetails2 := true;
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportName = 'OVERVIEW REPORT';
        DateFrom = 'Date from';
        DateTo = 'Date to';
    }

    trigger OnPreReport()
    begin
        /*CASE TRUE OF
          (DateFrom <> 0D) AND (DateTo <> 0D):
            "Cust. Ledger Entry".SETRANGE("Posting Date",DateFrom,DateTo);
          (DateFrom <> 0D):
            "Cust. Ledger Entry".SETFILTER("Posting Date",'%1..',DateFrom);
          ELSE
            "Cust. Ledger Entry".SETRANGE("Posting Date",0D,DateTo);
        END;*/

    end;

    var
        DateFrom: Date;
        DateTo: Date;
        showDetails: Boolean;
        kindergartenNo: Code[20];
        showDetails2: Boolean;
}

