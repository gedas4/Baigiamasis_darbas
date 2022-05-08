page 50240 "Kindergarten Group - To Add Ch"
{
    PageType = Document;
    SourceTable = "Kindergarten Groups";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("Group No."; "Group No.")
                {
                    Editable = false;
                }
                field("Kindergarten No."; "Kindergarten No.")
                {
                    Editable = false;
                }
                field("Group Name"; "Group Name")
                {
                    Editable = false;
                }
            }
            part(Control6; "Add Child To Group")
            {
                SubPageLink = "Group No." = FIELD("Group No.");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        test: Code[20];
    begin
        //SubPage.GetNo("Group No.");
    end;

    var
        GrpNo: Code[20];
        SubPage: Page "Add Child To Group";

    [Scope('OnPrem')]
    procedure GroupNoAdd(): Code[20]
    var
        "No.": Code[20];
    begin
        //MESSAGE('%1',"Group No.");
        exit("Group No.");
    end;
}

