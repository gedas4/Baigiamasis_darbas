page 50180 "Contract Journal Line"
{
    Editable = false;
    PageType = List;
    SourceTable = "Contract Journal Line";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Line No."; "Line No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Child No."; "Child No.")
                {
                }
                field("Type of Contract"; "Type of Contract")
                {
                }
                field("Service No."; "Service No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Actual Date of Entry"; "Actual Date of Entry")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Service Price"; "Service Price")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action14)
            {
                action(Post)
                {
                    Image = Post;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        PostCode.PostJournalToLedger;
                        Message('Journal lines are posted');
                    end;
                }
            }
        }
    }

    var
        PostCode: Codeunit "Child Contract - Post";
}

