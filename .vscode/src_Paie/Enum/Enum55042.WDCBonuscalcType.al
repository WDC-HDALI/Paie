enum 55042 "WDC Bonus calc. Type"
{
    Extensible = true;

    value(0; "Prime=(((Salaire base+Indemnité)*NbjourTravaillé)/NbjourAnuel)*Taux")
    {
        Caption = 'Prime=(((Salaire base+Indemnité)*NbjourTravaillé)/NbjourAnuel)*Taux';
    }
    value(1; "Prime=(somme SB Brut* 26 *(J TR/360)/(24*M TR))- (SB Brut12*(M TR/12))")
    {
        Caption = 'Prime=(somme SB Brut* 26 *(J TR/360)/(24*M TR))- (SB Brut12*(M TR/12))';
    }
    value(2; "Prime=(((somme SB Brut* NB jour payé)/NB jour annuel)*Taux)")
    {
        Caption = 'Prime=(((somme SB Brut* NB jour payé)/NB jour annuel)*Taux)';
    }
    value(3; "Prime=(((Salaire base+Indemnité)*NbjourTravaillé+HN)/NbjourHAnuel)*Taux ")
    {
        Caption = 'Prime=(((Salaire base+Indemnité)*NbjourTravaillé+HN)/NbjourHAnuel)*Taux ';
    }
    value(4; "Prime=(((Salaire base+Indemnité)*Note/20")
    {
        Caption = 'Prime=(((Salaire base+Indemnité)*Note/20';
    }
    value(5; "SBase*8*2*N*n/12")
    {
        Caption = 'SBase*8*2*N*n/12';
    }
    value(6; "Brut*10%")
    {
        Caption = 'Brut*10%';
    }
    value(7; "prime=((S base+ind) pourcentage*nb jours*nb mois trav)/12")
    {
        Caption = 'prime=((S base+ind) pourcentage*nb jours*nb mois trav)/12';
    }
    value(8; "Prime=(Somme S base+indemités)*pourcentage")
    {
        Caption = 'Prime=(Somme S base+indemités)*pourcentage';
    }
    value(9; "Formules GMS")
    {
        Caption = 'Formules GMS';
    }
    value(10; "S Base * note")
    {
        Caption = 'S Base * note';
    }
}
