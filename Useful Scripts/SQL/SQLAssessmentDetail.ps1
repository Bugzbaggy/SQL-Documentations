//let selectedCategories = dynamic([]);
//let selectedTotSev = dynamic(["High","Medium","Low","Information","Warning","Critical"]);
SqlAssessment_CL
| where _ResourceId =~ "/subscriptions/3a8032ca-dc2c-4137-9f64-f8daaa55c78d/resourceGroups/sap-pb3-prd-rg/providers/Microsoft.Compute/virtualMachines/azsappdb25"
| extend asmt = parse_csv(RawData)
| extend AsmtId=tostring(asmt[1]), CheckId=tostring(asmt[2]), DisplayString=asmt[3], Description=tostring(asmt[4]), HelpLink=asmt[5], TargetType=case(asmt[6] == 1, "Server", asmt[6] == 2, "Database", ""), TargetName=tostring(asmt[7]), 
    Severity=case(asmt[8] == 30, "High", asmt[8] == 20, "Medium", asmt[8] == 10, "Low", asmt[8] == 0, "Information", asmt[8] == 1, "Warning", asmt[8] == 2, "Critical", "Passed"), Message=tostring(asmt[9]), TagsArr=split(tostring(asmt[10]), ","), Sev = toint(asmt[8])
| where AsmtId == "73d50b10-865a-4579-8fbe-5dcb19c48258" 
    and (set_has_element(dynamic(['*']), CheckId) or "'*'" == "'*'")
    and (set_has_element(dynamic(['*']), TargetName) or "'*'" == "'*'")
    and set_has_element(dynamic([30, 20, 10, 0]), Sev)
    and (array_length(set_intersect(TagsArr, dynamic(['*']))) > 0 or "'*'" == "'*'")
| extend Category = case(array_length(set_intersect(TagsArr, dynamic(["CPU", "IO", "Storage"]))) > 0, '0',
    array_length(set_intersect(TagsArr, dynamic(["TraceFlag", "Backup", "DBCC", "DBConfiguration", "SystemHealth", "Traces", "DBFileConfiguration", "Configuration", "Replication", "Agent", "Security", "DataIntegrity", "MaxDOP", "PageFile", "Memory", "Performance", "Statistics"]))) > 0, '1',
    array_length(set_intersect(TagsArr, dynamic(["UpdateIssues", "Index", "Naming", "Deprecated", "masterDB", "QueryOptimizer", "QueryStore", "Indexes"]))) > 0, '2',
    '3')
| extend Tags=strcat_array(array_slice(TagsArr, 1, -1), ',')
| extend SQLServer = Computer
| parse SQLServer with SQLServer "." * // "virtualMachines/" SQLServer   
| extend Environment = case(_ResourceId contains "2df031a7-e21f-49c7-b61e-b0bb3e097c79", 'DEV',
    _ResourceId contains "3a8032ca-dc2c-4137-9f64-f8daaa55c78d", 'PRD',
    _ResourceId contains "cbb944ea-aa79-4701-909a-e114ab57ad7a", 'TST',
    "--")
| extend SID = _ResourceId
| parse SID with * "sap-" SID "-" *
| summarize LatestAssessment = max(TimeGenerated) by SQLServer, SID, Environment, TargetType, TargetName, Severity, Message, Tags, Description, Sev, tostring(HelpLink)   
| where Sev >= 0 
    //and (Category in (selectedCategories) or array_length(selectedCategories) == 0)
| project
    LatestAssessment,
    SQLServer,
    SID,
    Environment,
    TargetType,
    TargetName,
    Severity,
    Message,
    Tags,
    Description,
    HelpLink = tostring(HelpLink),
    SeverityCode = toint(Sev)
    //Message
//| where LatestAssessment = max(TimeGenerated)
//| distinct * 
//| summarize LatestAssessment = max(TimeGenerated) by SeverityCode, Severity, Tags, CheckId
//| summarize Issues = count() by SQLServer, SID, Environment, LatestAssessment, SeverityCode, Severity, Tags, CheckId
//| project LatestAssessment, SQLServer, Environment, SID, Severity, Tags, CheckId, Issues, SeverityCode
| order by SeverityCode desc, TargetType desc, TargetName asc
| project-away SeverityCode

