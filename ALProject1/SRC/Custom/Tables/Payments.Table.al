table 50200 Payments
{

    fields
    {
        field(10; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Journal Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50; "Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                "Document Date" := Today;
                "Posting Date" := Today;
            end;
        }
        field(52; "Applies-to Doc. No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cust. Ledger Entry"."Document No." WHERE ("Document Type" = CONST (Invoice),
                                                                       "Customer No." = FIELD ("Account No."));
        }
        field(55; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(70; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        ContractSetup: Record "Contract Setup";
    begin
        if "No." = '' then begin
            ContractSetup.Get;
            ContractSetup.TestField("Payment Nos.");
            NoSeriesMgt.InitSeries(ContractSetup."Payment Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

