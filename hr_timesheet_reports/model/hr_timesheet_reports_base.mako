<!DOCTYPE html SYSTEM
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<html>
<head>
    <style type="text/css">
        ${css}
        body {
            font-size: 9px;
        }
        p {
            font-size: 9px;
            line-height: 11px;
        }
        table p {
            font-size: 9px;
            line-height: 9px;
            padding: 0px;
            padding-bottom: 1px;
            margin: 0px;
        }
        table, th, td {
            border: 1px solid grey;
            border-collapse: collapse;
            text-align: center;
            font-size: 9px;
            padding: 3px;
            vertical-align: top;
        }
        th {
            border: 1px solid black;
        }
        .resume {
            text-align: left;
            border: none;
        }
        .description {
            text-align: left;
        }
        .duration {
            font-weight: bold;
        }
        .date {
            font-weight: bold;
        }
        .paid {
            color: green;
        }
        .unpaid {
            color: red;
        }
        .invoices_content table,
        .invoices_content th,
        .invoices_content td {
            border: none;
            text-align: center;
            font-size: 9px;
            padding: 3px;
            vertical-align: top;
        }
        .invoices_content td {
            width: 20%;
        }
        .invoices_content td.amount {
            text-align: right;
            width: 40%;
        }
        /**
        Fonts Size
        */
        h1, h2, h3, h4, h5 { line-height: auto; }
        h1 { font-size: 14px; }
        h2 { font-size: 13px; }
        h3 { font-size: 12px; }
        h4, h5 { font-size: 11px; }
        table.endpage
        {
            page-break-after: always;
        }
    </style>
</head>
<body style="border:0;">
    %for obj in objects :
        <h2>Report Name: ${obj.filter_id.name}</h2>
        <h3>
            Resumed Report.
        </h3>
        <p>
        ${obj.comment_timesheet}
        </p>
        <table class="resume endpage" style="border: none">
            <td style="border: none">
                <table>
                    <tr class="by_account">
                        <td colspan="2"> By Date </td>
                    </tr>
                    <tr class="title">
                        <td> Month </td>
                        <td> Hours </td>
                    </tr>
                    %for resume in obj.records['resume_month'] :
                        <tr class="by_account">
                            <td style="text-align: left;">
                            ${resume.get('date')}
                            </td>
                            <td>
                            ${formatLang(resume.get('unit_amount'))}
                            </td>
                        </tr>
                    %endfor
                </table>
            </td>
            <td style="border: none">
                <table>
                    <tr class="by_account">
                        <td colspan="2"> By Analytic </td>
                    </tr>
                    <tr class="title">
                        <td> Account </td>
                        <td> Hours </td>
                    </tr>
                    %for resume in obj.records['resume'] :
                    <tr class="by_account">
                        <td style="text-align: left;">
                        ${resume.get('account_id')[1].split('/')[-1]}
                        </td>
                        <td>
                        ${formatLang(resume.get('unit_amount', '0.00'))}
                        </td>
                    </tr>
                    %endfor
                </table>
            </td>
            <td style="border: none">
                % if obj.records.get('invoices', []):
                <table>
                <tr class="by_account">
                    <td colspan="2">Status of invoices until today in the project.</td>
                </tr>
                <tr class="title">
                    <td width="10%"> Period </td>
                    <td style="padding: 0px;">
                        <table width="100%">
                            <tr>
                            <td width="30%"> Invoice Number </td>
                            <td width="35%"> Total (Currency)</td>
                            <td width="35%"> Pending (Currency)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                %for period in obj.records['periods'] :
                    <tr>
                        <td width="10%" style="text-align: left;">
                        ${period.get('period_id')[1]}
                        </td>
                        <td  width="40%" class="invoices_content">
                            <table width="100%">
                                %for invoice in obj.records['invoices'] :
                                    % if invoice.period_id.id == period.get('period_id')[0]:
                                    % if invoice.residual > 1.00:
                                    <tr class="unpaid">
                                    % endif
                                    % if invoice.residual < 1.00:
                                    <tr class="paid">
                                    % endif
                                        <td> ${invoice.number} </td>
                                        <td class="amount"> ${formatLang(invoice.amount_total)} ( ${invoice.currency_id.name} )</td>
                                        <td class="amount"> ${formatLang(invoice.residual)} ( ${invoice.currency_id.name} )</td>
                                    </tr>
                                    % endif
                                %endfor
                            </table>
                        </td>
                    </tr>
                %endfor
                </table>
                % endif
            </td>
        </table>
        % if obj.records.get('issues', []):
        <h3> Issues. </h3>
        <p>
        ${obj.comment_issues}
        </p>
        <table width="50%" class="endpage">
            <tr class="by_account">
                <td colspan="3">Status of issues until today in the project.</td>
            </tr>
            <tr class="title">
                <td width="30%"> Analytic Account </td>
                <td width="10%"> Qty </td>
                <td width="60%"> Status </td>
            </tr>
            %for issue in obj.records['issues'] :
            <tr>
                <td width="30%" style="text-align: left;">
                    ${issue.get('analytic_account_id') and issue.get('analytic_account_id')[1] or 'Not analytic Setted.' }
                </td>
                <td  width="10%" class="invoices_content">
                    ${issue['analytic_account_id_count']}
                </td>
                <td  width="60%" style="text-align: right;" class="invoices_content">
                    %for stage in issue['children_by_stage'] :
                    <p style="padding-top:2px;">${stage['stage_id'][1]} - ${stage['stage_id_count']}</p>
                    %endfor
                </td>
            </tr>
            %endfor
        </table>
        % endif
        % if obj.records.get('user_stories', []):
        <h3> User Stories. </h3>
        <p>
        ${obj.comment_hu}
        </p>
        <table width="100%" class="endpage">
            <tr class="by_account">
                <td colspan="3">Status of issues until today in the project.</td>
            </tr>
            <tr class="title">
                <td width="10%"> ID </td>
                <td width="80%"> Title </td>
                <td width="10%"> Status </td>
            </tr>
            %for hu in obj.records['user_stories'] :
            <tr>
                <td width="10%" style="text-align: left;">
                    ${hu.id}
                </td>
                <td  width="80%" class="invoices_content">
                    ${hu.name}
                </td>
                <td  width="10%" style="text-align: right;" class="invoices_content">
                    ${hu.state}
                </td>
            </tr>
            %endfor
        </table>
        % endif
        <h3> Detailed Report. </h3>
        %for res in obj.records['data'] :
        <table width="100%" style="font-size: 14px;">
            <tr>
                <th colspan="5">
                <h3><b>Analytic Account:</b> ${res}</h3>
                </th>
            </tr>
            <tr>
                <th width="5%"> ID </th>
                <th width="10%"> User </th>
                <th> Description </th>
                <th> Date </th>
                <th> Duration </th>
            </tr>
            %for rec in obj.records['data'][res] :
            <tr>
                <td width="5%">
                    ${rec['id']}
                </td>
                <td width="10%">
                    ${rec['author']}
                </td>
                <td class="description">
                    ${rec['description']}
                </td>
                <td class="date" width="10%">
                    ${rec['date']}
                </td>
                <td class="duration">
                    ${formatLang(rec['duration'], digits=2)}
                </td>
            </tr>
            %endfor
        </table>
        %endfor
    <p>
    </p>
%endfor
</body>
</html>
