codeunit 89800 JBP_JobQueueErrorHandler
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        JQE: Record "Job Queue Entry";
        JQEResponse: Enum JBP_JobQEntryFailRespons;
    begin
        if Rec."Parameter String" = 'InduceError' then
            Error('Testing Job Queue Error');

        JQE.SetFilter(JBP_JobQueueEntryFailResponse, '<>%1', JQEResponse::" ");
        JQE.SetRange(Status, JQE.Status::Error);
        if JQE.FindSet() then
            repeat
                case JQE.JBP_JobQueueEntryFailResponse of
                    JBP_JobQEntryFailRespons::Restart:
                        RestartJob(JQE);
                    JBP_JobQEntryFailRespons::"Send Email":
                        SendEmail(JQE);
                    JBP_JobQEntryFailRespons::"Restart and Send Email":
                        RestartAndSendEmail(JQE);
                end;
            until JQE.Next() = 0;
    end;

    local procedure RestartJob(JobQueueEntryRecord: Record "Job Queue Entry")
    begin
        JobQueueEntryRecord.SetStatus(JobQueueEntryRecord.Status::Ready);
    end;

    local procedure SendEmail(JobQueueEntryRecord: Record "Job Queue Entry")
    var
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        ErrorMessageLbl: Label 'An error has been detected on the job %1 on company %2. The errors must be resolved manualy.', Comment = 'NOR="En feil er oppdaget på jobb %1 i selskapet %2. Feilen må følges opp manuelt."';
        ErrorSubjectLbl: Label 'Error on job queue "%1"', Comment = 'NOR="Feil på jobbkø "%1""';
    begin
        if JobQueueEntryRecord.JBP_FailResponseEmailSent then
            exit;

        emailMessage.Create(JobQueueEntryRecord.JBP_JobQueueEntryResponseEmail, StrSubstNo(ErrorSubjectLbl, JobQueueEntryRecord.Description), StrSubstNo(ErrorMessageLbl, JobQueueEntryRecord.Description, CompanyName()));
        email.Send(emailMessage, Enum::"Email Scenario"::"Job Queue Error Message");

        JobQueueEntryRecord.JBP_FailResponseEmailSent := true;
        JobQueueEntryRecord.Modify(false);
    end;

    local procedure RestartAndSendEmail(JobQueueEntryRecord: Record "Job Queue Entry")
    var
        email: Codeunit Email;
        emailMessage: Codeunit "Email Message";
        ErrorMessageLbl: Label 'An error has been detected on the job "%1" on company "%2". Trying to restart job. If job is able to restart a confirmation email will be sendt.', Comment = 'NOR="En feil er oppdaget på jobb "%1" i selskapet "%2". Prøver å starte jobb på nytt igjen. Hvis jobben blir kjørt vellykket igjen vil en bekreftelsesepost bli sendt."';
        ErrorSubjectLbl: Label 'Error on job queue %1', Comment = 'NOR="Feil på jobbkø %1"';
    begin
        JobQueueEntryRecord.JBP_NumberOfRestarts := JobQueueEntryRecord.JBP_NumberOfRestarts + 1;
        JobQueueEntryRecord.Modify(false);

        JobQueueEntryRecord.SetStatus(JobQueueEntryRecord.Status::Ready);

        if not (JobQueueEntryRecord.JBP_NumberOfRestarts > JobQueueEntryRecord.JBP_RestartsBeforeAlert) then
            exit;

        if JobQueueEntryRecord.JBP_FailResponseEmailSent = true then
            exit;

        emailMessage.Create(JobQueueEntryRecord.JBP_JobQueueEntryResponseEmail, StrSubstNo(ErrorSubjectLbl, JobQueueEntryRecord.Description), StrSubstNo(ErrorMessageLbl, JobQueueEntryRecord.Description, CompanyName()));
        email.Send(emailMessage, Enum::"Email Scenario"::"Job Queue Error Message");
        JobQueueEntryRecord.JBP_FailResponseEmailSent := true;
        JobQueueEntryRecord.Modify(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Queue Entry", 'OnBeforeSetStatusValue', '', false, false)]
    local procedure ClearFailResponseEmailSent(var JobQueueEntry: Record "Job Queue Entry"; var NewStatus: Option)
    begin
        if (NewStatus = JobQueueEntry.Status::Ready) and
             (JobQueueEntry.JBP_FailResponseEmailSent) and
             (JobQueueEntry.JBP_JobQueueEntryFailResponse = JobQueueEntry.JBP_JobQueueEntryFailResponse::"Send Email") then begin
            JobQueueEntry.JBP_FailResponseEmailSent := false;
            JobQueueEntry.Modify(false);
        end;
    end;

}