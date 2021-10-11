```bash
#data provided in the excel file was maintained manually for years and is assumed to be not correct. Some items have an expiration date passed or approaching and their status with further action plan need to be adjusted.
path_file=/home/anna/data_check/file
#There are two replacement dates columns, one is the original and second is new. Merging them both together as for the purpose of the excercise I need to only only the final date and not it's history
rm $path_file/file
cat $path_file/file_cur_data_val | 
  awk -F';' 'BEGIN{OFS=";"}
    {
    if($4=="Not available" || $4=="New_proposed_replacement_date")
      {print $1,$2,$3,$5,$6,$7,"Original replacement date";}
    else
      {print $1,$2,$4,$5,$6,$7,"Replacement date was changed"}
    }' >$path_file/file
rm $path_file/report
exp1_date=$(date -d "`date +%Y%m01` +18 month -1 day" +%Y-%m-%d)
exp2_date=$(date -d "`date +%Y%m01` +12 month -1 day" +%Y-%m-%d)
exp3_date=$(date -d "`date +%Y%m01` +6 month -1 day" +%Y-%m-%d)
exp_date=$(date -d "`date +%Y%m01` +1 month" +%Y-%m-%d)
#assumption that dates for replacement and their statuses don't match the rule defined above - needs to be checked and corrected
#1.step - define multiple variables in awk for the dates
cat $path_file/file | 
awk -F';' -v sell_date="$sell__date" -v exp_1_date="$exp_1_date" -v exp_2_date="$exp_2_date" -v exp_3_date="$exp_3_date" -v exp_date="$exp_date" 'BEGIN{OFS=";"}
        {
        if ($3 <= exp_date && $2 ~/^'Exc'/){$2="Exception (expired)";print $0;}
        else if($3 <= exp_date){$2="Expired";print $0}
        else if($3 <= exp_3_date && $3 > exp_date && $2 ~/^'Exc'/){$2="Exception (expiring 3)";print $0;}
        else if($3 <= exp_3_date && $3 > exp_date){$2="Expiring 3";print $0;}
        else if($3 <= exp_2_date && $3 > exp_3_date && $2 ~/^'Exc'/){$2="Exception (expiring 2)";print $0;}
        else if($3 <= exp_2_date && $3 > exp_3_date){$2="Expiring 2";print $0;}
        else if($3 <= exp_1_date && $3 > exp_2_date && $2 ~/^'Exc'/){$2="Exception (expiring 1)";print $0;}
        else if($3 <= exp_1_date && $3 > exp_2_date){$2="Exiring 1";print $0;}
        else if($3 > exp_1_date && $2 ~/^'Exc'/){$2="Exception (selling)";print $0;}
        else if($3 > exp1_date){$2="Selling";print $0;}
        else if($3 == "Not available"){print $0}
        }' |
#many items don't have the replacement dates defined and it needs to be checked with suppliers
awk -F';' 'BEGIN{OFS=";"}
        {
        if ($3 == "Not available"){$7="Replacement date to be confirmed";print $0;}
        else{print $0}
        }' | awk -F';' 'BEGIN{OFS=";"}{print $5,$6,$1,$2,$3,$4,$7}'> $path_file/file_report
 ```
