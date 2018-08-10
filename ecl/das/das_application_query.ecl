appRec := RECORD
    STRING id;
    STRING title;
END;

_application_file := DATASET([{'cancer_research','Cancer Research'},{'sales_demo','Sales Demo' }], appRec) :STORED('application_file');
// _application_file := '~hpcc_das::config::apps.flat' :STORED('application_file');

// ds := DATASET(DYNAMIC(_application_file), appRec, FLAT);

OUTPUT(_application_file,,NAMED('application_data'));