enum 89800 JBP_JobQEntryFailRespons
{
    Extensible = true;
    value(0; " ")
    {
    }
    value(1; "Restart")
    {
        Caption = 'Restart', Comment = 'NOR="Omstart"';
    }
    value(2; "Send Email")
    {
        Caption = 'Send Email', Comment = 'NOR="Send epost"';
    }
    value(3; "Restart and Send Email")
    {
        Caption = 'Restart and send email', Comment = 'NOR="Omstart og send epost"';
    }
}