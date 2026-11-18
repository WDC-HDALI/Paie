// codeunit 55029 "WDC Process Payroll"
// {
//     // BESCHREIBUNG
//     //   Zieht beim Aufruf einen DLB-Lieferschein um dann falls nötig(TEST) einen Wareneingang zu erstellen und ihn zu buchen.
//     // 
//     // 
//     // 
//     // MARK        Date            Admin                   Description
//     // ===============================================================================================================
//     //             18.04.2017      BEHG.SB                 Created.
//     //             24.04.2017      BEHG.SB/CB              Final bugfixes. Tests were successful.


//     trigger OnRun()
//     begin
//     end;

//     var
//         EDEL: Text;
//         DoTNet_INPUTBOX: DotNet Interaction;
//         DLB_LSNummer: Code[50];
//         global_Lotlist_TEMP: Record 6505 temporary;
//         Text008: Label 'Es wurde keine offene Bestellposition für %1, Zeilennummer %2 gefunden.';
//         WhseNo: Code[30];
//         MobileProcessItemData2: Record 94303;
//         WE_counter: Integer;
//         T1: Text;
//         T2: Text;
//         T3: Text;
//         T4: Text;
//         T5: Text;
//         T6: Text;
//         T7: Text;
//         T8: Text;
//         T9: Text;
//         T10: Text;
//         T11: Text;
//         T12: Text;
//         T13: Text;
//         T14: Text;
//         T15: Text;
//         T16: Text;
//         T17: Text;
//         T18: Text;
//         T19: Text;
//         T20: Text;
//         T21: Text;
//         T22: Text;
//         T23: Text;
//         T24: Text;
//         T25: Text;
//         T26: Text;
//         T27: Text;
//         T28: Text;
//         T29: Text;
//         T30: Text;
//         T31: Text;
//         T32: Text;
//         T33: Text;
//         T34: Text;
//         T35: Text;
//         T36: Text;
//         T37: Text;
//         T38: Text;
//         T39: Text;
//         T40: Text;
//         T41: Text;
//         T42: Text;
//         T43: Text;
//         T44: Text;
//         T45: Text;
//         T46: Text;
//         CUMT: Text;
//         ET1: Text;
//         ET2: Text;
//         ET3: Text;
//         ET4: Text;
//         TP: Text[5];
//         ET5: Text;
//         ET6: Text;
//         TS: Text[3];

//     local procedure STRREPLACE(Search: Text[1024]; Replace: Text[1024]; Subject: Text[1024]): Text[1024]
//     var
//         Position: Integer;
//         FirstPart: Text[1024];
//     begin
//         // not found
//         IF (STRPOS(Subject, Search) = 0) THEN
//             EXIT(Subject);

//         // first position
//         Position := STRPOS(Subject, Search);

//         // get first part
//         IF (Position > 1) THEN BEGIN
//             FirstPart := COPYSTR(Subject, 1, Position - 1) + Replace;
//         END ELSE BEGIN
//             FirstPart := Replace;
//         END;

//         EXIT(FirstPart + STRREPLACE(Search, Replace, DELSTR(Subject, 1, Position + STRLEN(Search) - 1)));
//     end;

//     procedure DELBeforeInsert()
//     var
//         SQLDataReader: DotNet SqlDataReader;
//         Connection: DotNet SqlConnection;
//         Setup: Record 50061;
//         SQLConnectionStringBuilder: DotNet SqlConnectionStringBuilder;
//         SQLServerString: Text[1024];
//         Company: Text;
//         "Schema": Text;
//         SQLCommand: DotNet SqlCommand;
//         SQL_SELECT: Text;
//         SQL_FROM: Text;
//         SQL_WHERE: Text;
//         DLBSalesOrderNo: Code[20];
//         RefPosition: Code[20];
//         varchar_text: Text;
//     begin
//         //lade konfiguration
//         Setup.GET(2);
//         //Connection-String bauen
//         SQLServerString := Setup."SQL Server";
//         IF Setup."SQL Instance" <> '' THEN
//             SQLServerString += STRSUBSTNO('\%1', Setup."SQL Instance");
//         IF Setup."SQL Port" <> 0 THEN
//             SQLServerString += STRSUBSTNO(',%1', Setup."SQL Port");

//         // build connection string
//         SQLConnectionStringBuilder := SQLConnectionStringBuilder.SqlConnectionStringBuilder();
//         SQLConnectionStringBuilder.DataSource(SQLServerString);
//         SQLConnectionStringBuilder.ConnectTimeout(60);
//         SQLConnectionStringBuilder.Pooling(FALSE);
//         SQLConnectionStringBuilder.InitialCatalog(Setup."SQL Database");  //WDC

//         CASE Setup."SQL Authentication" OF
//             Setup."SQL Authentication"::"SQL User":
//                 BEGIN
//                     SQLConnectionStringBuilder.UserID(Setup."SQL User");
//                     SQLConnectionStringBuilder.Password(Setup."SQL Password");
//                 END;

//             Setup."SQL Authentication"::"Windows User":
//                 BEGIN
//                     SQLConnectionStringBuilder.IntegratedSecurity(TRUE);
//                 END;
//         END;

//         // connect
//         Connection := Connection.SqlConnection(SQLConnectionStringBuilder.ConnectionString);
//         Connection.Open();

//         IF Connection.State <> 1 THEN
//             EXIT;

//         EDEL := ' DELETE FROM  [KBE-SCS].dbo.[KBE-TN$Gen_ Journal Line] WHERE [Journal Template Name] =' + '''' + 'PAIE' + '''' + ' AND [Journal Batch Name]=' + '''' + 'PAIE' + '''';

//         //--NEW SQL
//         Company := GetSQLName(Setup."SQL Company Name") + '$';
//         //command 1 Suppression des écritures du journal paie
//         SQLCommand := Connection.CreateCommand();
//         SQLCommand.CommandText := EDEL;
//         //2202 SQLCommand.CommandTimeout(10);
//         SQLDataReader := SQLCommand.ExecuteReader();
//         SQLCommand.Dispose();
//         SQLDataReader.Dispose();
//         Connection.Close();
//     end;

//     // local procedure CheckLots(): Boolean
//     // var
//     //     PurchLine: Record 39;
//     //     ItemLedgerEntry: Record 32;
//     // begin

//     //     IF global_Lotlist_TEMP.ISEMPTY THEN
//     //         EXIT(FALSE);
//     //     //bestellung finden
//     //     IF global_Lotlist_TEMP.FIND('-') THEN
//     //         REPEAT
//     //             PurchLine.SETCURRENTKEY("Document Type", "Document No.", Type, "No.");
//     //             PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
//     //             PurchLine.SETRANGE("Document No.", global_Lotlist_TEMP."Purchase Order No.");  //ExtDocNo
//     //             PurchLine.SETRANGE(Type, PurchLine.Type::Item);
//     //             PurchLine.SETRANGE(Position, global_Lotlist_TEMP."No. in Set");      //RefPosition
//     //             IF PurchLine.COUNT > 1 THEN EXIT(FALSE); //Mehrdeutig, zuordnung nicht möglich
//     //             IF PurchLine.FINDFIRST THEN BEGIN
//     //                 global_Lotlist_TEMP."Purchase Order Line No." := PurchLine."Line No.";
//     //                 global_Lotlist_TEMP."Item No." := PurchLine."No.";
//     //                 global_Lotlist_TEMP."Variant Code" := PurchLine."Variant Code";
//     //             END;

//     //             //2.test falls erster kein ergebnis erbracht. suche bestellung via artikel
//     //             IF (global_Lotlist_TEMP."Purchase Order Line No." = 0) AND (global_Lotlist_TEMP."Item No." <> '') THEN BEGIN
//     //                 PurchLine.SETCURRENTKEY("Document Type", "Document No.", Type, "No.");
//     //                 PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
//     //                 PurchLine.SETRANGE("Document No.", global_Lotlist_TEMP."Purchase Order No.");
//     //                 PurchLine.SETRANGE(Type, PurchLine.Type::Item);
//     //                 PurchLine.SETRANGE("No.", global_Lotlist_TEMP."Item No.");
//     //                 IF PurchLine.COUNT > 1 THEN EXIT(FALSE);  //Mehrdeutig
//     //                 IF PurchLine.FINDFIRST THEN
//     //                     global_Lotlist_TEMP."Purchase Order Line No." := PurchLine."Line No.";
//     //             END;

//     //             //3. test falls bis hier nichts passiert
//     //             IF global_Lotlist_TEMP."Purchase Order Line No." = 0 THEN
//     //                 EXIT(FALSE);

//     //             //last but not least: überprüfe bestellung ob es bereits buchungen gibt
//     //             PurchLine.RESET;
//     //             IF PurchLine.GET(1, global_Lotlist_TEMP."Purchase Order No.", global_Lotlist_TEMP."Purchase Order Line No.") THEN BEGIN
//     //                 ItemLedgerEntry.RESET;
//     //                 ItemLedgerEntry.SETRANGE("Item No.", PurchLine."No.");
//     //                 ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
//     //                 ItemLedgerEntry.SETRANGE("Variant Code", PurchLine."Variant Code");
//     //                 ItemLedgerEntry.SETRANGE(Positive, TRUE);
//     //                 ItemLedgerEntry.SETRANGE("External Lot No.", global_Lotlist_TEMP."Lot No.");
//     //                 ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
//     //                 ItemLedgerEntry.SETRANGE("Source No.", PurchLine."Buy-from Vendor No.");
//     //                 ItemLedgerEntry.SETRANGE("Source Type", ItemLedgerEntry."Source Type"::Vendor);
//     //                 IF ItemLedgerEntry.FINDFIRST THEN
//     //                     global_Lotlist_TEMP.DELETE
//     //                 ELSE
//     //                     global_Lotlist_TEMP.MODIFY;
//     //                 //    EXIT(FALSE);//es dürften hier keine treffer geben, sonst fehler
//     //             END;
//     //         //  global_Lotlist_TEMP.MODIFY; // wenn alles gut läuft, sollen änderungen für später gespeichert werden.

//     //         UNTIL global_Lotlist_TEMP.NEXT() = 0;



//     //     EXIT(TRUE);
//     // end;

//     // local procedure SaveLots()
//     // var
//     //     PurchaseLine: Record 39;
//     //     MobileProcessItemData: Record 94303;
//     // begin
//     //     global_Lotlist_TEMP.RESET;

//     //     IF global_Lotlist_TEMP.FIND('-') THEN
//     //         REPEAT
//     //             PurchaseLine.GET(1, global_Lotlist_TEMP."Purchase Order No.", global_Lotlist_TEMP."Purchase Order Line No.");
//     //             PurchaseLine.TESTFIELD("Prod. Order No.", '');

//     //             MobileProcessItemData.RESET;
//     //             MobileProcessItemData.SETRANGE("Process No.", 'KBE_WHSE_RECEIPT');
//     //             MobileProcessItemData.SETRANGE(Source, 'CODEUNIT_IMPORT');
//     //             MobileProcessItemData.SETRANGE("Item No.", global_Lotlist_TEMP."Item No.");
//     //             MobileProcessItemData.SETRANGE("Variant Code", global_Lotlist_TEMP."Variant Code");
//     //             MobileProcessItemData.SETRANGE("Lot No.", global_Lotlist_TEMP."Lot No.");
//     //             MobileProcessItemData.SETRANGE(Processed, FALSE);
//     //             IF NOT MobileProcessItemData.FINDFIRST THEN BEGIN
//     //                 MobileProcessItemData.RESET;
//     //                 MobileProcessItemData.SETRANGE("Process No.", 'KBE_WHSE_RECEIPT');
//     //                 MobileProcessItemData.SETRANGE(Source, 'CODEUNIT_IMPORT');
//     //                 IF MobileProcessItemData.FINDLAST THEN
//     //                     MobileProcessItemData."Line No." += 1
//     //                 ELSE BEGIN
//     //                     MobileProcessItemData."Process No." := 'KBE_WHSE_RECEIPT';
//     //                     MobileProcessItemData.Source := 'CODEUNIT_IMPORT';
//     //                     MobileProcessItemData."Line No." := 1;
//     //                 END;
//     //                 MobileProcessItemData.INIT;
//     //                 MobileProcessItemData.INSERT;
//     //             END;

//     //             MobileProcessItemData."Item No." := global_Lotlist_TEMP."Item No.";
//     //             MobileProcessItemData."Variant Code" := global_Lotlist_TEMP."Variant Code";
//     //             MobileProcessItemData."Lot No." := global_Lotlist_TEMP."Lot No.";
//     //             MobileProcessItemData.Description := ''; //external LC
//     //             MobileProcessItemData."Document No." := global_Lotlist_TEMP."Purchase Order No.";
//     //             MobileProcessItemData."Document Line No." := global_Lotlist_TEMP."Purchase Order Line No.";
//     //             IF global_Lotlist_TEMP."geb. Wa" = '' THEN ERROR('');
//     //             MobileProcessItemData."Whse. Document No." := global_Lotlist_TEMP."geb. Wa";
//     //             MobileProcessItemData."Length (M)" := global_Lotlist_TEMP."Lead Diameter Actual";          //meter
//     //             MobileProcessItemData."Total Quantity (Base)" := global_Lotlist_TEMP."Qty. Whse. Receipt";//menge kg
//     //             MobileProcessItemData.MODIFY;

//     //         UNTIL global_Lotlist_TEMP.NEXT() = 0;
//     // end;

//     // local procedure FinishImport()
//     // var
//     //     MobileProcessItemDataTemp: Record "94303" temporary;
//     //     MobileProcessItemData: Record "94303";
//     //     WhseRequest: Record "5765";
//     //     WhseRcptHeader: Record "7316";
//     //     WhseRcptLine: Record "7317";
//     //     GetSourceDocuments: Report "5753";
//     //     TotalQtyToReceive: Decimal;
//     //     ReservMgt: Codeunit "99000845";
//     //     TrackingSpecification: Record "336";
//     //     CalcReservEntry: Record "337";
//     //     LCType: Code[20];
//     //     ExternalLotNo: Code[20];
//     //     CurrentUoMCode: Code[10];
//     //     ExtLCNo: Text[30];
//     //     Purchline: Record "39";
//     //     PurchLineReserve: Codeunit "99000834";
//     //     Quant_meter: Decimal;
//     //     Quant_kg: Decimal;
//     //     LotNoInfo: Record "6505";
//     //     GeneralMgmt: Codeunit "50073";
//     //     LotNo: Code[30];
//     //     ItemTrackingMgt: Codeunit "6500";
//     //     CurrReservEntryStatus: Option Reservation,Tracking,Surplus,Prospect;
//     //     CreateReservEntry: Codeunit "99000830";
//     //     TotalWeightNet: Decimal;
//     // begin
//     //     MobileProcessItemData.RESET;
//     //     MobileProcessItemData.SETRANGE("Process No.", 'KBE_WHSE_RECEIPT');
//     //     MobileProcessItemData.SETRANGE(Source, 'CODEUNIT_IMPORT');
//     //     MobileProcessItemData.SETRANGE(Processed, FALSE);
//     //     IF NOT MobileProcessItemData.FIND('-') THEN
//     //         ERROR('Es gibt nichts zu buchen.');

//     //     //die unterschiedlichen Lieferscheine müssen hier nicht gespeichert werden, es gibt nur einen(code aus vorlage entfernt)

//     //     REPEAT
//     //         //nach Bestellnummer gruppieren
//     //         MobileProcessItemData.SETRANGE("Document No.", MobileProcessItemData."Document No.");

//     //         //erwartet lagerbewegung
//     //         WhseRequest.RESET;
//     //         WhseRequest.SETRANGE(WhseRequest.Type, WhseRequest.Type::Inbound);
//     //         WhseRequest.SETRANGE("Source Type", 39);
//     //         WhseRequest.SETRANGE("Source Subtype", 1);
//     //         WhseRequest.SETRANGE("Source No.", MobileProcessItemData."Document No.");
//     //         WhseRequest.SETRANGE("Document Status", WhseRequest."Document Status"::Released);
//     //         WhseRequest.SETRANGE("Completely Handled", FALSE);
//     //         IF NOT WhseRequest.FINDSET(FALSE, FALSE) THEN
//     //             ERROR('Fehler, keine "Erwartete Lagerbewegung" gefunden');

//     //         //wareneingangs zeile, falls möglich
//     //         WhseRcptLine.RESET;
//     //         WhseRcptLine.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Source Line No.");
//     //         WhseRcptLine.SETRANGE("Source Type", WhseRequest."Source Type");
//     //         WhseRcptLine.SETRANGE("Source Subtype", WhseRequest."Source Subtype");
//     //         WhseRcptLine.SETRANGE("Source No.", WhseRequest."Source No.");
//     //         IF WhseRcptLine.FINDFIRST THEN
//     //             WhseRcptHeader.GET(WhseRcptLine."No.")
//     //         ELSE BEGIN
//     //             WhseRcptHeader.INIT;
//     //             WhseRcptHeader."No." := '';
//     //             WhseRcptHeader."Location Code" := WhseRequest."Location Code";
//     //             //neuen wareneingang erstellen
//     //             WhseRcptHeader.INSERT(TRUE);
//     //         END;

//     //         //global Whse number
//     //         WhseNo := WhseRcptHeader."No.";

//     //         WhseRcptHeader."Assigned User ID" := 'MDE';
//     //         WhseRcptHeader."Assignment Date" := TODAY;
//     //         WhseRcptHeader."Assignment Time" := TIME;
//     //         WhseRcptHeader."Vendor Shipment No." := MobileProcessItemData."Whse. Document No.";
//     //         WhseRcptHeader.MODIFY;

//     //         WhseRcptLine.SETRANGE("No.", WhseRcptHeader."No.");
//     //         WhseRcptLine.DELETEALL;

//     //         CLEAR(GetSourceDocuments);
//     //         GetSourceDocuments.SetHideDialog(TRUE);
//     //         GetSourceDocuments.SetOneCreatedReceiptHeader(WhseRcptHeader);
//     //         GetSourceDocuments.USEREQUESTPAGE(FALSE);
//     //         GetSourceDocuments.SETTABLEVIEW(WhseRequest);
//     //         GetSourceDocuments.RUNMODAL;

//     //         WhseRcptLine.SETRANGE("No.", WhseRcptHeader."No.");
//     //         IF NOT WhseRcptLine.FINDSET(FALSE, FALSE) THEN
//     //             ERROR('Keine Wareneingangszeilen gefunden');

//     //         //main
//     //         REPEAT
//     //             MobileProcessItemData.SETRANGE("Document Line No.", MobileProcessItemData."Document Line No.");
//     //             MobileProcessItemData2.COPY(MobileProcessItemData);
//     //             MobileProcessItemData2.CALCSUMS("Length (M)");  // total "meter" of all lots
//     //             TotalQtyToReceive := MobileProcessItemData2."Length (M)";
//     //             MobileProcessItemData2.CALCSUMS("Total Quantity (Base)");
//     //             TotalWeightNet := MobileProcessItemData2."Total Quantity (Base)";
//     //             // Find Warehouse Receipt Line for current Purchase Line
//     //             WhseRcptLine.RESET;
//     //             WhseRcptLine.SETCURRENTKEY("No.", "Source Type", "Source Subtype", "Source No.", "Source Line No.");
//     //             WhseRcptLine.SETRANGE("No.", WhseRcptHeader."No.");
//     //             WhseRcptLine.SETRANGE("Source Type", 39);
//     //             WhseRcptLine.SETRANGE("Source Subtype", 1);
//     //             WhseRcptLine.SETRANGE("Source No.", MobileProcessItemData."Document No.");
//     //             WhseRcptLine.SETRANGE("Source Line No.", MobileProcessItemData."Document Line No.");
//     //             IF NOT WhseRcptLine.FINDFIRST THEN
//     //                 ERROR(Text008, MobileProcessItemData."Document No.", MobileProcessItemData."Document Line No.");

//     //             // Adjust "Qty. to Receive"
//     //             IF WhseRcptLine."Qty. to Receive" <> TotalQtyToReceive THEN BEGIN
//     //                 WhseRcptLine.VALIDATE("Qty. to Receive", TotalQtyToReceive);
//     //                 WhseRcptLine.MODIFY;
//     //             END;
//     //             WhseRcptLine.VALIDATE("Weight of Qty. to Receive", TotalWeightNet);
//     //             WhseRcptLine.MODIFY;


//     //             Purchline.GET(1, MobileProcessItemData."Document No.", MobileProcessItemData."Document Line No.");
//     //             PurchLineReserve.InitTrackingSpecification(Purchline, TrackingSpecification);

//     //             CLEAR(ReservMgt);
//     //             ReservMgt.SetCalcReservEntry(TrackingSpecification, CalcReservEntry);
//     //             ReservMgt.SetItemTrackingHandling(1); // Allow Deletion
//     //             ReservMgt.DeleteReservEntries(TRUE, 0);

//     //             // Create Lot No. Information & Item Tracking for all scanned Lots for current Purchase Line
//     //             REPEAT
//     //                 LCType := Purchline."Trading Unit Type Code";
//     //                 ExternalLotNo := MobileProcessItemData."Lot No.";
//     //                 ExtLCNo := MobileProcessItemData.Description;
//     //                 Quant_meter := MobileProcessItemData."Length (M)";
//     //                 Quant_kg := MobileProcessItemData."Total Quantity (Base)";

//     //                 //check if this lots has already been processed
//     //                 IF MobileProcessItemData."New Lot No." = '' THEN BEGIN
//     //                     LotNoInfo."Lot No." := '';
//     //                     GeneralMgmt.CreateLotNoInfo_WhseRcpt(WhseRcptLine, LotNoInfo, LCType, ExternalLotNo, ExtLCNo, 0, 0, 0, Quant_meter, Purchline."Unit of Measure");
//     //                     LotNo := LotNoInfo."Lot No.";

//     //                     MobileProcessItemData."New Lot No." := LotNo;
//     //                     MobileProcessItemData.MODIFY; //memorizes that it has been processed
//     //                 END ELSE
//     //                     LotNo := MobileProcessItemData."New Lot No.";

//     //                 CreateReservEntry.SetCreatedBy('DATA_IMPORT');
//     //                 CreateReservEntry.CreateReservEntryForTradgUnit(LotNo, '');
//     //                 CreateReservEntry.SetAddDataQM(1, ExternalLotNo, 0D, 0D, TODAY, '', '', '', 0D, 0D, 0D, 0D, 0D);


//     //                 //create item tracking
//     //                 IF ItemTrackingMgt.IsOrderNetworkEntity(WhseRcptLine."Source Type", WhseRcptLine."Source Subtype") THEN
//     //                     CurrReservEntryStatus := CurrReservEntryStatus::Surplus
//     //                 ELSE
//     //                     CurrReservEntryStatus := CurrReservEntryStatus::Prospect;

//     //                 WITH WhseRcptLine DO BEGIN
//     //                     CreateReservEntry.CreateReservEntryFor(
//     //                           "Source Type",
//     //                           "Source Subtype",
//     //                           "Source No.",
//     //                           '',
//     //                           0,
//     //                           "Source Line No.",
//     //                           "Qty. per Unit of Measure",
//     //                           MobileProcessItemData."Length (M)",
//     //                           ROUND(MobileProcessItemData."Length (M)" * "Qty. per Unit of Measure", 0.00001),
//     //                           '',
//     //                           LotNo);

//     //                     CreateReservEntry.CreateEntry(
//     //                           "Item No.",
//     //                           "Variant Code",
//     //                           "Location Code",
//     //                           Description,
//     //                           0D, "Due Date", 0, CurrReservEntryStatus);
//     //                 END;


//     //             UNTIL MobileProcessItemData.NEXT() = 0; //item tracking & co. KG (i take no responsibility)

//     //             WhseRcptLine."Mobile Dialog Processed" := TRUE;
//     //             WhseRcptLine.MODIFY;

//     //             MobileProcessItemData.SETRANGE("Document Line No.");

//     //         UNTIL MobileProcessItemData.NEXT() = 0; // main

//     //         //mark lines as processed
//     //         MobileProcessItemData2.COPY(MobileProcessItemData);
//     //         MobileProcessItemData2.FINDSET;
//     //         REPEAT
//     //             MobileProcessItemData2.MARK(TRUE);
//     //         UNTIL MobileProcessItemData2.NEXT() = 0;
//     //         MobileProcessItemData2.MODIFYALL(Processed, TRUE);  //danach werden diese zeilen nicht mehr im filter erscheinen

//     //         //post current WE
//     //         PostWhse(WhseNo);
//     //         WE_counter += 1;

//     //         //reset Doc-No and step to next purchase order
//     //         MobileProcessItemData.SETRANGE("Document No.");
//     //     UNTIL MobileProcessItemData.NEXT() = 0;
//     // end;

//     // local procedure PostWhse(WE_No: Code[30])
//     // var
//     //     WhseRcptHeader: Record "7316";
//     //     WhseRcptLine: Record "7317";
//     //     WhsePostReceipt: Codeunit "5760";
//     // begin

//     //     WhseRcptLine.SETRANGE("No.", WE_No);
//     //     IF NOT WhseRcptLine.FINDFIRST THEN BEGIN
//     //         MESSAGE(STRSUBSTNO('Wareneingangsnummer: %1 ist ungültig', WE_No));
//     //         MobileProcessItemData2.SETRANGE(Processed);
//     //         MobileProcessItemData2.MARKEDONLY(TRUE);
//     //         MobileProcessItemData2.MODIFYALL(Processed, FALSE);    //ermöglicht bei fehler ein erneutes buchen
//     //         COMMIT;
//     //     END;

//     //     WhseRcptHeader.GET(WhseRcptLine."No.");
//     //     IF WhseRcptHeader."Posting Date" <> WORKDATE THEN BEGIN
//     //         WhseRcptHeader.VALIDATE("Posting Date", WORKDATE);
//     //         WhseRcptHeader.MODIFY;
//     //     END;

//     //     //// Post
//     //     CLEAR(WhsePostReceipt);
//     //     WhsePostReceipt.SetHideValidationDialog(TRUE);
//     //     WhsePostReceipt.RUN(WhseRcptLine);
//     // end;



//     // local procedure GetSQLFieldValue(var SQLDataReader: DotNet SqlDataReader; SQLFieldName: Text; SQLFieldType: Code[10]): Text
//     // var
//     //     Index: Integer;
//     // begin
//     //     SQLFieldName := GetSQLName(SQLFieldName);

//     //     // get ordinal
//     //     Index := SQLDataReader.GetOrdinal(SQLFieldName);

//     //     IF SQLDataReader.IsDBNull(Index) THEN
//     //         EXIT('');

//     //     CASE SQLFieldType OF
//     //         'VARCHAR':
//     //             EXIT(FORMAT(SQLDataReader.GetString(Index)));
//     //         'DECIMAL':
//     //             EXIT(FORMAT(SQLDataReader.GetDecimal(Index)));
//     //         'INTEGER':
//     //             EXIT(FORMAT(SQLDataReader.GetInt32(Index)));
//     //         'BOOLEAN':
//     //             EXIT(FORMAT(SQLDataReader.GetBoolean(Index)));
//     //         'DATE', 'DATETIME', 'TIME':
//     //             EXIT(FORMAT(SQLDataReader.GetDateTime(Index)));
//     //     END;

//     //     // default return
//     //     EXIT('');
//     // end;

//     local procedure GetSQLName(Name: Text): Text
//     begin
//         EXIT(CONVERTSTR(Name, '[]."\/''%', '________'));
//     end;

//     // local procedure FN2SQL(FieldName: Text): Text
//     // begin
//     //     EXIT('[' + GetSQLName(FieldName) + ']');
//     // end;

//     // local procedure EscapeValue(Text: Text[512]): Text[512]
//     // var
//     //     Management: Codeunit 5344982;
//     // begin
//     //     EXIT(STRREPLACE('''', '''''', Text)); // escape apostrophe
//     // end;

//     local procedure STRREPLACE(Search: Text[1024]; Replace: Text[1024]; Subject: Text[1024]): Text[1024]
//     var
//         Position: Integer;
//         FirstPart: Text[1024];
//     begin
//         // not found
//         IF (STRPOS(Subject, Search) = 0) THEN
//             EXIT(Subject);

//         // first position
//         Position := STRPOS(Subject, Search);

//         // get first part
//         IF (Position > 1) THEN BEGIN
//             FirstPart := COPYSTR(Subject, 1, Position - 1) + Replace;
//         END ELSE BEGIN
//             FirstPart := Replace;
//         END;

//         EXIT(FirstPart + STRREPLACE(Search, Replace, DELSTR(Subject, 1, Position + STRLEN(Search) - 1)));
//     end;

//     procedure InsertSQL()
//     var
//         SQLDataReader: DotNet SqlDataReader;
//         Connection: DotNet SqlConnection;
//         Setup: Record 50061;
//         SQLConnectionStringBuilder: DotNet SqlConnectionStringBuilder;
//         SQLServerString: Text[1024];
//         Company: Text;
//         "Schema": Text;
//         SQLCommand: DotNet SqlCommand;
//         SQL_SELECT: Text;
//         SQL_FROM: Text;
//         SQL_WHERE: Text;
//         DLBSalesOrderNo: Code[20];
//         RefPosition: Code[20];
//         varchar_text: Text;
//     begin
//         // hole lieferschein und schreib in globale temp_tabelle

//         //lade konfiguration
//         Setup.GET(2);
//         //Connection-String bauen
//         SQLServerString := Setup."SQL Server";
//         IF Setup."SQL Instance" <> '' THEN
//             SQLServerString += STRSUBSTNO('\%1', Setup."SQL Instance");
//         IF Setup."SQL Port" <> 0 THEN
//             SQLServerString += STRSUBSTNO(',%1', Setup."SQL Port");

//         // build connection string
//         SQLConnectionStringBuilder := SQLConnectionStringBuilder.SqlConnectionStringBuilder();
//         SQLConnectionStringBuilder.DataSource(SQLServerString);
//         SQLConnectionStringBuilder.ConnectTimeout(60);
//         SQLConnectionStringBuilder.Pooling(FALSE);
//         SQLConnectionStringBuilder.InitialCatalog(Setup."SQL Database");  //WDC

//         CASE Setup."SQL Authentication" OF
//             Setup."SQL Authentication"::"SQL User":
//                 BEGIN
//                     SQLConnectionStringBuilder.UserID(Setup."SQL User");
//                     SQLConnectionStringBuilder.Password(Setup."SQL Password");
//                 END;

//             Setup."SQL Authentication"::"Windows User":
//                 BEGIN
//                     SQLConnectionStringBuilder.IntegratedSecurity(TRUE);
//                 END;
//         END;

//         // connect
//         Connection := Connection.SqlConnection(SQLConnectionStringBuilder.ConnectionString);
//         Connection.Open();

//         IF Connection.State <> 1 THEN
//             EXIT;
//         //--NEW SQL
//         T1 := '[Journal Template Name], [Journal Batch Name], [Line No_], [Account Type], [Account No_],';
//         T2 := '[Posting Date], [Document Type], [Document No_], Description, [VAT _], [Bal_ Account No_], ';
//         T3 := '[Currency Code], Amount, [Debit Amount], [Credit Amount],[Amount (LCY)], [Balance (LCY)], ';
//         T4 := '[Currency Factor], [Sales_Purch_ (LCY)], [Profit (LCY)], [Inv_ Discount (LCY)], ';
//         T5 := '[Bill-to_Pay-to No_], [Posting Group], [Shortcut Dimension 1 Code], [Shortcut Dimension 2 Code],';
//         T6 := '[Salespers__Purch_ Code], [Source Code],[System-Created Entry], [On Hold], [Applies-to Doc_ Type], ';
//         T7 := '[Applies-to Doc_ No_], [Due Date], [Pmt_ Discount Date], [Payment Discount _], [Job No_], Quantity, ';
//         T8 := '[VAT Amount], [VAT Posting], [Payment Terms Code], [Applies-to ID], [Business Unit Code], [Reason Code], ';
//         T9 := '[Recurring Method], [Expiration Date], [Recurring Frequency], [Gen_ Posting Type], [Gen_ Bus_ Posting Group],';
//         T10 := '[Gen_ Prod_ Posting Group], [VAT Calculation Type], [EU 3-Party Trade], [Allow Application], ';
//         T11 := '[Bal_ Account Type], [Bal_ Gen_ Posting Type],[Bal_ Gen_ Bus_ Posting Group], [Bal_ Gen_ Prod_ Posting Group], ';
//         T12 := '[Bal_ VAT Calculation Type], [Bal_ VAT _], [Bal_ VAT Amount], [Bank Payment Type], [VAT Base Amount],';
//         T13 := '[Bal_ VAT Base Amount], Correction, [Check Printed], [Document Date],[External Document No_], ';
//         T14 := '[Source Type], [Source No_], [Posting No_ Series], [Tax Area Code], [Tax Liable], [Tax Group Code], ';
//         T15 := '[Use Tax], [Bal_ Tax Area Code], [Bal_ Tax Liable], [Bal_ Tax Group Code], [Bal_ Use Tax], [VAT Bus_ Posting Group], ';
//         T16 := '[VAT Prod_ Posting Group], [Bal_ VAT Bus_ Posting Group], [Bal_ VAT Prod_ Posting Group], [Additional-Currency Posting],';
//         T17 := '[FA Add_-Currency Factor], [Source Currency Code], [Source Currency Amount], [Source Curr_ VAT Base Amount],';
//         T18 := '[Source Curr_ VAT Amount], [VAT Base Discount _], [VAT Amount (LCY)], [VAT Base Amount (LCY)], ';
//         T19 := '[Bal_ VAT Amount (LCY)], [Bal_ VAT Base Amount (LCY)], [Reversing Entry], [Allow Zero-Amount Posting], ';
//         T20 := '[Ship-to_Order Address Code], [VAT Difference], [Bal_ VAT Difference], [IC Partner Code], ';
//         T21 := '[IC Direction], [IC Partner G_L Acc_ No_], [IC Partner Transaction No_], [Sell-to_Buy-from No_], ';
//         T22 := '[VAT Registration No_], [Country_Region Code], Prepayment, [Financial Void], [Incoming Document Entry No_], ';
//         T23 := '[Creditor No_], [Payment Reference], [Payment Method Code],[Applies-to Ext_ Doc_ No_], [Recipient Bank Account], ';
//         T24 := '[Message to Recipient], [Exported to Payment File], [Dimension Set ID], [Credit Card No_], [Job Task No_], ';
//         T25 := '[Job Unit Price (LCY)], [Job Total Price (LCY)], [Job Quantity], [Job Unit Cost (LCY)], [Job Line Discount _], ';
//         T26 := '[Job Line Disc_ Amount (LCY)], [Job Unit Of Measure Code], [Job Line Type], [Job Unit Price], [Job Total Price], ';
//         T27 := '[Job Unit Cost], [Job Total Cost], [Job Line Discount Amount], [Job Line Amount], [Job Total Cost (LCY)], ';
//         T28 := '[Job Line Amount (LCY)], [Job Currency Factor],[Job Currency Code], [Job Planning Line No_], [Job Remaining Qty_], ';
//         T29 := '[Direct Debit Mandate ID], [Posting Exch_ Entry No_], [Payer Information], [Transaction Information],';
//         T30 := '[Posting Exch_ Line No_], [Applied Automatically], [Campaign No_], [Prod_ Order No_], ';
//         T31 := '[FA Posting Date], [FA Posting Type], [Depreciation Book Code], [Salvage Value], [No_ of Depreciation Days],';
//         T32 := '[Depr_ until FA Posting Date], [Depr_ Acquisition Cost], [Maintenance Code], [Insurance No_], [Budgeted FA No_],';
//         T33 := '[Duplicate in Depreciation Book],[Use Duplication List], [FA Reclassification Entry], [FA Error Entry No_],';
//         T34 := '[Index Entry], [Source Line No_], Comment, [Transit Entry], [Payment File created], [Payment Type], ';
//         T35 := '[Payment Order No_], [Debit Date], [Date Pre-Notification], [Mandate No_], [Mandate invalid], ';
//         T36 := '[Debit Date expired], [Due Date SEPA], [Mandate type], [Creation Date Payment File], [Mandate debit type],';
//         T37 := '[Line created manually], [Creditor-ID Vendor], [Created by], [BOM Document Type], [BOM Document No_], ';
//         T38 := '[BOM Document Line No_], [BOM Lfd_ Nr_],[Advance Payment], [Advance Payment No_], [Advance Payment Type], ';
//         T39 := '[Adv_ Payment Sequential No_], Secured, [Related to Adv_ Paym_ Entry], [Advance Payment Allocation No_],';
//         T40 := '[Queue Status], [Queue Last Modified Date], [Last Queue Message],[Queue Document No_], [Queue User ID], ';
//         T41 := '[Applied Account Type], [Applied Account No_], [Applied by], [ID Applied-Entry], [Posting Payment Discount], ';
//         T42 := '[Posting Payment Discount _], [Pmt_ Import Entry No_], [Suppress CurrCode Validation], [Application Status],';
//         T43 := 'Payback,[Reopen-to ID], [Payback Processed], [Bank Account No__IBAN Code],[Bank Branch Code_BIC-Code], ';
//         T44 := '[Check No_], [Original Currency Factor], [Invoice Entrance Date], [Payment in Process], [Mandate ID], ';
//         T45 := '[PIP Account Type], [Customer Reference No_],[Job Line Unique No_], [Usage Job No_], [Usage Job Line Unique No_], [Usage WBS], ';
//         T46 := '[WIP Posting], [Deduction (Amount)], [EDI Additional Information]';
//         CUMT := T1 + T2 + T3 + T4 + T5 + T6 + T7 + T8 + T9 + T10 + T11 + T12 + T13 + T14 + T15 + T16 + T17 + T18 + T19 + T20 + T21 + T22 + T23 + T24 + T25 + T26 + T27 + T28 + T29 + T30 + T31 + T32 + T33 + T34 + T35 + T36 + T37 + T38 + T39 + T40 + T41 + T42 + T43 + T44 + T45 + T46;
//         ET1 := 'insert into  [KBE-SCS].dbo.[KBE-TN$Gen_ Journal Line]';
//         ET2 := ET1 + '( ' + CUMT + ') ';
//         ET3 := ET2 + '( Select ' + CUMT;
//         TP := 'PAIE';
//         ET4 := ET3 + ' FROM  [KBE-SCS-Payroll].dbo.[KBE-TN$Gen_ Journal Line] WHERE [Journal Template Name] =' + '''' + 'PAIE' + '''' + ' AND [Journal Batch Name]=' + '''' + 'PAIE' + '''' + ')';
//         //--NEW SQL
//         Company := GetSQLName(Setup."SQL Company Name") + '$';
//         SQLCommand := Connection.CreateCommand();
//         SQLCommand.CommandText := ET4;
//         SQLCommand.CommandTimeout(10);
//         SQLDataReader := SQLCommand.ExecuteReader();
//         SQLCommand.Dispose();
//         SQLDataReader.Dispose();
//         Connection.Close();
//         MESSAGE('Insertion du journal de paie effectuée avec succès');
//     end;
// }



