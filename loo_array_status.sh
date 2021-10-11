``bash
#change value of one column based on the values in other two and the highest number in one.
#in case there was already an array with the same name created, good to remove rules assigned to it
unset version_array;
#create an asociative array
declare -A version_array;
function max_version ()
{
    while read A B C D E F G; do #while reading all the columns in the file
        if [ -z "${version_array[$A]}" ]; then
            version_array[$A]=$B;
            echo checking combination $A $B;
        else
            echo "${version_array[$A]} < $B";
            compare_version=$(echo "${version_array[$A]} < $B" |bc -l); #bc - working with floating numbers , use to avoid error
            if let $compare_version; then
                version_array[$A]=$B;
            fi;
        fi;
    done
}
function compare_version ()
{
    while read A B C D E F G; do
        compare_version=$(echo "${version_array[$A]} > $B" |bc -l);
        if let $compare_version; then
            D=Spare;
        fi;
        echo $A $B $C $D $E $F $G;
    done
}
max_version < test1 > /dev/null 2>&1
compare_version < test1 | sed 's" ";"g' | sed 's"~" "g' > res1
awk -F';' 'NR==FNR{a[$1 FS $2]=$2 FS $3;next}{print $0";"a[$1 FS $2]}' res1 file_report |
awk -F';' 'BEGIN{OFS=";"}
    {
    if($14 ~/^[[:alnum:]]/)
        {$7=$14;print $0;}
    else
        {print $0}
    }' | cut -d ";" -f 1-12 > file_updated
```
