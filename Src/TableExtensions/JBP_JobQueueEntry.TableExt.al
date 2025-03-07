tableextension 89800 JBP_JobQueueEntry extends "Job Queue Entry"
{
    fields
    {
        field(89800; JBP_JobQueueEntryFailResponse; Enum JBP_JobQEntryFailRespons)
        {
            DataClassification = ToBeClassified;
            Caption = 'Response on error', Comment = 'NOR="Håndtering ved feil"';
        }

        field(89801; JBP_JobQueueEntryResponseEmail; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Email on error', Comment = 'NOR="Epost ved feil"';
        }
        field(89802; JBP_FailResponseEmailSent; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Email on error sendt', Comment = 'NOR="Epost ved feil sendt"';
        }
        field(89803; JBP_RestartsBeforeAlert; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Number of restarts before email sendt', Comment = 'NOR="Antall omstarter før epost sendes"';
        }
        field(89804; JBP_NumberOfRestarts; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Number of restarts', Comment = 'NOR="Antall omstarter"';
        }
    }
}