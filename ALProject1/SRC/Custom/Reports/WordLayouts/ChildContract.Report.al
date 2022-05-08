report 50000 "Child Contract"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'SRC\Custom\Reports\RdlcLayouts\ChildContract.rdl';

    dataset
    {
        dataitem("Child Header"; "Child Header")
        {
            column(No; "Child Header"."No.")
            {
            }
            column(ChildNo; "Child Header"."Child No.")
            {
            }
            column(ParentName; "Child Header"."Parent Name")
            {
            }
            column(TypeOfContract; "Child Header"."Type of Contract")
            {
            }
            column(DateFrom; "Child Header"."Date From")
            {
            }
            column(DateTo; "Child Header"."Date To")
            {
            }
            column(KindName; KindergartenName)
            {
            }
            column(KindCity; KindergartenCity)
            {
            }
            column(KindAddres; KindergartenAddress)
            {
            }
            column(ContractPeriod; interval1)
            {
            }
            column(mPrice; mealPrice)
            {
            }
            column(activitiesPrice; servicePrice)
            {
            }
            column(prdPrice; periodPrice)
            {
            }
            column(IncActivities; activities)
            {
            }
            column(ContractType; "Child Header"."Type of Contract")
            {
            }
            column(mealCnt; mealCount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*Kid.SETFILTER(Kid."Child No.","Child Header"."Child No.");
                IF Kid.FINDSET THEN BEGIN
                  KindGroup.SETFILTER("Group No.",Kid."Group No.");
                  IF KindGroup.FINDSET THEN BEGIN
                    Kindergarten.SETFILTER("No.",KindGroup."Kindergarten No.");
                    IF Kindergarten.FINDSET THEN BEGIN
                      KindergartenName := Kindergarten.Name;
                      KindergartenAddress := Kindergarten.Address;
                      KindergartenCity := Kindergarten.City;
                    END;
                  END;
                END;*/
                Kindergarten.FindFirst;
                if Kindergarten.FindSet then begin
                    KindergartenName := Kindergarten.Name;
                    KindergartenAddress := Kindergarten.Address;
                    KindergartenCity := Kindergarten.City;
                end;
                mealCount := 0;
                actCount := 0;
                Line.SetFilter("Child Contract No.", "Child Header"."No.");
                if Line.FindSet then begin
                    repeat
                        if Line."Service Type" = Line."Service Type"::Month then begin
                            periodPrice := Line."Service Price" / Line.Amount;
                        end;
                        if Line."Service Type" = Line."Service Type"::Day then begin
                            periodPrice := Line."Service Price" / Line.Amount;
                        end;
                        if Line."Service Type" = Line."Service Type"::Activity then begin
                            actCount := actCount + 1;
                        end;
                        if Line."Service Type" = Line."Service Type"::Meal then begin
                            mealCount := mealCount + 1;
                        end;
                    until Line.Next = 0;
                end;

                mealPrice := 3.5;
                servicePrice := 45;


                if actCount > 0 then begin
                    activities := Txt50000;
                end
                else begin
                    activities := Txt50001;
                end;


                if "Child Header"."Type of Contract" = "Child Header"."Type of Contract"::"Long-term"
                 then begin
                    interval1 := MonthTxt;
                end
                else begin
                    interval1 := DayTxt;
                end;

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        Type = '<>';
    }

    var
        KindergartenName: Text[50];
        KindergartenCity: Text[50];
        KindergartenAddress: Text[100];
        KindGroup: Record "Kindergarten Groups";
        Kindergarten: Record Kindergarten;
        Kid: Record Childer;
        mealCount: Integer;
        interval1: Text[40];
        interval2: Text[40];
        interval3: Text[40];
        activities: Text[10];
        mealPrice: Decimal;
        servicePrice: Decimal;
        periodPrice: Decimal;
        dayPrice: Decimal;
        Line: Record "Contract Lines";
        actCount: Integer;
        MonthTxt: Label 'month';
        DayTxt: Label 'day';
        Txt50000: Label 'Taip';
        Txt50001: Label 'Ne';
}

