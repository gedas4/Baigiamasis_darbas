codeunit 50000 "Child Contract - Post"
{

    trigger OnRun()
    begin
    end;

    var
        NextEntryNo: Integer;
        NextEntryNo2: Integer;

    [Scope('OnPrem')]
    procedure CheckContract(childHeader: Record "Child Header")
    var
        Line: Record "Contract Lines";
        "count": Integer;
    begin
        if (childHeader."Child No." = '') or (childHeader."Posting Date" = 0D) or (childHeader."Date To" = 0D) or (childHeader."Date From" = 0D) then begin
            Error('One of the following Mandotary fields is missing: Child No., Posting Date, Date To, Date From');
        end;

        if (childHeader."Total No. of Services" = 0) then
            Error('Add at least one line to a contract - it cannot be empty');
    end;

    [Scope('OnPrem')]
    procedure PostContract(childHeader: Record "Child Header")
    var
        contractLine: Record "Contract Lines";
        contractJournalLine: Record "Contract Journal Line";
        postedContractLine: Record "Posted Contract Lines";
        postedChildHeader: Record "Posted Child Header";
        genJournalLine: Record "Gen. Journal Line";
        genJrnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        contractLine.SetFilter("Child Contract No.", childHeader."No.");
        if contractLine.FindSet then begin
            repeat
                contractJournalLine.Init;
                contractJournalLine."Line No." := contractLine."Line No.";
                contractJournalLine."Posting Date" := childHeader."Posting Date";
                contractJournalLine."Child No." := childHeader."Child No.";
                contractJournalLine."Type of Contract" := childHeader."Type of Contract";
                contractJournalLine."Service No." := contractLine."Service No.";
                contractJournalLine.Description := contractLine.Description;
                contractJournalLine."Actual Date of Entry" := Today;
                contractJournalLine.Amount := contractLine.Amount;
                contractJournalLine."Service Price" := contractLine."Service Price";
                contractJournalLine."Total Service Amount" := childHeader."Total Service Amount";
                contractJournalLine.Insert(true);

                postedContractLine.Init;
                postedContractLine."Child Contract No." := contractLine."Child Contract No.";
                postedContractLine."Line No." := contractLine."Line No.";
                postedContractLine."Service Type" := contractLine."Service Type";
                postedContractLine."Service No." := contractLine."Service No.";
                postedContractLine.Description := contractLine.Description;
                postedContractLine.Amount := contractLine.Amount;
                postedContractLine."Unit Price" := contractLine."Unit Price";
                postedContractLine."Rem. Amount" := contractLine."Rem. Amount";
                postedContractLine."Service Price" := contractLine."Service Price";
                postedContractLine.Insert;
                contractLine.Delete;

            until contractLine.Next = 0;
        end;

        postedChildHeader.Init;
        postedChildHeader."No." := childHeader."No.";
        postedChildHeader."Child No." := childHeader."Child No.";
        postedChildHeader."Parent Name" := childHeader."Parent Name";
        postedChildHeader."Type of Contract" := childHeader."Type of Contract";
        postedChildHeader."Date From" := childHeader."Date From";
        postedChildHeader."Date To" := childHeader."Date To";
        postedChildHeader."Issued By" := childHeader."Issued By";
        postedChildHeader."Total Service Amount" := childHeader."Total Service Amount";
        postedChildHeader."Total No. of Services" := childHeader."Total No. of Services";
        postedChildHeader.Status := childHeader.Status;
        postedChildHeader."Document Date" := childHeader."Document Date";
        postedChildHeader."Posting Date" := childHeader."Posting Date";
        postedChildHeader.Address := childHeader.Address;
        postedChildHeader."Address 2" := childHeader."Address 2";
        postedChildHeader."Post Code" := childHeader."Post Code";
        postedChildHeader.City := childHeader.City;
        postedChildHeader.Insert;

        genJournalLine.Init;
        InitNextEntryNo2;
        genJournalLine.Validate("Line No.", NextEntryNo2);
        genJournalLine.Validate("Journal Template Name", 'PAYMENT');
        genJournalLine.Validate("Journal Batch Name", 'BANK');
        genJournalLine.Validate("Posting Date", Today);
        genJournalLine.Validate("Document Type", genJournalLine."Document Type"::Invoice);
        genJournalLine.Validate("Document No.", childHeader."No.");
        genJournalLine.Validate("Account Type", genJournalLine."Account Type"::Customer);
        genJournalLine.Validate("Account No.", childHeader."Child No.");
        genJournalLine.Validate(Amount, childHeader."Total Service Amount");
        genJournalLine.Validate("Bal. Account Type", genJournalLine."Bal. Account Type"::"Bank Account");
        genJournalLine.Validate("Bal. Account No.", 'WWB-OPERATING');
        genJournalLine.Insert;
        genJrnlPost.Run(genJournalLine);
        childHeader.Delete;
        PostJournalToLedger;
    end;

    [Scope('OnPrem')]
    procedure PostJournalToLedger()
    var
        contractJournalLine: Record "Contract Journal Line";
        generalLedger: Record "Contract Ledger Entry";
    begin

        repeat
            if (contractJournalLine."Document No." <> '') and (contractJournalLine."Child No." <> '') and (contractJournalLine."Service No." <> '') then begin
                InitNextEntryNo;
                generalLedger.Init;
                generalLedger."Entry No." := NextEntryNo;
                generalLedger."Posting Date" := contractJournalLine."Posting Date";
                generalLedger."Document no." := contractJournalLine."Document No.";
                generalLedger."Type of Contract" := contractJournalLine."Type of Contract";
                generalLedger."Child No." := contractJournalLine."Child No.";
                generalLedger."Service no." := contractJournalLine."Service No.";
                generalLedger.Description := contractJournalLine.Description;
                generalLedger."Actual Date of Entry" := contractJournalLine."Actual Date of Entry";
                generalLedger.Amount := contractJournalLine.Amount;
                generalLedger."Service Price" := contractJournalLine."Service Price";
                generalLedger."Total Service Amount" := contractJournalLine."Total Service Amount";
                generalLedger.Insert;
                contractJournalLine.Delete;
            end;
        until contractJournalLine.Next = 0;
    end;

    local procedure InitNextEntryNo()
    var
        GLEntry: Record "Contract Ledger Entry";
    begin
        GLEntry.LockTable;
        if GLEntry.FindLast then begin
            NextEntryNo := GLEntry."Entry No." + 1;
        end else begin
            NextEntryNo := 1;
        end;
    end;

    local procedure InitNextEntryNo2()
    var
        GLJournal: Record "Gen. Journal Line";
    begin
        GLJournal.LockTable;
        if GLJournal.FindLast then begin
            NextEntryNo2 := GLJournal."Line No." + 1;
        end else begin
            NextEntryNo2 := 1;
        end;
    end;

    [Scope('OnPrem')]
    procedure PostPayment(payment: Record Payments)
    var
        genJournalLine: Record "Gen. Journal Line";
        genJrnlPost: Codeunit "Gen. Jnl.-Post";
    begin
        /*IF(payment."Document Date" = 0D) OR (payment."Posting Date" = 0D) OR (payment."Account No." = '') THEN
          ERROR('One of the following Mandotary fields is missing: Posting Date, Document Date, Account No.');*/

        genJournalLine.Init;
        InitNextEntryNo2;
        genJournalLine.Validate("Line No.", NextEntryNo2);
        genJournalLine.Validate("Journal Template Name", 'PAYMENT');
        genJournalLine.Validate("Journal Batch Name", 'BANK');
        genJournalLine.Validate("Posting Date", Today);
        genJournalLine.Validate("Document Type", genJournalLine."Document Type"::Payment);
        genJournalLine.Validate("Document No.", payment."No.");
        genJournalLine.Validate("Account Type", genJournalLine."Account Type"::Customer);
        genJournalLine.Validate("Account No.", payment."Account No.");
        if payment.Amount < 0 then begin
            genJournalLine.Validate(Amount, payment.Amount);
        end else begin
            genJournalLine.Validate(Amount, (payment.Amount * -1));
        end;
        genJournalLine.Validate("Bal. Account Type", genJournalLine."Bal. Account Type"::"Bank Account");
        genJournalLine.Validate("Bal. Account No.", 'WWB-OPERATING');
        genJournalLine.Validate("Applies-to Doc. Type", genJournalLine."Applies-to Doc. Type"::Invoice);
        genJournalLine.Validate("Applies-to Doc. No.", payment."Applies-to Doc. No");
        genJournalLine.Insert;
        payment.Delete;
        genJrnlPost.Run(genJournalLine);



    end;
}

