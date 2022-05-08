page 50200 "Posted Child Contract List"
{
    CardPageID = "Posted Child Contract";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Child Header";
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

    actions
    {
        area(processing)
        {
            group("Posted Contract Actions")
            {
                action("Create Periodic Invoices")
                {
                    Image = NewInvoice;
                    Promoted = true;

                    trigger OnAction()
                    var
                        salesHeader: Record "Sales Header";
                        salesLine: Record "Sales Line";
                        attendanceLine: Record "Child Attendance";
                        d1: Date;
                        docNo: Code[20];
                        LineNo: Integer;
                        postedLines: Record "Posted Contract Lines";
                        currMonth: Integer;
                        currYear: Integer;
                        attendMonth: Integer;
                        attendYear: Integer;
                        countService: Integer;
                        countMeal: Integer;
                        childrenKind: Record Childer;
                        run: Boolean;
                        monthDisc: Decimal;
                        contractMonth: Integer;
                        monthDays: Integer;
                        dayPrice: Decimal;
                        prevMonth: Integer;
                        absence: Integer;
                        testtxt: Text;
                        headerNo: Integer;
                        monthDicsPerc: Decimal;
                        postSaslesCodeUnit: Codeunit "Sales-Post";
                        text10000: Label 'Periodic invoices has been successfully posted';
                    begin
                        d1 := Today;
                        d1 := CalcDate('<-CM>', d1);
                        d1 := d1 - 1;
                        currMonth := Date2DMY(Today, 2);
                        currYear := Date2DMY(Today, 3);
                        monthDays := Date2DMY(d1, 1);
                        prevMonth := Date2DMY(d1, 2);
                        //MESSAGE('%1',d1);
                        /*REPEAT
                          CLEAR(salesHeader);
                          salesHeader.INIT;
                          salesHeader.VALIDATE("Document Type",salesHeader."Document Type"::Invoice);
                          salesHeader.VALIDATE("Sell-to Customer No.","Child No.");
                          salesHeader.INSERT(TRUE);
                        UNTIL Rec.NEXT = 0;
                        docNo := salesHeader."No.";
                        
                        
                        salesLine.SETRANGE("Document Type",salesLine."Document Type"::Invoice);
                        salesLine.SETRANGE("Document No.",docNo);
                        IF salesLine.FINDLAST THEN BEGIN
                          LineNo := salesLine."Line No." + 10000;
                        END ELSE BEGIN
                          LineNo := 10000;
                        END;
                        
                        salesLine.INIT;
                        salesLine."Document Type" := salesLine."Document Type"::Invoice;
                        salesLine."Document No." := docNo;
                        salesLine."Line No." := LineNo;
                        salesLine.Type := salesLine.Type::Item;
                        salesLine.VALIDATE("No.",'1001');
                        salesLine.VALIDATE(Quantity,3);
                        salesLine.INSERT(TRUE);*/

                        Rec.SetRange("Type of Contract", Rec."Type of Contract"::"Long-term");
                        if Rec.FindSet then begin
                            repeat
                                //countService := 0;
                                //countMeal := 0;
                                //absence := 0;
                                contractMonth := Date2DMY(Rec."Date From", 2);
                                childrenKind.SetFilter(childrenKind."Child No.", "Child No.");
                                if childrenKind.FindSet then begin
                                    Clear(salesHeader);
                                    salesHeader.Init;
                                    salesHeader.Validate("Document Type", salesHeader."Document Type"::Invoice);
                                    salesHeader.Validate("Sell-to Customer No.", "Child No.");
                                    salesHeader.Insert(true);
                                    docNo := salesHeader."No.";
                                    postedLines.SetFilter("Child Contract No.", "No.");
                                    if postedLines.FindSet then begin
                                        repeat
                                            countService := 0;
                                            countMeal := 0;
                                            absence := 0;
                                            salesLine.SetRange("Document Type", salesLine."Document Type"::Invoice);
                                            salesLine.SetRange("Document No.", docNo);
                                            if salesLine.FindLast then begin
                                                LineNo := salesLine."Line No." + 10000;
                                            end else begin
                                                LineNo := 10000;
                                            end;

                                            salesLine.Init;
                                            salesLine."Document Type" := salesLine."Document Type"::Invoice;
                                            salesLine."Document No." := docNo;
                                            salesLine."Line No." := LineNo;
                                            salesLine.Type := salesLine.Type::Item;
                                            if postedLines."Service Type" = postedLines."Service Type"::Month then begin
                                                //salesLine.Type := salesLine.Type::Month;
                                                salesLine.Validate("No.", postedLines."Service No.");
                                                //salesLine."No." := postedLines."Service No.";
                                                salesLine.Validate(Quantity, 1);
                                                //salesLine."Unit Price" := postedLines."Service Price"/postedLines.Amount;
                                                if contractMonth <> currMonth then begin
                                                    dayPrice := (postedLines."Service Price" / postedLines.Amount) / monthDays;
                                                    attendanceLine.SetFilter(attendanceLine."Child No.", "Child No.");
                                                    if attendanceLine.FindSet then begin
                                                        repeat
                                                            attendMonth := Date2DMY(attendanceLine.Date, 2);
                                                            attendYear := Date2DMY(attendanceLine.Date, 3);
                                                            if (prevMonth = attendMonth) and (currYear = attendYear) and (attendanceLine.Participation = attendanceLine.Participation::Absent) then
                                                                absence := absence + 1;
                                                        until attendanceLine.Next = 0;
                                                    end;
                                                    monthDisc := (postedLines."Service Price" / postedLines.Amount) - (dayPrice * absence);
                                                    monthDicsPerc := 100 - ((monthDisc / (postedLines."Service Price" / postedLines.Amount)) * 100);
                                                    if monthDicsPerc <= 45 then begin
                                                        //monthDicsPerc := (monthDisc/(postedLines."Service Price"/postedLines.Amount))*100;
                                                        //salesLine."Line Discount %" := monthDicsPerc;
                                                        salesLine.Validate("Line Discount %", monthDicsPerc);
                                                        //salesLine."Line Discount Amount" := monthDisc;
                                                        //MESSAGE('veikia');
                                                    end;
                                                    //MESSAGE('ab %1 md %2',absence,monthDicsPerc);
                                                end;
                                            end;

                                            if postedLines."Service Type" = postedLines."Service Type"::Activity then begin
                                                //salesLine.Type := salesLine.Type::Activity;
                                                salesLine.Validate("No.", postedLines."Service No.");
                                                //salesLine."No." := postedLines."Service No.";
                                                attendanceLine.SetFilter(attendanceLine."Child No.", "Child No.");
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
                                                salesLine.Validate(Quantity, countService);
                                                //salesLine."Unit Price" := postedLines."Service Price"/postedLines.Amount;
                                            end;

                                            if postedLines."Service Type" = postedLines."Service Type"::Meal then begin
                                                //salesLine.Type := salesLine.Type::Meal;
                                                salesLine.Validate("No.", postedLines."Service No.");
                                                //salesLine."No." := postedLines."Service No.";
                                                attendanceLine.SetFilter(attendanceLine."Child No.", "Child No.");
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
                                                salesLine.Validate(Quantity, countMeal);
                                                //salesLine."Unit Price" := postedLines."Service Price"/postedLines.Amount;
                                            end;
                                            //salesLine."VAT Prod. Posting Group" := 'VAT25';
                                            salesLine.Insert(true);
                                        until postedLines.Next = 0;
                                    end;
                                    postSaslesCodeUnit.Run(salesHeader);
                                end;
                            until Rec.Next = 0;
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
}

