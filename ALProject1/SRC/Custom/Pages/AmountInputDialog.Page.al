page 50290 "Amount Input Dialog"
{
    InstructionalText = 'Enter paid amount';
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(NumberToEnter; NumberToEnter)
            {
                ShowCaption = false;
            }
        }
    }

    actions
    {
    }

    var
        NumberToEnter: Decimal;

    [Scope('OnPrem')]
    procedure ReturnEnteredNumber(): Decimal
    begin
        exit(NumberToEnter);
    end;
}

