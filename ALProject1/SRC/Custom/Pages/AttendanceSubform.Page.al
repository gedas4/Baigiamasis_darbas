page 50140 "Attendance Subform"
{
    AutoSplitKey = false;
    PageType = ListPart;
    SourceTable = "Child Attendance";

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
                }
                field("Child No."; "Child No.")
                {
                    Visible = false;
                }
                field(Date; Date)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Participation; Participation)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Attendance; Attendance)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Breakfast; Breakfast)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Brunch; Brunch)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Lunch; Lunch)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Dinner; Dinner)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Activity; Activity)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Activity2; Activity2)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Activity3; Activity3)
                {
                    Style = Favorable;
                    StyleExpr = Color;
                }
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdateStyle;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange(Date, Today);
    end;

    var
        [InDataSet]
        Color: Boolean;

    local procedure UpdateStyle()
    begin
        if Date = Today then
            Color := true
        else
            Color := false;
    end;
}

