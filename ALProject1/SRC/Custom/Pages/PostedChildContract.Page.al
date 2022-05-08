page 50170 "Posted Child Contract"
{
    Editable = true;
    PageType = Document;
    SourceTable = "Posted Child Header";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                Editable = false;
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

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Date To"; "Date To")
                {

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Issued By"; "Issued By")
                {
                }
                field("Total Service Amount"; "Total Service Amount")
                {
                }
                field("Total Paid Amount"; "Total Paid Amount")
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
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
            }
            part(Control19; "Posted Child Contract Subform")
            {
                SubPageLink = "Child Contract No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Posted Contract Actions")
            {
                action("Payment Report")
                {
                    Image = "Report";
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Rec.Get("No.");
                        Rec.SetRecFilter;
                        REPORT.Run(50060, true, true, Rec);
                    end;
                }
                action("Add Payment")
                {
                    Image = ContractPayment;
                    Promoted = true;

                    trigger OnAction()
                    var
                        payment: Record Payments;
                        postCodeUnit: Codeunit "Child Contract - Post";
                        ConfirmDialog: Page "Amount Input Dialog";
                        test: Decimal;
                        CustLedger: Record "Cust. Ledger Entry";
                    begin
                        ConfirmDialog.LookupMode(true);
                        if ConfirmDialog.RunModal = ACTION::Yes then begin
                            payment.Init;
                            payment."Account No." := Rec."Child No.";
                            payment."Applies-to Doc. No" := Rec."No.";
                            payment.Amount := ConfirmDialog.ReturnEnteredNumber;
                            if payment.Amount > 0 then
                                payment.Amount := payment.Amount * -1;

                            payment.Insert(true);
                            payment.SetRange("Applies-to Doc. No", "No.");
                            postCodeUnit.PostPayment(payment);

                        end;

                        CustLedger.SetFilter("Document No.", "No.");
                        if CustLedger.FindSet then begin
                            CustLedger.CalcFields("Remaining Amount");
                            //MESSAGE('%1', CustLedger."Remaining Amount");
                            "Total Paid Amount" := "Total Service Amount" - CustLedger."Remaining Amount";
                        end;
                    end;
                }
                action("Create Periodic Invoice")
                {
                    Image = NewInvoice;
                    Promoted = true;

                    trigger OnAction()
                    var
                        salesHeader: Record "Sales Header";
                        salesLines: Record "Sales Line";
                        attendanceLine: Record "Child Attendance";
                        currMonth: Integer;
                        prevMonth: Integer;
                        monthDays: Integer;
                        currYear: Integer;
                        prevYear: Integer;
                        monthDisc: Decimal;
                        monthDiscPerc: Decimal;
                        childrenKind: Record Childer;
                        absence: Integer;
                        countService: Integer;
                        countMeal: Integer;
                        text10000: Label 'Periodic invoice has been successfully posted';
                        d1: Date;
                        text10001: Label 'Periodic invoice can be generated only for Long-term contracts';
                        text10002: Label 'Periodic invoice invoice can only be generated for a child attending kindergarten - child is not enrolled in kindergarten';
                        docNo: Code[20];
                        postedLines: Record "Posted Contract Lines";
                        LinesNo: Integer;
                        contractMonth: Integer;
                        dayPrice: Decimal;
                        attendMonth: Integer;
                        attendYear: Integer;
                        postSalesCodeUnit: Codeunit "Sales-Post";
                    begin
                        d1 := Today;
                        d1 := CalcDate('<-CM>', d1);
                        d1 := d1 - 1;
                        currMonth := Date2DMY(Today, 2);
                        currYear := Date2DMY(Today, 3);
                        monthDays := Date2DMY(d1, 1);
                        prevMonth := Date2DMY(d1, 2);
                        prevYear := Date2DMY(d1, 3);
                        contractMonth := Date2DMY(Rec."Date From", 2);

                        if Rec."Type of Contract" = Rec."Type of Contract"::"Short-term" then
                            Error(text10001);

                        childrenKind.SetRange(childrenKind."Child No.", "Child No.");
                        if childrenKind.FindSet then begin
                            Clear(salesHeader);
                            salesHeader.Init;
                            salesHeader.Validate("Document Type", salesHeader."Document Type"::Invoice);
                            salesHeader.Validate("Sell-to Customer No.", "Child No.");
                            salesHeader.Insert(true);
                            docNo := salesHeader."No.";
                            postedLines.SetRange("Child Contract No.", "No.");
                            if postedLines.FindSet then begin
                                repeat
                                    countMeal := 0;
                                    countService := 0;
                                    absence := 0;
                                    salesLines.SetRange("Document Type", salesLines."Document Type"::Invoice);
                                    salesLines.SetRange("Document No.", docNo);
                                    if salesLines.FindLast then begin
                                        LinesNo := salesLines."Line No." + 10000;
                                    end else begin
                                        LinesNo := 10000;
                                    end;
                                    salesLines.Init;
                                    salesLines."Document Type" := salesLines."Document Type"::Invoice;
                                    salesLines."Document No." := docNo;
                                    salesLines."Line No." := LinesNo;
                                    salesLines.Type := salesLines.Type::Item;
                                    if postedLines."Service Type" = postedLines."Service Type"::Month then begin
                                        salesLines.Validate("No.", postedLines."Service No.");
                                        salesLines.Validate(Quantity, 1);
                                        if contractMonth <> currMonth then begin
                                            dayPrice := (postedLines."Service Price" / postedLines.Amount) / monthDays;
                                            attendanceLine.SetRange(attendanceLine."Child No.", "Child No.");
                                            if attendanceLine.FindSet then begin
                                                repeat
                                                    attendMonth := Date2DMY(attendanceLine.Date, 2);
                                                    attendYear := Date2DMY(attendanceLine.Date, 3);
                                                    if (prevMonth = attendMonth) and (currYear = attendYear) and (attendanceLine.Participation = attendanceLine.Participation::Absent) then
                                                        absence := absence + 1;
                                                until attendanceLine.Next = 0;
                                            end;
                                            monthDisc := (postedLines."Service Price" / postedLines.Amount) - (absence * dayPrice);
                                            monthDiscPerc := 100 - ((monthDisc / (postedLines."Service Price" / postedLines.Amount)) * 100);
                                            if monthDiscPerc <= 45 then begin
                                                salesLines.Validate("Line Discount %", monthDiscPerc);
                                            end;
                                        end;
                                    end;

                                    if postedLines."Service Type" = postedLines."Service Type"::Activity then begin
                                        salesLines.Validate("No.", postedLines."Service No.");
                                        attendanceLine.SetRange(attendanceLine."Child No.", "Child No.");
                                        if attendanceLine.FindSet then begin
                                            repeat
                                                attendMonth := Date2DMY(attendanceLine.Date, 2);
                                                attendYear := Date2DMY(attendanceLine.Date, 3);
                                                if (currMonth = attendMonth) and (currYear = attendYear) and (attendanceLine.Participation = attendanceLine.Participation::Present) then begin
                                                    if (attendanceLine.Activity <> '') and (attendanceLine.Activity = postedLines."Service No.") then
                                                        countService := countService + 1;

                                                    if (attendanceLine.Activity2 <> '') and (attendanceLine.Activity2 = postedLines."Service No.") then
                                                        countService := countService + 1;

                                                    if (attendanceLine.Activity3 <> '') and (attendanceLine.Activity3 = postedLines."Service No.") then
                                                        countService := countService + 1;
                                                end;
                                            until attendanceLine.Next = 0;
                                        end;
                                        salesLines.Validate(Quantity, countService);
                                    end;

                                    if postedLines."Service Type" = postedLines."Service Type"::Meal then begin
                                        salesLines.Validate("No.", postedLines."Service No.");
                                        attendanceLine.SetRange(attendanceLine."Child No.", "Child No.");
                                        if attendanceLine.FindSet then begin
                                            repeat
                                                attendMonth := Date2DMY(attendanceLine.Date, 2);
                                                attendYear := Date2DMY(attendanceLine.Date, 3);
                                                if (currMonth = attendMonth) and (currYear = attendYear) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Breakfast') then begin
                                                    if attendanceLine.Breakfast = true then
                                                        countMeal := countMeal + 1;
                                                end;

                                                if (currMonth = attendMonth) and (currYear = attendYear) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Brunch') then begin
                                                    if attendanceLine.Brunch = true then
                                                        countMeal := countMeal + 1;
                                                end;

                                                if (currMonth = attendMonth) and (currYear = attendYear) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Lunch') then begin
                                                    if attendanceLine.Lunch = true then
                                                        countMeal := countMeal + 1;
                                                end;
                                                if (currMonth = attendMonth) and (currYear = attendYear) and (attendanceLine.Participation = attendanceLine.Participation::Present) and (postedLines.Description = 'Dinner') then begin
                                                    if attendanceLine.Dinner = true then
                                                        countMeal := countMeal + 1;
                                                end;
                                            until attendanceLine.Next = 0;
                                        end;
                                        salesLines.Validate(Quantity, countMeal);
                                    end;

                                    salesLines.Insert(true);
                                until postedLines.Next = 0;
                            end;
                            postSalesCodeUnit.Run(salesHeader);
                        end else begin
                            Error(text10002);
                        end;
                        Message(text10000);
                    end;
                }
                action("Terminate Contract")
                {
                    Image = Cancel;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        if Rec.Status = Rec.Status::Valid then
                            Rec.Status := Rec.Status::Terminated;
                        Rec.Modify;

                        Rec.Get("No.");
                        Rec.SetRecFilter;
                        Commit;
                        REPORT.Run(50110, true, true, Rec);
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        IsChecked := false;
    end;

    var
        ContractPost: Codeunit "Child Contract - Post";
        IsChecked: Boolean;
}

