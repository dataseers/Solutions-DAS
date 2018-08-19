IMPORT STD;

column_record := RECORD
    STRING50 column_label;
    Real     value;
END;

row_record := RECORD
    STRING50 series_label;
    DATASET(column_record) column_data;
END;

TransactionLayout := RECORD
  unsigned8 unique_id;
  string13 transaction_type;
  string36 account_number;
  string10 program_id;
  string50 program_name;
  string10 product_id;
  string50 product_desc;
  string36 card_id;
  string10 agent_user_id;
  string50 person_id;
  string50 network_code;
  string50 sub_network_code;
  string50 transaction_code;
  string100 transaction_desc;
  unsigned2 ds_transaction_code;
  string100 ds_transaction_desc;
  string50 transaction_id;
  string15 authorization_code;
  string65 authorization_desc;
  unsigned2 ds_authorization_code;
  string100 ds_authorization_desc;
  string25 auth_type_id;
  string65 auth_type_id_desc;
  string50 message_type;
  string65 message_type_desc;
  string5 pos_entry_mode;
  UNSIGNED1 international_trasaction_indicator_code;
  STRING20  international_trasaction_indicator_desc;
//   string4 pin_sig_flag;
  string50 address_verification_response;
  decimal18_5 transaction_amount;
  decimal18_5 fee_amt;
  decimal18_5 interchange_fee_amount;
  decimal18_5 acquirer_fee_amount;
  string1 transaction_impact;
  string3 transaction_currency_code_iso;
  string3 transaction_currency;
  string3 transaction_country_code_iso;
  string35 transaction_country;
  decimal18_5 processor_commission_amt;
  decimal18_5 store_commission_amt;
  string1 direct_deposit_indicator;
  string10 pos_indicator;
  string50 pos_indicator_desc;
  unsigned4 settlement_date;
  unsigned4 transaction_date;
  unsigned3 transaction_time;
  unsigned4 post_date;
  unsigned3 post_time;
  unsigned4 business_log_date;
  unsigned3 business_log_time;
  unsigned4 auth_expiration_date;
  unsigned3 auth_expiration_time;
  unsigned4 orig_transaction_date;
  unsigned3 orig_transaction_time;
  string50  orig_transaction_id;
  string64  orig_msg_type;
  string65  orig_msg_type_desc;
  decimal18_5 orig_txn_amount;
  string1 cvv_cvc;
  string1 cvv_cvc2;
  string20 store_number;
  string20 merchant_ref_num;
  string30 merchant_number;
  string50 merchant_name;
  string100 merchant_address;
  string50 merchant_city;
  string2 merchant_state;
  string3 merchant_country_code;
  string35 merchant_country;
  string10 merchant_zip;
  string4 merchant_category_code;
  string255 merchant_category;
  string100 origination_name;
  decimal18_5 requested_amt;
  decimal18_5 balance_amt;
  decimal18_5 ledger_balance;
  decimal18_5 available_balance;
  string255 credit_debit_notes;
  string255 credit_debit_reasons;
  string6 receipt_ref_num;
  unsigned4 src_created_date;
  unsigned3 src_created_time;
  string6 terminal_fiid;
  string16 terminal_identifier;
  string50 process_type;
  unsigned1 partial_preauth_ind;
  string2 cycle_number;
  decimal18_5 preauth_amt;
  unsigned1 preauth_ind;
  string50 card_owning_fiid;
  string15 duration;
  string50 card_bin_identifier;
  string100 preauthkey;
  string255 attribute1;
  string255 attribute2;
  string15 terminal_capability_id;
  unsigned1 is_card_holder_present;
  string100 token_id;
  decimal18_5 transcashback;
  string25 processor;
  unsigned4 as_of_date;
  unsigned4 filedate;
  string100 filename;
  unsigned4 processdate;
 END;

transactionds := DATASET('~.::dataseers::dev::superfiles::transaction::master',TransactionLayout, THOR);


getValueRec := RECORD
    STRING100   account_number;
    DECIMAL18_5  amount;
    UNSIGNED8 EachDay;
END;

getValues := TABLE(transactionds,{
    STRING100 account_number := transactionds.account_number;
    DECIMAL18_5 amount := transactionds.transaction_amount;
    UNSIGNED8 EachDay := STD.Date.Month(transactionds.as_of_date);
},account_number);

getValues;

byEachMonthColsGroup := GROUP(TOPN(getValues,100,account_number), EachDay);



row_Record doMonthRollup(getValueRec l, DATASET(getValueRec) allRows) := TRANSFORM
    SELF.series_label :=(STRING)l.EachDay; 
    SELF.column_data := PROJECT(allRows(eachDay = l.EachDay), TRANSFORM(column_record, SELF.column_label := (STRING50) LEFT.account_number, SELF.value := LEFT.amount));
END;

byMonthRows := ROLLUP(byEachMonthColsGroup, GROUP, doMonthRollup(LEFT,ROWS(LEFT)));


byMonthRows;
// ds1 := PROJECT(getValues,TRANSFORM(column_record,SELF.column_label := LEFT.account_number, SELF.value := LEFT.amount));



// ds2 := PROJECT(ds1,TRANSFORM(row_record,SELF.series_label := STD.Date.DateToString(getValues.EachDay,'%Y%m%d'),SELF := LEFT));

// ds := DATASET([{getValues.accountNumber,[{}, {'Q2',120000}, {'Q3',90000}, {'Q4',150000}]}, 
//                      {'CR-V',[{'Q1',150000}, {'Q2',170000}, {'Q3',190000}, {'Q4',250000}]},
//                      {'Civic',[{'Q1',300000}, {'Q2',320000}, {'Q3',390000}, {'Q4',250000}]},
//                      {'Pilot',[{'Q1',200000}, {'Q2',220000}, {'Q3',210000}, {'Q4',350000}]},
//                      {'HR-V',[{'Q1',460000}, {'Q2',420000}, {'Q3',200000}, {'Q4',250000}]},
//                      {'Odyssey',[{'Q1',300000}, {'Q2',350000}, {'Q3',150000}, {'Q4',370000}]}], row_record);


OUTPUT(byMonthRows,,NAMED('chart_data'));