page 50050 "Child Contract"
{
    UsageCategory = Documents;
    PageType = Document;
    SourceTable = "Child Header";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    Editable = true;
                }
                field("Child No."; "Child No.")
                {
                    Editable = true;
                }
                field("Parent Name"; "Parent Name")
                {
                    Editable = false;
                }
                field("Date From"; "Date From")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Date To"; "Date To")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Type of Contract"; "Type of Contract")
                {
                    Editable = false;
                }
                field("Issued By"; "Issued By")
                {
                    Editable = true;
                }
                field("Total Service Amount"; "Total Service Amount")
                {
                    Editable = false;
                }
                field("Total No. of Services"; "Total No. of Services")
                {
                    Editable = false;
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
                    Editable = false;
                }
                field("Address 2"; "Address 2")
                {
                    Editable = false;
                }
                field("Post Code"; "Post Code")
                {
                    Editable = false;
                }
                field(City; City)
                {
                    Editable = false;
                }
            }
            part(Control19; "Child Contract Subform")
            {
                SubPageLink = "Child Contract No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action21)
            {
            }
            action("Check Contract")
            {
                Image = Confirm;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ContractPost.CheckContract(Rec);
                    Message('Contract is successfully checked');
                    IsChecked := true;
                end;
            }
            action("Add Periodic Invoice")
            {
                Image = NewInvoice;
                Promoted = true;
                RunObject = Page "Periodic Invoice Page";
                Visible = false;
            }
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PostedRec: Record "Posted Child Header";
                begin
                    if IsChecked = true then begin
                        ContractPost.PostContract(Rec);
                        Message('Contract is posted');
                        PostedRec.Get("No.");
                        PAGE.Run(50170, PostedRec);
                        IsChecked := false;
                    end
                    else begin
                        Message('Contract is not checked');
                    end;
                end;
            }
            action("Create Contract")
            {
                Image = CreateDocument;
                Promoted = true;

                trigger OnAction()
                begin
                    Rec.Get("No.");
                    Rec.SetRecFilter;
                    REPORT.Run(50000, true, true, Rec);
                end;
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
        Number: Code[20];
        MyRec: Record "Child Header";
}

