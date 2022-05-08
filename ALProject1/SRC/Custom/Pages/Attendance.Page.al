page 50130 Attendance
{
    UsageCategory = Documents;
    PageType = Document;
    SourceTable = Childer;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field("Entry No."; "Entry No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Child No."; "Child No.")
                {
                    Editable = false;
                }
                field("Group No."; "Group No.")
                {
                    Editable = false;
                }
                field("Child Name"; "Child Name")
                {
                    Editable = false;
                }
                field("Parent Name"; "Parent Name")
                {
                    Editable = false;
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
            part(Control12; "Attendance Subform")
            {
                SubPageLink = "Child No." = FIELD("Child No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Attendance Actions")
            {
                action("Attendance Report")
                {
                    Image = "Report";
                    Promoted = true;

                    trigger OnAction()
                    begin
                        Rec.Get("Entry No.", "Child No.", "Group No.");
                        Rec.SetRecFilter;
                        REPORT.Run(50090, true, true, Rec);
                    end;
                }
                action("Create Attendance")
                {
                    Image = Add;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        AttendaceCodeUnit.AddDates(Rec);
                    end;
                }
            }
        }
    }

    var
        AttendaceCodeUnit: Codeunit "Attendance date";
}

