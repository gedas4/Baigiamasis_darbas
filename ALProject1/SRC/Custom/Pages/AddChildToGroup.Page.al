page 50230 "Add Child To Group"
{
    PageType = ListPart;
    SourceTable = Childer;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                    Visible = false;

                    trigger OnValidate()
                    var
                        KindGroup: Record "Kindergarten Groups";
                    begin
                        //"Group No." := GroupPage.GroupNoAdd();
                    end;
                }
                field("Child No."; "Child No.")
                {

                    trigger OnValidate()
                    begin
                        //"Group No." := GroupPage.GroupNoAdd;
                        //"Group No." := "No.";
                        //MESSAGE('veikia');
                    end;
                }
                field("Group No."; "Group No.")
                {
                    Visible = false;
                }
                field("Child Name"; "Child Name")
                {
                }
                field("Parent Name"; "Parent Name")
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
        }
    }

    actions
    {
    }

    var
        GroupPage: Page "Kindergarten Group - To Add Ch";
        "No.": Code[20];

    [Scope('OnPrem')]
    procedure GetNo(GroupNo: Code[20])
    begin
        "No." := GroupNo;
        Message('%1', "No.");
    end;
}

