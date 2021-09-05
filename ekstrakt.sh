#!/bin/bash
#
# ===========================================================================#
#                                                                            #
#   REQUIREMENTS:  (Linux) Terminal - (Windows) Laragon, Bash                #
#          NOTES:  Ekstrakt - Extract Keyword From CSV                       #
#         AUTHOR:  Mei Mustaqim                                              #
#          EMAIL:  frematers@gmail.com                                       #                                            
#           PAGE:  https://www.frematers.com                                 #
#        VERSION:  1.0                                                       #
#        CREATED:  16/02/2021 - 17:50                                        #
#      COPYRIGHT:  @2021 Mei Mustaqim                                        #
#                                                                            #
# ===========================================================================#
#
#
#                             [ Ekstrakt ]
# 
# Extract data from .csv file without using Spreedsheet program 
# 
# Support Platform :
# 1) Autokeywordx : https://autokeywordx.com/ (expired ?)
# 2) Google Ads - Keyword Planner : https://ads.google.com/aw/keywordplanner/ideas/new
# 3) Semrush (All Account) : https://www.semrush.com/analytics/keywordmagic/start
# 4) Long Tail Pro : https://longtailpro.com/
# etc...

# Master Location
#HERE=`pwd`
#relative_location=`dirname $0` #/bin file
#keyword_folder=$HERE/keyword

# Source Filename
file=$2
filename=$(basename -- "$file")
filename="${filename%.*}"
#output=$keyword_folder/$filename.txt
output=$filename.txt
line=0

extract_semrush(){
    ls | grep .csv > listsemrush
    list_semrush_file="listsemrush"
    
    while IFS= read -r semrushdata; do
        filename=$(basename -- "$semrushdata")
        filename="${filename%.*}"
        #output=$keyword_folder/$filename.txt
        out=$filename.txt
        
        while IFS=',' read -r keywords volume keyword_dificult cpc; do
            #echo $line
            ((line++))
        done < "$semrushdata"
        
        if [[ $line -eq 50004 && $line != 30004 && $line != 10004 ]]; then
            line=0
            while IFS=',' read -r keywords volume keyword_dificult cpc
            do
                echo $keywords
                ((line++))
                
                # Semrush Business Account for 50.000 Keywords
                if [[ $line -eq 50001 ]]; then
                    break
                fi
            done < "$semrushdata" | grep -v "Keyword" | sed 's/"//g' > "$out"
            
        elif [[ $line == 30004 ]]; then
            line=0
            while IFS=',' read -r keywords volume keyword_dificult cpc; do
                echo $keywords
                ((line++))
                
                # Semrush Guru Account for 30.000 Keywords
                if [[ $line -eq 30001 ]]; then
                    break
                fi
            done < "$semrushdata" | grep -v "Keyword" | sed 's/"//g' > "$out"
            
        elif [[ $line == 10004 ]]; then
            line=0
            while IFS=',' read -r keywords volume keyword_dificult cpc
            do
                echo $keywords
                ((line++))
                
                # Semrush Pro Account for 10.000 Keywords
                if [[ $line -eq 10001 ]]; then
                    break
                fi
            done < "$semrushdata" | grep -v "Keyword" | sed 's/"//g' > "$out"
        else
            line=0
            while IFS=',' read -r keywords volume keyword_dificult cpc
            do
                echo $keywords
                ((line++))
                
                # Semrush Business Account for 50.000 Keywords
                if [[ $line -eq 50001 ]]; then
                    break
                fi
            done < "$semrushdata" | grep -v "Keyword" | sed 's/"//g' > "$out"
        fi
    done < "$list_semrush_file"
    
    rm listsemrush
}

function cecho(){
    local exp=$1;  # Argument 1
    local color=$2;  # Argument 2
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;;
       esac
    fi
    tput bold;
    tput setaf $color;
    echo $exp;
    tput sgr0;
}

semrush(){
    while IFS=',' read -r keywords volume keyword_dificult cpc
    do
        #echo $line
        ((line++))
    done < "$file"
    
    # Semrush Business Account for 50.000 Keywords
    if [[ $line -eq 50004 && $line != 30004 && $line != 10004 ]]; then
        semrush_business
        #break
         
    elif [[ $line == 30004 ]]; then
        semrush_guru
        #break
        
    elif [[ $line == 10004 ]]; then
        semrush_pro
        #break
    else
        semrush_default
    fi
}

semrush_business(){
    line=0
    while IFS=',' read -r keywords volume keyword_dificult cpc
    do
        echo $keywords
        ((line++))
        
        # Semrush Business Account for 50.000 Keywords
        if [[ $line -eq 50001 ]]; then
            break
        fi
    done < "$file" | grep -v "Keyword" | sed 's/"//g' > "$output"
}

semrush_guru(){
    line=0
    while IFS=',' read -r keywords volume keyword_dificult cpc
    do
        echo $keywords
        ((line++))
        
        # Semrush Guru Account for 30.000 Keywords
        if [[ $line -eq 30001 ]]; then
            break
        fi
    done < "$file" | grep -v "Keyword" | sed 's/"//g' > "$output"
}

semrush_pro(){
    line=0
    while IFS=',' read -r keywords volume keyword_dificult cpc
    do
        echo $keywords
        ((line++))
        
        # Semrush Pro Account for 10.000 Keywords
        if [[ $line -eq 10001 ]]; then
            break
        fi
    done < "$file" | grep -v "Keyword" | sed 's/"//g' > "$output"
}

semrush_default(){
    line=0
    while IFS=',' read -r keywords volume keyword_dificult cpc
    do
        echo $keywords
        ((line++))
        
        # Semrush Business Account for 50.000 Keywords
        if [[ $line -eq 50001 ]]; then
            break
        fi
    done < "$file" | grep -v "Keyword" | sed 's/"//g' > "$output"
}

google_plan(){   

    # Google Ads - Keyword Planner
    while IFS=$'\t' read -r keywords currency average_monthly competition
    do
        ((line++))
        if [[ $line -gt 3 ]]; then
            echo $keywords
        fi
    done < "$file" | grep -v "Keyword" | sed 's/"//g' > "$output"
}

google_plan_all(){   

    # Google Ads - Keyword Planner All Keyword
    
    ls | grep .csv > listkeyword
    list_keyword_file="listkeyword"
    
    while IFS= read -r keyworddata; do
        filename=$(basename -- "$keyworddata")
        filename="${filename%.*}"
        #output=$keyword_folder/$filename.txt
        out=$filename.txt
        

        while IFS=$'\t' read -r keywords currency average_monthly competition
        do
            ((line++))
            if [[ $line -gt 3 ]]; then
                echo $keywords
            fi
        done < "$keyworddata" | grep -v "Keyword" | sed 's/"//g' > "$out"
        
    done < "$list_keyword_file"
    
    rm listkeyword
    
}

autokeywordx(){
    # Autokeywordx - 404
    while IFS=',' read -r number keywords queries
    do
        echo $keywords
    done < "$file" | grep -v "Keyword" | sed 's/"//g' > "$output"
}

autokeywordx_all(){   
    # Autokeywordx - 404
    ls | grep .csv > listkeyword
    list_keyword_file="listkeyword"
    
    while IFS= read -r keyworddata; do
        filename=$(basename -- "$keyworddata")
        filename="${filename%.*}"
        #output=$keyword_folder/$filename.txt
        out=$filename.txt
        
        while IFS=',' read -r number keywords queries
        do
            echo $keywords
        done < "$keyworddata" | grep -v "Keyword" | sed 's/"//g' > "$out"
        
    done < "$list_keyword_file"
    
    rm listkeyword
}

longtailpro(){
    # Long Tail Pro 
    while IFS=',' read -r keywords volume bid
    do
        ((line++))
        if [[ $line -gt 1 ]]; then
            echo $keywords
        fi
        #echo $keywords
    done < "$file" | grep -v "Keyword" | sed 's/"//g' > "$output"
}

longtailpro_all(){   
    # Long Tail Pro All Keyword
    
    ls | grep .csv > listkeyword
    list_keyword_file="listkeyword"
    
    while IFS= read -r keyworddata; do
        filename=$(basename -- "$keyworddata")
        filename="${filename%.*}"
        #output=$keyword_folder/$filename.txt
        out=$filename.txt
        
        while IFS=',' read -r keywords volume bid
        do
            ((line++))
            if [[ $line -gt 1 ]]; then
                echo $keywords
            fi
            #echo $keywords
        done < "$keyworddata" | grep -v "Keyword" | sed 's/"//g' > "$out"
        
    done < "$list_keyword_file"
    
    rm listkeyword
}


usage(){
    echo $'\n'
    echo $'\t' "[ Mind Blowing ]"
    echo $'\n'
    cecho "$0 usage:" cyan && grep " .)\ #" $0;
    echo $'\n'
    exit 0;
}

Help()
{
   # Display Help
   echo $'\n'
   echo "[ Ekstrakt - 1.0 ]"
   echo 
   echo "Available arguments:"
   echo $'\n'
   echo -e "  Print Help :"
   echo -e "  > ekstrakt.sh -h"
   echo
   echo -e "  Extract keyword from one file"
   echo -e "    -g     : Extract Keyword from Google Keyword Planner | .csv to .txt"
   echo -e "    -l     : Extract Keyword from Long Tail Pro | .csv to .txt"
   echo -e "    -s     : Extract Keyword from Semrush | .csv to .txt"
   echo -e "    -x     : Extract Keyword from Autokeywordx | .csv to .txt"
   echo 
   echo -e "  > ekstrakt.sh [-g|l|s|x] [filename]"
   echo $'\n'
   echo -e "  Extract all available keyword"
   echo -e "    -G     : Extract All Keyword from Google Keyword Planner | .csv to .txt"
   echo -e "    -L     : Extract All Keyword from Long Tail Pro | .csv to .txt"
   echo -e "    -S     : Extract All Keyword from Semrush | .csv to .txt"
   echo -e "    -X     : Extract All Keyword from Autokeywordx | .csv to .txt"
   echo 
   echo -e "  > ekstrakt.sh [-G|L|S|X]"
   echo $'\n'
   
   exit 0;
}

# [ $# -eq 0 ] && usage

no_args="true"
while getopts ":hs:g:l:x:bSGLX" arg; do
    echo $'\n'
    # echo -e "\e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
    case $arg in
        S) # Extract All Keyword From Semrush .csv
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            extract_semrush
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m"
            echo -e
            ls -1 *.txt
            ;;
        G) # Extract All Keyword From Google .csv
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            google_plan_all
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m"
            echo -e
            ls -1 *.txt
            ;;
        L) # Extract All Keyword From Long Tail Pro .csv
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            longtailpro_all
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m"
            echo -e
            ls -1 *.txt
            ;;
        X) # Extract All Keyword From Autokeywordx .csv
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            autokeywordx_all
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m"
            echo -e
            ls -1 *.txt
            ;;
        g) # Google Plan : ./extrait.sh -g keyword.csv
            # Google Plan : Extract Keyword from .csv to .txt
            # echo $'\n'
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            google_plan
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m\e[1;92m"$output"\e[0m"
            echo $'\n'
            ;;
        l) # Long Tail Pro : ./extrait.sh -g keyword.csv
            # Google Plan : Extract Keyword from .csv to .txt
            # echo $'\n'
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            longtailpro
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m\e[1;92m"$output"\e[0m"
            echo $'\n'
            ;;
        s) # Semrush : ./extrait.sh -s keyword.csv 
            # Semrush : Extract Keyword from .csv to .txt
            # echo $'\n'
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            semrush
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m\e[1;92m"$output"\e[0m"
            echo $'\n'
            ;;
        x) # Autokeywordx : ./extrait.sh -x keyword.csv
            # Autokeywordx : Extract Keyword from .csv to .txt
            echo $'\n'
            echo -e " \e[1;92m[ ~ ] \e[1;96mStart Extracting . . . . ."
            autokeywordx
            echo -e " \e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m\e[1;92m"$output"\e[0m"
            echo $'\n'
            ;;
        h | *) # Display help 
            Help
            exit 0
            ;;
    esac
    no_args="false"
    
    # echo -e "\e[1;92m[ + ] \e[1;96mExtracting Keyword Finish : \e[0m\e[1;92m$output\e[0m"
    echo $'\n'
done

[[ "$no_args" == "true" ]] && {
    Help
    exit 1
}
