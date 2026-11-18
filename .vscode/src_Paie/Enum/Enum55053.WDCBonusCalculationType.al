Enum 55053 "WDC Bonus Calculation Type"
{
    Extensible = true;
    value(0; " ") { }
    value(1; "(((Salaire base+Indemnité)*NbjourTravaillé)/NbjourAnuel)*Taux") { }
    value(2; "((somme SB Brut* 26 *(J TR/360)/(24*M TR))- (SB Brut12*(M TR/12))") { }
    value(3; "(((somme SB Brut* NB jour payé)/NB jour annuel)*Taux)") { }
    value(4; "((Salaire base+Indemnité)*NbjourTravaillé+HN)/NbjourHAnuel)*Taux ") { }
    value(5; "(((Salaire base+Indemnité)*NbjourTravaillé+HN)/NbjourHAnuel)*Taux ") { }
    value(6; "Base*8*2*N*n/12") { }
    value(7; "Brut*10%") { }
    value(8; "((S base+ind) pourcentage*nb jours*nb mois trav)/12") { }
    value(9; "(Somme S base+indemités)*pourcentage") { }
    value(10; "Formules GMS") { }
    value(11; "S Base * note") { }



}