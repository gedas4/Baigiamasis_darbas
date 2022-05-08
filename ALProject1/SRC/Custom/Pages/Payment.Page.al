page 50280 Payment
{
    SourceTable = Payments;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Applies-to Doc. No"; "Applies-to Doc. No")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                        CustLedgPage: Page "Customer Ledger Entries";
                    begin
                        CustLedgerEntry.SetFilter("Customer No.", "Account No.");
                        CustLedgPage.SetRecord(CustLedgerEntry);
                        CustLedgPage.SetTableView(CustLedgerEntry);
                        CustLedgPage.LookupMode(true);
                        if CustLedgPage.RunModal = ACTION::LookupOK then begin
                            CustLedgPage.GetRecord(CustLedgerEntry);
                            "Applies-to Doc. No" := CustLedgerEntry."Document No.";
                        end;
                    end;

                    trigger OnValidate()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                        CustLedgPage: Page "Customer Ledger Entries";
                    begin
                    end;
                }
                field(Amount; Amount)
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
            group(Action10)
            {
                action(Post)
                {
                    Image = Post;
                    Promoted = true;

                    trigger OnAction()
                    var
                        PostCodeUnit: Codeunit "Child Contract - Post";
                    begin
                        PostCodeUnit.PostPayment(Rec);
                        Message('Payment is posted');
                    end;
                }
            }
        }
    }
}

