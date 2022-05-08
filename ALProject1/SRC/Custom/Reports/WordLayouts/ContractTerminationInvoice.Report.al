report 50110 "Contract Termination Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\ContractTerminationInvoice.rdlc';

    dataset
    {
        dataitem("Posted Child Header"; "Posted Child Header")
        {
            column(ContractNo; "Posted Child Header"."No.")
            {
            }
            column(ChildNo; "Posted Child Header"."Child No.")
            {
            }
            column(ParentName; "Posted Child Header"."Parent Name")
            {
            }
            column(TypeOfContract; "Posted Child Header"."Type of Contract")
            {
            }
            column(messageTxt; textmsg)
            {
            }
            column(CurrMonthAmount; amount)
            {
            }
            column(diff; difference)
            {
            }
            column(over; Overall)
            {
            }
            column(overMsg; overallmsg)
            {
            }
            dataitem(Kindergarten; Kindergarten)
            {
                column(KindAdress; Kindergarten.Address)
                {
                }
                column(KindCity; Kindergarten.City)
                {
                }
                column(KindName; Kindergarten.Name)
                {
                }
            }

            trigger OnAfterGetRecord()
            var
                d1: Date;
                currMonth: Integer;
                monthDays: Integer;
                prevMonth: Integer;
                contractMonth: Integer;
                postedLines: Record "Posted Contract Lines";
                countMeal: Integer;
                countService: Integer;
                absence: Integer;
                attendanceLine: Record "Child Attendance";
                dayPrice: Decimal;
                attendMonth: Integer;
                monthDisc: Decimal;
                monthDiscPerc: Decimal;
                text10002: Label 'Child is not added into a kindergarten - contract termination invoice cannot be generated';
                childrenKind: Record Childer;
                custLedgerEntry: Record "Cust. Ledger Entry";
                salesHeader: Record "Sales Invoice Header";
                paidAmount: Decimal;
                invoiceAmount: Decimal;
                test: Decimal;
                text10000: Label 'Amount to return from previous periods';
                text10001: Label 'Amount to pay for previous periods';
                text10003: Label 'We must pay you back:';
                text10004: Label 'Total:';
            begin

                termDate := Today;
                d1 := Today;
                d1 := CalcDate('<-CM>', d1);
                d1 := d1 - 1;
                currMonth := Date2DMY(Today, 2);
                monthDays := Date2DMY(d1, 1);
                prevMonth := Date2DMY(d1, 2);
                contractMonth := Date2DMY("Date From", 2);
                amount := 0;
                /*IF Rec."Type of Contract" = Rec."Type of Contract"::"Short-term" THEN
                  ERROR(text10001);*/

                childrenKind.SetRange(childrenKind."Child No.", "Child No.");
                if childrenKind.FindSet then begin
                    postedLines.SetRange("Child Contract No.", "No.");
                    if postedLines.FindSet then begin
                        repeat
                            countMeal := 0;
                            countService := 0;
                            absence := 0;
                            if postedLines."Service Type" = postedLines."Service Type"::Month then begin
                                if contractMonth <> currMonth then begin
                                    dayPrice := (postedLines."Service Price" / postedLines.Amount) / monthDays;
                                    attendanceLine.SetRange(attendanceLine."Child No.", "Child No.");
                                    if attendanceLine.FindSet then begin
                                        repeat
                                            attendMonth := Date2DMY(attendanceLine.Date, 2);
                                            if (prevMonth = attendMonth) and (attendanceLine.Participation = attendanceLine.Participation::Absent) then
                                                absence := absence + 1;
                                        until attendanceLine.Next = 0;
                                    end;
                                    monthDisc := (postedLines."Service Price" / postedLines.Amount) - (absence * dayPrice);
                                    monthDiscPerc := 100 - ((monthDisc / (postedLines."Service Price" / postedLines.Amount)) * 100);
                                    if monthDiscPerc <= 45 then begin
                                        amount := amount + monthDisc;
                                    end else begin
                                        amount := amount + (postedLines."Service Price" / postedLines.Amount);
                                    end;
                                end else begin
                                    amount := amount + (postedLines."Service Price" / postedLines.Amount);
                                end;
                            end;

                            if postedLines."Service Type" = postedLines."Service Type"::Activity then begin
                                attendanceLine.SetRange(attendanceLine."Child No.", "Child No.");
                                if attendanceLine.FindSet then begin
                                    repeat
                                        attendMonth := Date2DMY(attendanceLine.Date, 2);
                                        if (currMonth = attendMonth) and (attendanceLine.Participation = attendanceLine.Participation::Present) then begin
                                            if (attendanceLine.Activity <> '') and (attendanceLine.Activity = postedLines."Service No.") then
                                                countService := countService + 1;

                                            if (attendanceLine.Activity2 <> '') and (attendanceLine.Activity2 = postedLines."Service No.") then
                                                countService := countService + 1;

                                            if (attendanceLine.Activity3 <> '') and (attendanceLine.Activity3 = postedLines."Service No.") then
                                                countService := countService + 1;
                                        end;
                                    until attendanceLine.Next = 0;
                                end;
                                amount := amount + ((postedLines."Service Price" / postedLines.Amount) * countService);
                            end;

                            if postedLines."Service Type" = postedLines."Service Type"::Meal then begin
                                attendanceLine.SetRange(attendanceLine."Child No.", "Child No.");
                                if attendanceLine.FindSet then begin
                                    repeat
                                        attendMonth := Date2DMY(attendanceLine.Date, 2);
                                        if (currMonth = attendMonth) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Breakfast') then begin
                                            if attendanceLine.Breakfast = true then
                                                countMeal := countMeal + 1;
                                        end;

                                        if (currMonth = attendMonth) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Brunch') then begin
                                            if attendanceLine.Brunch = true then
                                                countMeal := countMeal + 1;
                                        end;

                                        if (currMonth = attendMonth) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Lunch') then begin
                                            if attendanceLine.Lunch = true then
                                                countMeal := countMeal + 1;
                                        end;
                                        if (currMonth = attendMonth) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Dinner') then begin
                                            if attendanceLine.Dinner = true then
                                                countMeal := countMeal + 1;
                                        end;
                                    until attendanceLine.Next = 0;
                                end;
                                amount := amount + ((postedLines."Service Price" / postedLines.Amount) * countMeal);
                            end;
                        until postedLines.Next = 0;
                    end;
                end else begin
                    Error(text10002);
                end;

                salesHeader.SetRange("Sell-to Customer No.", "Posted Child Header"."Child No.");
                salesHeader.SetFilter("No.", '>=103033');
                if salesHeader.FindSet then begin
                    repeat
                        salesHeader.CalcFields(Amount);
                        invoiceAmount := invoiceAmount + salesHeader.Amount;
                    until salesHeader.Next = 0;
                    //MESSAGE('%1', invoiceAmount);
                end;

                custLedgerEntry.SetRange("Customer No.", "Posted Child Header"."Child No.");
                custLedgerEntry.SetFilter("Document No.", '%1', 'PAYM' + '*');
                if custLedgerEntry.FindSet then begin
                    repeat
                        custLedgerEntry.CalcFields(Amount);
                        paidAmount := paidAmount + (custLedgerEntry.Amount * -1);
                    until custLedgerEntry.Next = 0;
                    //MESSAGE('%1', paidAmount);
                end;

                difference := invoiceAmount - paidAmount;
                if difference < 0 then begin
                    difference := difference * -1;
                    textmsg := text10000;
                    Overall := amount - difference;
                    if Overall < 0 then begin
                        Overall := Overall * -1;
                        overallmsg := text10003;
                    end else begin
                        overallmsg := text10004;
                    end;
                end else begin
                    textmsg := text10001;
                    Overall := amount + difference;
                    overallmsg := text10004;
                end;

                Kid.SetFilter(Kid."Child No.", "Posted Child Header"."Child No.");
                if Kid.FindSet then begin
                    KindGroup.SetRange(KindGroup."Group No.", Kid."Group No.");
                    if KindGroup.FindSet then begin
                        Kindergarten.SetFilter("No.", KindGroup."Kindergarten No.");
                        if Kindergarten.FindSet then;
                    end;
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
        }

        actions
        {
        }
    }

    labels
    {
        ReportName = 'CONTRACT TERMINATION INVOICE';
        ClientName = 'Client';
        ChildNr = 'Child Nr.';
    }

    var
        textmsg: Text;
        amount: Decimal;
        difference: Decimal;
        Kid: Record Childer;
        KindGroup: Record "Kindergarten Groups";
        termDate: Date;
        Overall: Decimal;
        overallmsg: Text;
}

