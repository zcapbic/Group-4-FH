zcat dbNSFP5.0a_variant.chr1.gz | head -1 | tr '\t' '\n' | nl | grep -i 'xxx' 
#This approach facilitates the identification of the specific column indices in the 
#dataset that correspond to the information listed under the “Column Name” field in Table 1.
#xxx refers to the column name to be extracted.



for chr in {1..22} X Y M; do
  zgrep -w "FH" dbNSFP5.0a_variant.chr${chr}.gz |
  awk -F'\t' 'BEGIN {OFS="\t"}
  {
    # Process multi - value fields
    split($7, rs_arr, ";");    $7 = rs_arr[1]    # rs_dbSNP（ column 7）
    split($12, aapos_arr, ";"); $12 = aapos_arr[1]  # aapos（column 12）
    split($21, hgvsc_arr, ";"); $21 = hgvsc_arr[1]  # HGVSc_VEP（column 21）
    
  
    
    # Print selected columns ( consistent with original command )
    print $1, $2, $3, $4, $13, $7, $76, $77, $95, $98, $96, $12, $5, $6, $21, $22
  }' >> FH_variants_03pf.tsv
done

# Add the header row
echo "Chr,hg38_Position,rsID,Nucleotide_Change,Amino_Acid_Change,REVEL_Score,ClinVar_Class" > FH_final.csv
# Input data
awk -F '\t' 'BEGIN {OFS=","} {print $1, $2, $3, $4, $5, $6, $7}' FH_variants_03pf.tsv >> FH_final.csv
# After confirming the column indices corresponding to the desired annotation fields
#, the following code enables the extraction of relevant information from the \
#texttt { chr } files . Additionally , basic data cleaning procedures are applied ,
#where in cases of multiple values within a single field , only the first entry is
#retained for downstream analysis .




 
awk -F',' 'BEGIN {OFS=","} 
NR==1 {print; next}   #Retain the header row
! ($7 == "." || $8 == ".") {print}  # Output only rows where both column 7 and column 8 are not "."
' FH_final.csv > FH_finalpf_cleaned.csv
