#!/bin/sh

###20171108 -- MultiEthnicGWAS

#20171227
#TOC

 - 20171108: PCAEffects


#20171227
#Conda environment setup/details/etc
#See `/users/mturchin/RamachandranLab.CCV_General.Workbook.vs1.sh` for initial setup 

module load conda
conda config --add channels r
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda create -n MultiEthnicGWAS
source activate MultiEthnicGWAS
conda install R
#conda install python #already installed as part of base package I guess
conda install perl
conda install java
conda install plink
conda install bedtools
conda install vcftools
conda install bcftools
conda install bwa
conda install samtools
conda install picard
conda install gatk
conda install imagemagick
conda install gnuplot
conda install eigensoft
conda install r-base
conda install r-devtools
conda install r-knitr
conda install r-testthat
conda install r-cairo
conda install r-ashr
conda install r-rcolorbrewer
#20180311
#conda install flashpca -- failed
conda install eigen
#conda install spectra -- installed a Python package called spectra, not what was intended
conda install boost
#conda install libgomp -- failed
conda install gcc
#20180315
conda install r-essentials
conda install -c anaconda fonts-anaconda
conda install -c bioconda r-extrafont
#NOTE -- needed to run `conda update --all` to correct the 'missing/boxed text' issue with the conda R verion's image plotting
#20180415
#conda install admixture -- failed


#20171117
#Dealing with sockets/missing screen issue

#From https://superuser.com/questions/58525/how-do-i-reconnect-to-a-lost-screen-detached-missing-socket

# ps aux | grep mturchin
# kill -CHLD 16830 

#20171128 NOTE -- might be helpful here, shows the use of `autodetach on` at the end from this person's defaults, which I was not originally including in my `.screenrc` file, `https://remysharp.com/2015/04/27/screen`
#20171227 NOTE -- the end result of this, which was troubleshooted by the IT department (via e-mail correspondence), was that there are two login nodes, 001 and 002, and if I setup screens on on one they'll appear as `dead` when logged onto the other login node; the solution then is to ssh into the appropriate login node if I'm randomly logged into the wrong one initially (and therefore in general work off of one login in node in particular from here on out).


##20171108 -- PCAEffects

#20171128 -- git webpage TOC main .Rmd file setup here

#cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | perl -F" " -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join(" ", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'
cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | sed 's/ /,/g' | perl -F, -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join(" ", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'

<!-- index.Rmd
---
title: "Home"
output:
  html_document:
    toc: false
---

Homepage for the Ramachandran Lab project `MultiEthnic GWAS`.

* [Example 1][example1]
* [Example 2][example2]

Github [repo][gitrepo1] page

[example1]: https://mturchin20.github.io/MultiEthnicGWAS/Example1.html 
[example2]: https://mturchin20.github.io/MultiEthnicGWAS/Example2.html 
[gitrepo1]: https://github.com/mturchin20/MultiEthnicGWAS

-->

#beginning Work

#/users/mturchin/data/ukbiobank , /users/mturchin/data/ukbiobank_jun17/mturchin

#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs
#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS
#mkdir /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/PCAEffects
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS
#mv /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/.; rm -r /users/mturchin/LabMisc/RamachandranLab/IntroProjs/ 

mkdir /users/mturchin/data/ukbiobank/mturchin

# interact -t 72:00:00 -m 8g
# (from MacBook Air) jupyter notebook /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/20171108_SS_Pipeline_Version_2.ipynb

##./gconv 
./gconv chrom21.cal mturchin/tempMisc/chrom21.basic.cal basic
#chrom18+ missing from *.int and *.con filetypes for some reason
./gconv chrom17.int mturchin/tempMisc/chrom17.basic.int basic
./gconv chrom17.con mturchin/tempMisc/chrom17.basic.con basic

#Retrieved from http://biobank.ctsu.ox.ac.uk/crystal/list.cgi and note the inclusion of `\` in front of each `&` in the URLs (manually did this after copy/pasting each URL)
#note -- don't actually need to include the `\` in front of the `&s` like I need to do from the command-line; interestingly enough including the `\s` produces the issue I was trying to avoid from the get-go, so kind of a reverse behavior going on here
urls1="http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101" 

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt; for i in $urls1; do echo $i; GET $i | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*.a class="basic" href="field.cgi\?id=(\d+)"..*.a class="subtle" href="field.cgi\?id=\d+".(.*).\/a..\/td..*/) { print $1, "\t", $2 ; }' >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt; done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt | perl -F"\t" -lane 'chomp(@F); print join(";", @F);' | sed 's/ /_/g'`; do 
#rm -f /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.FieldCategories.Field_Name.vs.txt | sed 's/\t/;/g' | sed 's/\s/_/g'`; do 
#	echo $i; done
	Field1=`echo $i | perl -F\; -ane 'print $F[0];'`
	Name1=`echo $i | perl -F\; -ane 'print $F[1];'`
	
#	echo $i $Field1 $Name1; 
#	echo $Field1 $Name1; 

	GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=$Field1 | perl -slane 'my $line = join(" ", @F); if ($line =~ m/.* (\d+,\d+) participants.*/) { print $Field2, "\t", $Name2, "\t", $1; }' -- -Field2=$Field1 -Name2=$Name1 | sed 's/,//g' >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt;
done

cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); png(\"/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/nana.png\", height=650, width=650, res=150); hist(Data1[,1], main=\"UKBioBank Number of \nParticipants per Phenotype\", xlab=\"Number of Participants\", breaks=50); dev.off();"
cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));"

#Getting .Rmd/.html/git directory stuff worked out by copying some base content from workflowr (https://github.com/jdblischak/workflowr) that I have stored in a previously temp workflowr test run at https://github.com/mturchin20/misc 
#cd /users/mturchin/LabMisc/RamachandranLab/
#clone https://github.com/mturchin20/misc

mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website

cp -rp /users/mturchin/LabMisc/RamachandranLab/misc/docs/site_libs/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs/site_libs/.
cp -rp /users/mturchin/LabMisc/RamachandranLab/misc/analysis/* /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/.

#some helpful comments on Makefile misc -- https://stackoverflow.com/questions/3220277/what-do-the-makefile-symbols-and-mean, https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile, https://stackoverflow.com/questions/3707517/make-file-echo-displaying-path-string, https://www.gnu.org/software/make/manual/html_node/File-Name-Functions.html, https://www.gnu.org/software/make/manual/html_node/Text-Functions.html

#20171128 NOTE -- copy and pasted the correct `<img src =....` lines from files such as `https://github.com/mturchin20/misc/blob/master/docs/index.html` into `/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/docs/20171127.CorrectHTML.html` and then coming up with the `head`, `awk if (NR >...`, and `cat tmp1 CorrectHTML tmp2` commands found in the `Makefile` now  
#20171128 NOTE -- using perl in makefiles necessitates double `$`s, via `https://stackoverflow.com/questions/18083421/how-do-i-run-perl-command-from-a-makefile`

#some helpful comments from here re: knitr related commands https://stackoverflow.com/questions/10646665/how-to-convert-r-markdown-to-html-i-e-what-does-knit-html-do-in-rstudio-0-9
#R -e "library(\"knitr\"); knitr::knit2html(\"Example.Rmd\");"

#cat MainScript.IntroProjs.MultiEthnGWAS.vs1.sh | 
#cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/MultiEthnicGWAS.Workbook.vs1.sh | perl -lane 'if ($. == 1) { $flag1 = 0; } my $line1 = join(" ", @F); if ($line1 =~ m/^-->.*/) { $flag1 = 0; close $fh1; } if ($flag1 == 1) { print $fh1 join("\t", @F); } if ($line1 =~ m/^<!-- (.*Rmd).*/) { $flag1 = 1; $file1 = "/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/website/" . $1; open($fh1, ">", $file1) }'

<!-- Example1.Rmd
---
title: "Example 1"
output:
  html_document:
    toc: false
---

# Would
## You
### Look
#### At
#### That

-->

<!-- Example2.Rmd

# Let's
## Go
### Again
#### Round
#### Two

-->

mkdir /users/mturchin/data/ukbiobank_jun17/mturchin

ln -s /users/mturchin/data/ukbiobank/ukb9200.csv /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv 
ln -s /users/mturchin/data/ukbiobank/ukb11108.csv /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv

#Leftout fields being recollected
join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.vs1.txt

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt; for i in `cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.vs1.txt`; do
	Field1=`echo $i | perl -F\; -ane 'print $F[0];'`

#	<tr><td>Description:</td><td>Average Y chromosome intensities for determining sex</td></tr>

	GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=$Field1 | perl -slane 'my $line = join(" ", @F); if ($line =~ m/.*Description:<\/td><td>(.*)<\/td><\/tr>/) { $description = $1; $description =~ tr/ /_/; } if ($line =~ m/.* (\d+) participants.*/) { $participants = $1; } if ($line =~ m/.* (\d+,\d+) participants.*/) { $participants = $1; } if (eof()) { print $Field2, "\t", $description, "\t", $participants; }' -- -Field2=$Field1 | sed 's/,//g' >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt;
done

cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.Field_Name_Participants.vs1.txt

join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.Field_Name_Participants.vs1.txt

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.Field_Name_Participants.vs1.txt /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.Field_Name_Participants.vs1.txt | sort -rg -k 3,3 | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000))); png(\"/users/mturchin/data/ukbiobank_jun17/mturchin/ukbFiles.Participants.hist.vs1.png\", height=650, width=650, res=150); hist(Data1[,1], main=\"ukb 9200 & 11108 Num. of \n Participants per Phenotype\", xlab=\"Num. of Participants\", breaks=50); dev.off();"

plink --bfile /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr21_v2 --recode --out /users/mturchin/data/ukbiobank_jun17/mturchin/ukb_snp_chr21_v2 --noweb

#20171218

##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(21000|21001|21003|22000|22001|22006|22007|22008|22009|22011|22012|22013|31|34|48|49|50|)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt
##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(21000\-|21001\-|21003\-|22000\-|22001\-|22006\-|22007\-|22008\-|22009\-|22011\-|22012\-|22013\-|31\-|34\-|48\-|49\-|50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt
##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' | sed 's/21000-/Ethnic_background-/g' | sed 's/21001-/Body_mass_index_(BMI)-/g' | sed 's/21003-/Age_when_attended_assessment_centre-/g' | sed 's/22000-/Genotype_measurement_batch-/g' | sed 's/22001-/Genetic_sex-/g' | sed 's/22006-/Genetic_ethnic_grouping-/g' | sed 's/22007-/Genotype_measurement_plate-/g' | sed 's/22008-/Genotype_measurement_well-/g' | sed 's/22009-/Genetic_principal_components-/g' | sed 's/22011-/Genetic_relatedness_pairing-/g' | sed 's/22012-/Genetic_relatedness_factor-/g' | sed 's/22013-/Genetic_relatedness_IBS0-/g' | sed 's/31-/Sex-/g' | sed 's/34-/Year_of_birth-/g' | sed 's/48-/Waist_circumference-/g' | sed 's/49-/Hip_circumference-/g' | sed 's/50-/Standing_height-/g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/21000-/Ethnic_background-/g' | sed 's/21001-/Body_mass_index_(BMI)-/g' | sed 's/21003-/Age_when_attended_assessment_centre-/g' | sed 's/22000-/Genotype_measurement_batch-/g' | sed 's/22001-/Genetic_sex-/g' | sed 's/22006-/Genetic_ethnic_grouping-/g' | sed 's/22007-/Genotype_measurement_plate-/g' | sed 's/22008-/Genotype_measurement_well-/g' | sed 's/22009-/Genetic_principal_components-/g' | sed 's/22011-/Genetic_relatedness_pairing-/g' | sed 's/22012-/Genetic_relatedness_factor-/g' | sed 's/22013-/Genetic_relatedness_IBS0-/g' | sed 's/31-/Sex-/g' | sed 's/34-/Year_of_birth-/g' | sed 's/48-/Waist_circumference-/g' | sed 's/49-/Hip_circumference-/g' | sed 's/50-/Standing_height-/g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt

#cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(^21000|^21001|^21003|^22000|^22001|^22006|^22007|^22008|^22009|^22011|^22012|^22013|^31|^34|^48|^49|^50)/) { push(@colsUse, $i); } } } print join(",", @colsUse);'
#cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(21000\-|21001\-|21003\-|22000\-|22001\-|22006\-|22007\-|22008\-|22009\-|22011\-|22012\-|22013\-|31\-|34\-|48\-|49\-|50\-)/) { push(@colsUse, $i); } } } print join(",", @colsUse), "\t", join(",", @F[@colsUse]);'

for i in {0..55}; do
	val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
	val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`

	echo $i $val1 $val2

done

##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = "2018" - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoies.txt 
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $year1 = $F[2]; $year1 =~ tr/"//d; print $F[0], ",", $F[1], ",", $F[12], ",", $F[2], ",", $F[18], ",", 2018 - $year1, ",", $F[9], ",", $F[15], ",", $F[3], ",", $F[6], ",", $F[21];' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt 

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | perl -F, -ane 'if ($F[2]) { $F[2] =~ s/^1$/White/g; $F[2] =~ s/^1001$/British/g; $F[2] =~ s/^2001$/White_and_Black_Caribbean/g; $F[2] =~ s/^3001$/Indian/g; $F[2] =~ s/^4001$/Caribbean/g; $F[2] =~ s/^2$/Mixed/g; $F[2] =~ s/^1002$/Irish/g; $F[2] =~ s/^2002$/White_and_Black_African/g; $F[2] =~ s/^3002$/Pakistani/g; $F[2] =~ s/^4002$/African/g; $F[2] =~ s/^3$/Asian_or_Asian_British/g; $F[2] =~ s/^1003$/Any_other_white_background/g; $F[2] =~ s/^2003$/White_and_Asian/g; $F[2] =~ s/^3003$/Bangladeshi/g; $F[2] =~ s/^4003$/Any_other_Black_background/g; $F[2] =~ s/^4$/Black_or_Black_British/g; $F[2] =~ s/^2004$/Any_other_mixed_background/g; $F[2] =~ s/^3004$/Any_other_Asian_background/g; $F[2] =~ s/^5$/Chinese/g; $F[2] =~ s/^6$/Other_ethnic_group/g; $F[2] =~ s/^-1$/Do_not_know/g; $F[2] =~ s/^-3$/Prefer_not_to_answer/g; print $F[0], "\t", $F[0], "\t", $F[1], "\t", $F[2], "\t", $F[4], "\n"; }' | grep -v eid | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE") - > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt 

##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | perl -F, -ane 'print $F[0], "\t", $F[0], "\t", $F[6], "\t", $F[7], "\t", $F[8], "\t", $F[9], "\n"; ' | grep -v eid | cat <(echo -e "FID\tIID\tHeight\tBMI\tWaist\tHip") - > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt
##cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt | perl -lane 'if ($#F == 5) { print join("\t", @F); }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $4 }' | sort | uniq -c | awk '{ print $2 }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt

for i in `cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt`; do
	echo $i;
	cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep -w $i | awk '{ print $1 "\t" $2 }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${i}.FIDIIDs 

done

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 4000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs

#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${ANCESTRY}.FIDIIDs
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs
#/users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam
#/users/mturchin/data/ukbiobank_jun17/calls/.
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${ANCESTRY}.FIDIIDs
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt
#/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt

mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack
mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British
mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack/African
mkdir /users/mturchin/data/ukbiobank_jun17/2017WinterHack/Caribbean

plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr21_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr21_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --recode --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000
plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr22_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr22_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr22_v2.British.Ran4000

##plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr21_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr21_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name SEX,AGE --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --linear --maf .01 --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000 
##plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr1_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr1_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs --assoc --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr1_v2.British.Ran4000 
plink --bfile /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr21_v2.British.Ran4000 --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE,SEX --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr21_v2.British.Ran4000.MikeOut

#NOTE -- changed/played around with a few permissions to help get other members of the retreat group access to some of the files that were created during this process; first used chmod 777 just to brute force fix things, then changed to be more specific (eg give just group users permission but not necessarily just anyone), and then afterwards cleaned things up be removing write-access to group users as well (some info for said steps from: https://en.wikipedia.org/wiki/Chmod)

#20171228 NOTE -- think I'm going to ditch this idea and just do the normal 'create file separately and edit/do things/etc in the file itself'; by uploading the file to the github space it should be made accessible for later downstream linking and reports/summaries/logs/etc...
#Saved the below code into a file via ':251,259w! /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.vs2.sh'; moved to the 'vs2' version after the retreat 
#!/bin/sh

ancestry1="$1"
ancestry2="$2"
keep="$3"
chr="$4"

plink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${chr}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${chr}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep $keep --out /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$ancestry1/ukb_chr${chr}_v2.${ancestry2} --noweb

##srun -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/error -o /users/mturchin/data/ukbiobank_jun17/2017WinterHack/out bash /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh British /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs 21
sbatch -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/British/ukb_chr${i}_v2.British.Ran4000.slurm.error /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran4000.FIDIIDs 21

#Ran below for 'British.Ran4000', 'African', and 'Caribbean'; also ran the below during the retreat itself, and then moved to the next version of the for loop that includes the outer, per-ancestry for loop as well
#for i in {X..X}; do
#	
#	echo $i	
#	sbatch -t 1:00:00 --mem 8g -e /users/mturchin/data/ukbiobank_jun17/2017WinterHack/Caribbean/ukb_chr${i}_v2.Caribbean.slurm.error /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Caribbean.FIDIIDs $i
#
#done

#20180509 -- pheno edit work (eg proper age-regressed residuals + inverse-normalization separated by sex)

#Note -- accidentally overrode '/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt' & '/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt' so lost original timestamp; see below for when those files were roughly first created (eg around the same timeframe, or a bit later after, '/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt')
#(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$ls -lrt /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt
#-rw-r--r-- 1 mturchin sramacha 24713163 Dec 18 15:03 /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt


cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | perl -F, -ane 'if ($F[2]) { $F[2] =~ s/^1$/White/g; $F[2] =~ s/^1001$/British/g; $F[2] =~ s/^2001$/White_and_Black_Caribbean/g; $F[2] =~ s/^3001$/Indian/g; $F[2] =~ s/^4001$/Caribbean/g; $F[2] =~ s/^2$/Mixed/g; $F[2] =~ s/^1002$/Irish/g; $F[2] =~ s/^2002$/White_and_Black_African/g; $F[2] =~ s/^3002$/Pakistani/g; $F[2] =~ s/^4002$/African/g; $F[2] =~ s/^3$/Asian_or_Asian_British/g; $F[2] =~ s/^1003$/Any_other_white_background/g; $F[2] =~ s/^2003$/White_and_Asian/g; $F[2] =~ s/^3003$/Bangladeshi/g; $F[2] =~ s/^4003$/Any_other_Black_background/g; $F[2] =~ s/^4$/Black_or_Black_British/g; $F[2] =~ s/^2004$/Any_other_mixed_background/g; $F[2] =~ s/^3004$/Any_other_Asian_background/g; $F[2] =~ s/^5$/Chinese/g; $F[2] =~ s/^6$/Other_ethnic_group/g; $F[2] =~ s/^-1$/Do_not_know/g; $F[2] =~ s/^-3$/Prefer_not_to_answer/g; print $F[0], "\t", $F[0], "\t", $F[1], "\t", $F[2], "\t", $F[4], "\n"; }' | grep -v eid | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE") - > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | perl -F, -ane 'print $F[0], "\t", $F[0], "\t", $F[6], "\t", $F[7], "\t", $F[8], "\t", $F[9], "\n"; ' | grep -v eid | cat <(echo -e "FID\tIID\tHeight\tBMI\tWaist\tHip") - > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt | perl -lane 'if ($#F == 5) { print join("\t", @F); }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt




cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | perl -F, -ane 'print $F[0], ",", $F[0], ",", $F[6], ",", $F[7], ",", $F[8], ",", $F[9], "\n"; ' | grep -v eid | cat <(echo -e "FID,IID,Height,BMI,Waist,Hip") - > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt | perl -F, -lane 'for (my $i = 0; $i <= $#F; $i++) { if (!$F[$i]) { $F[$i] = -9; } } print join("\t", @F);' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt











#post-retreat extra work to clean things up/actually partially use/follow-up; just continuing on here with things I think

mkdir /users/mturchin/data/ukbiobank_jun17/subsets/
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro

#Put in `/users/mturchin/.bashrc`, from sources such as `http://www.accre.vanderbilt.edu/?page_id=361`, etc...
##`alias sacct='sacct --format JobID,JobName,Partition,User,Account,Submit,CPUTime,AllocCPUS,State,ExitCode'`
#`alias sacct='sacct --format JobID,JobName,Partition,User,Account,Submit,CPUTime,AllocCPUS,State,ExitCode,Comment%50'`
#`alias squeue='squeue --Format=jobid,partition,name,username,statecompact,starttime,timeused,numnodes,nodelist'`
#sacct --starttime 2014-07-01 #From https://ubccr.freshdesk.com/support/solutions/articles/5000686909-how-to-retrieve-job-history-and-accounting

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 10000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran10000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 100000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran100000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 200000 > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.Ran200000.FIDIIDs

#val1hg19=`echo "HaemgenRBC2016;HaemgenRBC2016;8.31e-9;RBC,MCV,PCV,MCH,Hb,MCHC GEFOS2015;GEFOS2015;1.2e-8;FA,FN,LS SSGAC2016;SSGAC2016;5e-8;NEB_Pooled,AFB_Pooled EMERGE22015;EMERGE22015;7.1e-9;ICV,Accumbens,Amygdala,Caudate,Hippocampus,Pallidum,Putamen,Thalamus"`;
#                
#for i in `cat <(echo $val1hg19 | perl -lane 'print join("\n", @F);')`; do
#        Dir1=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#        Dir2=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#        pVal1=`echo $i | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`

#UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;
#UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British 
British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;
#UKBioBankPops=`echo "British;British British;British.Ran100000 British;British.Ran200000"`; 
UKBioBankPops=`echo "African;African Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`; 
UKBioBankPops=`echo "British;British.Ran4000"`;

#African;African
#Any_other_Asian_background;Any_other_Asian_background
#Any_other_Black_background;Any_other_Black_background
#Any_other_mixed_background;Any_other_mixed_background
#Any_other_white_background;Any_other_white_background
#Asian_or_Asian_British;Asian_or_Asian_British
#Bangladeshi;Bangladeshi
#Black_or_Black_British;Black_or_Black_British
#British;British
#British;British.Ran4000
#British;British.Ran10000
#British;British.Ran100000
#British;British.Ran200000
#Caribbean;Caribbean
#Chinese;Chinese
#Do_not_know;Do_not_know
#Indian;Indian
#Irish;Irish
#Mixed;Mixed
#Other_ethnic_group;Other_ethnic_group
#Pakistani;Pakistani
#Prefer_not_to_answer;Prefer_not_to_answer
#White;White
#White_and_Asian;White_and_Asian
#White_and_Black_African;White_and_Black_African
#White_and_Black_Caribbean;White_and_Black_Caribbean

#cp -p /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.sh /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.sh
#cp -p /users/mturchin/data/ukbiobank_jun17/2017WinterHack/2017WinterHack.plink.GetAncestrySubsets.vs2.sh /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.vs2.sh

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	for chr in {1..22} X; do
	
		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1 ]; then
			mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1	
		fi
		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2 ]; then
			mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2
		fi
	
		echo $ancestry1 $ancestry2 $chr	
		sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.$ancestry2.slurm.%j.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.$ancestry2.slurm.%j.error /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.vs2.sh $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.$ancestry2.FIDIIDs $chr
	
	done
done

#From https://stackoverflow.com/questions/2920301/clear-a-file-without-changing-its-timestamp
##!/bin/sh
#TMPFILE=`mktemp`
##save the timestamp
#touch -r file-name $TMPFILE
#> file_name
##restore the timestamp after truncation
#touch -r $TMPFILE file-name
#rm $TMPFILE

for j in `echo "African Caribbean British"`; do
	for i in `ls -lrt /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/. | awk '{ print $9 }' | grep -E 'bed|bim|fam'`; do
		echo /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i
		
		TMPFILE=`mktemp`
		touch -r /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i $TMPFILE
		cat /dev/null > /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i
		touch -r $TMPFILE /users/mturchin/data/ukbiobank_jun17/2017WinterHack/$j/$i
		rm $TMPFILE
	done
done

for 

#for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
#	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#
#	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#
#	cat /dev/null > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#	
#	for chr in {2..22} X; do
#		echo "/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.${ancestry2}.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.${ancestry2}.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${chr}_v2.${ancestry2}.fam" >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#	done
#
#done
#
#for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
#	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#
#	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt
#
#	sbatch -t 1:00:00 --mem 100g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.slurm.%j.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.slurm.%j.error --comment "$ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr1_v2.${ancestry2} --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}") 
#
##	rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.Height.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.Height.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.Height.fam
#
#done

#Below completed with help from `http://zzz.bwh.harvard.edu/plink/dataman.shtml#mergelist`, `https://stackoverflow.com/questions/6907531/generating-a-bash-script-with-echo-problem-with-shebang-line`, & `https://stackoverflow.com/questions/13799789/expansion-of-variable-inside-single-quotes-in-a-command-in-bash` 
#Note -- did not end up going with `--merge-list` route since it, apparently, creates the merged PLINK files automatically, and I couldn't immediately find an option to by-pass this; one possibly solution would have been to delete these files at the end of the script, but I also realized that running the regressions (and possibly more/later analyses) would take less time if I keep things in a parallelized, per-chromosome state
#20180104 NOTE -- do not use `SEX` as a covariate, the UKBioBank PLINK files (as witnessed in the human-readable .ped/.map formats) already contain this information; additionally, PLINK expects the coding to be 1/2 and the UKBioBank sex coding (currently) is as 1/0, which may cause additional problems (or treat it as some binary covariate called `SEX` but having nothing to do with the actual designation). See results in scratch section showing covariate file lining up with .ped sex column (aside from the 1/2 vs. 1/0 coding issue). 
	#From https://www.cog-genomics.org/plink2/formats: "This page describes specialized PLINK input and output file formats which are identifiable by file extension. ..... isn't in dataset); Within-family ID of mother ('0' if mother isn't in dataset); Sex code ('1' = male, '2' = female, '0' = unknown); Phenotype value ('1' = control, '2' = case, '-9'/'0'/non-numeric = missing data if case/control)."; from http://biobank.ctsu.ox.ac.uk/crystal/coding.cgi?id=9: "Coding	Meaning 0	Female 1	Male"
	#From http://zzz.bwh.harvard.edu/plink/faq.shtml#faq9:
~~~
		#How does PLINK handle the X chromosome in association tests?
		#By default, in the linear and logistic (--linear, --logistic) models, for alleles A and B, males are coded
		#     A   ->   0
		#     B   ->   1
		#and females are coded
		#     AA  ->   0
		#     AB  ->   1
		#     BB  ->   2
		#and additionally sex (0=male,1=female) is also automatically included as a covariate. It is therefore important not to include sex as a separate covariate in a covariate file ever, but rather to use the special --sex command that tells PLINK to add sex as coded in the PED/FAM file as the covariate (in this way, it is not double entered for X chromosome markers). If the sample is all female or all male, PLINK will know not to add sex as an additional covariate for X chromosome markers.
		#The basic association tests that are allelic (--assoc, --mh, etc) do not need any special changes for X chromosome markers: the above only applies to the linear and logistic models where the individual, not the allele, is the unit of analysis. Similarly, the TDT remains unchanged. For the --model test and Hardy-Weinberg calculations, male X chromosome genotypes are excluded.
		#Not all analyses currently handle X chromosomes markers (for example, LD pruning, epistasis, IBS calculations) but support will be added in future.
~~~

#for pheno1 in `echo "Height BMI Waist Hip"`; do
for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22} X; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.error --comment "$pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}")

		done
	done	
done

#		sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.slurm.%j.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.slurm.%j.error <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr1_v2.${ancestry2} --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.MergeList.txt --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE,SEX --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}")

#for pheno1 in `echo "Height"`; do
#	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
#		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#		echo $pheno1 $ancestry1 $ancestry2
#
#		for i in {1..22} X; do
#			if [ ! -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.assoc.linear ]; then 
#				echo -e "\t" $i
#			fi
#		done
#	done	
#done

#20180104 NOTE -- for large `British` pops, I reran the clumping code with a more strict set of parameters, just since you would, more naturally for such large sample sizes, use such parameters for them (vs. parameters tuned on ~4k pop sizes); for largest sizes it's possible a p1 of 5-8 is even too liberal still
#UKBioBankPops=`echo "British;British British;British.Ran100000 British;British.Ran200000"`;

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22} X; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.assoc.linear | grep -E 'NMISS|ADD' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.linear.clump.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.linear.clump.slurm.error --comment "clumping $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear")

		done
	done	
done

#			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.strict.linear.clump.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.strict.linear.clump.slurm.error --comment "clumping $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear --clump-p1 5e-8 --clump-p2 0.0001 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.strict.assoc.linear")
#			plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
#cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.assoc.linear | grep -E 'NMISS|ADD' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.ADD.assoc.linear
#plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background --clump /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Height.ADD.assoc.linear
#plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African --clump /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.ADD.assoc.linear

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped

		rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz
		rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.gz 
		for i in {1..22} X; do

			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | perl -lane 'if ($#F == 8) { print join("\t", @F); }' >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear 
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped 

		done
	
		cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | sort -g -k 1,1 -k 4,4 | uniq | grep -v BETA | grep -v ^$ | cat <(echo "  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P ") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1
		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
		cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped | sort -g -k 1,1 -k 4,4 | uniq | grep -v NSIG | grep -v ^$ | cat <(echo " CHR    F           SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1
		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
		gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
		gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped

	done	
done

UKBioBankPops=`echo "African;African Any_other_white_background;Any_other_white_background British;British British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`;

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc
#cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
#join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc
join <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g)  <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.gz | awk '{ print $3 }' | sort -g) | wc

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1))); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear.hist.png\", height=1250, width=1250, res=300); hist(Data1[,1]); dev.off()"
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1))); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear.hist.png\", height=1250, width=1250, res=300); hist(Data1[,1]); dev.off()"
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));" 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));" 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"

mkdir /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.pedind | awk '{ print $1 "\t" $2 }' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 4000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.Ran4kIndv.pedind
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --keep /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.Ran4kIndv.pedind --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.bim | awk '{ if ($1 < 23) { print $0 } } ' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 20000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim | awk '{ print $2 }' >  /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim.rsIDs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --extract /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim.rsIDs --recode --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.ped | perl -lane '$F[5] = "1"; print join("\t", @F);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.phenoColEdit.ped
rm /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.ped
ln -s /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran20k.bim /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.pedsnp
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran20k.phenoColEdit.ped | perl -lane 'print join("\t", @F[0..5]);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.phenoColEdit.pedind
cp -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.parfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.parfile
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.bim | awk '{ if ($1 < 23) { print $0 } } ' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 100000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim | awk '{ print $2 }' >  /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim.rsIDs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --extract /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim.rsIDs --recode --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.ped | perl -lane '$F[5] = "1"; print join("\t", @F);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.phenoColEdit.ped
rm /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.ped
ln -s /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran100k.bim /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.pedsnp
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.phenoColEdit.ped | perl -lane 'print join("\t", @F[0..5]);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.phenoColEdit.pedind
cp -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.parfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.smartpca.parfile

#Got info for smartpca and .parfile input from HIV project work -- just copy/pasted the original code/sources and based new line/code on that

plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr1_v2.Any_other_white_background --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.MergeList.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.bim | awk '{ if ($1 < 23) { print $0 } } ' | sort -R --random-source=/users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | head -n 200000 > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim | awk '{ print $2 }' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim.rsIDs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --extract /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim.rsIDs --recode --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.ped | perl -lane '$F[5] = "1"; print join("\t", @F);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.phenoColEdit.ped
rm /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.ped
ln -s /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.bim /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.pedsnp 
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Ran200k.phenoColEdit.ped | perl -lane 'print join("\t", @F[0..5]);' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.phenoColEdit.pedind
#Made `/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.parfile` from HIV example

smartpca -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.parfile
smartpca -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.parfile
smartpca -p /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Ran100k.smartpca.parfile

ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca -c 1:2 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.1vs2.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.1vs2.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.1vs2.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca -c 3:4 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.3vs4.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.3vs4.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca.plot.3vs4.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca -c 1:2 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.1vs2.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.1vs2.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.1vs2.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca -c 3:4 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.3vs4.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.3vs4.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran20k.Results.pca.plot.3vs4.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca -c 1:2 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.1vs2.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.1vs2.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.1vs2.pdf
ploteig -i /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca -c 3:4 -p Control -x -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.3vs4.xtxt
ps2pdf /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.3vs4.ps /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca.plot.3vs4.pdf

#From MacBook Air
#mkdir /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran*.Results.pca.plot.*.pdf /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank/. 
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran*.Results.pca.plot.*.pdf /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank/.

join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.wFullCovars.pca
join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.wFullCovars.pca

plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs

for i in {1..22} X; do
	
	echo $i
#	sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs.linear.slurm.error --comment "Height Any_other_white_background Any_other_white_background.Ran4000 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --chr $i --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs")	
	sbatch -t 1:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs.linear.slurm.error --comment "Height Any_other_white_background Any_other_white_background $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --chr $i --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name Height --linear sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.smartpca.Ran200k.Results.wFullCovars.pca --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs")	

done

#rm -f /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
rm -f /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear
for i in {1..22} X; do

	echo $i
#	cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chr${i}_v2.Any_other_white_background.Ran4000.Height.w10PCs.assoc.linear | grep ADD >> /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
	cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr${i}_v2.Any_other_white_background.Height.w10PCs.assoc.linear | grep ADD >> /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear

done 

cat <(echo " CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P") /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear.temp1
mv /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000 --clump /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear
cat <(echo " CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P") /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear.temp1
mv /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background --clump /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.w10PCs.ADD.assoc.linear

mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/
#From https://www.biostars.org/p/70795/
mkdir /users/mturchin/Software/UCSCGB
#cd /users/mturchin/Software/UCSCGB
#wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/fetchChromSizes
mkdir /users/mturchin/data2
mkdir /users/mturchin/data2/UCSCGB
##/users/mturchin/Software/UCSCGB/fetchChromSizes GRCh37 > /users/mturchin/data2/UCSCGB/GRCh37.chrom.sizes
/users/mturchin/Software/UCSCGB/fetchChromSizes hg19 > /users/mturchin/data2/UCSCGB/hg19.chrom.sizes
mkdir /users/mturchin/data2/GIANT
#cd /users/mturchin/data2/GIANT
#wget https://portals.broadinstitute.org/collaboration/giant/images/0/01/GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq.txt.gz https://portals.broadinstitute.org/collaboration/giant/images/1/15/SNP_gwas_mc_merge_nogc.tbl.uniq.gz https://portals.broadinstitute.org/collaboration/giant/images/e/eb/GIANT_2015_WHRadjBMI_COMBINED_EUR.txt.gz 
#gunzip *

#In R:
#library("ashr")
#Data1 <- read.table("/users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.gz", header=T)
#Data2 <- read.table("/users/mturchin/data2/GIANT/GIANT_HEIGHT_Wood_et_al_2014_publicrelease_HapMapCeuFreq.txt.gz", header=T)
#Data3 <- read.table("/users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz", header=T)
##Data3.Chr5 <- Data3[Data3$CHR==5,]
#Data3.Chr19 <- Data3[Data3$CHR==19,]
#Output3 <- ash(Data3.Chr19$BETA, abs(Data3.Chr19$BETA)/qnorm(Data3.Chr19$P/2, lower.tail=FALSE))
#png("nana2.png", height=1500, width=3000, res=300); par(mfrow=c(1,2)); plot(Output3$result$betahat, Output3$result$PosteriorMean); abline(0,1, col="RED"); plot(-log10(1/seq(1, length(sort(-log10(2*pnorm(abs(Output3$result$betahat)/Output3$result$sebetahat, lower.tail=FALSE)), decreasing=FALSE)))), sort(-log10(2*pnorm(abs(Output3$result$betahat)/Output3$result$sebetahat, lower.tail=FALSE)), decreasing=FALSE), col="BLUE"); points(-log10(1/seq(1, nrow(Data3.Chr19))), sort(-log10(2*pnorm(abs(Output3$result$PosteriorMean)/Output3$result$PosteriorSD, lower.tail=FALSE)), decreasing=FALSE), col="RED"); abline(0,1, col="BLACK"); dev.off();
#head(Data2)
#Output2 <- ash(Data2$b, Data2$SE)

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz
		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.ashr.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.ashr.slurm.error --comment "ashr $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz | R -q -e \"library(\\\"ashr\\\"); Data1 <- read.table(file('stdin'), header=TRUE); Results1 <- ash(Data1\\\$BETA, abs(Data1\\\$BETA)/qnorm(Data1\\\$P/2, lower.tail=FALSE)); write.table(Results1\\\$result, file=\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results\\\", quote=FALSE, row.names=FALSE);\"\ngzip -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results")
	done	
done

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed

#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.500kbPadding.bed
#bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.500kbPadding.bed

bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.10kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.50kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.250kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.500kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.10kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.50kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.250kbPadding.bed
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.500kbPadding.bed

cat <(paste <(echo "Brit.Ran4k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Brit.Ran10k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \
<(paste <(echo "Brit.Ran100k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Brit.Ran200k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "African") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Caribbean") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Indian") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') ) \ 
<(paste <(echo "Irish") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') )  

paste <(echo "Afr_v_Caribbean") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 








for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.gz | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed

	done
done

#UKBioBankPops=`echo "African;African British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`; 
#UKBioBankPops=`echo "British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 African;African Caribbean;Caribbean Indian;Indian Irish;Irish"`;
UKBioBankPops=`echo "British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 British;British African;African Caribbean;Caribbean Indian;Indian Irish;Irish"`;
rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
#	rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.AllPopComps
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.AllPopComps 

		paste <(echo $ancestry2) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps 

	done	

	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps

done

for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 1e-4) { print join("\t", @F); }' | grep -v NA | awk '{ print "chr" $1 "\t" $3 "\t" $3 "\t" $2 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

#		if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm ]; then
#			mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm
#		fi 
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps 
		paste <(echo "$ancestry2") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
done

#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.slurm.error --comment "bedIntersect $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "paste <(echo \"$ancestry2\") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.10kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.50kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.250kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.500kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps") 
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.0kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.0kbPadding.slurm.error --comment "0kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }' > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.0kbPadding") 
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.10kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.10kbPadding.slurm.error --comment "10kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.10kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }' > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.10kbPadding") 
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.50kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.50kbPadding.slurm.error --comment "50kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.50kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.50kbPadding")
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.250kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.250kbPadding.slurm.error --comment "250kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.250kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.250kbPadding")
#		sbatch -t 24:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.500kbPadding.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/slurm/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.linear.bedIntersect.500kbPadding.slurm.error --comment "500kb $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.500kbPadding.bed | awk '{ print \$1 \"_\" \$2 }' | sort | uniq | wc | awk '{ print \$1 }') > /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.AllPopComps.500kbPadding")

#/users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.results.gz
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 

		paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.gz)  | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, 2*pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < 1e-4) { print join("\t", @F); }' | grep -v PosteriorSD | grep -v NA | grep -v ^\> | awk '{ print "chr" $1 "\t" $2 "\t" $2 "\t" $3 }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip"`; do
#for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 
		paste <(echo "$ancestry2") 
		<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') 
		<(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
done









#20180311

#From ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/, https://unix.stackexchange.com/questions/117988/wget-with-wildcards-in-http-downloads 

mkdir /users/mturchin/data/1000G
cd /users/mturchin/data/1000G
#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/*txt 
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL* 
#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/README* 
#wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/*ALL* 
mkdir /users/mturchin/data/1000G/mturchin20
mkdir /users/mturchin/data/1000G/mturchin20/subsets
mkdir /users/mturchin/data/1000G/subsets
mkdir /users/mturchin/data/1000G/subsets/CEU
mkdir /users/mturchin/data/1000G/subsets/YRI
mkdir /users/mturchin/data/1000G/subsets/CHB
for i in `cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $2 }' | sort | uniq`; do echo $i; cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | grep -w $i | awk '{ print $1 }' > /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs; done
cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.bim | awk '{ print $2 }' | sort | uniq > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.bim.rsIDs
#for i in `echo "CEU YRI CHB"`; do
#for i in `echo "GBR ESN JPT ACB ASW"`; do
#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW"`; do
#for i in `echo "MXL PEL ITU PJL"`; do
for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL TSI IBS FIN"`; do
#for i in `echo "TSI IBS FIN"`; do #20180419 NOTE -- as of this date, TSi/IBS only being included here for hirschhorn polygenic height re-up work, not anything to do with the collection of 1kG pops used for ukb PCAs/analysis (just fyi)
	
	if [ ! -d /users/mturchin/data/1000G/subsets/$i ]; then
		mkdir /users/mturchin/data/1000G/subsets/$i
	fi 
	if [ ! -d /users/mturchin/data/1000G/subsets/$i/mturchin20 ]; then
		mkdir /users/mturchin/data/1000G/subsets/$i/mturchin20
	fi 
	
	for j in `echo {1..22}`; do 
		sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; \ 
		echo -e "\n echo $i $j; vcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes"; \ 
		echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.recode.vcf"; \
		echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs"; \
		echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs"; \ 
		echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.map"; \
		echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs --extract /users/mturchin/data/ukbiobank_jun17/mturchin/ukb_chrAll_v2.All.QCed.pruned.QCed.bim.noX.rsIDs --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb";)
	done

#	j="X"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes"; echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.map";)
#	j="Y"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_integrated_v2a.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes"; echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.map";)

done
	
#		echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs --biallelic-only strict --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs"; \
#		echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs --exclude /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.dups.txt --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.dedup"; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.dedup --flip /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs-merge.missnp --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.dedup.flip"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.dedup.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.dedup.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.dedup.fam /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.dedup.log";)
#	j="X"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes"; echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.map";)
#	j="Y"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/ALL.chr${j}.phase3_integrated_v2a.20130502.genotypes.vcf.gz --keep /users/mturchin/data/1000G/subsets/integrated_call_samples_v3.20130502.ALL.panel.$i.IIDs --recode --recode-INFO-all --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes"; echo -e "\ngzip -f /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.map";)
#	j="X"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs --biallelic-only strict --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.map";)
#	j="Y"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs --biallelic-only strict --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.map";)
#	j="X"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs --exclude /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.dups.txt --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.dedup"; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.dedup --flip /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs-merge.missnp --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.dedup.flip"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.dedup.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.dedup.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.dedup.fam /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.dedup.log";)
#	j="Y"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs --exclude /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.dups.txt --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.dedup"; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.dedup --flip /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs-merge.missnp --make-bed --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.dedup.flip"; echo -e "\n rm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.dedup.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.dedup.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.dedup.fam /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.dedup.log";) 
#	j="X"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs --extract /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.bim.rsIDs --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ukb"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.map";)
#	j="Y"; sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e "\necho $i $j"; echo -e "\nvcftools --gzvcf /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.recode.vcf.gz --min-alleles 2 --max-alleles 2 --remove-indels --plink --out /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs"; echo -e "\nplink --file /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs --extract /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.bim.rsIDs --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ukb"; echo -e "\nrm /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ped /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.map";)
#		echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs --extract /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.bim.noX.rsIDs --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb";)
#		plink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs --extract /users/mturchin/data/ukbiobank_jun17/mturchin/ukb_chrAll_v2.All.QCed.pruned.QCed.bim.noX.rsIDs --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb
	
#for i in `echo "CEU YRI CHB"`; do
#for i in `echo "GBR ESN JPT ACB ASW"`; do
#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW"`; do
for i in `echo "MXL PEL ITU PJL"`; do
#for i in `echo "TSI IBS FIN"`; do
	echo $i

#	rm /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.MergeList.Vs1.txt 
#	rm /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.flipped.MergeList.Vs1.txt
#	rm /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.dedup.flip.MergeList.Vs1.txt 
	cat /dev/null > /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.MergeList.Vs1.txt 
        cat /dev/null > /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt 
#	cat /dev/null > /users/mturchin/data/1000G/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt

        for j in {2..22}; do
                echo "/users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.MergeList.Vs1.txt
                echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt
        done
#	j="X"; echo "/users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.MergeList.Vs1.txt 
#	j="Y"; echo "/users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.bed /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.bim /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.MergeList.Vs1.txt

done
	
#	j="X"; echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ukb.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ukb.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.SNPs.ukb.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt 
#	j="Y"; echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ukb.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ukb.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_integrated_v2a.20130502.genotypes.SNPs.ukb.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt

#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW"`; do
#	echo $i
#
##	sbatch -t 72:00:00 --mem 20g -o /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.slurm.error --comment "$i $j" <(echo -e '#!/bin/sh'; echo -e $i; echo -e "\ncat /users/mturchin/data/1000G/subsets/$i/*genotypes.SNPs.bim | awk '{ print $2 }' | sort | uniq -d > /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.dups.txt";)
#	cat /users/mturchin/data/1000G/subsets/$i/*genotypes.SNPs.bim | awk '{ print $2 }' | sort | uniq -d > /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.dups.txt
#
#done

#for i in `echo "CEU YRI CHB"`; do
#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW"`; do
#for i in `echo "CEU"`; do
#for i in `echo "TSI IBS FIN"`; do
for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL TSI IBS FIN"`; do
	echo $i /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.MergeList.Vs1.txt

        sbatch -t 72:00:00 --mem 20g -o /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3.genotypes.slurm.merge.output -e /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3.genotypes.slurm.merge.error --comment "MergeList $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --merge-list /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb") 

done

#cat /dev/null > /users/mturchin/data/1000G/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt
#for i in `echo "GBR YRI ESN CHB JPT ACB ASW"`; do
##for i in `echo "IBS FIN"`; do
#	echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam" >> /users/mturchin/data/1000G/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt
##	echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam" >> /users/mturchin/data/1000G/subsets/TSIIBSFIN.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt
#done
#
#plink --bfile /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --merge-list /users/mturchin/data/1000G/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt --make-bed --out /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb 
#cat /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.bim | awk '{ print $2 }' > /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.bim.rsIDs
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX --extract /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.bim.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.pre
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.onlyRltvs.noX --extract /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.bim.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.onlyRltvs.noX.1kG
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.pre --bmerge /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG
#
#/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG
#/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.onlyRltvs.noX.1kG
#
##plink --bfile /users/mturchin/data/1000G/subsets/TSI/mturchin20/TSI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --bmerge /users/mturchin/data/1000G/subsets/IBS/mturchin20/IBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --out /users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb 
#plink --bfile /users/mturchin/data/1000G/subsets/TSI/mturchin20/TSI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --merge-list /users/mturchin/data/1000G/subsets/TSIIBSFIN.chrAll.phase3.genotypes.SNPs.ukb.MergeList.Vs1.txt --make-bed --out /users/mturchin/data/1000G/mturchin20/subsets/TSIIBSFIN.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb









 

#20180319 

#NOTE 20180319 -- after running the provided (by the dbGaP download page) ascp command, I remove the key and replace it with '***'.
mkdir /users/mturchin/data/dbGaP
cd /users/mturchin/data/dbGaP

mkdir /users/mturchin/data/dbGaP/PAGE
mkdir /users/mturchin/data/dbGaP/PAGE/MEC
cd /users/mturchin/data/dbGaP/PAGE/MEC
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60828 .

mkdir /users/mturchin/data/dbGaP/PAGE/Summary
cd /users/mturchin/data/dbGaP/PAGE/Summary
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60836 .

mkdir /users/mturchin/data/dbGaP/PAGE/BioVU
cd /users/mturchin/data/dbGaP/PAGE/BioVU
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60837 .

mkdir /users/mturchin/data/dbGaP/eMERGE
mkdir /users/mturchin/data/dbGaP/eMERGE/NetworkPhenos
mkdir /users/mturchin/data/dbGaP/eMERGE/NetworkPhenos/HMB
cd /users/mturchin/data/dbGaP/eMERGE/NetworkPhenos/HMB
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60838 .
mkdir /users/mturchin/data/dbGaP/eMERGE/NetworkPhenos/HMB_Gene
cd /users/mturchin/data/dbGaP/eMERGE/NetworkPhenos/HMB_Gene
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60840 .
mkdir /users/mturchin/data/dbGaP/eMERGE/41Phenos
mkdir /users/mturchin/data/dbGaP/eMERGE/41Phenos/HMB
cd /users/mturchin/data/dbGaP/eMERGE/41Phenos/HMB
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60841 .
mkdir /users/mturchin/data/dbGaP/eMERGE/41Phenos/HMB_Gene
cd /users/mturchin/data/dbGaP/eMERGE/41Phenos/HMB_Gene
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60842 .
mkdir /users/mturchin/data/dbGaP/eMERGE/41Phenos/General
cd /users/mturchin/data/dbGaP/eMERGE/41Phenos/General
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60843 .

mkdir /users/mturchin/data/dbGaP/PAGE/GblRefPnl
cd /users/mturchin/data/dbGaP/PAGE/GblRefPnl
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60844 .

mkdir /users/mturchin/data/dbGaP/PAGE/IPMBioME
cd /users/mturchin/data/dbGaP/PAGE/IPMBioME
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/60845 .

#20180424
mkdir /users/mturchin/data/dbGaP/eMERGE/NetworkPhenos/HMB_GSO
cd /users/mturchin/data/dbGaP/eMERGE/NetworkPhenos/HMB_GSO
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/61499 .

mkdir /users/mturchin/data/dbGaP/eMERGE/41Phenos/HMB_GSO
cd /users/mturchin/data/dbGaP/eMERGE/41Phenos/HMB_GSO
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/61500 .

mkdir /users/mturchin/data/dbGaP/CHARGE
mkdir /users/mturchin/data/dbGaP/CHARGE/GRU
cd /users/mturchin/data/dbGaP/CHARGE/GRU
/users/mturchin/.aspera/connect/bin/ascp -QTr -l 300M -k 1 -i /users/mturchin/.aspera/connect/etc/asperaweb_id_dsa.openssh -W *** dbtest@gap-upload.ncbi.nlm.nih.gov:data/instant/mturchin20/61501 .

#20180509 (From Priya)
mkdir /users/mturchin/data/dbGaP/MESA
cd /users/mturchin/data/dbGaP/MESA
#Files copied over from Priya/MacBook Air
#scp -p /Users/mturchin20/Downloads/CONTROLS* /Users/mturchin20/Downloads/UnrelatedMESA* mturchin@ssh.ccv.brown.edu:/users/mturchin/data/dbGaP/MESA/.








#20180427 -- Height GWAS Results
#From https://docs.google.com/spreadsheets/d/1b3oGI2lUt57BcuHttWaZotQcI0-mBRPyZihz87Ms_No/edit#gid=1209628142
mkdir /users/mturchin/data2/Neale2017
cd /users/mturchin/data2/Neale2017
wget https://www.dropbox.com/s/f8ylaxjp4b0h5ti/ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz?dl=0 -O ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz 
wget https://www.dropbox.com/s/ehnp53rfqmp6xjg/variants.tsv?dl=0 -O variants.tsv
wget https://www.dropbox.com/s/oe5q85454vhc3hi/phenosummary_final_11898_18597.tsv?dl=0  -O phenosummary_final_11898_18597.tsv
wget https://www.dropbox.com/s/sbfgb6qd5i4cxku/50.assoc.tsv.gz?dl=0 -O 50.assoc.tsv.gz
wget https://www.dropbox.com/s/sweqn7nztyv42zt/21001.assoc.tsv.gz?dl=0 -O 21001.assoc.tsv.gz
wget https://www.dropbox.com/s/un2xvfmjsdhtrfb/48.assoc.tsv.gz?dl=0 -O 48.assoc.tsv.gz
wget https://www.dropbox.com/s/6nwd4p12xtaos87/49.assoc.tsv.gz?dl=0 -O 49.assoc.tsv.gz
#Copy and pasted contents of the Google Sheet into /users/mturchin/data2/Neale2017/UKBB_GWAS_Manifest_20170915
zcat /users/mturchin/data2/Neale2017/50.assoc.tsv.gz | sed 's/:/ /g' | perl -lane 'print "chr", $F[0], "\t", $F[1], "\t", $F[1], "\t", join("_", @F[3,8,9,11]);' | grep -v chrvariant | gzip > /users/mturchin/data2/Neale2017/50.assoc.edits.bed.gz

#From https://data.broadinstitute.org/alkesgroup/UKBB/
mkdir /users/mturchin/data2/Loh2017
cd /users/mturchin/data2/Loh2017
wget https://data.broadinstitute.org/alkesgroup/UKBB/body_HEIGHTz.sumstats.gz
wget https://data.broadinstitute.org/alkesgroup/UKBB/body_BMIz.sumstats.gz
wget https://data.broadinstitute.org/alkesgroup/UKBB/body_WHRadjBMIz.sumstats.gz
##zcat /users/mturchin/data2/Loh2017/body_HEIGHTz.sumstats.gz | awk '{ print "chr" $2 "\t" $3 "\t" $3 "\t" $4 "_" $8 "_" $9 "_" $10 }' | grep -v chrCHR | sed 's/E/e/g' | gzip > /users/mturchin/data2/Loh2017/body_HEIGHTz.sumstats.edits.bed.gz
zcat /users/mturchin/data2/Loh2017/body_HEIGHTz.sumstats.gz | awk '{ print "chr" $2 "\t" $3 "\t" $3 "\t" $4 "_" $8 "_" $9 "_" $10 }' | grep -v chrCHR | sed 's/_/ /g' | sed 's/E/ /g' | R -q -e "Data1 <- read.table(file('stdin'), header=F); Data1 <- cbind(Data1, Data1[,8] + log10(Data1[,7])); write.table(Data1, quote=FALSE, col.names=FALSE, row.names=FALSE);" | grep -v ^\> | awk '{ print $1 "\t" $2 "\t" $3 "\t" $4 "_" $5 "_" $6 "_" $9 "_" $7 "e" $8 }' | gzip > /users/mturchin/data2/Loh2017/body_HEIGHTz.sumstats.edits.bed.gz

#From Eric Bartells (Hirschhorn Lab)
mkdir /users/mturchin/data2/HirschhornLab
#From MacBook Air
scp -p /Users/mturchin20/Documents/Work/LabMisc/Data/Hirschhorn/20180427_Bartell.tsv mturchin@ssh.ccv.brown.edu:/users/mturchin/data2/HirschhornLab/. 
mv /users/mturchin/data2/HirschhornLab/20180427_Bartell.tsv /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.tsv
gzip /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.tsv
zcat /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.tsv.gz | perl -lane '$F[0] =~ s/.0//; print "chr", $F[0], "\t", $F[1], "\t", $F[1], "\t", join("_", @F[2,19,5,18,$#F-1,$#F]);' | grep -v chrchrom | gzip > /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz





#20180427 -- PopRes
#/users/mturchin/data/POPRES/*
#/users/mturchin/data/POPRES/NHGRI/POPRES/phs000145v2/p2/phg000027v2/phg000027.v2.p2.POPRES.genotype-calls.Affy500K.c1.GRU.matrixfmt.genotype/POPRES_Genotypes_QC2_v2.bed (...*)
cat /users/mturchin/data/POPRES/NHGRI/POPRES/phs000145v2/p2/POPRES.European.covariates.txt | grep -v ^# | perl -F\\t -lane 'print $F[$#F-7];' | sort | uniq -c










#From https://github.com/gabraham/flashpca
#See /users/mturchin/PackageInstallationLog.vs1.sh for information re: installing flashpca (done within Conda environment; recall note re: 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/users/mturchin/conda/MultiEthnicGWAS/lib')
```
.
.
.
Quick start
First thin the data by LD (highly recommend plink2 for this):

plink --bfile data --indep-pairwise 1000 50 0.05 --exclude range exclusion_regions_hg19.txt
plink --bfile data --extract plink.prune.in --make-bed --out data_pruned
where exclusion_regions_hg19.txt contains:

5 44000000 51500000 r1
6 25000000 33500000 r2
8 8000000 12000000 r3
11 45000000 57000000 r4
(You may need to change the --indep-pairwise parameters to get a suitable number of SNPs for you dataset, 10,000-50,000 is usually enough.)

To run on the pruned dataset:

./flashpca --bfile data_pruned
To append a custom suffix '_mysuffix.txt' to all output files:

./flashpca --suffix _mysuffix.txt ...
To see all options

./flashpca --help 
Output
By default, flashpca produces the following files:

eigenvectors.txt: the top k eigenvectors of the covariance X XT / p, same as matrix U from the SVD of the genotype matrix X/sqrt(p)=UDVT (where p is the number of SNPs).
pcs.txt: the top k principal components (the projection of the data on the eigenvectors, scaled by the eigenvalues, same as XV (or UD). This is the file you will want to plot the PCA plot from.
eigenvalues.txt: the top k eigenvalues of X XT / p. These are the square of the singular values D (square of sdev from prcomp).
pve.txt: the proportion of total variance explained by each of the top k eigenvectors (the total variance is given by the trace of the covariance matrix X XT / p, which is the same as the sum of all eigenvalues). To get the cumulative variance explained, simply do the cumulative sum of the variances (cumsum in R).
Warning
You must perform quality control using PLINK (at least filter using --geno, --mind, --maf, --hwe) before running flashpca on your data. You will likely get spurious results otherwise.
.
.
.
Checking accuracy of results
flashpca can check how accurate a decomposition is, where accuracy is defined as || X XT / p - U D2 ||F2 / (n × k).

This is done using

./flashpca --bfile data --check \
--outvec eigenvectors.txt --outval eigenvalues.txt
The final mean squared error should be low (e.g., <1e-8).

Outlier removal in PCA
Unlike EIGENSOFT/smartpca, flashpca does not remove outliers automatically (numoutlieriter in EIGENSOFT). We recommend inspecting the PCA plot manually, and if you wish to remove outliers and repeat PCA on the remaining samples, use plink --remove to create a new bed/bim/fam fileset and run flashpca on the new data.
.
.
.
```

#Some info on more recent QC procedures, from: https://www.biorxiv.org/content/biorxiv/early/2017/07/20/166298.full.pdf, https://www.biorxiv.org/content/biorxiv/suppl/2017/07/20/166298.DC1/166298-1.pdf & https://media-nature-com.revproxy.brown.edu/original/nature-assets/ng/journal/v46/n11/extref/ng.3097-S1.pdf
#Note -- the following article has a good, short description re: the concern of strand-mismatching, which moreso has to do with comparing a given dataset with a reference datasets (which shouldn't be a problem here when dealing with just within-UKBioBank data and not
#Note -- little unsure why they were concerned with 'unresolvable strand differences' since they knew the strand for UKBioBank (all '+' it looks like), and they should have been able to get some raw information for the stranded of the 1000G data too....unless for some reason that latter information wasn't available? Pretty sure you can determine even C/G and A/T ref/alt differences between two datasets if you can confirm that both datasets are on the same strand?...
#Note -- I think not using/including 1000G data to determine PCs within each ancestry subset is fine...but if wanting to create or use global PCs probably want to include 1000G data like UKBioBank 2017 publication did; in fact their PC data may even be available (probably/likely it is??) ('/users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt' shows the PC loadings for some SNPs but not all SNPs...which probably means those are the SNPs that were used in the overlapping, pruned dataset to get the PCs...but currently don't have the individual QC file that would give us the individual PC loadings which should be dataset-wide, unlike only some of these SNPs having the PC-loadings information)
```
.
.
.
	In	order	to	
attenuate population	structure	effects we	applied	all	marker-based	QC	tests	using	a	
subset	of	463,844 individuals	with	estimated	European	ancestry.	We	identified these	
individuals	from	the genotype data	prior	to	conducting	any	QC by projecting all	the	
UK	Biobank	samples	on	to	the	two	major	principal	components of	four	1000	
Genomes	populations	(CEU,	YRI,	CHB	and	JPT) [28].	We	then	selected samples	with	
principal	component (PC) scores	falling	in	the	neighbourhood	of	the	CEU	cluster (see	
Supplementary	Material).	
Most	QC	metrics	require	a	threshold	beyond	which	to	consider	a	marker	‘not	
reliable’.	We	used thresholds such	that	only	strongly	deviating	markers	would	fail	QC	
tests (see Supplementary	Material),	therefore	allowing	researchers	to	further	refine	
the	QC	in	whichever	way	is	most	appropriate	for their	study	requirements. Table	3
summarises	the	amount	of	data	affected	by applying	these	tests.
.
.
.
```
```
.
.
.
We	first	downloaded	1000	Genomes	Project	Phase	1	data in Variant	Call	File	(VCF)	
format	[8] and	extracted	714,168	SNPs (no	Indels)	that	are	also on	the	UK	Biobank	
Axiom	array.		We	selected	355	unrelated	samples	from	the	populations	CEU,	CHB,	
JPT,	YRI,	and	then	chose	SNPs	for	principal	component	analysis	using	the	following	
criteria:
• MAF	≥	5%	and	HWE	p-value	>	10-6
,	in	each	of	the	populations	CEU,	CHB,	JPT	
and	YRI.		
• Pairwise	r
2 ≤	0.1	to	exclude	SNPs	in	high	LD.		(The	r
2 coefficient	was	
computed	using	plink [9] and	its ‘indep-pairwise’	function	with	a	moving	
window	of	size	1000	bp).
• Removed	C/G	and	A/T	SNPs	to	avoid	unresolvable	strand	mismatches.
• Excluded	SNPs	in	several	regions	with	high	PCA	loadings	(after	an	initial	PCA).
With	the	remaining	40,220 SNPs	we	computed	PCA loadings	from	the	355	1,000	
Genomes	samples,	then	projected	all	the UK	Biobank	samples	onto	the	1st and	2nd
principal	components.		All	computations	were	performed	with	Shellfish
(http://www.stats.ox.ac.uk/~davison/software/shellfish/shellfish.php).
.
.
.
```
```
.
.
.
1.1.5 Meta-analysis of GWA studies
A total of 2,550,858 autosomal SNPs were meta-analyzed across 174 input files (many of
the 79 cohorts had separate male-female and/or case-control files). We did not apply a
minor allele frequency cut-off, but we did apply an arbitrary cut-off of NxMAF > 3 (equivalent
Nature Genetics: doi:10.1038/ng.3097
Page 48 of 76
to a minor allele count of 6) to guard against extremely rare variants present in only one or
two samples (possible genotyping/imputation errors or private mutations), for which
regression coefficients are not estimated well using the standard statistical methods
employed in most GWA statistical programs
.
.
.
Supplementary Table 17. Study design, number of individuals and sample quality control for genome-wide association study cohorts
Study
Study design Total sample
size (N)
Sample QC Samples in
analyses(N)
Anthropometric
assessment
method
References Short name Full name Call rate* other exclusions
ACTG The AIDS Clinical
Trials Group
Population-based 2648 >95% 1) Non-Europeans (based on PCA);
2) High individual missingness
(>5%);
3) High heterozygosity (Inbreeding
coefficient > 0.1 or < -0.1);
4) Related individuals
5) duplicates
1055 measured International, H.I.V.C.S. et al. The major genetic
determinants of HIV-1 control affect HLA class I peptide
presentation. Science 330, 1551-7 (2010).
AE Athero-Express
Biobank Study
patient-cohort 2512 ≥ 97% 1) Heterozygosity (Ĥ) ± 3 standard
deviations of the mean;
2) Ethnic outliers through Principal
Component Analysis compared to
HapMap 2 (r22);
3) Related individuals and
duplicates, π>0.20;
4) Missing body weight and height.
686 measured 1) Verhoeven, B.A. et al. Athero-express: differential
atherosclerotic plaque expression of mRNA and protein
in relation to cardiovascular events and patient
characteristics. Rationale and design. Eur J Epidemiol 19,
1127-33 (2004).
2) Hurks, R. et al. Aneurysm-express: human abdominal
aortic aneurysm wall expression in relation to
heterogeneity and vascular events - rationale and
design. Eur Surg Res 45, 34-40 (2010).
ASCOT AngloScandinavian

Cardiac Outcome
Trial
Randomised control
clinical trial
3868 ≥ 95% 1) Sample cryptic duplicates
2) Sample outliers in ancestry
principle components analysis
3) First and second degree
relatives;
4) Missing body weight and height.
3802 measured
.
.
.
```
```
.
.
.
Strand alignment
Strand alignment between genotype data set and reference data set is crucial for GWA analysis and imputation. Generally, reference panels such as HapMap are given as ‘+’ strand but data might be genotyped with respect to negative strand. If two samples at a SNP are genotyped at different strands, it can be easily recognized except for C/G or A/T SNPs. PLINK has the option to detect opposite strand alignments between cases and controls (“--flip-scan”). fcGENE supports the comparison of strand information between genotyped SNP data and reference panels using this PLINK's “--flip-scan” feature in the following way:
.
.
.
```

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/users/mturchin/conda/MultiEthnicGWAS/lib

#cd /users/mturchin/Software/flashpca
#wget https://github.com/gabraham/flashpca/blob/master/exclusion_regions_hg19.txt
#Note -- this file is already provided with the flashpca install

#20180313 Note -- as of this date, the first version of this file downloaded appears to be the 'old' version in circulation (see 'http://www.ukbiobank.ac.uk/wp-content/uploads/2017/07/ukb_genetic_file_description.txt'); going to attempt to find/locate/access the most recent, up-to-date one soon
cd /users/mturchin/data/ukbiobank_jun17
ftp ftp.ega.ebi.ac.uk
#See Slack for login & PW
cd EGAD00010001226
ls
get ukb_sqc_v2.txt.gz.enc.cip
paste <(cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr17_v2_s488363.fam) <(zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.txt.gz) | gzip > /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz
zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($29 == 1) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs
zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($25 == 1) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.hetmiss_outlrs.FIDIIDs
zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($26 == 1) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.putativ_aneuploidy.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.hetmiss_outlrs.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.putativ_aneuploidy.FIDIIDs | sort | uniq > /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.ukbDrops.FIDIIDs
cat <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) | perl -lane 'print join("\t", @F[1..$#F]);' | sort | uniq > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.dropExcess.dat 
cat <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.hetmiss_outlrs.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.putativ_aneuploidy.FIDIIDs | sort -k 1,1 | uniq)) <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.hetmiss_outlrs.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.putativ_aneuploidy.FIDIIDs | sort -k 1,1 | uniq)) | perl -lane 'print join("\t", @F[1..$#F]);' | sort | uniq > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.wukbDrops.dat 

#UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;
#UKBioBankPops=`echo "African;African Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Indian;Indian Irish;Irish"`; 
UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`; 
#UKBioBankPops=`echo "African;African"`;
#UKBioBankPops=`echo "British;British British;British.Ran100000 British;British.Ran200000"`;
#UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British.Ran4000 British;British.Ran10000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;
UKBioBankPops=`echo "British;British.Admix.TSI9;BritTSI9 British;British.Admix.TSI95;BritTSI95 British;British.Admix.TSI9Ran10k;BritTSI9Ran10k British;British.Admix.TSI8;BritTSI8 British;British.Admix.TSI9Ran20k;BritTSI9Ran20k British;British.Admix.TSI89Ran10k;BritTSI89Ran10k British;British.Admix.IBS9;BritIBS9 British;British.Admix.IBS95;BritIBS95 British;British.Admix.IBS9Ran10k;BritIBS9Ran10k British;British.Admix.IBS8;BritIBS8 British;British.Admix.IBS9Ran20k;BritIBS9Ran20k British;British.Admix.IBS89Ran10k;BritIBS89Ran10k"`;

mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1
mkdir /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/AncCmps
mv /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/PCAEffect /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/.
#/users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/scripts/Intro/2017WinterHack.plink.GetAncestrySubsets.vs2.sh
#/users/mturchin/data/ukbiobank_jun17/subsets/

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
	echo $ancestry1 $ancestry2

	if [ ! -d /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20 ]; then
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Height
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/BMI
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Waist
		mkdir /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Hip
	fi

	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.bed* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.fam* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.bim* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.log* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.nosex* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr*_v2.$ancestry2.slurm* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*Height* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Height/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*BMI* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/BMI/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*Waist* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Waist/.
	mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/*Hip* /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/Hip/.

done

#for pheno1 in `echo "Height BMI Waist Hip"`; do
for pheno1 in `echo "Height"`; do
#for pheno1 in `echo "BMI Waist Hip"`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22}; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			sbatch -t 72:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.QC.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.QC.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \ 
			echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --maf .01 --geno .05 --hwe 1e-6 --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed"; \ 
			echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed --indep-pairwise 1000 50 0.05 --exclude range /users/mturchin/Software/flashpca/exclusion_regions_hg19.txt --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed"; \
			echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed --extract /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.prune.in --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.pruned") 

		done
	done	
	sleep 2
done

#			sbatch -t 72:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.fastpca.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --maf .01 --geno --mind .95
#			sbatch -t 1:00:00 --mem 20g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.slurm.error --comment "$pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2} --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt --covar-name AGE --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}")

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt

	cat /dev/null > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt
	
	for chr in {2..22}; do
		echo "/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${chr}_v2.${ancestry2}.QCed.pruned.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${chr}_v2.${ancestry2}.QCed.pruned.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${chr}_v2.${ancestry2}.QCed.pruned.fam" >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt
	done

done








for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt

	sbatch -t 1:00:00 --mem 100g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.slurm.MergeList.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.slurm.MergeList.error --comment "$ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr1_v2.${ancestry2}.QCed.pruned --merge-list /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.MergeList.Vs2.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned") 
done

##For $UKBioBankPops not including 'British;British British;British.Ran100000 British;British.Ran200000' 
for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	sbatch -t 72:00:00 --mem 200g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.QC.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.QC.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \ 
	echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned --mind .05 --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed"; \
#	echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed --genome gz --min .05 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed";) 

done	










	
##For $UKBioBankPops including 'British;British British;British.Ran100000 British;British.Ran200000' 
#cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | awk '{ print $1 "\t" $1 "\t" $2 "\t" $2 "\t" $3 "\t" $4 "\tPH\tPH\tPH\t" $5 }' | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.ukb22419_rel_s488363.gz
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.ukb22419_rel_s488363.gz /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.genome.gz 

/users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.ukbDrops.FIDIIDs
/users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.wukbDrops.dat

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

#	cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.gz 
	cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.wukbDrops.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.wukbDrops.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.gz 
	zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.gz | awk '{ if ($5 >= .0884) { print $0 } }' | wc
	zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.gz | awk '{ if ($5 >= .0442) { print $0 } }' | wc

done	

#From: https://www.biostars.org/p/75335/
#IBD values for 1st degree rels (~.5), 2nd degree (~.25), 3rd degree (~.125) -- using .2 as cutoff for now to get rid of 2nd degree & up allowing for a little bit of room for egregious, cryptic relatedness (ie that space in between .2 and .25)
#From http://people.virginia.edu/~wc9c/KING/manual.html & https://biobank.ctsu.ox.ac.uk/crystal/docs/genotyping_qc.pdf
#re: KING kinship coefficients from their paper: "an estimated kinship coefficient range >0.354, [0.177, 0.354], [0.0884, 0.177] and [0.0442, 0.0884] corresponds to duplicate/MZ twin, 1st-degree, 2nd-degree, and 3rd-degree relationships respectively"
#UKBioBankPops=`British;British British;British.Ran100000 British;British.Ran200000`
for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.gz  | awk '{ if ($5 >= .0442) { print $1 "\t" $1 "\t" $2 "\t" $2 } }' | grep -v Kinship |  R -q -e "set.seed(459721380); Data1 <- read.table(file('stdin'), header=F); names(Data1)[3] <- names(Data1)[1]; names(Data1)[4] <- names(Data1)[2]; Data2 <- c(); for (i in 1:nrow(Data1)) { if (runif(1) >= .5) { Data2 <- rbind(Data2, Data1[i,c(1:2)]); } else { Data2 <- rbind(Data2, Data1[i,c(3:4)]) } }; write.table(Data2, quote=FALSE, col.names=FALSE, row.names=FALSE);" | grep -v \> | grep -v FID | sort | uniq > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.drop.FIDIIDs
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.drop.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.ukbDrops.FIDIIDs | sort | uniq > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukbKing.drop.ukbDrops.FIDIIDs
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.bim | awk '{ if ($1 != 23) { print $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.bim.noX.rsIDs
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed --remove /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukbKing.drop.ukbDrops.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs --extract /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.bim.noX.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed --keep /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukbKing.drop.ukbDrops.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs --extract /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.bim.noX.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs.noX

done	








#R -q -e "set.seed(459721380); Data1 <- read.table(file('stdin'), header=F); Data2 <- c(); for (i in 1:nrow(Data1)) { if (runif(1) >= .5) { Data2 <- rbind(Data2, c(Data1[i,c(1:2)])); } else { Data2 <- rbind(Data2, c(Data1[i,
#R -q -e "set.seed(459721380); Data1 <- read.table(file('stdin'), header=F); names(Data1)[3] <- names(Data1)[1]; names(Data1)[4] <- names(Data1)[2]; Data2 <- c(); for (i in 1:nrow(Data1)) { if ((! Data1[i,2] %in% Data2[,2]) && (! Data1[i,4] %in% Data2[,2])) { if (runif(1) >= .5) { Data2 <- rbind(Data2, Data1[i,c(1:2)]); } else { Data2 <- rbind(Data2, Data1[i,c(3:4)]) } } }; write.table(Data2, quote=FALSE, col.names=FALSE, row.names=FALSE);" | grep -v \> > 
#	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs | wc
#	zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.gz | awk '{ if ($10 >= .2) { print $1 "\t" $2 "\t" $3 "\t" $4 } }' | grep -v PI_HAT |  R -q -e "set.seed(459721380); Data1 <- read.table(file('stdin'), header=F); names(Data1)[3] <- names(Data1)[1]; names(Data1)[4] <- names(Data1)[2]; Data2 <- c(); for (i in 1:nrow(Data1)) { if (runif(1) >= .5) { Data2 <- rbind(Data2, Data1[i,c(1:2)]); } else { Data2 <- rbind(Data2, Data1[i,c(3:4)]) } }; write.table(Data2, quote=FALSE, col.names=FALSE, row.names=FALSE);" | grep -v \> | grep -v FID | sort | uniq > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs 
#	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.wukbDrops.FIDIIDs

#For comparison to below: ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/README_phase3_callset_20150220
cat /users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/ukb_chrAll_v2.*.QCed.pruned.QCed.bim.noX.rsIDs | sort | uniq > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb_chrAll_v2.All.QCed.pruned.QCed.bim.noX.rsIDs

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.run.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.run.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \ 
	echo -e "\n/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX -d 20 --outpc /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.pcs.txt --outload /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.loads.txt --outvec /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.vecs.txt --outval /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.vals.txt --outpve /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.pve.txt --outmeansd /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.meansd.txt"; \
	echo -e "\n/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs.noX --project --inmeansd /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.meansd.txt --outproj /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.projRltvs.txt --inload /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.loads.txt"; \
	echo -e "\nR -q -e \"Data1 <- read.table(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.pcs.txt\\\", header=T); Data2 <- read.table(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.projRltvs.txt\\\", header=T); Data1 <- cbind(Data1, rep(\\\"BLACK\\\", nrow(Data1))); Data2 <- cbind(Data2, rep(\\\"RED\\\", nrow(Data2))); names(Data2)[ncol(Data2)] <- names(Data1)[ncol(Data1)]; Data3 <- rbind(Data1, Data2); png(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.flashpca.wRltvs.PCplots.vs1.png\\\", height=8000, width=4000, res=300); par(oma=c(5,5,4,2), mfrow=c(4,2)); plot(Data3[,3], Data3[,4], xlab=\\\"PC1\\\", ylab=\\\"PC2\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,5], Data3[,6], xlab=\\\"PC3\\\", ylab=\\\"PC4\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,7], Data3[,8], xlab=\\\"PC5\\\", ylab=\\\"PC6\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,9], Data3[,10], xlab=\\\"PC7\\\", ylab=\\\"PC8\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,11], Data3[,12], xlab=\\\"PC9\\\", ylab=\\\"PC10\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,13], Data3[,14], xlab=\\\"PC11\\\", ylab=\\\"PC12\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,15], Data3[,16], xlab=\\\"PC13\\\", ylab=\\\"PC14\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data3[,17], Data3[,18], xlab=\\\"PC15\\\", ylab=\\\"PC16\\\", col=Data3[,ncol(Data3)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); dev.off();\"";)

done	

#legend(\"bottomright\", c(\"GWAS Thresh\"), lty=2, lwd=2, col=\"RED\", cex=1.5);

#From MacBook Air
#mkdir /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1
#mv /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/.
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/*noX.flashpca*wRltvs.PCplots.vs1.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.

cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(234324); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 50 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(234724); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 100 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(234444); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 500 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(434322); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 1000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(564374); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 5000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(254329); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(274384); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 5000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(737321); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 100000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs | R -q -e "set.seed(931284); Data1 <- read.table(file('stdin'), header=F); Data1 <- Data1[sample(nrow(Data1)),] ; write.table(Data1, quote=FALSE, row.names=FALSE, col.names=FALSE);" | grep -v \> | head -n 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000.FIDIIDs

plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000
plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr2_v2.British --keep /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs --hardy --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2

paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran500.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran1000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran5000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran10000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran50000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran100000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran250000.hwe | sort -rg -k 9,9 | awk '{ print $9 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.hwe | sort -rg -k 9,9 | awk '{ print $9 }') | vi -

#R -q -e "png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.hweComps.vs1.png\", height=2000, width=2000, res=300); plot(0, xlim=c(0, 61966), ylim=c(0,-log10(9.881e-323))); for (i in c(50, 100, 500, 1000, 5000, 10000, 50000, 100000, 250000)) { Data1 <- read.table(paste(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.Ran\", i, \".hwe\", sep=\"\"),  header=T); Data1 <- Data1[order(Data1[,9], decreasing=FALSE),]; points(seq(1, 61966), -log10(Data1[,9])); }; Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb9200.2017_8_WinterRetreat.Covars.British.Vs2.hwe\", header=T); Data1 <- Data1[order(Data1[,9], decreasing=FALSE),]; points(seq(1, 61966), -log10(Data1[,9])); dev.off();"


#/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG
#/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.onlyRltvs.noX.1kG

/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG -d 20 --outpc /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.txt --outload /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.loads.txt --outvec /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.vecs.txt --outval /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.vals.txt --outpve /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pve.txt --outmeansd /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.meansd.txt
	
/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.onlyRltvs.noX.1kG --project --inmeansd /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.meansd.txt --outproj /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.projRltvs.txt --inload /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.loads.txt

join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.fam | awk '{ print $1 "_" $2 "\tukb_AFR" }') <(cat /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_CEU" }') <(cat /users/mturchin/data/1000G/subsets/GBR/mturchin20/GBR.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_GBR" }') <(cat /users/mturchin/data/1000G/subsets/YRI/mturchin20/YRI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_YRI" }') <(cat /users/mturchin/data/1000G/subsets/ESN/mturchin20/ESN.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_ESN" }') <(cat /users/mturchin/data/1000G/subsets/CHB/mturchin20/CHB.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_CHB" }') <(cat /users/mturchin/data/1000G/subsets/JPT/mturchin20/JPT.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_JPT" }') <(cat /users/mturchin/data/1000G/subsets/ACB/mturchin20/ACB.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_ACB" }') <(cat /users/mturchin/data/1000G/subsets/ASW/mturchin20/ASW.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_ASW" }') | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);' | cat <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.txt | head -n 1 | perl -lane 'push (@F, "POP"); print join("\t", @F);') - > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt

#From: https://www.r-bloggers.com/palettes-in-r/

R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt\", header=T); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.projRltvs.txt\", header=T); \ 
Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1[,ncol(Data1)] <- factor(Data1[,ncol(Data1)], levels=c(colors(), brewer.pal(12, \"Paired\"))); \ 
Data1[Data1[ncol(Data1)-1] == \"1kG_CEU\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[2]; Data1[Data1[ncol(Data1)-1] == \"1kG_GBR\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[1]; Data1[Data1[ncol(Data1)-1] == \"1kG_YRI\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[6]; Data1[Data1[ncol(Data1)-1] == \"1kG_ESN\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[5]; Data1[Data1[ncol(Data1)-1] == \"1kG_CHB\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[4]; Data1[Data1[ncol(Data1)-1] == \"1kG_JPT\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[3]; Data1[Data1[ncol(Data1)-1] == \"1kG_ACB\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[10]; Data1[Data1[ncol(Data1)-1] == \"1kG_ASW\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[9]; Data1 <- cbind(Data1, rep(16, nrow(Data1))); \
Data1[Data1[ncol(Data1)-2] != \"ukb_AFR\", ncol(Data1)] <- 4; \
Data2 <- cbind(Data2, rep(\"ukb_AFR\", nrow(Data2))); Data2 <- cbind(Data2, rep(brewer.pal(12, \"Paired\")[11], nrow(Data2))); Data2 <- cbind(Data2, rep(16, nrow(Data2))); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-2], levels=levels(Data1[,ncol(Data1)-2])); Data2[,ncol(Data2)-1] <- factor(Data2[,ncol(Data2)-1], levels=c(colors(), brewer.pal(12, \"Paired\"))); \ 
names(Data2) <- names(Data1); Data3 <- rbind(Data1, Data2); \ 
plotLegend <- function(x) { return(legend(x, c(\"ukb_AFR\", \"AFR_rel\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\"), pch=c(16, 16, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), bg=\"transparent\", cex=1.25)); }; \
png(\"/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.AFR.1kG.flashpca.wRltvs.PCplots.vs1.png\", height=8000, width=4000, res=300); par(oma=c(5,5,4,2), mfrow=c(4,2)); \ 
plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"bottomleft\"); abline(.005, .555); \
plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"topleft\"); \ 
plot(Data3[,7], Data3[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"bottomright\"); \
plot(Data3[,9], Data3[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"topleft\"); \
plot(Data3[,11], Data3[,12], xlab=\"PC9\", ylab=\"PC10\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"bottomleft\"); \ 
plot(Data3[,13], Data3[,14], xlab=\"PC11\", ylab=\"PC12\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"topleft\"); \
plot(Data3[,15], Data3[,16], xlab=\"PC13\", ylab=\"PC14\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"bottomleft\"); \
plot(Data3[,17], Data3[,18], xlab=\"PC15\", ylab=\"PC16\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend(\"bottomright\"); dev.off(); \
aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * .555) + .005) ) { returnVal1 <- TRUE; }; return(returnVal1); }; \
Data3[(Data3[,ncol(Data3)-2] == \"ukb_AFR\" & (! mapply(aboveLnrThrsh, Data3[, 3], Data3[, 4]))), ncol(Data3)-1] <- \"brown\"; \
plotLegend2 <- function(x) { return(legend(x, c(\"ukb_AFR\", \"AFR_rel\", \"AFR_Outlr\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\"), pch=c(16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", brewer.pal(12, \"Paired\")[11], \"BROWN\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), bg=\"transparent\", cex=1.25)); }; \
png(\"/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.AFR.1kG.flashpca.wRltvs.PCplots.ctOff.vs1.png\", height=3500, width=6000, res=300); par(oma=c(5,5,4,2), mfrow=c(1,2)); \
plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend2(\"bottomleft\"); abline(.005, .555); \
plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend2(\"topleft\"); dev.off();"  

#From MacBook Air
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.wRltvs.PCplots.vs1.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.AFR.1kG.flashpca.wRltvs.PCplots.*png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.

##Data4 <- Data3[Data3[,ncol(Data3)-2] == "ukb_AFR",][mapply(aboveLnrThrsh, Data3[Data3[,ncol(Data3)-2] == "ukb_AFR", 3], Data3[Data3[,ncol(Data3)-2] == "ukb_AFR", 4]),]
#Data4 <- Data3[(Data3[,ncol(Data3)-2] == \"ukb_AFR\" & mapply(aboveLnrThrsh, Data3[, 3], Data3[, 4])) | Data3[,ncol(Data3)-2] != \"ukb_AFR\",]; \
#plot(Data4[,3], Data4[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data4[,ncol(Data4)], col=as.character(Data4[,ncol(Data4)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend2(\"bottomleft\"); abline(.005, .555); \
#plot(Data4[,5], Data4[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data4[,ncol(Data4)], col=as.character(Data4[,ncol(Data4)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend2(\"topleft\"); dev.off()" 

#Data1[Data1[ncol(Data1)-1] == \"1kG_CEU\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[2]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_GBR\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[1]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_YRI\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[6]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_ESN\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[5]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_CHB\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[8]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_YRI\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[7]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_ACB\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[4]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_ASW\", ncol(Data1)] <- brewer.pal(12, \"Paired\")[3]; \

#Data1[Data1[ncol(Data1)-1] == \"1kG_CEU\", ncol(Data1)] <- \"blue\"; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_GBR\", ncol(Data1)] <- \"cyan\"; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_YRI\", ncol(Data1)] <- \"lightcoral\"; \ 
#Data1[Data1[ncol(Data1)-1] == \"1kG_ESN\", ncol(Data1)] <- \"hotpink4\"; \ 
#Data1[Data1[ncol(Data1)-1] == \"1kG_CHB\", ncol(Data1)] <- \"yellow\"; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_YRI\", ncol(Data1)] <- \"orange\"; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_ACB\", ncol(Data1)] <- colors()[10]; \
#Data1[Data1[ncol(Data1)-1] == \"1kG_ASW\", ncol(Data1)] <- \"green\"; \ 









UKBioBankPops=`echo "African;African Any_other_Asian_background;Any_other_Asian_background Any_other_mixed_background;Any_other_mixed_background Any_other_white_background;Any_other_white_background British;British British;British.Ran4000 British;British.Ran10000 British;British.Ran100000 British;British.Ran200000 Caribbean;Caribbean Chinese;Chinese Indian;Indian Irish;Irish Pakistani;Pakistani"`;

#Below because this one SNP was messing up the downstream merge between ukb and 1kG, so just removing it for ease here
#cp -p /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.bim.noX.rsIDs /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.bim.noX.rsIDs.vs1
cat /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.bim.noX.rsIDs | grep -v rs57154009 > /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.bim.noX.rsIDs.tmp
mv /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.bim.noX.rsIDs.tmp /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.bim.noX.rsIDs 

#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW"`; do
#for i in `echo "CEU GBR YRI ESN CHB JPT 
#for i in `echo "ASW MXL PEL ITU PJL"`; do
#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL"`; do
#for i in `echo "TSI IBS FIN"`; do
for i in `cat <(echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL TSI IBS FIN" | perl -lane 'print join("\n", @F);') | head -n 1`; do
	for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | head -n 1`; do
		ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
		
		for j in `echo {1..22}`; do 
			sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3.genotypes.slurm.output -e /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3.genotypes.slurm.error --comment "$i $k $j" <(echo -e '#!/bin/sh'; \ 
			echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs --extract /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.bim.noX.rsIDs --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}";)
		done
	
	done
	sleep 2
done










#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL"`; do
for i in `echo "TSI IBS FIN"`; do
	for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
        
		cat /dev/null > /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt 
		
		for j in `echo {1..22}`; do 
			echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam" >> /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt
		done
	
	done
done

#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL"`; do
#for i in `echo "TSI IBS FIN"`; do
for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL TSI IBS FIN"`; do
#for i in `echo "TSI IBS FIN"`; do
	echo $i /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.MergeList.Vs1.txt
	for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	        sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3.genotypes.ukb.${ancestry2}.slurm.merge.output -e /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3.genotypes.ukb.${ancestry2}.slurm.merge.error --comment "MergeList $i $k" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2} --merge-list /users/mturchin/data/1000G/subsets/$i/$i.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt --make-bed --out /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}") 
	done

done

#for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL"`; do
#for i in `echo "TSI IBS FIN"`; do
for i in `echo "CEU GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL TSI IBS FIN"`; do
	for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
        
		for j in `echo {1..22}`; do 
			rm /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.log /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chr${j}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.nosex
		done
	done
done

for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British`; do
	ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
	
	cat /dev/null > /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt
#	cat /dev/null > /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.wTSIIBSFIN.Vs1.txt
	for i in `echo "GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL"`; do
#	for i in `echo "GBR YRI ESN CHB JPT ACB ASW MXL PEL ITU PJL TSI IBS FIN"`; do
		echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam" >> /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt
#		echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam" >> /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.wTSIIBSFIN.Vs1.txt
	
	done
done

for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

#	plink --bfile /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2} --merge-list /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt --out /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}	
#	plink --bfile /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2} --merge-list /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.wTSIIBSFIN.Vs1.txt --out /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.TSIIBSFIN	
#	cat /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.bim | awk '{ print $2 }' > /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.bim.rsIDs
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX --extract /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.bim.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre --bmerge /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2} --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG
#	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre --bmerge /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.TSIIBSFIN --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.TSIIBSFIN
	rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre*
	
done

#	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs.noX --extract /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.bim.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs.noX.1kG

##UKBioBankPops=`echo "African;African;ukb_Afr Any_other_Asian_background;Any_other_Asian_background;ukb_Asian Any_other_mixed_background;Any_other_mixed_background;ukb_Mixed Any_other_white_background;Any_other_white_background;ukb_White British;British;ukb_Brit British;British.Ran4000;ukb_Brit4k British;British.Ran10000;ukb_Brit10k British;British.Ran100000;ukb_Brit100k British;British.Ran200000;ukb_Brit200k Caribbean;Caribbean;ukb_Carib Chinese;Chinese;ukb_Chi Indian;Indian;ukb_Indn Irish;Irish;ukb_Irish Pakistani;Pakistani;ukb_Pkstn"`;
UKBioBankPops=`echo "African;African;Afr Any_other_Asian_background;Any_other_Asian_background;Asian Any_other_mixed_background;Any_other_mixed_background;Mixed Any_other_white_background;Any_other_white_background;White British;British;Brit British;British.Ran4000;Brit4k British;British.Ran10000;Brit10k British;British.Ran100000;Brit100k British;British.Ran200000;Brit200k Caribbean;Caribbean;Carib Chinese;Chinese;Chi Indian;Indian;Indn Irish;Irish;Irish Pakistani;Pakistani;Pkstn"`;

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
	ancestry3=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`

	echo $ancestry1 $ancestry2 $ancestry3

	sbatch -t 72:00:00 --mem 8g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.1kG.fastpca.run.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.1kG.fastpca.run.slurm.error --comment "fastpca $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/bash'; \
	echo -e "\n/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG -d 20 --outpc /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.txt --outload /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.loads.txt --outvec /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.vecs.txt --outval /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.vals.txt --outpve /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pve.txt --outmeansd /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.meansd.txt"; \
	echo -e "\n/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.onlyRltvs.noX.1kG --project --inmeansd /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.meansd.txt --outproj /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.projRltvs.txt --inload /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.loads.txt"; \ 
	echo -e "\njoin <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.txt | awk '{ print \$1 \"_\" \$2 \"\t\" \$0 }' | sort -k 1,1) <(cat <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.fam | awk -v ancestry3b=$ancestry3  '{ print \$1 \"_\" \$2 \"\t\" ancestry3b }') <(cat /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_CEU\" }') <(cat /users/mturchin/data/1000G/subsets/GBR/mturchin20/GBR.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_GBR\" }') <(cat /users/mturchin/data/1000G/subsets/YRI/mturchin20/YRI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_YRI\" }') <(cat /users/mturchin/data/1000G/subsets/ESN/mturchin20/ESN.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_ESN\" }') <(cat /users/mturchin/data/1000G/subsets/CHB/mturchin20/CHB.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_CHB\" }') <(cat /users/mturchin/data/1000G/subsets/JPT/mturchin20/JPT.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_JPT\" }') <(cat /users/mturchin/data/1000G/subsets/ACB/mturchin20/ACB.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_ACB\" }') <(cat /users/mturchin/data/1000G/subsets/ASW/mturchin20/ASW.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_ASW\" }') <(cat /users/mturchin/data/1000G/subsets/MXL/mturchin20/MXL.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_MXL\" }') <(cat /users/mturchin/data/1000G/subsets/PEL/mturchin20/PEL.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_PEL\" }') <(cat /users/mturchin/data/1000G/subsets/ITU/mturchin20/ITU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_ITU\" }') <(cat /users/mturchin/data/1000G/subsets/PJL/mturchin20/PJL.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_PJL\" }') | sort -k 1,1) | perl -lane 'print join(\"\t\", @F[1..\$#F]);' | cat <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.txt | head -n 1 | perl -lane 'push(@F, \"POP\"); print join(\"\t\", @F);') - > /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt";)

done	

#	<(cat /users/mturchin/data/1000G/subsets/TSI/mturchin20/TSI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_TSI\" }') 
#	<(cat /users/mturchin/data/1000G/subsets/IBS/mturchin20/IBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_IBS\" }') 
#	<(cat /users/mturchin/data/1000G/subsets/FIN/mturchin20/FIN.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print \$1 \"_\" \$2 \"\t1kG_FIN\" }') 

#From https://dr-k-lo.blogspot.com/2014/03/the-simplest-way-to-plot-legend-outside.html, https://coders-corner.net/2016/03/06/data-visualization-in-r-show-legend-outside-of-the-plotting-area/, http://research.stowers.org/mcm/efg/R/Graphics/Basics/mar-oma/index.htm, https://stackoverflow.com/questions/38332355/vertical-spaces-in-legend, https://stackoverflow.com/questions/38332355/vertical-spaces-in-legend, https://www.r-bloggers.com/two-tips-adding-title-for-graph-with-multiple-plots-add-significance-asterix-onto-a-boxplot/, https://stackoverflow.com/questions/14660372/common-main-title-of-a-figure-panel-compiled-with-parmfrow 
for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
	ancestry3=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`

	R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt\", header=T); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.projRltvs.txt\", header=T); \
	Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1 <- cbind(Data1, rep(16, nrow(Data1))); Data1[Data1[ncol(Data1)-2] !=\"${ancestry3}\", ncol(Data1)] <- 4; \ 
	Data1[,ncol(Data1)-1] <- factor(Data1[,ncol(Data1)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"), brewer.pal(12, \"Set3\"), brewer.pal(9, \"YlGnBu\"))); \ 
	Data1[Data1[ncol(Data1)-2] == \"1kG_CEU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[2]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_GBR\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[1]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_YRI\", ncol(Data1)-1] <- \"#C51B7D\"; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_ESN\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[5]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_CHB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[12]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_JPT\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[8]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_ACB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[4]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_ASW\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[3]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_MXL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[7]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_PEL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[11]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_ITU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[10]; \
	Data1[Data1[ncol(Data1)-2] == \"1kG_PJL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[9]; \
	Data2 <- cbind(Data2, rep(\"ukb_Afr\", nrow(Data2))); Data2 <- cbind(Data2, rep(brewer.pal(12, \"Paired\")[6], nrow(Data2))); Data2 <- cbind(Data2, rep(16, nrow(Data2))); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-2], levels=levels(Data1[,ncol(Data1)-2])); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"), brewer.pal(12, \"Set3\"), brewer.pal(9, \"YlGnBu\"))); \ 
	names(Data2) <- names(Data1); Data3 <- rbind(Data1, Data2); \ 
	png(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.ukb_${ancestry3}.1kG.flashpca.wRltvs.PCplots.vs2.png\", height=8250, width=4750, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(4,2)); \
	plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,7], Data3[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,9], Data3[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,11], Data3[,12], xlab=\"PC9\", ylab=\"PC10\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,13], Data3[,14], xlab=\"PC11\", ylab=\"PC12\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,15], Data3[,16], xlab=\"PC13\", ylab=\"PC14\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,17], Data3[,18], xlab=\"PC15\", ylab=\"PC16\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); \ 
	mtext(\"${ancestry2}\", line=-.75, outer=TRUE, cex=2.5); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_${ancestry3}\", \"${ancestry3}_rel\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\", \"1kG_MXL\", \"1kG_PEL\", \"1kG_ITU\", \"1kG_PJL\"), pch=c(16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", \"#C51B7D\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[7], brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), xpd=TRUE, inset=c(.027,.0385), bg=\"transparent\", cex=1.35, y.intersp=2); \
	dev.off();"

done

#From MacBook Air
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/ukb_chrAll_v2*1kG.flashpca.wRltvs.PCplots.vs2.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/ukb_chrAll_v2*1kG.TSIIBSFIN.flashpca.wRltvs.PCplots.vs2.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.

#abline(.005, .555); 
#c("ukb_AFR", "AFR_rel", "1kG_CEU", "1kG_GBR", "1kG_YRI", "1kG_ESN", "1kG_CHB", "1kG_JPT", "1kG_ACB", "1kG_ASW")
#c("BLACK", brewer.pal(12, "Paired")[11], brewer.pal(12, "Paired")[2], brewer.pal(12, "Paired")[1], brewer.pal(12, "Paired")[6], brewer.pal(12, "Paired")[5], brewer.pal(12, "Paired")[4], brewer.pal(12, "Paired")[3]
#[1] "BLACK"   "#FFFF99" "#1F78B4" "#A6CEE3" "#E31A1C" "#FB9A99" "#33A02C" "#B2DF8A"
#> brewer.pal(12, "Paired")
# [1] "#A6CEE3" "#1F78B4" "#B2DF8A" "#33A02C" "#FB9A99" "#E31A1C" "#FDBF6F"
# [8] "#FF7F00" "#CAB2D6" "#6A3D9A" "#FFFF99" "#B15928"
#	R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.TSIIBSFIN.flashpca.pcs.wAncs.txt\", header=T); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.projRltvs.txt\", header=T); \
#	Data1[Data1[ncol(Data1)-2] == \"1kG_TSI\", ncol(Data1)-1] <- brewer.pal(12, \"Set3\")[1]; \
#	Data1[Data1[ncol(Data1)-2] == \"1kG_IBS\", ncol(Data1)-1] <- brewer.pal(12, \"Set3\")[11]; \
#	Data1[Data1[ncol(Data1)-2] == \"1kG_FIN\", ncol(Data1)-1] <- brewer.pal(9, \"YlGnBu\")[9]; \
#	png(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.ukb_${ancestry3}.1kG.TSIIBSFIN.flashpca.wRltvs.PCplots.vs2.png\", height=8250, width=4750, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(4,2)); \
#	mtext(\"${ancestry2}\", line=-.75, outer=TRUE, cex=2.5); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_${ancestry3}\", \"${ancestry3}_rel\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_FIN\", \"1kG_TSI\", \"1kG_IBS\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\", \"1kG_MXL\", \"1kG_PEL\", \"1kG_ITU\", \"1kG_PJL\"), pch=c(16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", \"#C51B7D\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(9, \"YlGnBu\")[9], brewer.pal(12, \"Set3\")[1], brewer.pal(12, \"Set3\")[11], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[7], brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), xpd=TRUE, inset=c(.027,.0385), bg=\"transparent\", cex=1.35, y.intersp=2); \

##20180417 NOTE -- this was done mid-rerunning things after correcting the upstream, general 1kG.ukb thing (eg redoing things at this point ended up being unnecessary, but did it anyways, and checked the 'new' PCs with the old ones before I clobbered the old file too; just to check things are the same since they should be?
#for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
#	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
#	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
#	ancestry3=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`
#
#	echo $j
#	for i in {1..10}; do
#		paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.wFullCovars.txt | awk -v iAwk=$i '{ print $(5+iAwk)}') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.txt | awk -v iAwk=$i '{ print $(2+iAwk) }') | awk '{ if ($1 != $2) { print $0 } }' | awk '{ if (NR > 1) { print $0 } }'
#	done
#done

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | head -n 14 | tail -n 1`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
	ancestry3=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`

	R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt\", header=T); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.projRltvs.txt\", header=T); \
	Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1 <- cbind(Data1, rep(16, nrow(Data1))); Data1[Data1[ncol(Data1)-2] !=\"${ancestry3}\", ncol(Data1)] <- 4; \ 
	Data1[,ncol(Data1)-1] <- factor(Data1[,ncol(Data1)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); \ 
	Data1[Data1[ncol(Data1)-2] == \"1kG_CEU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[2]; Data1[Data1[ncol(Data1)-2] == \"1kG_GBR\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[1]; Data1[Data1[ncol(Data1)-2] == \"1kG_YRI\", ncol(Data1)-1] <- \"#C51B7D\"; Data1[Data1[ncol(Data1)-2] == \"1kG_ESN\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[5]; Data1[Data1[ncol(Data1)-2] == \"1kG_CHB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[12]; Data1[Data1[ncol(Data1)-2] == \"1kG_JPT\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[8]; Data1[Data1[ncol(Data1)-2] == \"1kG_ACB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[4]; Data1[Data1[ncol(Data1)-2] == \"1kG_ASW\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[3]; Data1[Data1[ncol(Data1)-2] == \"1kG_MXL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[7]; Data1[Data1[ncol(Data1)-2] == \"1kG_PEL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[11]; Data1[Data1[ncol(Data1)-2] == \"1kG_ITU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[10]; Data1[Data1[ncol(Data1)-2] == \"1kG_PJL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[9]; Data2 <- cbind(Data2, rep(\"ukb_Afr\", nrow(Data2))); Data2 <- cbind(Data2, rep(brewer.pal(12, \"Paired\")[6], nrow(Data2))); Data2 <- cbind(Data2, rep(16, nrow(Data2))); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-2], levels=levels(Data1[,ncol(Data1)-2])); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); \ 
	names(Data2) <- names(Data1); Data3 <- rbind(Data1, Data2); \ 
	png(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.ukb_${ancestry3}.1kG.flashpca.wRltvs.PCplots.ctOff.vs2.png\", height=5250, width=6000, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(2,2)); \
	plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); abline(.08, 2.1, lwd=3, lty=2); \ 
	plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,7], Data3[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,9], Data3[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); \ 
	mtext(\"${ancestry2}\", line=-.75, outer=TRUE, cex=2.75); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_${ancestry3}\", \"${ancestry3}_rel\", \"${ancestry3}_Outlr\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\", \"1kG_MXL\", \"1kG_PEL\", \"1kG_ITU\", \"1kG_PJL\"), pch=c(16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", \"#C51B7D\", \"BROWN\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[7], brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), xpd=TRUE, inset=c(.031,.076), bg=\"transparent\", cex=1.55, y.intersp=2); \
	dev.off();"
done
	
#	abline(v=.065, lwd=3, lty=2); \ 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * 3.3) - .3)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if ((y <= ((x * .725) - .1775)) || (x >= .065)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#	Data3[(Data3[,ncol(Data3)-2] == \"ukb_AFR\" & (! mapply(aboveLnrThrsh, Data3[, 3], Data3[, 4]))), ncol(Data3)-1] <- \"brown\"; \

#From MacBook Air
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/ukb_chrAll_v2*1kG.flashpca.wRltvs.PCplots.ctOff.vs2.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.

#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * .555) + .005) ) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#	Data3[(Data3[,ncol(Data3)-2] == \"ukb_AFR\" & (! mapply(aboveLnrThrsh, Data3[, 3], Data3[, 4]))), ncol(Data3)-1] <- \"brown\"; \
#	png(\"/users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.AFR.1kG.flashpca.wRltvs.PCplots.ctOff.vs2.png\", height=3500, width=6000, res=300); par(oma=c(5,5,4,2), mfrow=c(1,2)); \
#	plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend2(\"bottomleft\"); abline(.005, .555); \
#	plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plotLegend2(\"topleft\"); dev.off();"  

#African;African;Afr 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y <= ((x * -.5) - .04) ) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#Any_other_Asian_background;Any_other_Asian_background;Asian 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if ((y <= ((x * .725) - .1775)) || (x >= .065)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#Any_other_mixed_background;Any_other_mixed_background;Mixed 
#	N/A
#Any_other_white_background;Any_other_white_background;White 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * 3.3) - .3)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#British;British;Brit 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * 11) - 1.5)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#British;British.Ran4000;Brit4k 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * 2.5) + .005)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#British;British.Ran10000;Brit10k 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * -4.6) - .1875)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#British;British.Ran100000;Brit100k 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * -9.4) - 1.4)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#British;British.Ran200000;Brit200k 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * 10) - 1.4)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#Caribbean;Caribbean;Carib 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * -.68) + .016)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#Chinese;Chinese;Chi 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if ((y >= ((x * 1.3) + .13)) && (x <= -.04)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#Indian;Indian;Indn 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if ((y <= ((x * 67.5) - 1.4)) && (y <= ((x * .7) + .0825))) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#Irish;Irish;Irish 
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * -2.75) - .06)) { returnVal1 <- TRUE; }; return(returnVal1); }; \
#Pakistani;Pakistani;Pkstn
#	aboveLnrThrsh <- function(x,y) { returnVal1 <- FALSE; if (y >= ((x * 2.1) + .08)) { returnVal1 <- TRUE; }; return(returnVal1); }; \

cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 <= (($3 * -.5) - .04))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_Asian_background/Any_other_Asian_background/mturchin20/ukb_chrAll_v2.Any_other_Asian_background.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || (($4 <= (($3 * .725) - .1775)) || ($3 >= .065))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_Asian_background/Any_other_Asian_background/mturchin20/ukb_chrAll_v2.Any_other_Asian_background.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
ln -s /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_mixed_background/Any_other_mixed_background/mturchin20/ukb_chrAll_v2.Any_other_mixed_background.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_mixed_background/Any_other_mixed_background/mturchin20/ukb_chrAll_v2.Any_other_mixed_background.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/mturchin20/ukb_chrAll_v2.Any_other_white_background.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * 3.3) - .3))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/mturchin20/ukb_chrAll_v2.Any_other_white_background.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * 11) - 1.5))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/mturchin20/ukb_chrAll_v2.British.Ran4000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * 2.5) + .005))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/mturchin20/ukb_chrAll_v2.British.Ran4000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * -4.6) - .1875))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/mturchin20/ukb_chrAll_v2.British.Ran100000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * -9.4) - 1.4))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/mturchin20/ukb_chrAll_v2.British.Ran100000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/mturchin20/ukb_chrAll_v2.British.Ran200000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * 10) - 1.4))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/mturchin20/ukb_chrAll_v2.British.Ran200000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/mturchin20/ukb_chrAll_v2.Caribbean.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * -.68) + .016))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/mturchin20/ukb_chrAll_v2.Caribbean.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || (($4 >= (($3 * 1.3) + .13)) && ($3 <= -.04))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/Chinese/Chinese/mturchin20/ukb_chrAll_v2.Chinese.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/mturchin20/ukb_chrAll_v2.Indian.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || (($4 <= (($3 * 67.5) - 1.4)) && ($4 <= (($3 * .7) + .0825)))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/mturchin20/ukb_chrAll_v2.Indian.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/mturchin20/ukb_chrAll_v2.Irish.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * -2.75) - .06))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/mturchin20/ukb_chrAll_v2.Irish.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt
cat /users/mturchin/data/ukbiobank_jun17/subsets/Pakistani/Pakistani/mturchin20/ukb_chrAll_v2.Pakistani.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | awk '{ if ($23 ~ /1kG/ || ($4 >= (($3 * 2.1) + .08))) { print $0 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/Pakistani/Pakistani/mturchin20/ukb_chrAll_v2.Pakistani.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
	ancestry3=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`

	R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt\", header=T); \
	Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1 <- cbind(Data1, rep(16, nrow(Data1))); Data1[Data1[ncol(Data1)-2] !=\"${ancestry3}\", ncol(Data1)] <- 4; \ 
	Data1[,ncol(Data1)-1] <- factor(Data1[,ncol(Data1)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); \ 
	Data1[Data1[ncol(Data1)-2] == \"1kG_CEU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[2]; Data1[Data1[ncol(Data1)-2] == \"1kG_GBR\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[1]; Data1[Data1[ncol(Data1)-2] == \"1kG_YRI\", ncol(Data1)-1] <- \"#C51B7D\"; Data1[Data1[ncol(Data1)-2] == \"1kG_ESN\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[5]; Data1[Data1[ncol(Data1)-2] == \"1kG_CHB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[12]; Data1[Data1[ncol(Data1)-2] == \"1kG_JPT\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[8]; Data1[Data1[ncol(Data1)-2] == \"1kG_ACB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[4]; Data1[Data1[ncol(Data1)-2] == \"1kG_ASW\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[3]; Data1[Data1[ncol(Data1)-2] == \"1kG_MXL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[7]; Data1[Data1[ncol(Data1)-2] == \"1kG_PEL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[11]; Data1[Data1[ncol(Data1)-2] == \"1kG_ITU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[10]; Data1[Data1[ncol(Data1)-2] == \"1kG_PJL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[9]; \ 
	png(\"/users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.ukb_${ancestry3}.1kG.flashpca.wRltvs.PCplots.ctOff.QCed.vs2.png\", height=5250, width=6000, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(2,2)); \
	plot(Data1[,3], Data1[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,5], Data1[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,7], Data1[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,9], Data1[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); \ 
	mtext(\"${ancestry2}\", line=-.75, outer=TRUE, cex=2.75); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_${ancestry3}\", \"${ancestry3}_rel\", \"${ancestry3}_Outlr\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\", \"1kG_MXL\", \"1kG_PEL\", \"1kG_ITU\", \"1kG_PJL\"), pch=c(16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", \"#C51B7D\", \"BROWN\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[7], brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), xpd=TRUE, inset=c(.031,.076), bg=\"transparent\", cex=1.55, y.intersp=2); \
	dev.off();"
done

#From MacBook Air
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/ukb_chrAll_v2*1kG.flashpca.wRltvs.PCplots.ctOff.QCed.vs2.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

#	cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | grep -v PC1 | grep -v 1kG | awk '{ print $1 "\t" $2 }' > /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.no1kG.FIDIIDs 
#	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX --keep /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.no1kG.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop

	echo $ancestry1 $ancestry2

	cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.fam | wc
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.fam | wc

done

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	sbatch -t 72:00:00 --qos=normal --mem 4g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.run.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.fastpca.run.slurm.error --comment "$ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \ 
	echo -e "\n/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop -d 20 --outpc /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.txt --outload /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.loads.txt --outvec /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.vecs.txt --outval /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.vals.txt --outpve /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pve.txt --outmeansd /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.meansd.txt"; \
	echo -e "\nR -q -e \"Data1 <- read.table(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.txt\\\", header=T); Data1 <- cbind(Data1, rep(\\\"BLACK\\\", nrow(Data1))); png(\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.PCplots.vs1.png\\\", height=8000, width=4000, res=300); par(oma=c(5,5,4,2), mfrow=c(4,2)); plot(Data1[,3], Data1[,4], xlab=\\\"PC1\\\", ylab=\\\"PC2\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data1[,5], Data1[,6], xlab=\\\"PC3\\\", ylab=\\\"PC4\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data1[,7], Data1[,8], xlab=\\\"PC5\\\", ylab=\\\"PC6\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data1[,9], Data1[,10], xlab=\\\"PC7\\\", ylab=\\\"PC8\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data1[,11], Data1[,12], xlab=\\\"PC9\\\", ylab=\\\"PC10\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data1[,13], Data1[,14], xlab=\\\"PC11\\\", ylab=\\\"PC12\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data1[,15], Data1[,16], xlab=\\\"PC13\\\", ylab=\\\"PC14\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); plot(Data1[,17], Data1[,18], xlab=\\\"PC15\\\", ylab=\\\"PC16\\\", col=Data1[,ncol(Data1)], cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); dev.off();\"";)

done	

/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --project --inmeansd /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/mturchin20/ukb_chrAll_v2.British.Ran4000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.meansd.txt --outproj /users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.proj.txt --inload /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/mturchin20/ukb_chrAll_v2.British.Ran4000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.loads.txt
/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --project --inmeansd /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.meansd.txt --outproj /users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.proj.txt --inload /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.loads.txt
/users/mturchin/Software/flashpca/flashpca --bfile /users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb --project --inmeansd /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/mturchin20/ukb_chrAll_v2.British.Ran200000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.meansd.txt --outproj /users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.proj.txt --inload /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/mturchin20/ukb_chrAll_v2.British.Ran200000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.loads.txt

R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/mturchin20/ukb_chrAll_v2.British.Ran4000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt\", header=T); Data2 <- read.table(\"/users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.proj.txt\", header=T); Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1 <- cbind(Data1, rep(16, nrow(Data1))); Data1[Data1[ncol(Data1)-2] !=\"ukb_Brit4k\", ncol(Data1)] <- 4; Data1[,ncol(Data1)-1] <- factor(Data1[,ncol(Data1)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); Data1[Data1[ncol(Data1)-2] == \"1kG_CEU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[2]; Data1[Data1[ncol(Data1)-2] == \"1kG_GBR\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[1]; Data1[Data1[ncol(Data1)-2] == \"1kG_YRI\", ncol(Data1)-1] <- \"#C51B7D\"; Data1[Data1[ncol(Data1)-2] == \"1kG_ESN\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[5]; Data1[Data1[ncol(Data1)-2] == \"1kG_CHB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[12]; Data1[Data1[ncol(Data1)-2] == \"1kG_JPT\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[8]; Data1[Data1[ncol(Data1)-2] == \"1kG_ACB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[4]; Data1[Data1[ncol(Data1)-2] == \"1kG_ASW\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[3]; Data1[Data1[ncol(Data1)-2] == \"1kG_MXL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[7]; Data1[Data1[ncol(Data1)-2] == \"1kG_PEL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[11]; Data1[Data1[ncol(Data1)-2] == \"1kG_ITU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[10]; Data1[Data1[ncol(Data1)-2] == \"1kG_PJL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[9]; Data2 <- cbind(Data2, rep(\"ukb_Afr\", nrow(Data2))); Data2 <- cbind(Data2, rep(brewer.pal(12, \"Paired\")[6], nrow(Data2))); Data2 <- cbind(Data2, rep(16, nrow(Data2))); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-2], levels=levels(Data1[,ncol(Data1)-2])); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); names(Data2) <- names(Data1); Data3 <- rbind(Data1, Data2); png(\"/users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.PCplots.Brit4k.vs1.png\", height=5250, width=6000, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(2,2)); plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); abline(.08, 2.1, lwd=3, lty=2); plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,7], Data3[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,9], Data3[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); mtext(\"British.Ran4000\", line=-.75, outer=TRUE, cex=2.75); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_ukb_Brit4k\", \"TSI_IBS\", \"ukb_Brit4k_Outlr\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\", \"1kG_MXL\", \"1kG_PEL\", \"1kG_ITU\", \"1kG_PJL\"), pch=c(16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", \"#C51B7D\", \"BROWN\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[7], brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), xpd=TRUE, inset=c(.031,.076), bg=\"transparent\", cex=1.55, y.intersp=2); dev.off();"
R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt\", header=T); Data2 <- read.table(\"/users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.proj.txt\", header=T); Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1 <- cbind(Data1, rep(16, nrow(Data1))); Data1[Data1[ncol(Data1)-2] !=\"ukb_Brit10k\", ncol(Data1)] <- 4; Data1[,ncol(Data1)-1] <- factor(Data1[,ncol(Data1)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); Data1[Data1[ncol(Data1)-2] == \"1kG_CEU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[2]; Data1[Data1[ncol(Data1)-2] == \"1kG_GBR\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[1]; Data1[Data1[ncol(Data1)-2] == \"1kG_YRI\", ncol(Data1)-1] <- \"#C51B7D\"; Data1[Data1[ncol(Data1)-2] == \"1kG_ESN\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[5]; Data1[Data1[ncol(Data1)-2] == \"1kG_CHB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[12]; Data1[Data1[ncol(Data1)-2] == \"1kG_JPT\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[8]; Data1[Data1[ncol(Data1)-2] == \"1kG_ACB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[4]; Data1[Data1[ncol(Data1)-2] == \"1kG_ASW\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[3]; Data1[Data1[ncol(Data1)-2] == \"1kG_MXL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[7]; Data1[Data1[ncol(Data1)-2] == \"1kG_PEL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[11]; Data1[Data1[ncol(Data1)-2] == \"1kG_ITU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[10]; Data1[Data1[ncol(Data1)-2] == \"1kG_PJL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[9]; Data2 <- cbind(Data2, rep(\"ukb_Afr\", nrow(Data2))); Data2 <- cbind(Data2, rep(brewer.pal(12, \"Paired\")[6], nrow(Data2))); Data2 <- cbind(Data2, rep(16, nrow(Data2))); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-2], levels=levels(Data1[,ncol(Data1)-2])); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); names(Data2) <- names(Data1); Data3 <- rbind(Data1, Data2); png(\"/users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.PCplots.Brit10k.vs1.png\", height=5250, width=6000, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(2,2)); plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); abline(.08, 2.1, lwd=3, lty=2); plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,7], Data3[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,9], Data3[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); mtext(\"British.Ran10000\", line=-.75, outer=TRUE, cex=2.75); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_ukb_Brit10k\", \"TSI_IBS\", \"ukb_Brit10k_Outlr\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\", \"1kG_MXL\", \"1kG_PEL\", \"1kG_ITU\", \"1kG_PJL\"), pch=c(16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", \"#C51B7D\", \"BROWN\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[7], brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), xpd=TRUE, inset=c(.031,.076), bg=\"transparent\", cex=1.55, y.intersp=2); dev.off();"
R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/mturchin20/ukb_chrAll_v2.British.Ran200000.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt\", header=T); Data2 <- read.table(\"/users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.proj.txt\", header=T); Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1 <- cbind(Data1, rep(16, nrow(Data1))); Data1[Data1[ncol(Data1)-2] !=\"ukb_Brit200k\", ncol(Data1)] <- 4; Data1[,ncol(Data1)-1] <- factor(Data1[,ncol(Data1)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); Data1[Data1[ncol(Data1)-2] == \"1kG_CEU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[2]; Data1[Data1[ncol(Data1)-2] == \"1kG_GBR\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[1]; Data1[Data1[ncol(Data1)-2] == \"1kG_YRI\", ncol(Data1)-1] <- \"#C51B7D\"; Data1[Data1[ncol(Data1)-2] == \"1kG_ESN\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[5]; Data1[Data1[ncol(Data1)-2] == \"1kG_CHB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[12]; Data1[Data1[ncol(Data1)-2] == \"1kG_JPT\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[8]; Data1[Data1[ncol(Data1)-2] == \"1kG_ACB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[4]; Data1[Data1[ncol(Data1)-2] == \"1kG_ASW\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[3]; Data1[Data1[ncol(Data1)-2] == \"1kG_MXL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[7]; Data1[Data1[ncol(Data1)-2] == \"1kG_PEL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[11]; Data1[Data1[ncol(Data1)-2] == \"1kG_ITU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[10]; Data1[Data1[ncol(Data1)-2] == \"1kG_PJL\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[9]; Data2 <- cbind(Data2, rep(\"ukb_Afr\", nrow(Data2))); Data2 <- cbind(Data2, rep(brewer.pal(12, \"Paired\")[6], nrow(Data2))); Data2 <- cbind(Data2, rep(16, nrow(Data2))); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-2], levels=levels(Data1[,ncol(Data1)-2])); Data2[,ncol(Data2)-2] <- factor(Data2[,ncol(Data2)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"))); names(Data2) <- names(Data1); Data3 <- rbind(Data1, Data2); png(\"/users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.PCplots.Brit200k.vs1.png\", height=5250, width=6000, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(2,2)); plot(Data3[,3], Data3[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); abline(.08, 2.1, lwd=3, lty=2); plot(Data3[,5], Data3[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,7], Data3[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data3[,9], Data3[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data3[,ncol(Data3)], col=as.character(Data3[,ncol(Data3)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); mtext(\"British.Ran200000\", line=-.75, outer=TRUE, cex=2.75); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_ukb_Brit200k\", \"TSI_IBS\", \"ukb_Brit200k_Outlr\", \"1kG_CEU\", \"1kG_GBR\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\", \"1kG_ACB\", \"1kG_ASW\", \"1kG_MXL\", \"1kG_PEL\", \"1kG_ITU\", \"1kG_PJL\"), pch=c(16, 16, 16, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", \"#C51B7D\", \"BROWN\", brewer.pal(12, \"Paired\")[2], brewer.pal(12, \"Paired\")[1], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8], brewer.pal(12, \"Paired\")[4], brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[7], brewer.pal(12, \"Paired\")[11], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[9]), xpd=TRUE, inset=c(.031,.076), bg=\"transparent\", cex=1.55, y.intersp=2); dev.off();"

#From MacBook Air
#mkdir /Users/mturchin20/Documents/Work/LabMisc/HirschhornLab/SohailRspnd
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/1000G/mturchin20/subsets/TSIIBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.flashpca.PCplots.*vs1.png /Users/mturchin20/Documents/Work/LabMisc/HirschhornLab/SohailRspnd/.
/users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/ukb_chrAll_v2*1kG.flashpca.wRltvs.PCplots.ctOff.QCed.vs2.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.









#From https://www.genetics.ucla.edu/software/admixture/admixture-manual.pdf, https://web1.ccv.brown.edu/technologies/computing, https://stackoverflow.com/questions/19225859/difference-between-core-and-processor, https://slurm.schedmd.com/sbatch.html, https://training.it.ufl.edu/media/trainingitufledu/documents/research-computing/Slurm-MPI-jobs.pdf
#And from material provided by Sam

mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture

for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British`; do
        ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
        ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

        cat /dev/null > /users/mturchin/data/1000G/mturchin20/subsets/FINCEUGBRTSI.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt
        cat /dev/null > /users/mturchin/data/1000G/mturchin20/subsets/FINCEUGBRIBS.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt
        for i in `echo "FIN CEU GBR TSI"`; do
                echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam" >> /users/mturchin/data/1000G/mturchin20/subsets/FINCEUGBRTSI.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt
        done
        for i in `echo "FIN CEU GBR IBS"`; do
                echo "/users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bed /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.bim /users/mturchin/data/1000G/subsets/$i/mturchin20/$i.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam" >> /users/mturchin/data/1000G/mturchin20/subsets/FINCEUGBRIBS.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt
        done
done

for k in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep Ran10000\;`; do
        ancestry1=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
        ancestry2=`echo $k | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX --extract /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.bim.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre --merge-list /users/mturchin/data/1000G/mturchin20/subsets/FINCEUGBRTSI.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI
	plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre --merge-list /users/mturchin/data/1000G/mturchin20/subsets/FINCEUGBRIBS.chrAll.phase3.genotypes.SNPs.ukb.${ancestry2}.MergeList.Vs1.txt --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS
	rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.pre*
	cat <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.fam | awk '{ print $1 "_" $2 "\t-" }') <(cat /users/mturchin/data/1000G/subsets/FIN/mturchin20/FIN.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print $1 "_" $2 "\t1kG_FIN" }') <(cat /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print $1 "_" $2 "\t-" }') <(cat /users/mturchin/data/1000G/subsets/GBR/mturchin20/GBR.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print $1 "_" $2 "\t-" }') <(cat /users/mturchin/data/1000G/subsets/TSI/mturchin20/TSI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print $1 "_" $2 "\t1kG_TSI" }') <(cat /users/mturchin/data/1000G/subsets/IBS/mturchin20/IBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.${ancestry2}.fam | awk '{ print $1 "_" $2 "\t1kG_IBS" }') > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/admixture/ukb.FINCEUGBRTSIIBS.${ancestry2}.fam.IIDsLabel
	R -q -e "Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.fam\", header=F); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/admixture/ukb.FINCEUGBRTSIIBS.${ancestry2}.fam.IIDsLabel\", header=F); Data1b <- data.frame(paste(Data1[,1], Data1[,2], sep=\"_\")); colnames(Data1b) <- c(\"IID\"); colnames(Data2) <- c(\"IID\", \"POP\"); Data3 <- merge(Data1b, Data2, by=\"IID\"); write.table(Data3, file=\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop.pre\", quote=FALSE, row.name=FALSE, col.name=FALSE);" 
	paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.fam | awk '{ print $1 "_" $2 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop.pre | awk '{ print $1 }') | awk '{ if ($1 == $2) { print $0 } }' | wc
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop.pre | awk '{ print $2 }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop; rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop.pre
	R -q -e "Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.fam\", header=F); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/admixture/ukb.FINCEUGBRTSIIBS.${ancestry2}.fam.IIDsLabel\", header=F); Data1b <- data.frame(paste(Data1[,1], Data1[,2], sep=\"_\")); colnames(Data1b) <- c(\"IID\"); colnames(Data2) <- c(\"IID\", \"POP\"); Data3 <- merge(Data1b, Data2, by=\"IID\"); write.table(Data3, file=\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop.pre\", quote=FALSE, row.name=FALSE, col.name=FALSE);" 
	paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.fam | awk '{ print $1 "_" $2 }') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop.pre | awk '{ print $1 }') | awk '{ if ($1 == $2) { print $0 } }' | wc
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop.pre | awk '{ print $2 }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop; rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop.pre

done

#Data1 <- read.table("/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.fam", header=F); Data2 <- read.table("/users/mturchin/data
#	PopFile <- c(); for (i in 1:nrow(Data1)) { val1 <- paste(Data1[,1], Data1[,2], sep=\"_\"); PopFile <- rbind(PopFile, Data2[Data2[,1] == val1, 2]); }; 
/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb.FINCEUGBRTSIIBS.British.fam.IIDsLabel", header=F);

ukb + fin + tsi (+ ceu + gbr), ukb + fin + ibs (+ ceu + gbr)
ukb10k + fin + tsi (+ ceu + gbr), ukb10k + fin + ibs (+ ceu + gbr) 
multithrd ukb + fin + tsi (+ ceu + gbr), ukb + fin + ibs (+ ceu + gbr)
multithrd ukb10k + fin + tsi (+ ceu + gbr), ukb10k + fin + ibs (+ ceu + gbr) 

#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.pop
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.pop
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.pop
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.pop
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.pop
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.pop
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.pop
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.bed /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.bed
#ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.pop

#for i in `echo bed bim fam pop`; do
for i in `echo bim fam`; do echo $i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.$i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.$i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.$i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.$i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.$i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.$i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.$i;
	ln -s /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.$i /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.$i;
done

sbatch -t UNLIMITED --mem 50g -n 16 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.error --comment "admix British British FINTSI" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 394234 -j16 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.bed 2";) 
sbatch -t UNLIMITED --mem 50g -n 16 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.error --comment "admix British British FINIBS" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 691158 -j16 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.bed 2";) 
sbatch -t UNLIMITED --mem 10g -n 16 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.error --comment "admix British British.Ran10000 FINTSI" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 703283 -j16 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.bed 2";) 
sbatch -t UNLIMITED --mem 10g -n 16 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.16.slurm.error --comment "admix British British.Ran10000 FINIBS" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 340853 -j16 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.bed 2";) 

#sbatch -t UNLIMITED --mem 50g -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.slurm.error --comment "admix British British FINTSI" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 394234 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.bed 2";) 
#sbatch -t UNLIMITED --mem 50g -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.slurm.error --comment "admix British British FINIBS" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 691158 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.bed 2";) 
#sbatch -t UNLIMITED --mem 50g -n 4 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.error --comment "admix British British FINTSI" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 394234 -j4 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.bed 2";) 
#sbatch -t UNLIMITED --mem 50g -n 4 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.error --comment "admix British British FINIBS" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 691158 -j4 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.bed 2";) 
#sbatch -t UNLIMITED --mem 10g -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.slurm.error --comment "admix British BritishRan10000 FINTSI" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 703283 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.bed 2";) 
#sbatch -t UNLIMITED --mem 10g -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.slurm.error --comment "admix British BritishRan10000 FINIBS" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 340853 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.bed 2";) 
#sbatch -t UNLIMITED --mem 10g -n 4 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINTSI.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.error --comment "admix British British.Ran10000 FINTSI" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 703283 -j4 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.4.bed 2";) 
#sbatch -t UNLIMITED --mem 10g -n 4 -o /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/admix.201804.1kG_FINIBS.ukb_Brit.1kG_CEUGBR.vs1.4.slurm.error --comment "admix British British.Ran10000 FINIBS" <(echo -e '#!/bin/sh'; echo -e "\n/users/mturchin/Software/admixture_linux-1.3.0/admixture -s 340853 -j4 --supervised /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/ukb_chrAll_v2.British.Ran10000.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.4.bed 2";) 

mv /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/*British.Ran10000* /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/mturchin20/admixture/.
mv /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/*British* /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/.

cat <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.fam | awk '{ print $1 "_" $2 "\tUKB_Brit" }') <(cat /users/mturchin/data/1000G/subsets/FIN/mturchin20/FIN.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.British.fam | awk '{ print $1 "_" $2 "\t1kG_FIN" }') <(cat /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.British.fam | awk '{ print $1 "_" $2 "\t1kG_CEU" }') <(cat /users/mturchin/data/1000G/subsets/GBR/mturchin20/GBR.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.British.fam | awk '{ print $1 "_" $2 "\t1kG_GBR" }') <(cat /users/mturchin/data/1000G/subsets/TSI/mturchin20/TSI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.British.fam | awk '{ print $1 "_" $2 "\t1kG_TSI" }') <(cat /users/mturchin/data/1000G/subsets/IBS/mturchin20/IBS.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.British.fam | awk '{ print $1 "_" $2 "\t1kG_IBS" }') > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb.FINCEUGBRTSIIBS.British.fam.IIDsLabel.Full
R -q -e "Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.fam\", header=F); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb.FINCEUGBRTSIIBS.British.fam.IIDsLabel.Full\", header=F); Data1b <- data.frame(paste(Data1[,1], Data1[,2], sep=\"_\")); colnames(Data1b) <- c(\"IID\"); colnames(Data2) <- c(\"IID\", \"POP\"); Data3 <- merge(Data1b, Data2, by=\"IID\"); write.table(Data3[,2], file=\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop.Full\", quote=FALSE, row.name=FALSE, col.name=FALSE);"
R -q -e "Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.fam\", header=F); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb.FINCEUGBRTSIIBS.British.fam.IIDsLabel.Full\", header=F); Data1b <- data.frame(paste(Data1[,1], Data1[,2], sep=\"_\")); colnames(Data1b) <- c(\"IID\"); colnames(Data2) <- c(\"IID\", \"POP\"); Data3 <- merge(Data1b, Data2, by=\"IID\"); write.table(Data3[,2], file=\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop.Full\", quote=FALSE, row.name=FALSE, col.name=FALSE);"

paste /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.fam /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop.Full /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q | cat <(echo "FID IID MM DD SEX PHENO ANC Q1 Q2") - > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo 
paste /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.fam /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.pop.Full /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q | cat <(echo "FID IID MM DD SEX PHENO ANC Q1 Q2") - > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo 

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,8], c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1)));"
for i in `echo .1 .2 .3 .4 .5 .6 .7 .8 .9 1`; do echo $i;
	cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 <= awkI) { print $0 } } ' | wc
done
for i in `echo .8 .825 .85 .875 .9 .925 .95 .975 .99 1`; do echo $i;
	cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 >= awkI) { print $0 } } ' | wc
done
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,8], c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1)));"
for i in `echo .1 .2 .3 .4 .5 .6 .7 .8 .9 1`; do echo $i;
	cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 <= awkI) { print $0 } } ' | wc
done
for i in `echo .8 .825 .85 .875 .9 .925 .95 .975 .99 1`; do echo $i;
	cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 >= awkI) { print $0 } } ' | wc
done

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1b <- Data1[,c(7,8,9)]; Data1b <- Data1b[order(Data1b[,2], decreasing=TRUE),]; Data1c <- t(as.matrix(Data1b[,2:3])); colnames(Data1c) <- Data1b[,1]; png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.barplot.vs1.pt1.png\", height=15500, width=20000, res=300); par(mfrow=c(6,1)); barplot(Data1c[,(ncol(Data1c)-999):ncol(Data1c)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-1999):(ncol(Data1c)-1000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-2999):(ncol(Data1c)-2000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-3999):(ncol(Data1c)-3000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-4999):(ncol(Data1c)-4000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-5999):(ncol(Data1c)-5000)], col=c(\"BLUE\", \"RED\"), las=2); dev.off(); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.barplot.vs1.pt2.png\", height=15500, width=20000, res=300); par(mfrow=c(6,1)); barplot(Data1c[,(ncol(Data1c)-6999):(ncol(Data1c)-6000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-7999):(ncol(Data1c)-7000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-8999):(ncol(Data1c)-8000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-9999):(ncol(Data1c)-9000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-10999):(ncol(Data1c)-10000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-11999):(ncol(Data1c)-11000)], col=c(\"BLUE\", \"RED\"), las=2); dev.off();" 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1b <- Data1[,c(7,8,9)]; Data1b <- Data1b[order(Data1b[,2], decreasing=TRUE),]; Data1c <- t(as.matrix(Data1b[,2:3])); colnames(Data1c) <- Data1b[,1]; png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.barplot.vs1.pt1.png\", height=15500, width=20000, res=300); par(mfrow=c(6,1)); barplot(Data1c[,(ncol(Data1c)-999):ncol(Data1c)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-1999):(ncol(Data1c)-1000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-2999):(ncol(Data1c)-2000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-3999):(ncol(Data1c)-3000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-4999):(ncol(Data1c)-4000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-5999):(ncol(Data1c)-5000)], col=c(\"BLUE\", \"RED\"), las=2); dev.off(); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.barplot.vs1.pt2.png\", height=15500, width=20000, res=300); par(mfrow=c(6,1)); barplot(Data1c[,(ncol(Data1c)-6999):(ncol(Data1c)-6000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-7999):(ncol(Data1c)-7000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-8999):(ncol(Data1c)-8000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-9999):(ncol(Data1c)-9000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-10999):(ncol(Data1c)-10000)], col=c(\"BLUE\", \"RED\"), las=2); barplot(Data1c[,(ncol(Data1c)-11999):(ncol(Data1c)-11000)], col=c(\"BLUE\", \"RED\"), las=2); dev.off();" 

#Data1b <- Data1b[1:10000,];

#From MacBook Air
##scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.barplot.vs1.pt*.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/. 
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR*.mltiThrd.16.2.Q.wInfo.barplot.vs1.pt*.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/. 

##join -a 1 -e NA -o 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 1.24 2.2 2.3 <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | awk '{ print $1 "_" $2 "\t" $8 "\t" $9 }' | sort -k 1,1) | grep -v "POP" | cat <(echo "FID IID PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 POP Q1 Q2") - > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.wPCs   
join -a 1 -e NA -o 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 2.2 2.3 <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.TSIIBSFIN.flashpca.pcs.wAncs.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | awk '{ print $1 "_" $2 "\t" $8 "\t" $9 }' | sort -k 1,1) | grep -v "POP" | cat <(echo "FID IID PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 PC11 PC12 PC13 PC14 PC15 PC16 PC17 PC18 PC19 PC20 POP Q1 Q2") - > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.wPCs
join -a 1 -e NA -o 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.20 1.21 1.22 1.23 1.24 2.2 2.3 <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.TSIIBSFIN.flashpca.pcs.wAncs.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | awk '{ print $1 "_" $2 "\t" $8 "\t" $9 }' | sort -k 1,1) | grep -v "POP" | cat <(echo "FID IID PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 PC11 PC12 PC13 PC14 PC15 PC16 PC17 PC18 PC19 PC20 POP Q1 Q2") - > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.wPCs

#From https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf
R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.wPCs\", header=T); \
	Data1 <- cbind(Data1, rep(\"black\", nrow(Data1))); Data1 <- cbind(Data1, rep(16, nrow(Data1))); Data1[Data1[ncol(Data1)-4] !=\"Brit\", ncol(Data1)] <- 4; \
	Data1[,ncol(Data1)-1] <- factor(Data1[,ncol(Data1)-1], levels=c(colors(), \"#C51B7D\", brewer.pal(12, \"Paired\"), NA, brewer.pal(11, \"RdBu\"), brewer.pal(12, \"Set3\"), brewer.pal(9, \"YlGnBu\"))); \
	Data1[Data1[ncol(Data1)-4] == \"1kG_CEU\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[3]; Data1[Data1[ncol(Data1)-4] == \"1kG_GBR\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[4]; Data1[Data1[ncol(Data1)-4] == \"1kG_YRI\", ncol(Data1)-1] <- \"#C51B7D\"; Data1[Data1[ncol(Data1)-4] == \"1kG_ESN\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[5]; Data1[Data1[ncol(Data1)-4] == \"1kG_CHB\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[12]; Data1[Data1[ncol(Data1)-4] == \"1kG_JPT\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[8]; Data1[Data1[ncol(Data1)-4] == \"1kG_ACB\", ncol(Data1)-1] <- NA; Data1[Data1[ncol(Data1)-4] == \"1kG_ASW\", ncol(Data1)-1] <- NA; Data1[Data1[ncol(Data1)-4] == \"1kG_MXL\", ncol(Data1)-1] <- NA; Data1[Data1[ncol(Data1)-4] == \"1kG_PEL\", ncol(Data1)-1] <- NA; Data1[Data1[ncol(Data1)-4] == \"1kG_ITU\", ncol(Data1)-1] <- NA; Data1[Data1[ncol(Data1)-4] == \"1kG_PJL\", ncol(Data1)-1] <- NA; Data1[Data1[ncol(Data1)-4] == \"1kG_TSI\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[9]; Data1[Data1[ncol(Data1)-4] == \"1kG_IBS\", ncol(Data1)-1] <- brewer.pal(12, \"Paired\")[10]; Data1[Data1[ncol(Data1)-4] == \"1kG_FIN\", ncol(Data1)-1] <- \"lightgoldenrod4\"; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] <= .1, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[1]; \ 
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .1 & Data1[ncol(Data1)-3] <= .2, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[2]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .2 & Data1[ncol(Data1)-3] <= .3, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[3]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .3 & Data1[ncol(Data1)-3] <= .4, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[4]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .4 & Data1[ncol(Data1)-3] <= .5, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[5]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .5 & Data1[ncol(Data1)-3] <= .6, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[7]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .6 & Data1[ncol(Data1)-3] <= .7, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[8]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .7 & Data1[ncol(Data1)-3] <= .8, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[9]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .8 & Data1[ncol(Data1)-3] <= .9, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[10]; \
	Data1[Data1[ncol(Data1)-4] ==\"Brit\" & Data1[ncol(Data1)-3] > .9 & Data1[ncol(Data1)-3] <= 1, ncol(Data1)-1] <- brewer.pal(11, \"RdBu\")[11]; \
	png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.wPCs.PCplots.vs1.png\", height=10250, width=4750, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(5,2)); \
	plot(Data1[,3], Data1[,4], xlab=\"PC1\", ylab=\"PC2\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,3], Data1[,4], xlab=\"PC1\", ylab=\"PC2\", xlim=c(-.02,.2), ylim=c(-.2,.1), pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,5], Data1[,6], xlab=\"PC3\", ylab=\"PC4\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,7], Data1[,8], xlab=\"PC5\", ylab=\"PC6\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,9], Data1[,10], xlab=\"PC7\", ylab=\"PC8\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,11], Data1[,12], xlab=\"PC9\", ylab=\"PC10\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,13], Data1[,14], xlab=\"PC11\", ylab=\"PC12\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,15], Data1[,16], xlab=\"PC13\", ylab=\"PC14\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,17], Data1[,18], xlab=\"PC15\", ylab=\"PC16\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75); plot(Data1[,19], Data1[,20], xlab=\"PC17\", ylab=\"PC18\", pch=Data1[,ncol(Data1)], col=as.character(Data1[,ncol(Data1)-1]), cex=1.75, cex.main=1.75, cex.axis=1.75, cex.lab=1.75);\
	mtext(\"British\", line=-.75, outer=TRUE, cex=2.5); par(fig = c(0, 1, 0, 1), mfrow=c(1,1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE); plot(0, 0, type = \"n\", bty = \"n\", xaxt = \"n\", yaxt = \"n\"); legend(\"topright\", c(\"ukb_Brit\", 
\"1kG_CEU\", \"1kG_GBR\", \"1kG_FIN\", \"1kG_TSI\", \"1kG_IBS\", \"1kG_YRI\", \"1kG_ESN\", \"1kG_CHB\", \"1kG_JPT\"), pch=c(16, 4, 4, 4, 4, 4, 4, 4, 4, 4), col=c(\"BLACK\", brewer.pal(12, \"Paired\")[3], brewer.pal(12, \"Paired\")[4], \"lightgoldenrod4\", brewer.pal(12, \"Paired\")[9], brewer.pal(12, \"Paired\")[10], brewer.pal(12, \"Paired\")[6], brewer.pal(12, \"Paired\")[5], brewer.pal(12, \"Paired\")[12], brewer.pal(12, \"Paired\")[8]), xpd=TRUE, inset=c(.027,.0385), bg=\"transparent\", cex=1.35, y.intersp=2); \
dev.off();"

#From MacBook Air
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR*.mltiThrd.16.2.Q.wInfo.wPCs.PCplots.vs1.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.

#R -q -e "library(\"RColorBrewer\"); Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.wPCs\", header=T); \
#	png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.wPCs.PCplots.vs1.png\", height=8250, width=4750, res=300); par(oma=c(1,1,4,17.5), mar=c(5,5,4,2), mfrow=c(4,2)); \

R -q -e "Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo\", header=T); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo\", header=T); Data1 <- cbind(Data1, paste(Data1[,1], \"_\", Data1[,2], sep=\"\")); colnames(Data1) <- c(colnames(Data1)[-length(colnames(Data1))], \"FIDIID\"); Data2 <- cbind(Data2, paste(Data2[,1], \"_\", Data2[,2], sep=\"\")); colnames(Data2) <- c(colnames(Data2)[-length(colnames(Data2))], \"FIDIID\"); Data3 <- merge(Data1[Data1[,7] == \"UKB_Brit\", c(8,10)], Data2[Data2[,7] == \"UKB_Brit\", c(8,10)], by=\"FIDIID\"); head(Data3); cor(Data3[,2], Data3[,3]); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.vsIBS_Qs.plot.vs1.png\", height=2000, width=2000, res=300); par(mar=c(5,5,4,2)); plot(Data3[,2], Data3[,3], main=\"admixture Brit NEur Qs:\n IBS vs. TSI\", xlab=\"TSI\", ylab=\"IBS\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); abline(a=0, b=1, lwd=2); dev.off();"

#From MacBook Air
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.vsIBS_Qs.plot.vs1.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.





#NEur >= .9
#NEur >= .95
#NEur >= .9 Ran10k
#SEur <= .8 (~10k indvs)
#NEur >= .9 Ran20k
#SEur <= .8 + NEur >= .9 Ran10k

cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .95) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurGTEpt95.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' | R -q -e "set.seed(834597234); Data1 <- read.table(file('stdin'), header=F); write.table(Data1[sample(1:nrow(Data1), 10000, replace=FALSE),], quote=FALSE, row.name=FALSE, col.name=FALSE);" | grep -v ^\> > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.Ran10k.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 <= .8) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurLTEpt8.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' | R -q -e "set.seed(743627934); Data1 <- read.table(file('stdin'), header=F); write.table(Data1[sample(1:nrow(Data1), 20000, replace=FALSE),], quote=FALSE, row.name=FALSE, col.name=FALSE);" | grep -v ^\> > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.Ran20k.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurLTEpt8.FIDIIDs <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' | R -q -e "set.seed(27593493); Data1 <- read.table(file('stdin'), header=F); write.table(Data1[sample(1:nrow(Data1), 10000, replace=FALSE),], quote=FALSE, row.name=FALSE, col.name=FALSE);" | grep -v ^\>) > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurLTEpt8_NEurGTEpt9_Ran10k.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .95) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.NEurGTEpt95.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' | R -q -e "set.seed(834597234); Data1 <- read.table(file('stdin'), header=F); write.table(Data1[sample(1:nrow(Data1), 10000, replace=FALSE),], quote=FALSE, row.name=FALSE, col.name=FALSE);" | grep -v ^\> > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.Ran10k.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 <= .8) { print $1 "\t" $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.NEurLTEpt8.FIDIIDs
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' | R -q -e "set.seed(743627934); Data1 <- read.table(file('stdin'), header=F); write.table(Data1[sample(1:nrow(Data1), 20000, replace=FALSE),], quote=FALSE, row.name=FALSE, col.name=FALSE);" | grep -v ^\> > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.Ran20k.FIDIIDs 
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.NEurLTEpt8.FIDIIDs <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep Brit | awk '{ if ($8 >= .9) { print $1 "\t" $2 } }' | R -q -e "set.seed(27593493); Data1 <- read.table(file('stdin'), header=F); write.table(Data1[sample(1:nrow(Data1), 10000, replace=FALSE),], quote=FALSE, row.name=FALSE, col.name=FALSE);" | grep -v ^\>) > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo.NEurLTEpt8_NEurGTEpt9_Ran10k.FIDIIDs






UKBioBankPops=`echo "British;British.Admix.TSI9;BritTSI9 British;British.Admix.TSI95;BritTSI95 British;British.Admix.TSI9Ran10k;BritTSI9Ran10k British;British.Admix.TSI8;BritTSI8 British;British.Admix.TSI9Ran20k;BritTSI9Ran20k British;British.Admix.TSI89Ran10k;BritTSI89Ran10k British;British.Admix.IBS9;BritIBS9 British;British.Admix.IBS95;BritIBS95 British;British.Admix.IBS9Ran10k;BritIBS9Ran10k British;British.Admix.IBS8;BritIBS8 British;British.Admix.IBS9Ran20k;BritIBS9Ran20k British;British.Admix.IBS89Ran10k;BritIBS89Ran10k"`;

mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI9; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI9/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI95; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI95/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI9Ran10k; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI9Ran10k/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI8; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI8/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI9Ran20k; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI9Ran20k/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI89Ran10k; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.TSI89Ran10k/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS9; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS9/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS95; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS95/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS9Ran10k; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS9Ran10k/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS8; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS8/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS9Ran20k; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS9Ran20k/mturchin20
mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS89Ran10k; mkdir /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.IBS89Ran10k/mturchin20

for j in `echo "TSI IBS"`; do
	for i in {1..22}; do
		echo $j $i
			
		sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/ukbiobank_jun17/subsets/British/mturchin20/ukb_chr${i}_v2.British.AdmixCreate.${j}.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/British/mturchin20/ukb_chr${i}_v2.British.AdmixCreate.${j}.slurm.error --comment "AdmixCreate $j $i" <(echo -e '#!/bin/sh'; \
		echo -e "\nplink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${i}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${i}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR${j}.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.${j}9/ukb_chr${i}_v2.British.Admix.${j}9"; \
		echo -e "\nplink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${i}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${i}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR${j}.mltiThrd.16.2.Q.wInfo.NEurGTEpt95.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.${j}95/ukb_chr${i}_v2.British.Admix.${j}95"; \
		echo -e "\nplink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${i}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${i}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR${j}.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.Ran10k.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.${j}9Ran10k/ukb_chr${i}_v2.British.Admix.${j}9Ran10k"; \
		echo -e "\nplink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${i}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${i}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR${j}.mltiThrd.16.2.Q.wInfo.NEurLTEpt8.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.${j}8/ukb_chr${i}_v2.British.Admix.${j}8"; \
		echo -e "\nplink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${i}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${i}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR${j}.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.Ran20k.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.${j}9Ran20k/ukb_chr${i}_v2.British.Admix.${j}9Ran20k"; \
		echo -e "\nplink --bed /users/mturchin/data/ukbiobank_jun17/calls/ukb_cal_chr${i}_v2.bed --bim /users/mturchin/data/ukbiobank_jun17/calls/ukb_snp_chr${i}_v2.bim --fam /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam --make-bed --keep /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBR${j}.mltiThrd.16.2.Q.wInfo.NEurLTEpt8_NEurGTEpt9_Ran10k.FIDIIDs --out /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Admix.${j}89Ran10k/ukb_chr${i}_v2.British.Admix.${j}89Ran10k";)
		
	done
done









#/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.txt
for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.txt | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.wFullCovars.txt

done	

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep African`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	for i in {1..22}; do
		echo $ancestry1 $ancestry2 $i
		sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCpostPCA.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCpostPCA.slurm.error --comment "QCpostPCA $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \
                echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed --missing --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed";)
	done
	sleep 2
done

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep African`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo $ancestry1 $ancestry2

	paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr1_v2.${ancestry2}.QCed.imiss | awk '{ print $1 "\t" $2 "\t" $4 "\t" $5 }') \
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr2_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr3_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr4_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr5_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr6_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr7_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr8_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr9_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr10_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr11_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr12_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr13_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr14_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr15_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr16_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr17_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr18_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr19_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr20_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr21_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') \  
	<(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr22_v2.${ancestry2}.QCed.imiss | awk '{ print $4 "\t" $5 }') > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss  
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss | grep -v FID | perl -lane 'my $miss = 0; my $variants = 0; for (my $i = 2; $i <= $#F; $i += 2) { $miss += $F[$i]; $variants += $F[$i+1]; } print $F[0], "\t", $F[1], "\t", $miss, "\t", $variants, "\t", $miss / $variants;' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats 
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats | awk '{ if ($5 >= .05) { print $1 "\t" $2 } } ' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs

done

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	for i in {1..22}; do
		echo $ancestry1 $ancestry2 $i
		rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.imiss /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.lmiss /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.log 
	done
done

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs.QCcheck;
	for i in {1..22}; do
		echo $ancestry1 $ancestry2 $i
	
		sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCpostPCA.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCpostPCA.slurm.error --comment "QCpostPCA $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; \
		echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed --remove /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs -make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed"; \ 
		echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed --remove /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukbKing.drop.ukbDrops.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs"; \
		echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs --keep /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.no1kG.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop"; \	
		echo -e "\necho $ancestry1 $ancestry2 $i >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs.QCcheck; cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs | wc >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs.QCcheck; cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.fam | wc >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs.QCcheck; cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.fam | wc >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs.QCcheck;" \ 
		echo -e "\nrm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.fam /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.log;\nrm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.bed /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.bim /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.fam /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.log;";)
	done
	sleep 2
done

#		echo -e "\ncat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.bim | awk '{ if ($1 != 23) { print $2 } }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.bim.noX.rsIDs"; \
#		echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed --extract /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.bim.noX.rsIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.noX"; \
#	echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed --mind .05 --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed"; \
#	rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukbKing.drop.ukbDrops.FIDIIDs.QCcheck;

for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
	ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
	ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

	echo "~~~~~~~~~~~~~~~~~~~"
	cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs.QCcheck | head -n 5;

done

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22}; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			sbatch -t 72:00:00 --mem 2g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.linear.PCs.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.linear.PCs.slurm.error --comment "LnRgr $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.wFullCovars.txt --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}")

		done
		sleep 2
	done	
done

#--qos=normal
#			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.${pheno1}*
#                        sbatch -t 72:00:00 --mem 2g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.error --comment "LnRgr $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.noX.PCAdrop --chr $i --pheno /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.Edit.txt --pheno-name $pheno1 --linear --sex --covar /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.wFullCovars.txt --covar-name AGE,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.${pheno1}")

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);' | grep BMI`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep -v Ran100000\; | grep -v Ran200000\; | grep -v British.British\;`; do
#	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep -v Ran4000\; | grep -v Ran10000\;`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		for i in {1..22}; do
			echo $pheno1 $ancestry1 $ancestry2 $i

			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.assoc.linear | grep -E 'NMISS|ADD' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear
			sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.linear.clump.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.linear.clump.slurm.error --comment "clumping $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear --clump-p1 .0001 --clump-p2 0.01 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear")
#			sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.linear.clump.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.linear.clump.slurm.error --comment "clumping $pheno1 $ancestry1 $ancestry2 $i" <(echo -e '#!/bin/sh'; echo -e "\nplink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop --clump /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear --clump-p1 5e-8 --clump-p2 0.0001 --clump-r2 0.1 --clump-kb 500 --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict")

		done
		sleep 2
	done	
done

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
#	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep -v Ran100000\; | grep -v Ran200000\; | grep -v British.British\;`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep -v Ran4000\; | grep -v Ran10000\;`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
		echo $pheno1 $ancestry1 $ancestry2 $HOME/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped

		for i in {1..22}; do
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.assoc.linear | perl -lane 'if ($#F == 8) { print join("\t", @F); }' 
		done | sort -g -k 1,1 -k 4,4 | uniq | grep -v BETA | grep -v ^$ | cat <(echo "  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P ") - | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.assoc.linear.gz
		for i in {1..22}; do
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear | perl -lane 'if ($#F == 8) { print join("\t", @F); }' 
		done | sort -g -k 1,1 -k 4,4 | uniq | grep -v BETA | grep -v ^$ | cat <(echo "  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P ") - | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz
		for i in {1..22}; do
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict.clumped 
		done | sort -g -k 1,1 -k 4,4 | uniq | grep -v NSIG | grep -v ^$ | cat <(echo " CHR    F           SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2") - | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.strict.clumped.gz
		ln -s /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.strict.clumped.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.gz  
		for i in {1..22}; do
                        cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.output 
		done > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.output
		for i in {1..22}; do
                        cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.error 
		done > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.error
		for i in {1..22}; do
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.log
		done > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.log	
		for i in {1..22}; do
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.log
		done > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.log	
		for i in {1..22}; do
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.${pheno1}.ADD.linear.clump.slurm.output
		done > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.linear.clump.slurm.output
		for i in {1..22}; do
			cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.${pheno1}.ADD.linear.clump.slurm.error
		done > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.linear.clump.slurm.error 
		
	done	
done

# :. s/ADD.assoc.linear/ADD.assoc.linear.strict/g
#		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.output /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.linear.PCs.slurm.output
#		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.error /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.linear.PCs.slurm.error

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);' | grep -E "Height|BMI"`; do
#	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep -v Ran100000\; | grep -v Ran200000\; | grep -v British.British\;`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep -v Ran4000\; | grep -v Ran10000\;`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 
		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.assoc.linear.gz | wc
		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz | wc 
		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.gz | wc
	
	done
done

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep -v Ran100000\; | grep -v Ran200000\; | grep -v British.British\;`; do
#	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep -v Ran4000\; | grep -v Ran10000\;`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped
		
		tar -cvzf /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.assoc.linear.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr*_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.assoc.linear
		tar -cvzf /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr*_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear 
		tar -cvzf /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr*_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped 
#		ln -s /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict.clumped.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped.tar.gz

	done
done

# :. s/ADD.assoc.linear/ADD.assoc.linear.strict/g
#		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndiv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.assoc.linear.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.assoc.linear.tar.gz
#		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndiv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.tar.gz
#		mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndiv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict.clumped.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict.clumped.tar.gz
#		rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndiv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped.tar.gz
#		ln -s /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict.clumped.tar.gz /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrIndv_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped.tar.gz

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
#	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep -v Ran100000\; | grep -v Ran200000\; | grep -v British.British\;`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep -v Ran4000\; | grep -v Ran10000\;`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.clumped
		
		for i in {1..22}; do
			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.assoc.linear
			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict
			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict.clumped
			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.${pheno1}.linear.PCs.slurm.*
			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.${pheno1}.ADD.linear.clump.slurm.*
			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.log
			rm /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chr${i}_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.${pheno1}.ADD.assoc.linear.strict.log
		done
	done
done

# :. s/ADD.assoc.linear/ADD.assoc.linear.strict/g

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz
		sbatch -t 72:00:00 --mem 4g -o /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.linear.ashr.slurm.output -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.linear.ashr.slurm.error --comment "ashr $pheno1 $ancestry1 $ancestry2" <(echo -e '#!/bin/sh'; echo -e "zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz | R -q -e \"library(\\\"ashr\\\"); Data1 <- read.table(file('stdin'), header=TRUE); Results1 <- ash(Data1\\\$BETA, abs(Data1\\\$BETA)/qnorm(Data1\\\$P/2, lower.tail=FALSE)); write.table(Results1\\\$result, file=\\\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results\\\", quote=FALSE, row.names=FALSE);\"\ngzip -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results")
	done	
done

#		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz | R -q -e "library(\"ashr\"); Data1 <- read.table(file('stdin'), header=TRUE); Results1 <- ash(Data1\$BETA, abs(Data1\$BETA)/qnorm(Data1\$P/2, lower.tail=FALSE)); write.table(Results$result, file=\"/users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results\", quote=FALSE, row.names=FALSE);";
# sacct | awk '{ if ($1 >= 19308273) { print $0 } } ' | perl -lane 'system("scontrol update jobid=$F[0] qos=normal");'

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.gz | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.AllPopComps 

		paste <(echo $ancestry2) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.AllPopComps 

	done	

	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.AllPopComps

done






for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.gz | perl -lane 'if ($F[4] < 5e-8) { print join("\t", @F); }' | awk '{ print "chr" $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.5eNeg8.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.5eNeg8.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.AllPopComps 

		paste <(echo $ancestry2) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.5eNeg8.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.5eNeg8.AllPopComps 

	done	

	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.clumped.5eNeg8.AllPopComps

done










for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 1e-4) { print join("\t", @F); }' | grep -v NA | awk '{ print "chr" $1 "\t" $3 "\t" $3 "\t" $2 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.AllPopComps 
		paste <(echo "$ancestry2") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.1eNeg4.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
done

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.AllPopComps 

		zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 5e-8) { print join("\t", @F); }' | grep -v NA | awk '{ print "chr" $1 "\t" $3 "\t" $3 "\t" $2 }' | grep -v BP > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.5eNeg8.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.5eNeg8.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.AllPopComps 
		paste <(echo "$ancestry2") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.5eNeg8.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.5eNeg8.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.5eNeg8.NoNAs.AllPopComps
done

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 

		paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.gz)  | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, 2*pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < 1e-4) { print join("\t", @F); }' | grep -v PosteriorSD | grep -v NA | grep -v ^\> | awk '{ print "chr" $1 "\t" $2 "\t" $2 "\t" $3 }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 
		paste <(echo "$ancestry2") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
done

for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
			
		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 

		paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.gz)  | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, 2*pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < 5e-8) { print join("\t", @F); }' | grep -v PosteriorSD | grep -v NA | grep -v ^\> | awk '{ print "chr" $1 "\t" $2 "\t" $2 "\t" $3 }' > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.10kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 50000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.50kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 250000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.250kbPadding.bed
		bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 500000 > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.500kbPadding.bed

	done
done

rm -f /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.AllPopComps
for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);'`; do
	echo -e "$pheno1\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.AllPopComps
	for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
		ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
		ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`

		echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.AllPopComps 
		paste <(echo "$ancestry2") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.10kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.50kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.250kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.bed -b /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/$pheno1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.500kbPadding.bed | awk '{ print $1 "_" $2 }' | sort | uniq | wc | awk '{ print $1 }') >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.AllPopComps 

	done	
	echo -e "\n" >> /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.AllPhenos.ADD.assoc.linear.ashr.results.5eNeg8.NoNAs.AllPopComps
done


zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.gz | awk '{ print "chr" $1 "\t" $3 "\t" $3 "\t" $4 "_" $7 "_" $9 }' | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.edits.bed.gz
join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.edits.bed.gz | awk '{ print $1 "_" $2 "\t" $4 }' | sort -k 1,1) | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5 "_" $6 }' > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed
cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed | sed 's/_/ /g' | awk '{ print $4 "\t" $1 "\t" $2 "\t" $5 "\t" $6 "\t" $7 }' | sed 's/chr//g' | cat <(echo -e "RSID\tCHR\tBP\tA1\tBETA\tPVAL") - | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.Height.linear.ADD.clumped.txt.gz

intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/Neale2017/50.assoc.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | perl -lane 'if ($F[0] ne $F[3]) { $F[3] = $F[0]; $F[4] = -1 * $F[4]; } print join("\t", @F);' | R -q -e "Data1 <- read.table(file('stdin'), header=F); Data1[,2] = Data1[,2] / 10; cor(Data1[,2], Data1[,5]); cor(-log10(Data1[,3]), -log10(Data1[,6])); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.Comp.Neale2017.plots.vs1.png\", height=2000, width=4000, res=300); par(mar=c(5,5,4,2), mfrow=c(1,2)); plot(Data1[,2], Data1[,5], xlab=\"UKB_Turchin\", ylab=\"UKB_Neale\", main=\"UKB_Neale vs. UKB_Turchin: Betas\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); legend(\"topleft\", c(\"Line Of Best Fit\"), col=\"RED\", lwd=2, lty=3); abline(a=0, b=1, lwd=2); abline(lm(Data1[,5]~Data1[,2]), col=\"RED\", lwd=2, lty=3); plot(-log10(Data1[,3]), -log10(Data1[,6]), xlab=\"UKB_Turchin\", ylab=\"UKB_Neale\", main=\"UKB_Neale vs. UKB_Turchin: -log10(pVals)\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); legend(\"topleft\", c(\"Line Of Best Fit\"), col=\"RED\", lwd=2, lty=3); abline(a=0, b=1, lwd=2); abline(lm(log10(Data1[,6])~log10(Data1[,3])), col=\"RED\", lwd=2, lty=3); dev.off();" 
#[1] 0.9973939
#[1] 0.9931324
intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/Loh2017/body_HEIGHTz.sumstats.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | perl -lane 'if ($F[0] ne $F[3]) { $F[3] = $F[0]; $F[4] = -1 * $F[4]; } print join("\t", @F);' | R -q -e "Data1 <- read.table(file('stdin'), header=F); Data1[,2] = Data1[,2] / 10; cor(Data1[,2], Data1[,5]); cor(-log10(Data1[,3]), -1*Data1[,6]); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.Comp.Loh2017.plots.vs1.png\", height=2000, width=4000, res=300); par(mar=c(5,5,4,2), mfrow=c(1,2)); plot(Data1[,2], Data1[,5], xlab=\"UKB_Turchin\", ylab=\"UKB_Loh\", main=\"UKB_Loh vs. UKB_Turchin: Betas\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); legend(\"topleft\", c(\"Line Of Best Fit\"), col=\"RED\", lwd=2, lty=3); abline(a=0, b=1, lwd=2); abline(lm(Data1[,5]~Data1[,2]), col=\"RED\", lwd=2, lty=3); plot(-log10(Data1[,3]), -1*Data1[,6], xlab=\"UKB_Turchin\", ylab=\"UKB_Loh\", main=\"UKB_Loh vs. UKB_Turchin: -log10(pVals)\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); legend(\"topleft\", c(\"Line Of Best Fit\"), col=\"RED\", lwd=2, lty=3); abline(a=0, b=1, lwd=2); abline(lm(Data1[,6]~log10(Data1[,3])), col=\"RED\", lwd=2, lty=3); dev.off();" 
#[1] 0.981359
#[1] 0.9656986
intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | perl -lane 'if ($F[0] ne $F[3]) { $F[3] = $F[0]; $F[4] = -1 * $F[4]; } print join("\t", @F);' | awk '{ if (($5 != ".") && ($6 != ".")) { print $0 } } ' | R -q -e "Data1 <- read.table(file('stdin'), header=F); Data1[,2] = Data1[,2] / 10; cor(Data1[,2], Data1[,5]); cor(-log10(Data1[,3]), -log10(Data1[,6])); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.Comp.Wood2014.plots.vs1.png\", height=2000, width=4000, res=300); par(mar=c(5,5,4,2), mfrow=c(1,2)); plot(Data1[,2], Data1[,5], xlab=\"UKB_Turchin\", ylab=\"GIANT_Wood\", main=\"GIANT_Wood vs. UKB_Turchin: Betas\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); legend(\"topleft\", c(\"Line Of Best Fit\"), col=\"RED\", lwd=2, lty=3); abline(a=0, b=1, lwd=2); abline(lm(Data1[,5]~Data1[,2]), col=\"RED\", lwd=2, lty=3); plot(-log10(Data1[,3]), -log10(Data1[,6]), xlab=\"UKB_Turchin\", ylab=\"GIANT_Wood\", main=\"GIANT_Wood vs. UKB_Turchin: -log10(pVals)\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); legend(\"topleft\", c(\"Line Of Best Fit\"), col=\"RED\", lwd=2, lty=3); abline(a=0, b=1, lwd=2); abline(lm(log10(Data1[,6])~log10(Data1[,3])), col=\"RED\", lwd=2, lty=3); dev.off();" 
#[1] 0.9256926
#[1] 0.9364169
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 5000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.5kPadding.bed 
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 10000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.10kPadding.bed 
bedtools slop -i /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed -g /users/mturchin/data2/UCSCGB/hg19.chrom.sizes -b 25000 > /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.25kPadding.bed 
intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | perl -lane 'print $F[$#F-1];' | sort | uniq -c
intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | perl -lane 'print $F[$#F];' | sort | uniq -c
intersectBed -F 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.5kPadding.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | perl -lane 'print $F[$#F-1];' | sort | uniq -c

#MacBook Air
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.Comp.*.plots.vs1.png /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/UKBioBank/.
#scp -p mturchin@ssh.ccv.brown.edu:/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.Height.linear.ADD.clumped.txt.gz /Users/mturchin20/Documents/Work/LabMisc/RamachandranLab/MultiEthnicGWAS/Rnd1/.
























#21000 Ethnic_background 501726
#21001 Body_mass_index_(BMI) 499579
#21003 Age_when_attended_assessment_centre 502620
#22000 Genotype_measurement_batch 488366
#22001 Genetic_sex 488366
#22006 Genetic_ethnic_grouping 409694
#22007 Genotype_measurement_plate 488366
#22008 Genotype_measurement_well 488366
#22009 Genetic_principal_components 488366
#22011 Genetic_relatedness_pairing 17306
#22012 Genetic_relatedness_factor 17306
#22013 Genetic_relatedness_IBS0 17306
#31 Sex 502620
#34 Year_of_birth 502620
#48 Waist_circumference 500500
#49 Hip_circumference 500438
#50 Standing_height 500130

#21000 Ethnic_background 501726
#21001 Body_mass_index_(BMI) 499579
#21003 Age_when_attended_assessment_centre 502620
#22000 Genotype_measurement_batch 488366
#22001 Genetic_sex 488366
#22003 Heterozygosity 488366
#22004 Heterozygosity_PCA_corrected 488366
#22005 Missingness 488366
#22006 Genetic_ethnic_grouping 409694
#22007 Genotype_measurement_plate 488366
#22008 Genotype_measurement_well 488366
#22009 Genetic_principal_components 488366
#22011 Genetic_relatedness_pairing 17306
#22012 Genetic_relatedness_factor 17306
#22013 Genetic_relatedness_IBS0 17306
#22018 Genetic_relatedness_exclusions 1532
#22051 UKBiLEVE_genotype_quality_control_for_samples 50002
#22052 UKBiLEVE_unrelatedness_indicator 50002
#22182 HLA_imputation_values 488366
#2443 Diabetes_diagnosed_by_doctor 501697
#2453 Cancer_diagnosed_by_doctor 501697
#2463 Fractured/broken_bones_in_last_5_years 501697
#2473 Other_serious_medical_condition/disability_diagnosed_by_doctor 501697
#2966 Age_high_blood_pressure_diagnosed 137429
#2976 Age_diabetes_diagnosed 26002
#2986 Started_insulin_within_one_year_diagnosis_of_diabetes 26027
#3005 Fracture_resulting_from_simple_fall 49691
#31 Sex 502620
#3140 Pregnant 272635
#34 Year_of_birth 502620
#48 Waist_circumference 500500
#49 Hip_circumference 500438
#50 Standing_height 500130
#52 Month_of_birth 502620

#=~ s/1/White/g
#=~ s/1001/British/g
#=~ s/2001/White_and_Black_Caribbean/g
#=~ s/3001/Indian/g
#=~ s/4001/Caribbean/g
#=~ s/2/Mixed/g
#=~ s/1002/Irish/g
#=~ s/2002/White_and_Black_African/g
#=~ s/3002/Pakistani/g
#=~ s/4002/African/g	
#=~ s/3/Asian_or_Asian_British/g
#=~ s/1003/Any_other_white_background/g
#=~ s/2003/White_and_Asian/g
#=~ s/3003/Bangladeshi/g
#=~ s/4003/Any_other_Black_background/g
#=~ s/4/Black_or_Black_British/g
#=~ s/2004/Any_other_mixed_background/g
#=~ s/3004/Any_other_Asian_background/g
#=~ s/5/Chinese/g
#=~ s/6/Other_ethnic_group/g
#=~ s/-1/Do_not_know/g
#=~ s/-3/Prefer_not_to_answer/g

#From http://biobank.ctsu.ox.ac.uk/crystal/coding.cgi?id=1001
#Coding	Meaning	Node	Parent
#1	White	1	Top
#1001	British	1001	1
#2001	White and Black Caribbean	2001	2
#3001	Indian	3001	3
#4001	Caribbean	4001	4
#2	Mixed	2	Top
#1002	Irish	1002	1
#2002	White and Black African	2002	2
#3002	Pakistani	3002	3
#4002	African	4002	4
#3	Asian or Asian British	3	Top
#1003	Any other white background	1003	1
#2003	White and Asian	2003	2
#3003	Bangladeshi	3003	3
#4003	Any other Black background	4003	4
#4	Black or Black British	4	Top
#2004	Any other mixed background	2004	2
#3004	Any other Asian background	3004	3
#5	Chinese	5	Top
#6	Other ethnic group	6	Top
#-1	Do not know	-1	Top
#-3	Prefer not to answer	-3	Top

#   3396 African
#   1815 Any_other_Asian_background
#    123 Any_other_Black_background
#   1033 Any_other_mixed_background
#  16340 Any_other_white_background
#     43 Asian_or_Asian_British
#    236 Bangladeshi
#     27 Black_or_Black_British
# 442688 British
#   4519 Caribbean
#   1574 Chinese
#    217 Do_not_know
#      1 Ethnic_background-0.0
#   5951 Indian
#  13213 Irish
#     49 Mixed
#   4560 Other_ethnic_group
#   1837 Pakistani
#   1662 Prefer_not_to_answer
#    571 White
#    831 White_and_Asian
#    425 White_and_Black_African
#    620 White_and_Black_Caribbean

~~~
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=53 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $line; }'
540,184 items of data are available, covering 502,620 participants.<br>Defined-instances run from 0 to 2, labelled using Instancing <a class="basic" href="instance.cgi?id=2">2</a>.
502,620 participants, 502,620 items
20,348 participants, 20,348 items
17,216 participants, 17,216 items
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0\&vt=11 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*.a class="basic" href="field.cgi\?id=(\d+)"..*.a class="subtle" href="field.cgi\?id=\d+".(.*).\/a..\/td..*/) { print $1, "\t", $2 ; }' | head -n 10
5111    3mm asymmetry angle (left)
5108    3mm asymmetry angle (right)
5112    3mm cylindrical power angle (left)
5115    3mm cylindrical power angle (right)
5292    3mm index of best keratometry results (left)
5237    3mm index of best keratometry results (right)
5104    3mm strong meridian angle (left)
5107    3mm strong meridian angle (right)
5103    3mm weak meridian angle (left)
5100    3mm weak meridian angle (right)
[  mturchin@login002  ~]$echo $urls1
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61 http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101
[  mturchin@login002  ~]$for i in urls1; do echo $i; done
urls1
[  mturchin@login002  ~]$for i in $urls1; do echo $i; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101
[  mturchin@login002  ~]$for i in `echo "http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0\&vt=11"`; do echo $i; GET "$i" | wc; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0\&vt=11
     74     279    3872
[  mturchin@login002  ~]$for i in `echo "http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11"`; do echo $i; GET "$i" | wc; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11
    398    6529  107322
[  mturchin@login002  ~]$for i in $urls1; do echo $i; GET $i | wc; done
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=11
    398    6529  107322
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=21
    943   15794  273946
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=22
    166    2241   37668
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=31
   1444   29862  452672
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=41
     86     781   12146
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=51
     80     699   10641
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=61
     66     437    6288
http://biobank.ctsu.ox.ac.uk/crystal/list.cgi?it=0&vt=101
     63     366    5296
[  mturchin@login002  ~]$cat /users/mturchin/LabMisc/RamachandranLab/IntroProjs/MultiEthnGWAS/UKBioBank.HTMLScraping.Field_Name.vs.txt | wc
   2821   19813  132241
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $line; }'
89,048 items of data are available, covering 89,048 participants.<br>Some values have special meanings defined by Data-Coding <a class="basic" href="coding.cgi?id=513">513</a>.
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $1; }'
9,048 participants
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d*,\d+ participants).*/) { print $1; }'
,048 participants
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.*(\d+,\d+ participants).*/) { print $1; }'
9,048 participants
[  mturchin@login002  ~]$GET http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=20434 | perl -lane 'my $line = join(" ", @F); if ($line =~ m/.* (\d+,\d+ participants).*/) { print $1; }'
89,048 participants
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));"
> Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));

    (0,1e+05] (1e+05,2e+05] (2e+05,3e+05] (3e+05,4e+05] (4e+05,5e+05] 
         1730           519           110            52           203 
(5e+05,6e+05] 
          122 
> 
> 
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | wc
 502630 7134350 3172553836
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | wc
 502617  502617 33818880
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'print $#F;' | sort | uniq -c
 501809 1929
    548 1930
    181 1931
     63 1932
     19 1933
      7 1934
      2 1935
      1 1938
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | perl -F, -lane 'print $#F;' | sort | uniq -c
 502617 12
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | wc
   1930    1930   24295
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | head -n 10
"eid"
"31-0.0"
"34-0.0"
"48-0.0"
"48-1.0"
"48-2.0"
"49-0.0"
"49-1.0"
"49-2.0"
"50-0.0"
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | head -n 10
eid
31-0.0
34-0.0
48-0.0
48-1.0
48-2.0
49-0.0
49-1.0
49-2.0
50-0.0
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | head -n 10
eid
31 0.0
34 0.0
48 0.0
48 1.0
48 2.0
49 0.0
49 1.0
49 2.0
50 0.0
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | wc
    222     222    1232
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | head -n 10
eid
31 0.0
34 0.0
48 0.0
48 1.0
48 2.0
49 0.0
49 1.0
49 2.0
50 0.0
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1 | head -n 10
    435 41204
    380 41202
     87 87
     87 20013
     87 20009
     87 20008
     87 20002
     42 40002
     32 41201
     30 41205
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1 | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1
    121 1
     71 3
      6 18
      5 87
      5 5
      3 2
      2 15
      2 12
      1 435
      1 42
      1 380
      1 32
      1 30
      1 28
      1 21
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | head -n 10
10721
10844
129
130
134
135
189
1920
1930
1940
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | head -n 10
5111    3mm_asymmetry_angle_(left)      121723
5108    3mm_asymmetry_angle_(right)     121954
5112    3mm_cylindrical_power_angle_(left)      124554
5115    3mm_cylindrical_power_angle_(right)     124540
5292    3mm_index_of_best_keratometry_results_(left)    124573
5237    3mm_index_of_best_keratometry_results_(right)   124552
5104    3mm_strong_meridian_angle_(left)        124573
5107    3mm_strong_meridian_angle_(right)       124552
5103    3mm_weak_meridian_angle_(left)  124573
5100    3mm_weak_meridian_angle_(right) 124552
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 1,1 | awk '{ print $1 }' | sort | uniq -c | sort -rg -k 2,2 | R -q -e "Data1 <- read.table(file('stdin'), header=F); sum(Data1[,1]);"
> Data1 <- read.table(file('stdin'), header=F); sum(Data1[,1]);
[1] 222
> 
> 
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | wc
   2736    8208  142895
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | wc
    222     222    1232
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) | wc
    122     366    5411
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) | head -n 10
10844
22010
22014
22015
22050
22101
22102
22103
22104
22105
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | grep 22015
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | wc
    100     278    4754
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | head -n 10
10844   Gestational_diabetes_only_(pilot)       63
22010   Recommended_genomic_analysis_exclusions 480
22014   
22015   Average_Y_chromosome_intensities_for_determining_sex    152720
22050   
22101   Chromosome_1_genotype_results   488366
22102   Chromosome_2_genotype_results   488366
22103   
22104   
22105   Chromosome_5_genotype_results   488366
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'print $#F;' | sort | uniq -c
     11 0
     89 2
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | wc
    211     633   10079
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | head -n 10
10721 Illness_injury_bereavement_stress_in_last_2_years_(pilot) 3776
129 Place_of_birth_in_UK_-_north_co-ordinate 452391
130 Place_of_birth_in_UK_-_east_co-ordinate 452391
134 Number_of_self-reported_cancers 501765
135 Number_of_self-reported_non-cancer_illnesses 501765
189 Townsend_deprivation_index_at_recruitment 501993
1920 Mood_swings 501724
1930 Miserableness 501724
1940 Irritability 501724
1950 Sensitivity_/_hurt_feelings 501723
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | tail -n 10
41104   Episodes_containing_&quot;External_cause_-_ICD10&quot;_data     66352
41105   Episodes_containing_&quot;External_cause_-_ICD10_addendum&quot;_data    176
41142   Episodes_containing_&quot;Diagnoses_-_main_ICD10&quot;_data     392294
41143   Episodes_containing_&quot;Diagnoses_-_main_ICD10_-_addendum&quot;_data  2734
41144   Episodes_containing_&quot;Diagnoses_-_main_ICD9&quot;_data      20309
41145   Episodes_containing_&quot;Diagnoses_-_main_ICD9_-_addendum&quot;_data   0
41148   Episodes_containing_&quot;Date_of_operation&quot;_data  377744
41216   Legal_statuses  38
41217   Mental_categories       59
41252   Episodes_containing_&quot;Source_of_inpatient_record&quot;_data 395938
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.ukb9200_dropouts.Field_Name_Participants.vs.txt | perl -lane 'if ($#F == 2) { print join("\t", @F); }' ) | perl -lane 'print $#F;' | sort | uniq -c
    211 2
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | wc
     13      13      76
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq | wc
      5       5      28
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1) | wc
      4      12     157
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)     
eid
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.csv | head -n 1 | perl -F, -lane 'foreach my $entry1 (@F) { print $entry1; }' | sed 's/"//g' | sed 's/-/ /g' | awk '{ print $1 }' | sort | uniq) <(cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/UKBioBank.HTMLScraping.IndividualFields.Field_Name_Participants.vs.txt | sort -k 1,1)  
30040 Mean_corpuscular_volume 479453
30080 Platelet_count 479450
30100 Mean_platelet_(thrombocyte)_volume 479445
30170 Nucleated_red_blood_cell_count 478360
[  mturchin@node420  ~/data/ukbiobank_jun17/mturchin]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.Field_Name_Participants.vs1.txt /users/mturchin/data/ukbiobank_jun17/mturchin/ukb11108.Field_Name_Participants.vs1.txt | sort -rg -k 3,3 | awk '{ print $3 }' | R -q -e "Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));"
> Data1 <- read.table(file('stdin'), header=F); table(cut(Data1[,1], c(0,100000,200000,300000,400000,500000,600000)));

    (0,1e+05] (1e+05,2e+05] (2e+05,3e+05] (3e+05,4e+05] (4e+05,5e+05] 
           54            66             1            18            36 
(5e+05,6e+05] 
           38 
> 
> 
#20171218
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | head -n 1 | perl -F, -lane 'my @vals1 = (4,7,11,211); print join("\t", @F[@vals1]);'
"48-1.0"        "49-1.0"        "50-2.0"        "2976-2.0"
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 5
eid,Sex-0.0,Year_of_birth-0.0,Waist_circumference-0.0,Waist_circumference-1.0,Waist_circumference-2.0,Hip_circumference-0.0,Hip_circumference-1.0,Hip_circumference-2.0,Standing_height-0.0,Standing_height-1.0,Standing_height-2.0,Ethnic_background-0.0,Ethnic_background-1.0,Ethnic_background-2.0,Body_mass_index_(BMI)-0.0,Body_mass_index_(BMI)-1.0,Body_mass_index_(BMI)-2.0,Age_when_attended_assessment_centre-0.0,Age_when_attended_assessment_centre-1.0,Age_when_attended_assessment_centre-2.0,Genotype_measurement_batch-0.0,Genetic_sex-0.0,Genetic_ethnic_grouping-0.0,Genotype_measurement_plate-0.0,Genotype_measurement_well-0.0,Genetic_principal_components-0.1,Genetic_principal_components-0.2,Genetic_principal_components-0.3,Genetic_principal_components-0.4,Genetic_principal_components-0.5,Genetic_principal_components-0.6,Genetic_principal_components-0.7,Genetic_principal_components-0.8,Genetic_principal_components-0.9,Genetic_principal_components-0.10,Genetic_principal_components-0.11,Genetic_principal_components-0.12,Genetic_principal_components-0.13,Genetic_principal_components-0.14,Genetic_principal_components-0.15,Genetic_relatedness_pairing-0.0,Genetic_relatedness_pairing-0.1,Genetic_relatedness_pairing-0.2,Genetic_relatedness_pairing-0.3,Genetic_relatedness_pairing-0.4,Genetic_relatedness_factor-0.0,Genetic_relatedness_factor-0.1,Genetic_relatedness_factor-0.2,Genetic_relatedness_factor-0.3,Genetic_relatedness_factor-0.4,Genetic_relatedness_IBS0-0.0,Genetic_relatedness_IBS0-0.1,Genetic_relatedness_IBS0-0.2,Genetic_relatedness_IBS0-0.3,Genetic_relatedness_IBS0-0.4
1251407,1,1961,92,94,,107,108,,180.5,180,,1001,1001,,27.9924,29.5988,,46,51,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5176998,1,1954,121,,,112,,,172,,,1001,,,37.1485,,,54,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5303357,1,1960,102,,,109,,,171,,,1001,,,32.7964,,,48,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
1501525,0,1952,95,,,114,,,157,,,1001,,,34.8087,,,58,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | wc       
 502630  502630 68394916
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'print $#F;' | sort | uniq -c                                                   501809 1929
    548 1930
    181 1931
     63 1932
     19 1933
      7 1934
      2 1935
      1 1938
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' | head -n 10
eid,31-0.0,34-0.0,48-0.0,48-1.0,48-2.0,49-0.0,49-1.0,49-2.0,50-0.0,50-1.0,50-2.0,21000-0.0,21000-1.0,21000-2.0,21001-0.0,21001-1.0,21001-2.0,21003-0.0,21003-1.0,21003-2.0,22000-0.0,22001-0.0,22006-0.0,22007-0.0,22008-0.0,22009-0.1,22009-0.2,22009-0.3,22009-0.4,22009-0.5,22009-0.6,22009-0.7,22009-0.8,22009-0.9,22009-0.10,22009-0.11,22009-0.12,22009-0.13,22009-0.14,22009-0.15,22011-0.0,22011-0.1,22011-0.2,22011-0.3,22011-0.4,22012-0.0,22012-0.1,22012-0.2,22012-0.3,22012-0.4,22013-0.0,22013-0.1,22013-0.2,22013-0.3,22013-0.4
1251407,1,1961,92,94,,107,108,,180.5,180,,1001,1001,,27.9924,29.5988,,46,51,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5176998,1,1954,121,,,112,,,172,,,1001,,,37.1485,,,54,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5303357,1,1960,102,,,109,,,171,,,1001,,,32.7964,,,48,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
1501525,0,1952,95,,,114,,,157,,,1001,,,34.8087,,,58,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5849213,1,1940,107,,,104.5,,,163,,,1001,,,31.9922,,,67,,,-11,1,1,SMP4_0012187,H02,-5.15936,-3.58885,1.53065,-6.66753,11.8696,2.91714,-0.932745,-2.22673,3.03368,-3.45926,-1.19595,-2.97451,-2.48113,2.79418,0.664615,,,,,,,,,,,,,,,
4326944,0,1956,85,,,106,,,167,,,1001,,,29.1513,,,53,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
4579899,1,1966,102,,,102,,,174,,,1001,,,30.5523,,,43,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
3671144,0,1947,84,,,108,,,165,,,1001,,,26.0422,,,60,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5606710,0,1959,72,,,87,,,165,,,1001,,,22.6263,,,49,,,2000,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | head -n 10
"eid","31-0.0","34-0.0","48-0.0","48-1.0","48-2.0","49-0.0","49-1.0","49-2.0","50-0.0","50-1.0","50-2.0","21000-0.0","21000-1.0","21000-2.0","21001-0.0","21001-1.0","21001-2.0","21003-0.0","21003-1.0","21003-2.0","22000-0.0","22001-0.0","22006-0.0","22007-0.0","22008-0.0","22009-0.1","22009-0.2","22009-0.3","22009-0.4","22009-0.5","22009-0.6","22009-0.7","22009-0.8","22009-0.9","22009-0.10","22009-0.11","22009-0.12","22009-0.13","22009-0.14","22009-0.15","22011-0.0","22011-0.1","22011-0.2","22011-0.3","22011-0.4","22012-0.0","22012-0.1","22012-0.2","22012-0.3","22012-0.4","22013-0.0","22013-0.1","22013-0.2","22013-0.3","22013-0.4"
"1251407","1","1961","92","94","","107","108","","180.5","180","","1001","1001","","27.9924","29.5988","","46","51","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5176998","1","1954","121","","","112","","","172","","","1001","","","37.1485","","","54","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5303357","1","1960","102","","","109","","","171","","","1001","","","32.7964","","","48","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"1501525","0","1952","95","","","114","","","157","","","1001","","","34.8087","","","58","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5849213","1","1940","107","","","104.5","","","163","","","1001","","","31.9922","","","67","","","-11","1","1","SMP4_0012187","H02","-5.15936","-3.58885","1.53065","-6.66753","11.8696","2.91714","-0.932745","-2.22673","3.03368","-3.45926","-1.19595","-2.97451","-2.48113","2.79418","0.664615","","","","","","","","","","","","","","",""
"4326944","0","1956","85","","","106","","","167","","","1001","","","29.1513","","","53","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"4579899","1","1966","102","","","102","","","174","","","1001","","","30.5523","","","43","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"3671144","0","1947","84","","","108","","","165","","","1001","","","26.0422","","","60","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
"5606710","0","1959","72","","","87","","","165","","","1001","","","22.6263","","","49","","","2000","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | head -n 20 | perl -F, -lane 'print $#F;' | sort | uniq -c
     20 55
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.csv | perl -F, -lane 'if ($. == 1) { @colsUse; for (my $i = 0; $i <= $#F; $i++) { if ($F[$i] =~ m/(eid|"21000\-|"21001\-|"21003\-|"22000\-|"22001\-|"22006\-|"22007\-|"22008\-|"22009\-|"22011\-|"22012\-|"22013\-|"31\-|"34\-|"48\-|"49\-|"50\-)/) { push(@colsUse, $i); } } } print join(",", @F[@colsUse]);' | sed 's/"//g' | head -n 20 | perl -F, -lane 'print $#F;' | sort | uniq -c
     17 21
      2 40
      1 55
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'print $#F;' | sort | uniq -c
 502630 55
[  mturchin@login002  ~]$for i in {1..2}; do
>         val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
>         val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`
>
>         echo $i $val1 $val2
>
> done
1 "Sex-0.0" 502630
2 "Year_of_birth-0.0" 502630
[  mturchin@login002  ~]$for i in {37..39}; do
>         val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
>         val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`
>
>         echo $i $val1 $val2
>
> done
37 "Genetic_principal_components-0.12" 152725
38 "Genetic_principal_components-0.13" 152725
39 "Genetic_principal_components-0.14" 152725
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'print $F[1];' | sort | uniq -c
 273460 "0"
 229169 "1"
      1 "Sex-0.0"
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'print $F[12];' | sort | uniq -c
    899 ""
    217 "-1"
   1662 "-3"
    571 "1"
 442688 "1001"
  13213 "1002"
  16340 "1003"
     49 "2"
    620 "2001"
    425 "2002"
    831 "2003"
   1033 "2004"
     43 "3"
   5951 "3001"
   1837 "3002"
    236 "3003"
   1815 "3004"
     27 "4"
   4519 "4001"
   3396 "4002"
    123 "4003"
   1574 "5"
   4560 "6"
      1 "Ethnic_background-0.0"
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for i in {0..55}; do
>         val1=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | head -n 1 | perl -F, -slane 'print $F[$iBash];' -- -iBash=$i`
>         val2=`cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -slane 'if ($F[$iBash] !~ m/""/) { print $F[$iBash]; }' -- -iBash=$i | wc | awk '{ print $1 }'`
>
>         echo $i $val1 $val2
>
> done
0 "eid" 502630
1 "Sex-0.0" 502630
2 "Year_of_birth-0.0" 502630
3 "Waist_circumference-0.0" 500470
4 "Waist_circumference-1.0" 20326
5 "Waist_circumference-2.0" 13206
6 "Hip_circumference-0.0" 500411
7 "Hip_circumference-1.0" 20321
8 "Hip_circumference-2.0" 13207
9 "Standing_height-0.0" 500091
10 "Standing_height-1.0" 20317
11 "Standing_height-2.0" 13205
12 "Ethnic_background-0.0" 501731
13 "Ethnic_background-1.0" 20340
14 "Ethnic_background-2.0" 11672
15 "Body_mass_index_(BMI)-0.0" 499525
16 "Body_mass_index_(BMI)-1.0" 20303
17 "Body_mass_index_(BMI)-2.0" 11886
18 "Age_when_attended_assessment_centre-0.0" 502630
19 "Age_when_attended_assessment_centre-1.0" 20003
20 "Age_when_attended_assessment_centre-2.0" 12552
21 "Genotype_measurement_batch-0.0" 502589
22 "Genetic_sex-0.0" 152725
23 "Genetic_ethnic_grouping-0.0" 120284
24 "Genotype_measurement_plate-0.0" 152725
25 "Genotype_measurement_well-0.0" 152725
26 "Genetic_principal_components-0.1" 152725
27 "Genetic_principal_components-0.2" 152725
28 "Genetic_principal_components-0.3" 152725
29 "Genetic_principal_components-0.4" 152725
30 "Genetic_principal_components-0.5" 152725
31 "Genetic_principal_components-0.6" 152725
32 "Genetic_principal_components-0.7" 152725
33 "Genetic_principal_components-0.8" 152725
34 "Genetic_principal_components-0.9" 152725
35 "Genetic_principal_components-0.10" 152725
36 "Genetic_principal_components-0.11" 152725
37 "Genetic_principal_components-0.12" 152725
38 "Genetic_principal_components-0.13" 152725
39 "Genetic_principal_components-0.14" 152725
40 "Genetic_principal_components-0.15" 152725
41 "Genetic_relatedness_pairing-0.0" 17308
42 "Genetic_relatedness_pairing-0.1" 1857
43 "Genetic_relatedness_pairing-0.2" 190
44 "Genetic_relatedness_pairing-0.3" 29
45 "Genetic_relatedness_pairing-0.4" 3
46 "Genetic_relatedness_factor-0.0" 17308
47 "Genetic_relatedness_factor-0.1" 1857
48 "Genetic_relatedness_factor-0.2" 190
49 "Genetic_relatedness_factor-0.3" 29
50 "Genetic_relatedness_factor-0.4" 3
51 "Genetic_relatedness_IBS0-0.0" 17308
52 "Genetic_relatedness_IBS0-0.1" 1857
53 "Genetic_relatedness_IBS0-0.2" 190
54 "Genetic_relatedness_IBS0-0.3" 29
55 "Genetic_relatedness_IBS0-0.4" 3
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | head -n 5
"eid"   "Sex-0.0"       "Year_of_birth-0.0"     2018    "Waist_circumference-0.0"       "Hip_circumference-0.0" "Standing_height-0.0"   "Ethnic_background-0.0" "Body_mass_index_(BMI)-0.0"     "Age_when_attended_assessment_centre-0.0"      "Genotype_measurement_batch-0.0"
"1251407"       "1"     "1961"  2018    "92"    "107"   "180.5" "1001"  "27.9924"       "46"    "2000"
"5176998"       "1"     "1954"  2018    "121"   "112"   "172"   "1001"  "37.1485"       "54"    "2000"
"5303357"       "1"     "1960"  2018    "102"   "109"   "171"   "1001"  "32.7964"       "48"    "2000"
"1501525"       "0"     "1952"  2018    "95"    "114"   "157"   "1001"  "34.8087"       "58"    "2000"
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | head -n 5
eid     Sex-0.0 Year_of_birth-0.0       2018    Waist_circumference-0.0 Hip_circumference-0.0   Standing_height-0.0     Ethnic_background-0.0   Body_mass_index_(BMI)-0.0       Age_when_attended_assessment_centre-0.0 Genotype_measurement_batch-0.0
1251407 1       1961    2018    92      107     180.5   1001    27.9924 46      2000
5176998 1       1954    2018    121     112     172     1001    37.1485 54      2000
5303357 1       1960    2018    102     109     171     1001    32.7964 48      2000
1501525 0       1952    2018    95      114     157     1001    34.8087 58      2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | perl -lane 'print $#F;' | sort | uniq -c
 498814 10
    365 5
   1655 6
     98 7
    526 8
   1172 9
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | perl -lane 'print $#F;' | sort | uniq -c
 502630 10
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | perl -lane 'if ($#F == 5) { print join("\t", @F); }' | head -n 5
1771417 1       1963    2018    46      2000
5949522 1       1948    2018    59      2000
3099432 0       1954    2018    54      2000
2349616 0       1947    2018    61      2000
4754372 1       1956    2018    52      2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], "\t", $F[1], "\t", $F[2], "\t", $age, "\t", $F[3], "\t", $F[6], "\t", $F[9], "\t", $F[12], "\t", $F[15], "\t", $F[18], "\t", $F[21];' | sed 's/"//g' | grep -E '1771417|5949522|3099432|2349616|4754372'
1771417 1       1963    2018                                            46      2000
5949522 1       1948    2018                                            59      2000
3099432 0       1954    2018                                            54      2000
2349616 0       1947    2018                                            61      2000
4754372 1       1956    2018                                            52      2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | head -n 5
"eid","Sex-0.0","Year_of_birth-0.0",2018,"Waist_circumference-0.0","Hip_circumference-0.0","Standing_height-0.0","Ethnic_background-0.0","Body_mass_index_(BMI)-0.0","Age_when_attended_assessment_centre-0.0","Genotype_measurement_batch-0.0"
"1251407","1","1961",2018,"92","107","180.5","1001","27.9924","46","2000"
"5176998","1","1954",2018,"121","112","172","1001","37.1485","54","2000"
"5303357","1","1960",2018,"102","109","171","1001","32.7964","48","2000"
"1501525","0","1952",2018,"95","114","157","1001","34.8087","58","2000"
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | head -n 5
eid,Sex-0.0,Year_of_birth-0.0,2018,Waist_circumference-0.0,Hip_circumference-0.0,Standing_height-0.0,Ethnic_background-0.0,Body_mass_index_(BMI)-0.0,Age_when_attended_assessment_centre-0.0,Genotype_measurement_batch-0.0
1251407,1,1961,2018,92,107,180.5,1001,27.9924,46,2000
5176998,1,1954,2018,121,112,172,1001,37.1485,54,2000
5303357,1,1960,2018,102,109,171,1001,32.7964,48,2000
1501525,0,1952,2018,95,114,157,1001,34.8087,58,2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | perl -F, -lane 'print $#F; | sort | uniq -c
> ^C
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | perl -F, -lane 'print $#F;' | sort | uniq -c
 502630 10
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'print $#F;' | sort | uniq -c
 502589 10
     41 9
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'if ($#F == 41) { print join(",", @F); }' | head -n 5
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'if ($#F == 9) { print join(",", @F); }' | head -n 5
4098943,0,1961,2018,86,105,168,1001,26.0771,47
2920100,0,1940,2018,93,100,158,1001,25.3966,68
5920959,1,1945,2018,96,105,167,1001,30.1553,63
3403302,0,1966,2018,94,108,170,1001,28.0623,42
1672299,0,1948,2018,75,95,161,1001,24.0346,61
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -lane 'if ($#F == 10) { print join(",", @F); }' | head -n 5
eid,Sex-0.0,Year_of_birth-0.0,2018,Waist_circumference-0.0,Hip_circumference-0.0,Standing_height-0.0,Ethnic_background-0.0,Body_mass_index_(BMI)-0.0,Age_when_attended_assessment_centre-0.0,Genotype_measurement_batch-0.0
1251407,1,1961,2018,92,107,180.5,1001,27.9924,46,2000
5176998,1,1954,2018,121,112,172,1001,37.1485,54,2000
5303357,1,1960,2018,102,109,171,1001,32.7964,48,2000
1501525,0,1952,2018,95,114,157,1001,34.8087,58,2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | grep -E '4098943|2920100|5920959|3403302|1672299'
"4098943","0","1961",2018,"86","105","168","1001","26.0771","47",""
"2920100","0","1940",2018,"93","100","158","1001","25.3966","68",""
"5920959","1","1945",2018,"96","105","167","1001","30.1553","63",""
"3403302","0","1966",2018,"94","108","170","1001","28.0623","42",""
"1672299","0","1948",2018,"75","95","161","1001","24.0346","61",""
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | grep -E '4098943|2920100|5920959|3403302|1672299' | sed 's/"//g'
4098943,0,1961,2018,86,105,168,1001,26.0771,47,
2920100,0,1940,2018,93,100,158,1001,25.3966,68,
5920959,1,1945,2018,96,105,167,1001,30.1553,63,
3403302,0,1966,2018,94,108,170,1001,28.0623,42,
1672299,0,1948,2018,75,95,161,1001,24.0346,61,
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $age = 2018 - $F[2]; print $F[0], ",", $F[1], ",", $F[2], ",", $age, ",", $F[3], ",", $F[6], ",", $F[9], ",", $F[12], ",", $F[15], ",", $F[18], ",", $F[21];' | sed 's/"//g' | perl -F, -ane 'print $#F, "\n";' | sort | uniq -c
 502630 10
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.txt | perl -F, -lane 'my $year1 = $F[2]; $year1 =~ tr/"//d; print $F[0], ",", $F[1], ",", $F[12], ",", $F[2], ",", $F[18], ",", 2018 - $year1, ",", $F[9], ",", $F[15], ",", $F[3], ",", $F[6], ",", $F[21];' | sed 's/"//g' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt 
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.PrepWork.MainChoices.txt | head -n 5 
eid,Sex-0.0,Ethnic_background-0.0,Year_of_birth-0.0,Age_when_attended_assessment_centre-0.0,2018,Standing_height-0.0,Body_mass_index_(BMI)-0.0,Waist_circumference-0.0,Hip_circumference-0.0,Genotype_measurement_batch-0.0
1251407,1,1001,1961,46,57,180.5,27.9924,92,107,2000
5176998,1,1001,1954,54,64,172,37.1485,121,112,2000
5303357,1,1001,1960,48,58,171,32.7964,102,109,2000
1501525,0,1001,1952,58,66,157,34.8087,95,114,2000
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | head -n 5
eid     eid     Sex-0.0 Ethnic_background-0.0   Age_when_attended_assessment_centre-0.0
1251407 1251407 1       British 46
5176998 5176998 1       British 54
5303357 5303357 1       British 48
1501525 1501525 0       British 58
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $3 }' | sort | uniq -c
 273007 0
 228723 1
      1 Sex-0.0
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $4 }' | sort | uniq -c
   3396 African
   1815 Any_other_Asian_background
    123 Any_other_Black_background
   1033 Any_other_mixed_background
  16340 Any_other_white_background
     43 Asian_or_Asian_British
    236 Bangladeshi
     27 Black_or_Black_British
 442688 British
   4519 Caribbean
   1574 Chinese
    217 Do_not_know
      1 Ethnic_background-0.0
   5951 Indian
  13213 Irish
     49 Mixed
   4560 Other_ethnic_group
   1837 Pakistani
   1662 Prefer_not_to_answer
    571 White
    831 White_and_Asian
    425 White_and_Black_African
    620 White_and_Black_Caribbean
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | head -n 5
FID     IID     SEX     ANCESTRY        AGE
1251407 1251407 1       British 46
5176998 5176998 1       British 54
5303357 5303357 1       British 48
1501525 1501525 0       British 58
[  mturchin@login002  ~]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Phenos.txt | head -n 5
FID     IID     Height  BMI     Waist   Hip
1251407 1251407 180.5   27.9924 92      107
5176998 5176998 172     37.1485 121     112
5303357 5303357 171     32.7964 102     109
1501525 1501525 157     34.8087 95      114
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | head -n 20
5482808 5482808 0 0 1 Batch_b001
1423779 1423779 0 0 2 Batch_b001
3069861 3069861 0 0 2 Batch_b001
3322840 3322840 0 0 2 Batch_b001
2016419 2016419 0 0 2 Batch_b001
3429631 3429631 0 0 1 Batch_b001
[  mturchin@login002  ~]$for i in `cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt`; do
>         echo $i;
>         cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep -w $i | awk '{ print $1 "\t" $2 }' > /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.${i}.FIDIIDs
> 
> done
ANCESTRY
African
Any_other_Asian_background
Any_other_Black_background
Any_other_mixed_background
Any_other_white_background
Asian_or_Asian_British
Bangladeshi
Black_or_Black_British
British
Caribbean
Chinese
Do_not_know
Indian
Irish
Mixed
Other_ethnic_group
Pakistani
Prefer_not_to_answer
White
White_and_Asian
White_and_Black_African
White_and_Black_Caribbean
[  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.
ukb9200.2017_8_WinterRetreat.Covars.ANCESTRY.FIDIIDs                    ukb9200.2017_8_WinterRetreat.Covars.Black_or_Black_British.FIDIIDs      ukb9200.2017_8_WinterRetreat.Covars.Pakistani.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.African.FIDIIDs                     ukb9200.2017_8_WinterRetreat.Covars.British.FIDIIDs                     ukb9200.2017_8_WinterRetreat.Covars.Prefer_not_to_answer.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Ancestries.txt                      ukb9200.2017_8_WinterRetreat.Covars.Caribbean.FIDIIDs                   ukb9200.2017_8_WinterRetreat.Covars.White.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_Asian_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Chinese.FIDIIDs                     ukb9200.2017_8_WinterRetreat.Covars.White_and_Asian.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_Black_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Do_not_know.FIDIIDs                 ukb9200.2017_8_WinterRetreat.Covars.White_and_Black_African.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_mixed_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Indian.FIDIIDs                      ukb9200.2017_8_WinterRetreat.Covars.White_and_Black_Caribbean.FIDIIDs
ukb9200.2017_8_WinterRetreat.Covars.Any_other_white_background.FIDIIDs  ukb9200.2017_8_WinterRetreat.Covars.Irish.FIDIIDs                       ukb9200.2017_8_WinterRetreat.Covars.txt
ukb9200.2017_8_WinterRetreat.Covars.Asian_or_Asian_British.FIDIIDs      ukb9200.2017_8_WinterRetreat.Covars.Mixed.FIDIIDs                       
ukb9200.2017_8_WinterRetreat.Covars.Bangladeshi.FIDIIDs                 ukb9200.2017_8_WinterRetreat.Covars.Other_ethnic_group.FIDIIDs          
#20171228
[  mturchin@node462  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$squeue --Format=jobid,partition,name,username,statecompact,starttime,timeused,numnodes,nodelist | head -n 10
JOBID               PARTITION           NAME                USER                ST                  START_TIME          TIME                NODES               NODELIST
18498392            batch                                   ssharm10            PD                  N/A                 0:00                4
18461427            batch               FRAGMENTS_100[16]   bsevilmi            PD                  N/A                 0:00                1
18461428            batch               FRAGMENTS_100[17]   bsevilmi            PD                  N/A                 0:00                1
18461429            batch               FRAGMENTS_100[18]   bsevilmi            PD                  N/A                 0:00                1
18461430            batch               FRAGMENTS_100[19]   bsevilmi            PD                  N/A                 0:00                1
18461431            batch               FRAGMENTS_100[20]   bsevilmi            PD                  N/A                 0:00                1
18461432            batch               FRAGMENTS_100[21]   bsevilmi            PD                  N/A                 0:00                1
18461433            batch               FRAGMENTS_100[22]   bsevilmi            PD                  N/A                 0:00                1
18461434            batch               FRAGMENTS_100[23]   bsevilmi            PD                  N/A                 0:00                1
[  mturchin@node463  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for pheno1 in `echo "Height"`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>                 echo $pheno1 $ancestry1 $ancestry2
> 
>                 for i in {1..22} X; do
>                         if [ ! -e /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.assoc.linear ]; then 
>                                 echo -e "\t" $i
>                         fi
>                 done
>         done
> done
Height African African
Height Any_other_white_background Any_other_white_background
Height British British
Height British British.Ran10000
Height British British.Ran100000
Height British British.Ran200000
Height Caribbean Caribbean
Height Indian Indian
Height Irish Irish
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | perl -lane 'print join("\t", @F[0..9]);' | head -n 10
5306119 5306119 0       0       2       -9      A       A       T       T
5459215 5459215 0       0       1       -9      A       A       T       T
2723077 2723077 0       0       2       -9      A       A       T       T
4357190 4357190 0       0       1       -9      A       A       T       T
2796634 2796634 0       0       1       -9      A       A       T       T
3270017 3270017 0       0       2       -9      A       A       T       T
3327488 3327488 0       0       1       -9      A       A       T       T
2001488 2001488 0       0       2       -9      A       A       T       T
2459402 2459402 0       0       1       -9      A       A       T       T
5523857 5523857 0       0       2       -9      A       A       T       T
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep 5459215
5459215 5459215 1       British 66
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | grep 2001488
2001488 2001488 0       British 56
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | awk '{ print $1 "\t" $5 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $1 "\t" $3 }' | sort -k 1,1) | wc
   3907   11721   46884
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | wc
   3907 88649830 180126025
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/2017WinterHack/ukb_chr21_v2.British.Ran4000.ped | awk '{ print $1 "\t" $5 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | awk '{ print $1 "\t" $3 }' | sort -k 1,1) | head -n 10
1000254 1 1
1003024 1 1
1003681 2 0
1006073 2 0
1007485 1 1
1007736 1 1
1009728 2 0
1011305 1 1
1015310 2 0
1018866 1 1
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | head -n 5
5482808 5482808 0 0 1 Batch_b001
1423779 1423779 0 0 2 Batch_b001
3069861 3069861 0 0 2 Batch_b001
3322840 3322840 0 0 2 Batch_b001
2016419 2016419 0 0 2 Batch_b001
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | grep 1000254
1000254 1000254 0 0 1 UKBiLEVEAX_b1
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/ukb2241_cal_chr1_v2_s488363.fam | grep 1003681
1003681 1003681 0 0 2 Batch_b034
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.temp1.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
  23      rs60075487    2699676    A        ADD     3099     0.1525       0.7321       0.4641
  23      rs60075487    2699676    A        AGE     3099    -0.2295       -16.09    5.152e-56
  23      rs60075487    2699676    A        SEX     3099      11.22        48.14            0
  23       rs2306736    2700027    C        ADD     3141     0.1219        0.637       0.5242
  23       rs2306736    2700027    C        AGE     3141    -0.2286       -16.17    1.456e-56
  23       rs2306736    2700027    C        SEX     3141      11.22        47.73            0
  23   Affx-92044070    2700151   AT        ADD     3111     -13.23       -2.111      0.03488
  23   Affx-92044070    2700151   AT        AGE     3111    -0.2283       -16.09    5.517e-56
  23   Affx-92044070    2700151   AT        SEX     3111      11.15        49.54            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
  23      rs60075487    2699676    A        ADD     3099         NA           NA           NA
  23      rs60075487    2699676    A        SEX     3099         NA           NA           NA
  23      rs60075487    2699676    A        AGE     3099         NA           NA           NA
  23      rs60075487    2699676    A        SEX     3099         NA           NA           NA
  23       rs2306736    2700027    C        ADD     3141         NA           NA           NA
  23       rs2306736    2700027    C        SEX     3141         NA           NA           NA
  23       rs2306736    2700027    C        AGE     3141         NA           NA           NA
  23       rs2306736    2700027    C        SEX     3141         NA           NA           NA
  23   Affx-92044070    2700151   AT        ADD     3111         NA           NA           NA
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.temp1.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
   1      rs28659788     723307    C        ADD        0         NA           NA           NA
   1      rs28659788     723307    C        AGE        0         NA           NA           NA
   1      rs28659788     723307    C        SEX        0         NA           NA           NA
   1     rs116587930     727841    A        ADD     2866     0.3683       0.3129       0.7543
   1     rs116587930     727841    A        AGE     2866    -0.2322       -15.93    7.872e-55
   1     rs116587930     727841    A        SEX     2866       11.3        48.72            0
   1     rs116720794     729632    T        ADD     3005      0.267       0.5391       0.5899
   1     rs116720794     729632    T        AGE     3005    -0.2291       -15.81    3.616e-54
   1     rs116720794     729632    T        SEX     3005      11.21        48.62            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.assoc.linear | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
   1      rs28659788     723307    C        ADD        0         NA           NA           NA
   1      rs28659788     723307    C        SEX        0         NA           NA           NA
   1      rs28659788     723307    C        AGE        0         NA           NA           NA
   1     rs116587930     727841    A        ADD     2866     0.3683       0.3129       0.7543
   1     rs116587930     727841    A        SEX     2866       11.3        48.72            0
   1     rs116587930     727841    A        AGE     2866    -0.2322       -15.93    7.872e-55
   1     rs116720794     729632    T        ADD     3005      0.267       0.5391       0.5899
   1     rs116720794     729632    T        SEX     3005      11.21        48.62            0
   1     rs116720794     729632    T        AGE     3005    -0.2291       -15.81    3.616e-54
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.temp1.assoc.linear | head -n 1546 | tail -n 10
  23     rs139127906    5192983    G        SEX     3033         NA           NA           NA
  23     rs149932678    5193109    C        ADD     3144    -0.2844     -0.06416       0.9489
  23     rs149932678    5193109    C        AGE     3144    -0.2288        -16.2    8.963e-57
  23     rs149932678    5193109    C        SEX     3144      11.18        49.92            0
  23       rs5961309    5203282    G        ADD     3141    -0.0281      -0.1518       0.8794
  23       rs5961309    5203282    G        AGE     3141    -0.2284       -16.18     1.33e-56
  23       rs5961309    5203282    G        SEX     3141      11.16        46.93            0
  23     rs150262381    5205074    C        ADD     3138     0.3212       0.2225        0.824
  23     rs150262381    5205074    C        AGE     3138    -0.2289       -16.17    1.601e-56
  23     rs150262381    5205074    C        SEX     3138      11.17        49.78            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.assoc.linear | head -n 1546 | tail -n 10
  23       rs1707492    4385969    G        SEX     3140         NA           NA           NA
  23       rs5915749    4388580    G        ADD     3132         NA           NA           NA
  23       rs5915749    4388580    G        SEX     3132         NA           NA           NA
  23       rs5915749    4388580    G        AGE     3132         NA           NA           NA
  23       rs5915749    4388580    G        SEX     3132         NA           NA           NA
  23       rs6638839    4388928    A        ADD     2703         NA           NA           NA
  23       rs6638839    4388928    A        SEX     2703         NA           NA           NA
  23       rs6638839    4388928    A        AGE     2703         NA           NA           NA
  23       rs6638839    4388928    A        SEX     2703         NA           NA           NA
  23     rs142163080    4424315    A        ADD     3113         NA           NA           NA
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.temp1.assoc.linear | head -n 1546 | tail -n 10
   1      rs12041925    1707740    G        SEX     3142      11.17        49.92            0
   1     rs116018620    1709119    T        ADD     3145      2.192        1.908      0.05648
   1     rs116018620    1709119    T        AGE     3145    -0.2284       -16.18    1.287e-56
   1     rs116018620    1709119    T        SEX     3145      11.18        49.94            0
   1      rs77787690    1712428    C        ADD     3144    -0.5953       -0.654       0.5132
   1      rs77787690    1712428    C        AGE     3144    -0.2295       -16.25    4.605e-57
   1      rs77787690    1712428    C        SEX     3144      11.18        49.95            0
   1     rs185462709    1720487    T        ADD     3145     0.4056       0.2885       0.7729
   1     rs185462709    1720487    T        AGE     3145    -0.2289       -16.21    7.842e-57
   1     rs185462709    1720487    T        SEX     3145      11.18        49.95            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.assoc.linear | head -n 1546 | tail -n 10
   1      rs12041925    1707740    G        AGE     3142      -0.23       -16.31    1.835e-57
   1     rs116018620    1709119    T        ADD     3145      2.192        1.908      0.05648
   1     rs116018620    1709119    T        SEX     3145      11.18        49.94            0
   1     rs116018620    1709119    T        AGE     3145    -0.2284       -16.18    1.287e-56
   1      rs77787690    1712428    C        ADD     3144    -0.5953       -0.654       0.5132
   1      rs77787690    1712428    C        SEX     3144      11.18        49.95            0
   1      rs77787690    1712428    C        AGE     3144    -0.2295       -16.25    4.605e-57
   1     rs185462709    1720487    T        ADD     3145     0.4056       0.2885       0.7729
   1     rs185462709    1720487    T        SEX     3145      11.18        49.95            0
   1     rs185462709    1720487    T        AGE     3145    -0.2289       -16.21    7.842e-57
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.temp1.assoc.linear | tail -n 10
  23        rs601290  154865915    A        SEX     3140      11.26         47.4            0
  23        rs473491  154899846    G        ADD     3132    -0.3918       -1.156       0.2479
  23        rs473491  154899846    G        AGE     3132    -0.2273       -16.07    6.487e-56
  23        rs473491  154899846    G        SEX     3132       11.2         49.8            0
  23     rs150522543  154900890    T        ADD     3135     0.6303       0.1423       0.8869
  23     rs150522543  154900890    T        AGE     3135    -0.2284       -16.14    2.266e-56
  23     rs150522543  154900890    T        SEX     3135      11.17        49.84            0
  23     rs111332691  154923374    A        ADD     3139    -0.1312      -0.0513       0.9591
  23     rs111332691  154923374    A        AGE     3139     -0.227       -16.08    5.338e-56
  23     rs111332691  154923374    A        SEX     3139      11.19        50.05            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Height.assoc.linear | tail -n 10
  23        rs473491  154899846    G        AGE     3132         NA           NA           NA
  23        rs473491  154899846    G        SEX     3132         NA           NA           NA
  23     rs150522543  154900890    T        ADD     3135         NA           NA           NA
  23     rs150522543  154900890    T        SEX     3135         NA           NA           NA
  23     rs150522543  154900890    T        AGE     3135         NA           NA           NA
  23     rs150522543  154900890    T        SEX     3135         NA           NA           NA
  23     rs111332691  154923374    A        ADD     3139         NA           NA           NA
  23     rs111332691  154923374    A        SEX     3139         NA           NA           NA
  23     rs111332691  154923374    A        AGE     3139         NA           NA           NA
  23     rs111332691  154923374    A        SEX     3139         NA           NA           NA
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.temp1.assoc.linear | tail -n 10
   1     rs150352847  249211879    A        SEX     3144         NA           NA           NA
   1      rs41308182  249212878    G        ADD     3108     -2.337       -2.102      0.03567
   1      rs41308182  249212878    G        AGE     3108    -0.2321       -16.34    1.142e-57
   1      rs41308182  249212878    G        SEX     3108      11.16        49.66            0
   1      rs74322946  249218540    A        ADD     3144     0.2623       0.1107       0.9119
   1      rs74322946  249218540    A        AGE     3144    -0.2295       -16.25    4.566e-57
   1      rs74322946  249218540    A        SEX     3144      11.17        49.89            0
   1     rs114152372  249222527    G        ADD     3112      1.903         1.09       0.2757
   1     rs114152372  249222527    G        AGE     3112    -0.2306       -16.23    6.133e-57
   1     rs114152372  249222527    G        SEX     3112      11.19        49.61            0
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr1_v2.African.Height.assoc.linear | tail -n 10
   1     rs150352847  249211879    A        AGE     3144         NA           NA           NA
   1      rs41308182  249212878    G        ADD     3108     -2.337       -2.102      0.03567
   1      rs41308182  249212878    G        SEX     3108      11.16        49.66            0
   1      rs41308182  249212878    G        AGE     3108    -0.2321       -16.34    1.142e-57
   1      rs74322946  249218540    A        ADD     3144     0.2623       0.1107       0.9119
   1      rs74322946  249218540    A        SEX     3144      11.17        49.89            0
   1      rs74322946  249218540    A        AGE     3144    -0.2295       -16.25    4.566e-57
   1     rs114152372  249222527    G        ADD     3112      1.903         1.09       0.2757
   1     rs114152372  249222527    G        SEX     3112      11.19        49.61            0
   1     rs114152372  249222527    G        AGE     3112    -0.2306       -16.23    6.133e-57
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for pheno1 in `echo "Height BMI Waist Hip"`; do
> #for pheno1 in `echo "Height"`; do
> #for pheno1 in `echo "BMI Waist Hip"`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
> 
>                 echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
>                 for i in {1..22} X; do
> 
>                         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 done
> 
>                 cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped | sort -g -k 1,1 -k 4,4 | uniq | grep -v NSIG | grep -v ^$ | cat <(echo " CHR    F           SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1
>                 mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>         done
> done
Height African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr19_v2.African.Height.ADD.assoc.linear.clumped: No such file or directory
Height Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped
Height British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.Height.ADD.assoc.linear.clumped: No such file or directory
Height Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr22_v2.Caribbean.Height.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.Height.ADD.assoc.linear.clumped: No such file or directory
Height Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.Height.ADD.assoc.linear.clumped: No such file or directory
Height Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.Height.ADD.assoc.linear.clumped: No such file or directory
BMI African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.BMI.ADD.assoc.linear.clumped: No such file or directory
BMI Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.BMI.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.BMI.ADD.assoc.linear.clumped: No such file or directory
Waist African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr13_v2.African.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr22_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr14_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr20_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.Waist.ADD.assoc.linear.clumped: No such file or directory
Hip African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrX_v2.Any_other_white_background.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrX_v2.British.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrX_v2.British.Ran10000.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrX_v2.British.Ran100000.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrX_v2.British.Ran200000.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrX_v2.Caribbean.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrX_v2.Indian.Hip.ADD.assoc.linear.clumped: No such file or directory
Hip Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.Hip.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrX_v2.Irish.Hip.ADD.assoc.linear.clumped: No such file or directory
...
Height British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr21_v2.British.Ran4000.Height.ADD.assoc.linear.clumped: No such file or directory
BMI British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.BMI.ADD.assoc.linear.clumped
Waist British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Waist.ADD.assoc.linear.clumped
Hip British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Hip.ADD.assoc.linear.clumped
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
   7002   84024 1049612
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
     81     972   11021
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
    149    1788   24644
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
   2057   24684  354566
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
   4847   58164  771603
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
    131    1572   13800
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
    154    1848   16587
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
   1352   16224  185798
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc
    240    2880   37655
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped | wc
  31630  379560 3982400
#From later in the day:
#[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear.clumped | wc
#     78     912   12923
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   6       rs2256175   31380449    C        ADD    15725      1.283        17.41    3.027e-67
   6       rs2596531   31387557    C        ADD    15709      1.238        16.19    1.702e-58
   6       rs2596530   31387373    G        ADD    15705      1.232        16.11    6.487e-58
   6       rs2256183   31380529    A        ADD    15561      1.238        16.03    2.217e-57
   6   Affx-28452229   31322303    G        ADD    15734     -1.186       -15.97    5.878e-57
   6      rs67841474   31380160   TG        ADD    14926      1.221        15.84    4.814e-56
   6        rs537160   31916400    A        ADD    15691      1.313        15.55    3.754e-54
   6       rs2844513   31388214    A        ADD    15678     -1.095       -14.64    3.043e-48
   6       rs2844514   31380340    T        ADD    15687     -1.096       -14.64    3.178e-48
   6        rs630379   31922254    A        ADD    15694      1.292        14.62    4.416e-48
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   6      rs41271299   19839415    T        ADD   428962     0.8564        27.51   2.065e-166
   6       rs6570507  142679572    A        ADD   429196    -0.3922       -25.77   2.486e-146
   6       rs7776375  142777064    G        ADD   428707    -0.3858       -25.35   1.211e-141
   6       rs3748069  142767633    G        ADD   425265    -0.3844       -25.22   3.393e-140
   6       rs7763064  142797289    A        ADD   428723    -0.3769       -24.98   1.416e-137
   6       rs7742369   34165721    G        ADD   429011     0.4481         24.8   1.104e-135
   6       rs7766641   26184102    A        ADD   421986    -0.3948       -24.69   1.649e-134
   6        rs806794   26200677    G        ADD   429099    -0.3813       -24.68   2.118e-134
   6        rs262121  142839498    C        ADD   428622    -0.3703       -24.48   3.265e-132
   6       rs2050157  142658162    A        ADD   382230    -0.3941       -24.45   6.076e-132
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | if ($9 < 5e-8) { print $0 } } ' | wc
bash: syntax error near unexpected token `{'
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-8) { print $0 } } ' | wc
   4077   36693  383504
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-8) { print $0 } } ' | wc
   2768   24912  260433
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-2) { print $0 } } ' | wc
  22485  202365 2113841
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-2) { print $0 } } ' | wc
  17949  161541 1687475
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-4) { print $0 } } ' | wc
   9158   82422  861093
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ if ($9 < 5e-4) { print $0 } } ' | wc
   7948   71532  747380
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
             0              0              7            180           1312 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
           366            471            629            884           1259 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
          1972           3305           5625          10462          25932 
> 
> 
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
            33             22            116            634           2309 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
           299            360            464            539            775 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
          1138           1969           3833           9348          31759 
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped | awk '{ print $6 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));

     (0,10]     (10,25]     (25,50]    (50,100]   (100,250]   (250,500] 
       1455         195          46          26          16           4 
(500,1e+03] 
          0 
> 
> 
[  mturchin@node410  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $6 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,10,25,50,100,250,500,1000)));

     (0,10]     (10,25]     (25,50]    (50,100]   (100,250]   (250,500] 
        153          41          21          25          14           4 
(500,1e+03] 
          1 
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print
 $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
             3             65            514           5034          45825
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
             0              0              0              0              0 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
             0              0              0              0              4 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
            39            208            823           5655          45223 
> 
> 
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10] 
             0              0              0             19            252 
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05] 
            67            112            215            312            518 
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1] 
           644            970           2343           7783          39969 
> 
> 
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.Height.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              1             20            123           1143
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
           288            281            310            384            610
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           779           1211           2884           8626          36800
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr6_v2.Any_other_white_background.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
            20            153            804           5784          45642
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chr6_v2.British.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0             17            237
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
           135            217            269            370            532
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           856           1291           2679           8657          38338
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr6_v2.British.Ran4000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
             5             71            509           4393          46463
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chr6_v2.British.Ran10000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              0
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             0              0              0              0              1
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
             7             64            524           4598          46758
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chr6_v2.British.Ran100000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0              5
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
             5              5              2             10             22
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           102            333           1505           6914          44301
>
>
[  mturchin@node421  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chr6_v2.British.Ran200000.BMI.assoc.linear | grep ADD | grep -v NA | awk '{ print $9 }' | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,1], c(0,1e-100,1e-75,1e-50,1e-25,1e-10,1e-9,1e-8,1e-7,1e-6,1e-5,1e-4,1e-3,1e-2,.1,1)));

    (0,1e-100] (1e-100,1e-75]  (1e-75,1e-50]  (1e-50,1e-25]  (1e-25,1e-10]
             0              0              0              0             25
 (1e-10,1e-09]  (1e-09,1e-08]  (1e-08,1e-07]  (1e-07,1e-06]  (1e-06,1e-05]
            12             16             48            102            168
(1e-05,0.0001] (0.0001,0.001]   (0.001,0.01]     (0.01,0.1]        (0.1,1]
           375            820           2198           7787          41909
>
>
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   2       rs7570971  135837906    C        ADD     3968      1.736        12.55    1.862e-35
  15       rs1129038   28356859    C        ADD     3983     -1.881       -12.35    2.071e-34
   2       rs4988235  136608646    A        ADD     3600      1.763         12.3    4.103e-34
   2       rs1446585  136407479    G        ADD     3978     -1.706       -12.29    4.238e-34
  15      rs12913832   28365618    A        ADD     3963     -1.874       -12.23    8.423e-34
   2       rs6754311  136707982    T        ADD     3617      1.699        11.84    9.586e-32
   2      rs12465802  136381348    G        ADD     3617      1.689        11.72    3.487e-31
   2       rs6730157  135907088    A        ADD     3601      1.681        11.62    1.174e-30
   2        rs309125  136643555    T        ADD     3975     -1.655       -11.52    3.077e-30
   2       rs6716536  136787402    T        ADD     3968     -1.648       -11.47    5.687e-30
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr*_v2.British.Ran4000.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   1      rs33998267  235993709    A        ADD     3873      2.769        5.504    3.949e-08
   7        rs849141   28185091    A        ADD     3869     0.7921        5.037     4.95e-07
   7        rs520161   28210660    T        ADD     3873     0.7809        5.004    5.874e-07
  20       rs2876163    9174693    A        ADD     3862      -1.18       -4.905    9.711e-07
   7       rs1708299   28189946    A        ADD     3878     0.7583        4.872     1.15e-06
   7       rs6944291    2745394    C        ADD     3869    -0.7003       -4.833    1.399e-06
  23      rs10284225   33254938    C        ADD     3877      1.976        4.761        2e-06
   7      rs10257934    2749790    G        ADD     3871    -0.7565        -4.72    2.438e-06
  17       rs2003549   62008437    T        ADD     3872     0.7768         4.68    2.964e-06
   8       rs1460590  113005023    T        ADD     3874    -0.6738       -4.668    3.146e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | wc
   3954   59310  486180
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | wc
   3955   47459  620900
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | head -n 10
1000329 1000329 1 Any_other_white_background 42 0.0099 -0.0075 -0.0031 0.0119 0.0001 -0.0020 -0.0008 0.0291 -0.0133 -0.0005
1000648 1000648 1 Any_other_white_background 58 0.0122 0.0222 0.0367 -0.0830 -0.0013 -0.0199 0.0121 -0.0093 -0.0012 0.0103
1002391 1002391 1 Any_other_white_background 61 -0.0050 -0.0059 -0.0139 -0.0049 0.0130 0.0127 -0.0138 -0.0151 0.0190 0.0433
1006367 1006367 0 Any_other_white_background 64 0.0072 -0.0129 -0.0010 0.0059 -0.0038 -0.0284 -0.0084 -0.0036 0.0079 0.0034
1007157 1007157 0 Any_other_white_background 51 -0.0066 0.0004 -0.0023 0.0098 0.0144 -0.0123 0.0154 -0.0109 0.0061 0.0082
1007351 1007351 0 Any_other_white_background 67 0.0105 -0.0033 -0.0018 0.0188 0.0229 0.0271 0.0030 0.0081 0.0035 0.0060
1007717 1007717 0 Any_other_white_background 40 0.0152 -0.0185 0.0219 -0.0142 -0.0013 0.0091 0.0073 0.0216 -0.0129 -0.0072
1007811 1007811 1 Any_other_white_background 53 0.0121 -0.0233 0.0049 0.0014 0.0246 -0.0114 -0.0061 0.0036 0.0106 -0.0161
1007941 1007941 0 Any_other_white_background 69 0.0020 -0.0014 -0.0134 0.0038 0.0322 -0.0342 -0.0027 0.0083 -0.0086 0.0046
1008510 1008510 0 Any_other_white_background 45 -0.0086 0.0074 -0.0058 -0.0094 -0.0099 0.0087 -0.0058 0.0065 -0.0174 -0.0047
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID     IID     SEX     ANCESTRY        AGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - | head -n 10
FID     IID     SEX     ANCESTRY        AGE     PC1     PC2     PC3     PC4     PC5     PC6     PC7     PC8     PC9     PC10
1000329 1000329 1 Any_other_white_background 42 0.0099 -0.0075 -0.0031 0.0119 0.0001 -0.0020 -0.0008 0.0291 -0.0133 -0.0005
1000648 1000648 1 Any_other_white_background 58 0.0122 0.0222 0.0367 -0.0830 -0.0013 -0.0199 0.0121 -0.0093 -0.0012 0.0103
1002391 1002391 1 Any_other_white_background 61 -0.0050 -0.0059 -0.0139 -0.0049 0.0130 0.0127 -0.0138 -0.0151 0.0190 0.0433
1006367 1006367 0 Any_other_white_background 64 0.0072 -0.0129 -0.0010 0.0059 -0.0038 -0.0284 -0.0084 -0.0036 0.0079 0.0034
1007157 1007157 0 Any_other_white_background 51 -0.0066 0.0004 -0.0023 0.0098 0.0144 -0.0123 0.0154 -0.0109 0.0061 0.0082
1007351 1007351 0 Any_other_white_background 67 0.0105 -0.0033 -0.0018 0.0188 0.0229 0.0271 0.0030 0.0081 0.0035 0.0060
1007717 1007717 0 Any_other_white_background 40 0.0152 -0.0185 0.0219 -0.0142 -0.0013 0.0091 0.0073 0.0216 -0.0129 -0.0072
1007811 1007811 1 Any_other_white_background 53 0.0121 -0.0233 0.0049 0.0014 0.0246 -0.0114 -0.0061 0.0036 0.0106 -0.0161
1007941 1007941 0 Any_other_white_background 69 0.0020 -0.0014 -0.0134 0.0038 0.0322 -0.0342 -0.0027 0.0083 -0.0086 0.0046
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb9200.2017_8_WinterRetreat.Covars.txt | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | sed 's/:/ /g' | awk '{ print $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11 "\t" $12 }' | sort -k 1,1) | cat <(echo -e "FID\tIID\tSEX\tANCESTRY\tAGE\tPC1\tPC2\tPC3\tPC4\tPC5\tPC6\tPC7\tPC8\tPC9\tPC10") - | head -n 10  
FID     IID     SEX     ANCESTRY        AGE     PC1     PC2     PC3     PC4     PC5     PC6     PC7     PC8     PC9     PC10
1000329 1000329 1 Any_other_white_background 42 0.0099 -0.0075 -0.0031 0.0119 0.0001 -0.0020 -0.0008 0.0291 -0.0133 -0.0005
1000648 1000648 1 Any_other_white_background 58 0.0122 0.0222 0.0367 -0.0830 -0.0013 -0.0199 0.0121 -0.0093 -0.0012 0.0103
1002391 1002391 1 Any_other_white_background 61 -0.0050 -0.0059 -0.0139 -0.0049 0.0130 0.0127 -0.0138 -0.0151 0.0190 0.0433
1006367 1006367 0 Any_other_white_background 64 0.0072 -0.0129 -0.0010 0.0059 -0.0038 -0.0284 -0.0084 -0.0036 0.0079 0.0034
1007157 1007157 0 Any_other_white_background 51 -0.0066 0.0004 -0.0023 0.0098 0.0144 -0.0123 0.0154 -0.0109 0.0061 0.0082
1007351 1007351 0 Any_other_white_background 67 0.0105 -0.0033 -0.0018 0.0188 0.0229 0.0271 0.0030 0.0081 0.0035 0.0060
1007717 1007717 0 Any_other_white_background 40 0.0152 -0.0185 0.0219 -0.0142 -0.0013 0.0091 0.0073 0.0216 -0.0129 -0.0072
1007811 1007811 1 Any_other_white_background 53 0.0121 -0.0233 0.0049 0.0014 0.0246 -0.0114 -0.0061 0.0036 0.0106 -0.0161
1007941 1007941 0 Any_other_white_background 69 0.0020 -0.0014 -0.0134 0.0038 0.0322 -0.0342 -0.0027 0.0083 -0.0086 0.0046
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | grep 1000329
     1000329:1000329     0.0099     -0.0075     -0.0031      0.0119      0.0001     -0.0020     -0.0008      0.0291     -0.0133     -0.0005          Control
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.smartpca.Ran100k.Results.pca | grep 1000648
     1000648:1000648     0.0122      0.0222      0.0367     -0.0830     -0.0013     -0.0199      0.0121     -0.0093     -0.0012      0.0103          Control
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background.Ran4000/ukb_chrAll_v2.Any_other_white_background.Ran4000.Height.w10PCs.ADD.assoc.linear | grep -v NA | sort -g -k 9,9 | head -n 10
 CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P
   2      rs10184951  128897703    C        ADD     3570     0.7349        4.841    1.349e-06
   2      rs10184951  128897703    C        ADD     3570     0.7349        4.841    1.349e-06
  12     rs117743355   93986948    A        ADD     3935      3.395        4.706    2.607e-06
  12     rs117743355   93986948    A        ADD     3935      3.395        4.706    2.607e-06
  12     rs117941140   74245886    A        ADD     3935     -2.342       -4.705    2.632e-06
  12     rs117941140   74245886    A        ADD     3935     -2.342       -4.705    2.632e-06
   6      rs12198986    7720059    A        ADD     3935     0.6566        4.618        4e-06
   6      rs12198986    7720059    A        ADD     3935     0.6566        4.618        4e-06
  20      rs73125296   40351173    T        ADD     3927      1.274        4.609     4.17e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr*_v2.Any_other_white_background.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
  15     rs1129038   28356859    C        ADD    15730     -1.764       -23.02   2.359e-115
  15    rs12913832   28365618    A        ADD    15660     -1.749       -22.72   1.968e-112
   2       rs7570971  135837906    C        ADD    15680      1.548        22.16   3.487e-107
   2       rs4988235  136608646    A        ADD    14154      1.587        21.66   2.218e-102
   2       rs1446585  136407479    G        ADD    15711     -1.508        -21.5   4.455e-101
   2      rs12465802  136381348    G        ADD    14211      1.561         21.3    4.007e-99
   2       rs6754311  136707982    T        ADD    14214      1.555        21.29    4.652e-99
   2       rs6730157  135907088    A        ADD    14167      1.544        21.01    1.423e-96
   2       rs6716536  136787402    T        ADD    15687     -1.453       -20.11    8.381e-89
   2       rs4452212  137015991    A        ADD    15700      1.452         20.1    9.679e-89
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr*_v2.British.Ran4000.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   1      rs33998267  235993709    A        ADD     3873      2.769        5.504    3.949e-08
   7        rs849141   28185091    A        ADD     3869     0.7921        5.037     4.95e-07
   7        rs520161   28210660    T        ADD     3873     0.7809        5.004    5.874e-07
  20       rs2876163    9174693    A        ADD     3862      -1.18       -4.905    9.711e-07
   7       rs1708299   28189946    A        ADD     3878     0.7583        4.872     1.15e-06
   7       rs6944291    2745394    C        ADD     3869    -0.7003       -4.833    1.399e-06
  23      rs10284225   33254938    C        ADD     3877      1.976        4.761        2e-06
   7      rs10257934    2749790    G        ADD     3871    -0.7565        -4.72    2.438e-06
  17       rs2003549   62008437    T        ADD     3872     0.7768         4.68    2.964e-06
   8       rs1460590  113005023    T        ADD     3874    -0.6738       -4.668    3.146e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr*_v2.African.Height.ADD.assoc.linear | grep ADD | grep -v NA | sort -g -k 9,9 | head -n 10
   4     rs115499719   85673984    G        ADD     3123      7.022        5.731    1.096e-08
   4      rs76512887   45839725    G        ADD     3145      6.918        5.064    4.332e-07
  14    rs77258689   29383787    T        ADD     3143      12.77        5.008    5.792e-07
   2     rs114846158   22672732    A        ADD     3119      8.912         4.94    8.225e-07
   7      rs73112189   46268024    A        ADD     3144      21.43        4.854    1.269e-06
   7        rs740091    9124433    A        ADD     3144       1.17        4.836    1.387e-06
   4     rs114447473  165302850    G        ADD     3143      13.49        4.822    1.491e-06
  14    rs74815549   95350999    G        ADD     3139     0.8471        4.788    1.766e-06
   5      rs72705201    1016654    T        ADD     3028      5.069        4.658    3.332e-06
   1      rs11805978  240251226    C        ADD     3140     -0.827       -4.627    3.862e-06
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | wc
   7002   84024 1049612
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | wc
     81     972   11021
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | wc
    149    1788   24644
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | wc
   2057   24684  354566
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | wc
   4847   58164  771603
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | wc
    131    1572   13800
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | wc
    154    1848   16587
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | wc
   1352   16224  185798
[  mturchin@node418  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | wc
    240    2880   37655
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      5       5      44
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
     20      20     206
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
    654     654    6879
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
   1779    1779   18899
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      2       2      14
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      3       3      24
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
     26      26     269
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
     24      24     244
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g)  <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped | awk '{ print $3 }' | sort -g) | wc
      1       1       4
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped | awk '{ print $1 "\t" $4 "\t" $4 "\t" $3 }' | grep -v CHR | head -n 10
1       958905  958905  rs2710890
1       987200  987200  rs9803031
1       1301388 1301388 rs71628956
1       1490161 1490161 rs3753332
1       1585642 1585642 rs3936009
1       1905790 1905790 rs16824603
1       1983421 1983421 rs4648795
1       2060058 2060058 rs28719902
1       2113565 2113565 rs262688
1       2127674 2127674 rs115785083
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat <(paste <(echo "Brit.Ran4k") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped.bed -b /users/mtur...
Brit.Ran4k      80      4       15      34      46      50
Brit.Ran10k     148     19      31      57      78      80
Brit.Ran100k    2056    653     824     1040    1161    1182
Brit.Ran200k    4846    1778    2028    2408    2626    2667
African 130     1       8       21      46      55
Caribbean       153     2       9       24      56      67
Indian  1351    25      123     302     584     696
Irish   239     23      57      95      123     136
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(echo "Afr_v_Caribbean") <(cat /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed | wc | awk '{ print $1 }') <(intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped.bed -b /users/mturchin/data/ukbio...
Afr_v_Caribbean 153     0       0       1       7       12
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps      
Height                                                                                                                                                                                                                         
                                                                                                                                                                                                                               British.Ran4000 80      4       15      34      46      50                                                                                                                                                                     British.Ran10000        148     19      31      57      78      80                                                                                                                                                             British.Ran100000       2056    653     824     1040    1161    1182                                                                                                                                                           British.Ran200000       4846    1778    2028    2408    2626    2667                                                                                                                                                           African 130     1       8       21      46      55                                                                                                                                                                             Caribbean       153     2       9       24      56      67                                                                                                                                                                     Indian  1351    25      123     302     584     696                                                                                                                                                                            Irish   239     23      57      95      123     136                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          BMI                                                                                                                                                                                                                             
British.Ran4000 168     1       9       24      74      108
British.Ran10000        162     2       15      34      86      115
British.Ran100000       565     194     246     336     457     496
British.Ran200000       1386    722     810     1025    1242    1305
African 1946    22      77      268     875     1283
Caribbean       266     2       9       38      123     176
Indian  250     3       13      36      105     157
Irish   190     5       21      49      105     135


#Waist
#
#British.Ran4000 103     2       6       13      41      55
#British.Ran10000        108     1       8       18      40      61
#British.Ran100000       425     148     176     238     320     352
#British.Ran200000       1020    516     585     713     882     934
#African 113     0       6       13      40      60
#Caribbean       119     0       3       11      47      67
#Indian  183     0       7       23      77      103
#Irish   135     2       11      23      56      84
#
#
#Hip
#
#British.Ran4000 190     1       9       27      81      114
#British.Ran10000        172     2       8       25      65      106
#British.Ran100000       552     175     224     307     432     477
#British.Ran200000       1167    592     683     851     1028    1078
#African 358     1       10      30      124     198
#Caribbean       173     0       5       28      72      113
#Indian  278     0       7       36      102     151
#Irish   172     1       10      35      84      112
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | head -n 10
  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
1       Affx-10000328   39542062        G       ADD     3877    -0.1765 -0.3424 0.7321
1       Affx-10047176   39917888        A       ADD     3877    0.1098  0.3073  0.7586
1       Affx-10071327   40092089        T       ADD     423     -2.211  -1.273  0.2038
1       Affx-10080353   40160585        A       ADD     3875    0.09407 0.4949  0.6207
1       Affx-10096385   40773149        C       ADD     3853    -0.1205 -0.6912 0.4895
1       Affx-10134350   41256213        G       ADD     3722    -0.1502 -0.6808 0.4961
1       Affx-10349342   43131653        A       ADD     3872    0.04474 0.2001  0.8414
1       Affx-10384750   43394887        A       ADD     3880    21.3    3.385   0.0007193
1       Affx-10384852   43395635        T       ADD     3865    0.1908  1.054   0.292
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 5e-4) { print join("\t", @F); }' | grep -v NA | wc
    485    4365   27439
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 5e-4) { print join("\t", @F); }' | grep -v NA | head -n 10
CHR     SNP     BP      A1      TEST    NMISS   BETA    STAT    P
1       Affx-80210901   20645219        A       ADD     3881    -24.39  -3.88   0.000106
1       Affx-92044118   17350516        C       ADD     3425    16.27   4.463   8.337e-06
1       rs10888315      248348194       G       ADD     3870    -0.5247 -3.506  0.0004596
1       rs113592356     1004331 T       ADD     3879    -1.172  -3.54   0.0004053
1       rs114257724     245336818       A       ADD     3877    2.496   3.679   0.0002376
1       rs114383419     24844069        T       ADD     3875    1.345   3.548   0.0003925
1       rs114479443     220769097       A       ADD     3877    -2.863  -3.645  0.0002708
1       rs11572510      217093153       C       ADD     3877    0.9267  3.895   9.976e-05
1       rs12088804      231436654       G       ADD     3873    1.853   3.788   0.0001542
(MultiEthnicGWAS) [  mturchin@login002  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | perl -lane 'if ($F[8] < 5e-4) { print join("\t", @F); }' | grep -v NA | sort -g -k 9,9 | head -n 10
CHR     SNP     BP      A1      TEST    NMISS   BETA    STAT    P
1       rs33998267      235993709       A       ADD     3873    2.769   5.504   3.949e-08
7       rs849141        28185091        A       ADD     3869    0.7921  5.037   4.95e-07
7       rs520161        28210660        T       ADD     3873    0.7809  5.004   5.874e-07
20      rs2876163       9174693 A       ADD     3862    -1.18   -4.905  9.711e-07
7       rs1708299       28189946        A       ADD     3878    0.7583  4.872   1.15e-06
7       rs6944291       2745394 C       ADD     3869    -0.7003 -4.833  1.399e-06
23      rs10284225      33254938        C       ADD     3877    1.976   4.761   2e-06
7       rs10257934      2749790 G       ADD     3871    -0.7565 -4.72   2.438e-06
17      rs2003549       62008437        T       ADD     3872    0.7768  4.68    2.964e-06
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(-log10(2*pnorm(abs(Data1\$betahat) / Data1\$sebetahat, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100))); table(cut(-log10(2*pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(-log10(2*pnorm(abs(Data1$betahat) / Data1$sebetahat, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100))); table(cut(-log10(2*pnorm(abs(Data1$PosteriorMean) / Data1$PosteriorSD, lower.tail=FALSE)), c(0,1,2,3,4,5,7,10,50,100)));

   (0,1]    (1,2]    (2,3]    (3,4]    (4,5]    (5,7]   (7,10]  (10,50] 
  661051    73259     8392     1224      210       82       16        0 
(50,100] 
       0 

   (0,1]    (1,2]    (2,3]    (3,4]    (4,5]    (5,7]   (7,10]  (10,50] 
  744109       63       23       11        7       10        4        7 
(50,100] 
       0 
> 
> 
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | R -q -e "Data1 <- read.table(file('stdin'), header=T); nrow(Data1[Data1\$PosteriorMean > Data1\$betahat,]); nrow(Data1[Data1\$PosteriorMean < Data1\$betahat,]); quantile(Data1\$PosteriorMean - Data1\$betahat, na.rm=TRUE);"
> Data1 <- read.table(file('stdin'), header=T); nrow(Data1[Data1$PosteriorMean > Data1$betahat,]); nrow(Data1[Data1$PosteriorMean < Data1$betahat,]); quantile(Data1$PosteriorMean - Data1$betahat, na.rm=TRUE);
[1] 430970
[1] 430984
           0%           25%           50%           75%          100% 
-2.691896e+01 -1.306974e-01 -2.127500e-06  1.305210e-01  2.425907e+01 
> 
> 
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | head -n 10
betahat sebetahat NegativeProb PositiveProb lfsr svalue lfdr qvalue PosteriorMean PosteriorSD
-0.2082 0.316310029612608 0.105064286700532 0.0774547708043533 0.894935713299468 0.747663534110751 0.817480942495115 0.797407434449884 -0.00289189233121574 0.0377938777536834
0.1906 0.222664595664309 0.066774711492263 0.115523212765579 0.884476787234421 0.700512727823062 0.817702075742158 0.797725923595555 0.00495449881520096 0.0372661174930877
-1.565 1.07461529486516 0.102830329008621 0.083788459776858 0.897169670991379 0.757427682006018 0.813381211214521 0.777695586667837 -0.00209183974882314 0.0395811913370459
0.2518 0.12228974699646 0.0275003353290735 0.252669002900265 0.747330997099735 0.233725064870417 0.719830661770662 0.628050238122853 0.0238036679540263 0.0519451640836735
-0.2304 0.109768394051956 0.277762933447017 0.023915071587609 0.722237066552983 0.197095225951551 0.698321994965374 0.599802177625683 -0.0265434060428938 0.0526208122095322
-0.2355 0.141252819555472 0.186426262701283 0.0380014707510792 0.813573737298717 0.395055165273512 0.775572266547638 0.705604776144254 -0.0151292319430873 0.0441418788613381
-0.1436 0.142120848755308 0.131968498892898 0.0510019752865797 0.868031501107102 0.622233380612944 0.817029525820523 0.796729843639772 -0.00778016863799267 0.0359848364074816
5.143 2.5953303821511 0.0877639081155271 0.0985227722202341 0.901477227779766 0.775968069694097 0.813713319664239 0.77912838655189 0.00118432777635476 0.0394798518318744
0.1544 0.114788869723054 0.0373973294106912 0.167123037335538 0.832876962664462 0.466403262476629 0.795479633253771 0.738488592591379 0.0123649327126391 0.0386105814672203
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.gz | head -n 10
  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
1       Affx-10000328   39542062        G       ADD     9684    -0.2082 -0.6583 0.5104
1       Affx-10047176   39917888        A       ADD     9684    0.1906  0.8561  0.392
1       Affx-10071327   40092089        T       ADD     1026    -1.565  -1.457  0.1453
1       Affx-10080353   40160585        A       ADD     9673    0.2518  2.059   0.03949
1       Affx-10096385   40773149        C       ADD     9615    -0.2304 -2.099  0.03582
1       Affx-10134350   41256213        G       ADD     9301    -0.2355 -1.667  0.09547
1       Affx-10349342   43131653        A       ADD     9670    -0.1436 -1.011  0.3123
1       Affx-10384750   43394887        A       ADD     9682    5.143   1.982   0.04752
1       Affx-10384852   43395635        T       ADD     9667    0.1544  1.345   0.1786
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.ashr.results.gz | head -n 19521 | tail -n 10
0.08758 0.165600321623496 0.0672670326399303 0.104178532320824 0.895821467679176 0.751571922312223 0.828554435039246 0.804844923833426 0.00355552034870258 0.0340498867233755
-0.2891 0.383888595105383 0.105354011073783 0.0788017481589557 0.894645988926217 0.746424715314987 0.815844240767261 0.794819823987724 -0.00282558212937117 0.0384572134795336
0.1025 0.16277952668542 0.0641601018135876 0.108855806750366 0.891144193249634 0.73097077832829 0.826984091436046 0.804302555229489 0.00430769098664402 0.0343577294845964
0.09289 0.0973722710409669 0.0404321022007422 0.132003633221478 0.867996366778522 0.622062669024447 0.82756426457778 0.804507714811594 0.00818239321218696 0.032587121304695
0.02967 0.0998256817502583 0.0597059437980346 0.0856378814141029 0.914362118585897 0.814252922687644 0.854656174787862 0.811739217499798 0.00225027274399547 0.0278592547976394
0.01992 0.197349661918707 0.082913585299225 0.0890796301545312 0.910920369845469 0.810990204456393 0.828006784546244 0.804659889666877 0.000605813030757792 0.0344369315134422
-0.3059 0.131694613084285 0.281215592071058 0.0259524875976148 0.718784407928942 0.192726301206359 0.692831920331328 0.592724996545808 -0.0287954321717079 0.0593170828049442
0.08057 0.0928041557057301 0.040904737396607 0.123937465832624 0.876062534167376 0.660726985310266 0.835157796770769 0.806745392913748 0.00728845977832374 0.0311459763991494
-0.1626 0.130507749759064 0.15228529868248 0.0433243094032559 0.84771470131752 0.528928847390138 0.804390391914264 0.755553135518811 -0.010509126571141 0.0379416219107211
-0.1354 0.117579152697003 0.147510048553087 0.0420069406210059 0.852489951446913 0.550287588635299 0.810483010825907 0.769300128481467 -0.0099249726881557 0.0362666162529511
[  mturchin@node519  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.gz | head -n 19521 | tail -n 10
1       rs1229387       167610200       A       ADD     9460    0.08758 0.5289  0.5969
1       rs1229395       167603062       C       ADD     9684    -0.2891 -0.7532 0.4514
1       rs1229401       167591280       G       ADD     9676    0.1025  0.6297  0.5289
1       rs1230673       114194513       G       ADD     9675    0.09289 0.9541  0.3401
1       rs1231762       192843391       C       ADD     9647    0.02967 0.2973  0.7663
1       rs1231768       192810565       T       ADD     9677    0.01992 0.101   0.9196
1       rs1231988       96990811        T       ADD     8935    -0.3059 -2.323  0.02019
1       rs1233789       197938330       C       ADD     9668    0.08057 0.8683  0.3853
1       rs1233830       198040978       T       ADD     9673    -0.1626 -1.246  0.2128
1       rs1233839       198034569       C       ADD     9418    -0.1354 -1.152  0.2495
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$for pheno1 in `echo "Height BMI Waist Hip"`; do
> #for pheno1 in `echo "Height"`; do
> #for pheno1 in `echo "BMI Waist Hip"`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
> 
>                 echo $pheno1 $ancestry1 $ancestry2 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.gz
>                 rm -f /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.gz
>                 for i in {1..22} X; do
> 
>                         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | perl -lane 'if ($#F == 8) { print join("\t", @F); }' >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
>                         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chr${i}_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped >> /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>                 done
> 
>                 cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear | sort -g -k 1,1 -k 4,4 | uniq | grep -v BETA | grep -v ^$ | cat <(echo "  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P ") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1
>                 mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
>                 cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped | sort -g -k 1,1 -k 4,4 | uniq | grep -v NSIG | grep -v ^$ | cat <(echo " CHR    F           SNP         BP        P    TOTAL   NSIG    S05    S01   S001  S0001    SP2") - > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1
>                 mv /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped.temp1 /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
>                 gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear
>                 gzip /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/ukb_chrAll_v2.${ancestry2}.${pheno1}.ADD.assoc.linear.clumped
> 
>         done
> done
Height African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr19_v2.African.Height.ADD.assoc.linear.clumped: No such file or directory
Height Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Height.ADD.assoc.linear.clumped
Height British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.clumped
Height British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chr21_v2.British.Ran4000.Height.ADD.assoc.linear.clumped: No such file or directory
Height British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Height.ADD.assoc.linear.clumped
Height British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Height.ADD.assoc.linear.clumped
Height British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Height.ADD.assoc.linear.clumped
Height Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Height.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr22_v2.Caribbean.Height.ADD.assoc.linear.clumped: No such file or directory
Height Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Height.ADD.assoc.linear.clumped
Height Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Height.ADD.assoc.linear.clumped
BMI African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.BMI.ADD.assoc.linear.clumped
BMI Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.BMI.ADD.assoc.linear.clumped
BMI British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.BMI.ADD.assoc.linear.clumped
BMI British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.BMI.ADD.assoc.linear.clumped
BMI British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.BMI.ADD.assoc.linear.clumped
BMI British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.BMI.ADD.assoc.linear.clumped
BMI British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.BMI.ADD.assoc.linear.clumped
BMI Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.BMI.ADD.assoc.linear.clumped
BMI Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.BMI.ADD.assoc.linear.clumped
BMI Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.BMI.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.BMI.ADD.assoc.linear.clumped: No such file or directory
Waist African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chr13_v2.African.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chr22_v2.Any_other_white_background.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Waist.ADD.assoc.linear.clumped
Waist British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Waist.ADD.assoc.linear.clumped
Waist British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Waist.ADD.assoc.linear.clumped
Waist British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Waist.ADD.assoc.linear.clumped
Waist British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Waist.ADD.assoc.linear.clumped
Waist Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Waist.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr14_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chr20_v2.Caribbean.Waist.ADD.assoc.linear.clumped: No such file or directory
Waist Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Waist.ADD.assoc.linear.clumped
Waist Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Waist.ADD.assoc.linear.clumped
Hip African African /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Hip.ADD.assoc.linear.clumped
Hip Any_other_white_background Any_other_white_background /users/mturchin/data/ukbiobank_jun17/subsets/Any_other_white_background/Any_other_white_background/ukb_chrAll_v2.Any_other_white_background.Hip.ADD.assoc.linear.clumped
Hip British British /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Hip.ADD.assoc.linear.clumped
Hip British British.Ran4000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Hip.ADD.assoc.linear.clumped
Hip British British.Ran10000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran10000/ukb_chrAll_v2.British.Ran10000.Hip.ADD.assoc.linear.clumped
Hip British British.Ran100000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran100000/ukb_chrAll_v2.British.Ran100000.Hip.ADD.assoc.linear.clumped
Hip British British.Ran200000 /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran200000/ukb_chrAll_v2.British.Ran200000.Hip.ADD.assoc.linear.clumped
Hip Caribbean Caribbean /users/mturchin/data/ukbiobank_jun17/subsets/Caribbean/Caribbean/ukb_chrAll_v2.Caribbean.Hip.ADD.assoc.linear.clumped
Hip Indian Indian /users/mturchin/data/ukbiobank_jun17/subsets/Indian/Indian/ukb_chrAll_v2.Indian.Hip.ADD.assoc.linear.clumped
Hip Irish Irish /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chrAll_v2.Irish.Hip.ADD.assoc.linear.clumped
cat: /users/mturchin/data/ukbiobank_jun17/subsets/Irish/Irish/ukb_chr21_v2.Irish.Hip.ADD.assoc.linear.clumped: No such file or directory
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps
Height

British.Ran4000 80      6       18      42      64      71
British.Ran10000        147     35      57      95      128     137
British.Ran100000       2105    1179    1458    1819    2051    2085
British.Ran200000       4949    3323    3771    4404    4836    4910
African 130     2       17      50      99      115
Caribbean       169     10      24      50      121     155
Indian  1401    51      198     505     1067    1277
Irish   208     36      82      130     182     199


BMI

British.Ran4000 168     1       9       25      75      109
British.Ran10000        165     2       15      36      88      117
British.Ran100000       572     197     250     340     459     498
British.Ran200000       1405    733     822     1039    1257    1322
African 2051    22      77      269     902     1327
Caribbean       291     2       10      40      132     190
Indian  261     3       13      37      108     161
Irish   199     5       21      51      106     139


Waist

British.Ran4000 103     2       6       13      40      55
British.Ran10000        109     2       9       19      41      63
British.Ran100000       424     147     176     240     317     351
British.Ran200000       1029    526     594     723     892     947
African 119     0       6       13      42      62
Caribbean       124     0       3       11      48      68
Indian  197     1       8       26      79      109
Irish   146     1       10      22      58      88


Hip

British.Ran4000 190     1       9       27      81      115
British.Ran10000        174     3       9       26      66      107
British.Ran100000       560     177     226     310     436     481
British.Ran200000       1187    601     693     862     1042    1093
African 373     1       10      30      128     204
Caribbean       181     0       6       30      75      118
Indian  288     0       7       37      105     158
Irish   179     2       11      36      86      117
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps
Height

British.Ran4000 114     37      50      77      97      103
British.Ran10000        303     218     233     257     279     292
British.Ran100000       7730    7307    7407    7530    7665    7707
British.Ran200000       17170   16318   16549   16826   17060   17125
African 140     7       36      71      110     125
Caribbean       191     23      45      73      144     176
Indian  2320    451     791     1246    1907    2170
Irish   442     312     343     368     412     432


BMI

British.Ran4000 180     6       23      46      88      119
British.Ran10000        193     29      50      72      113     142
British.Ran100000       1337    1048    1089    1145    1223    1262
British.Ran200000       4267    3744    3824    3941    4097    4169
African 2670    98      212     492     1234    1764
Caribbean       320     6       20      57      149     207
Indian  279     9       33      61      124     176
Irish   221     16      46      79      127     161


Waist

British.Ran4000 123     11      16      27      54      75
British.Ran10000        136     30      38      47      72      92
British.Ran100000       945     700     728     764     828     863
British.Ran200000       2860    2386    2457    2556    2710    2766
African 130     1       8       16      46      71
Caribbean       128     1       7       22      56      74
Indian  244     2       11      38      107     144
Irish   182     21      38      53      86      120


Hip

British.Ran4000 204     1       18      40      89      124
British.Ran10000        197     21      32      46      90      123
British.Ran100000       1498    1199    1243    1289    1375    1422
British.Ran200000       4151    3675    3767    3866    3993    4048
African 422     2       20      53      153     236
Caribbean       186     4       20      39      85      124
Indian  323     2       27      56      119     184
Irish   195     9       25      51      107     131
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | head -n 10
betahat sebetahat NegativeProb PositiveProb lfsr svalue lfdr qvalue PosteriorMean PosteriorSD
-0.1765 0.51557925141764 0.0366912797649103 0.0315488250421891 0.96330872023509 0.862324648681602 0.931759895192901 0.92328361376068 -0.000809380073474425 0.034999291979268
0.1098 0.357282595715227 0.0299213285682757 0.0362317047108396 0.96376829528916 0.867007368532384 0.933846966720885 0.924981453385552 0.000977346036550227 0.0338432182335573
-2.211 1.73984964988889 0.0381274867326558 0.0321889650903872 0.961872513267344 0.84797149646054 0.929683548176957 0.914895418659724 -0.000950890146514495 0.0362407434251708
0.09407 0.190094740640057 0.0221156469489675 0.0373327373205447 0.962667262679455 0.855869476031909 0.940551615730488 0.927182400131154 0.00219662913468734 0.0299895055311396
-0.1205 0.174358632247393 0.0415753147510309 0.0190823441117376 0.958424685248969 0.811800868755402 0.939342341137231 0.926856075093709 -0.00321752153813457 0.0305116974733594
-0.1502 0.220675012513906 0.0418744148985092 0.0220087740075788 0.958125585101491 0.808506011633257 0.936116811093912 0.925904563115253 -0.00295857212563033 0.0324158858125707
0.04474 0.223584815001318 0.0273329712795276 0.0329475634322919 0.967052436567708 0.888122723210991 0.939719465288181 0.926956229099168 0.000828632491571682 0.0305521600483588
21.3 6.29783416075755 0.0329864820380841 0.0373680393834688 0.962631960616531 0.855509935620387 0.929645478578447 0.914704723883216 0.000704664552574581 0.036354585522483
0.1908 0.181068594738024 0.0165023357465738 0.0526948133339399 0.94730518666606 0.677541451457243 0.930802850919486 0.92177025441877 0.00533736364891803 0.0346973476960722
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | head -n 10
  CHR             SNP         BP   A1       TEST    NMISS       BETA         STAT            P 
1       Affx-10000328   39542062        G       ADD     3877    -0.1765 -0.3424 0.7321
1       Affx-10047176   39917888        A       ADD     3877    0.1098  0.3073  0.7586
1       Affx-10071327   40092089        T       ADD     423     -2.211  -1.273  0.2038
1       Affx-10080353   40160585        A       ADD     3875    0.09407 0.4949  0.6207
1       Affx-10096385   40773149        C       ADD     3853    -0.1205 -0.6912 0.4895
1       Affx-10134350   41256213        G       ADD     3722    -0.1502 -0.6808 0.4961
1       Affx-10349342   43131653        A       ADD     3872    0.04474 0.2001  0.8414
1       Affx-10384750   43394887        A       ADD     3880    21.3    3.385   0.0007193
1       Affx-10384852   43395635        T       ADD     3865    0.1908  1.054   0.292
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | tail -n 10
0.1559 0.165604448619374 0.0162934295255303 0.0490458437783885 0.950954156221612 0.722767884797491 0.934660726696081 0.925366120241675 0.00471175797341617 0.0327070513954554
-0.08657 0.164407085879733 0.0369938040277777 0.0199729529593963 0.963006195972222 0.859257326984155 0.943033243012826 0.927848564868901 -0.00238158651065105 0.0285291542284419
-6.634 2.83823379826688 0.0386260950325508 0.031905129759768 0.961373904967449 0.842934814852382 0.929468775207681 0.913985323863885 -0.00108121420490664 0.0365232847617687
-0.1822 0.177145809088945 0.0519270376131318 0.0164303293635157 0.948072962386868 0.687051054640137 0.931642633023352 0.923126603218458 -0.00520609672609872 0.0342637018513619
0.3236 0.166981050358021 0.0104211677643059 0.104201777806725 0.895798222193275 0.234824682506148 0.885377054428969 0.839331672079351 0.0149661618391396 0.05158235078295
0.4043 0.213950916617067 0.0133037963650402 0.0849424189012549 0.915057581098745 0.349690506520774 0.901753784733705 0.863248805687215 0.0114671610445161 0.0469791306142695
-0.064 0.16703138232166 0.0338970113748707 0.0217569683829767 0.966102988625129 0.885583876087643 0.944346020242153 0.9282027699294 -0.00169571267367072 0.0278479234927784
-0.1988 0.260571419069276 0.0433388157068274 0.0231052510812477 0.956661184293173 0.791771849726535 0.933555933211925 0.924818377794005 -0.00307978241021344 0.0338398462347753
0.6088 0.534500402008459 0.0269509425887307 0.0438017507459463 0.956198249254054 0.786400187917598 0.929247306665323 0.913208395548966 0.00266980563261122 0.0362728932431515
-0.1736 0.160693226013192 0.0542656097267101 0.0148916381871372 0.94573439027329 0.65789072339012 0.930842752086153 0.921843174090134 -0.00569624259840861 0.0343907117415166
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | tail -n 10
23      rs995355        44281368        G       ADD     3876    0.1559  0.9415  0.3465
23      rs996126        46676931        T       ADD     3872    -0.08657        -0.5266 0.5985
23      rs996341        98536813        A       ADD     3457    -6.634  -2.338  0.01942
23      rs9969869       29626423        G       ADD     3875    -0.1822 -1.029  0.3037
23      rs9969910       129429712       T       ADD     3862    0.3236  1.939   0.05263
23      rs9969915       30346878        T       ADD     3874    0.4043  1.89    0.0588
23      rs9969924       140023572       T       ADD     3874    -0.064  -0.3832 0.7016
23      rs9988241       138270573       G       ADD     3432    -0.1988 -0.7631 0.4455
23      rs9988292       112123649       C       ADD     3870    0.6088  1.139   0.2547
23      rs9988299       144219627       A       ADD     3861    -0.1736 -1.08   0.28
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | head -n 435165 | tail -n 10
-0.1872 0.468546211670901 0.0372455088670453 0.0307052727687713 0.962754491132955 0.856745148099336 0.932049218364183 0.923623037267994 -0.00102645476764451 0.0348341923776666
-0.2297 0.369525796654266 0.040042151197612 0.02750935869758 0.959957848802388 0.828342934706538 0.932448490104808 0.924019900269691 -0.00195049806657821 0.034569859125062
-0.1086 0.472195657846298 0.0357237038891803 0.0319919832482926 0.96427629611082 0.872435962170257 0.932284312862527 0.923864256863055 -0.000585452475121904 0.0347153586052106
0.007177 0.454458688361793 0.0335598482265164 0.0338245303864884 0.966175469613512 0.885829692700163 0.932615621386995 0.924167498336451 4.14513526105802e-05 0.0345378409594841
1.071 0.71709580133105 0.0273913096593632 0.0442097943299856 0.955790205670014 0.781620879235534 0.928398896010651 0.910693685607487 0.00268212540618194 0.0367651084939341
-0.2392 0.148572334722714 0.084444094322961 0.0108378749022974 0.915555905677039 0.353331374933784 0.904718030774742 0.867846935110199 -0.0111486286825356 0.0444312969736253
1.213 0.315078875670193 0.0102049726109904 0.16020973421066 0.83979026578934 0.0966595187388178 0.82958529317835 0.766538594969194 0.0272534109649107 0.0735596302135026
0.273 0.603854372851334 0.0315063138984886 0.0373902736744102 0.96260972632559 0.855292639569116 0.931103412427101 0.922307165537358 0.000930124662650361 0.0353572359133559
-0.5202 0.424307906969782 0.047115214325671 0.0245566001377374 0.952884785674329 0.746541773931772 0.928328185536592 0.910497566593847 -0.00356198387286329 0.0366638583016746
-0.2021 0.300544714834968 0.0413137101693685 0.0253191730249551 0.958686289830632 0.814698312316146 0.933367116805676 0.924704307363091 -0.00245903925753234 0.0340199387845769
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | head -n 435165 | tail -n 10 
9       rs75520839      10358103        G       ADD     3873    -0.1872 -0.3996 0.6895
9       rs75524650      81144942        G       ADD     3878    -0.2297 -0.6217 0.5342
9       rs75524760      122917206       T       ADD     3614    -0.1086 -0.23   0.8181
9       rs75525254      71192450        G       ADD     3626    0.007177        0.01573 0.9874
9       rs75525992      132531575       C       ADD     3458    1.071   1.494   0.1353
9       rs755267        13986757        C       ADD     3868    -0.2392 -1.61   0.1074
9       rs75527174      133280476       A       ADD     3878    1.213   3.854   0.0001182
9       rs75529319      72752666        T       ADD     3882    0.273   0.4521  0.6512
9       rs75529335      93613252        A       ADD     3880    -0.5202 -1.226  0.2202
9       rs75531388      3032917 T       ADD     3869    -0.2021 -0.6724 0.5013
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cmp <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat)                         /dev/fd/63 /dev/fd/62 differ: char 318211, line 44596
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | head -n 44600 | tail -n 10
-0.02706        -0.02706
0.717   0.717
-0.1034 -0.1034
-0.07824        -0.07824
-0.1562 -0.1562
0.0005  5e-04
-0.1303 -0.1303
-0.257  -0.257
-0.5004 -0.5004
0.1294  0.1294
[  mturchin@node832  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British.Ran4000/ukb_chrAll_v2.British.Ran4000.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | awk '{ if ($1 != $2) { print $0 } } ' | wc
      0       0       0
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | awk '{ if ($1 != $2) { print $0 } } ' | wc
      0       0       0
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.gz | awk '{ print $7 }' | grep -v BETA) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrAll_v2.African.Height.ADD.assoc.linear.ashr.results.gz | awk '{ print $1 }' | grep -v betahat) | awk '{ if ($1 != $2) { print $0 } } ' | wc
      0       0       0
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz) | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | head -n 10
> Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1$PosteriorMean) / Data1$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], "pVal"); write.table(Data1, quote=FALSE, row.names=FALSE);
CHR BP SNP PosteriorMean PosteriorSD pVal
1 39542062 Affx-10000328 -0.0183108628018179 0.0305653098790492 0.274561983753496
1 39917888 Affx-10047176 0.128908276748433 0.0338473484293385 6.9900743152814e-05
1 40092089 Affx-10071327 -0.0256278303887924 0.0555566592434716 0.322294639789851
1 40160585 Affx-10080353 0.096319454869676 0.0197522309691447 5.40242026014832e-07
1 40773149 Affx-10096385 -0.142986662598653 0.0150650324639293 1.14091172877303e-21
1 41256213 Affx-10134350 -0.0561900409014686 0.0223232788908437 0.00591617505556995
1 43131653 Affx-10349342 0.0134496039954067 0.0169219723849402 0.213364575782362
1 43394887 Affx-10384750 0.00134349867728841 0.0469280960919012 0.488580290617208
Error in write.table(Data1, quote = FALSE, row.names = FALSE) : 
  ignoring SIGPIPE signal
Execution halted
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz) | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < .0001) { print join("\t", @F0); } ' | wc
  26452       0   26452
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$paste <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.gz) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.gz) | perl -lane 'print $F[0], "\t", $F[2], "\t", $F[1], "\t", $F[$#F-1], "\t", $F[$#F];' | R -q -e "Data1 <- read.table(file('stdin'), header=T); Data1 <- cbind(Data1, pnorm(abs(Data1\$PosteriorMean) / Data1\$PosteriorSD, lower.tail=FALSE)); colnames(Data1) <- c(names(Data1)[-ncol(Data1)], \"pVal\"); write.table(Data1, quote=FALSE, row.names=FALSE);" | perl -lane 'if ($F[$#F] < 5e-8) { print join("\t", @F0); } ' | wc
  12978       0   12978
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.bed | head -n 10
chr1    39917888        39917888        Affx-10047176
chr1    40160585        40160585        Affx-10080353
chr1    40773149        40773149        Affx-10096385
chr1    53072454        53072454        Affx-11410175
chr1    84876711        84876711        Affx-15002439
chr1    93400766        93400766        Affx-15758179
chr1    51047717        51047717        Affx-35344154
chr1    218510892       218510892       Affx-35455537
chr1    119075738       119075738       Affx-4674273
chr1    25629943        25629943        Affx-52122172
[  mturchin@node803  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/ukb_chrAll_v2.British.Height.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.250kbPadding.bed | head -n 10
chr1    39667888        40167888        Affx-10047176
chr1    39910585        40410585        Affx-10080353
chr1    40523149        41023149        Affx-10096385
chr1    52822454        53322454        Affx-11410175
chr1    84626711        85126711        Affx-15002439
chr1    93150766        93650766        Affx-15758179
chr1    50797717        51297717        Affx-35344154
chr1    218260892       218760892       Affx-35455537
chr1    118825738       119325738       Affx-4674273
chr1    25379943        25879943        Affx-52122172
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.
AllPopComps                                                                                                                                                                                                                     
Height
British.Ran4000 0       0       0       0       0       0                                                                                                                                                                    
British.Ran10000        27      21      27      27      27      27                                                                                                                                                            
British.Ran100000       3843    3810    3825    3829    3838    3838                                                                                                                                                          
British.Ran200000       8620    8521    8551    8582    8605    8611                                                                                                                                                         
African 0       0       0       0       0       0                                                                                                                                                                           
Caribbean       0       0       0       0       0       0                                                                                                                                                                  
Indian  218     25      51      99      196     210                                                                                                                                                                        
Irish   44      37      43      43      43      44


BMI                                                                                                                                                                                                                            
 
British.Ran4000 14      0       3       4       5       6
British.Ran10000        6       2       4       4       4       4
British.Ran100000       222     219     219     219     219     221
British.Ran200000       1001    983     984     992     997     999
African 694     21      39      66      169     259
Caribbean       0       0       0       0       0       0
Indian  7       0       1       2       3       3
Irish   14      0       1       2       4       5


Waist

British.Ran4000 0       0       0       0       0       0
British.Ran10000        5       5       5       5       5       5
British.Ran100000       104     101     101     102     103     103
British.Ran200000       730     687     692     704     718     720
African 0       0       0       0       0       0
Caribbean       3       0       0       0       0       1
Indian  0       0       0       0       0       0
Irish   1       0       0       0       1       1


Hip

British.Ran4000 12      0       4       4       4       6
British.Ran10000        12      3       4       4       4       7
British.Ran100000       426     410     410     411     412     413
British.Ran200000       1353    1330    1331    1335    1341    1343
African 34      0       0       0       6       10
Caribbean       0       0       0       0       0       0
Indian  3       0       0       0       0       0
Irish   13      0       1       1       5       7
...
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.clumped.AllPopComps   
Height

British.Ran4000 80      6       18      42      64      71
British.Ran10000        147     35      57      95      128     137
British.Ran100000       2105    1179    1458    1819    2051    2085
British.Ran200000       4949    3323    3771    4404    4836    4910
British 13019   13019   13019   13019   13019   13019
African 130     2       17      50      99      115
Caribbean       169     10      24      50      121     155
Indian  1401    51      198     505     1067    1277
Irish   208     36      82      130     182     199


BMI

British.Ran4000 168     1       9       25      75      109
British.Ran10000        165     2       15      36      88      117
British.Ran100000       572     197     250     340     459     498
British.Ran200000       1405    733     822     1039    1257    1322
British 4088    4088    4088    4088    4088    4088
African 2051    22      77      269     902     1327
Caribbean       291     2       10      40      132     190
Indian  261     3       13      37      108     161
Irish   199     5       21      51      106     139


Waist

British.Ran4000 103     2       6       13      40      55
British.Ran10000        109     2       9       19      41      63
British.Ran100000       424     147     176     240     317     351
British.Ran200000       1029    526     594     723     892     947
British 3040    3040    3040    3040    3040    3040
African 119     0       6       13      42      62
Caribbean       124     0       3       11      48      68
Indian  197     1       8       26      79      109
Irish   146     1       10      22      58      88


Hip

British.Ran4000 190     1       9       27      81      115
British.Ran10000        174     3       9       26      66      107
British.Ran100000       560     177     226     310     436     481
British.Ran200000       1187    601     693     862     1042    1093
British 3217    3217    3217    3217    3217    3217
African 373     1       10      30      128     204
Caribbean       181     0       6       30      75      118
Indian  288     0       7       37      105     158
Irish   179     2       11      36      86      117
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.1eNeg4.NoNAs.AllPopComps 
Height                                                                                                                                                                                                                         
                                                                                                                                                                                                                               
British.Ran4000 114     37      50      77      97      103                                                                                                                                                                    
British.Ran10000        303     218     233     257     279     292                                                                                                                                                            
British.Ran100000       7730    7307    7407    7530    7665    7707                                                                                                                                                           
British.Ran200000       17170   16318   16549   16826   17060   17125                                                                                                                                                          
British 40381   40381   40381   40381   40381   40381
African 140     7       36      71      110     125
Caribbean       191     23      45      73      144     176
Indian  2320    451     791     1246    1907    2170
Irish   442     312     343     368     412     432


BMI

British.Ran4000 180     6       23      46      88      119
British.Ran10000        193     29      50      72      113     142
British.Ran100000       1337    1048    1089    1145    1223    1262
British.Ran200000       4267    3744    3824    3941    4097    4169
British 13774   13774   13774   13774   13774   13774
African 2670    98      212     492     1234    1764
Caribbean       320     6       20      57      149     207
Indian  279     9       33      61      124     176
Irish   221     16      46      79      127     161


Waist

British.Ran4000 123     11      16      27      54      75
British.Ran10000        136     30      38      47      72      92
British.Ran100000       945     700     728     764     828     863
British.Ran200000       2860    2386    2457    2556    2710    2766
British 9316    9316    9316    9316    9316    9316
African 130     1       8       16      46      71
Caribbean       128     1       7       22      56      74
Indian  244     2       11      38      107     144
Irish   182     21      38      53      86      120


Hip

British.Ran4000 204     1       18      40      89      124
British.Ran10000        197     21      32      46      90      123
British.Ran100000       1498    1199    1243    1289    1375    1422
British.Ran200000       4151    3675    3767    3866    3993    4048
British 12123   12123   12123   12123   12123   12123
African 422     2       20      53      153     236
Caribbean       186     4       20      39      85      124
Indian  323     2       27      56      119     184
Irish   195     9       25      51      107     131
[  mturchin@node844  ~/LabMisc/RamachandranLab/MultiEthnicGWAS]$cat /users/mturchin/LabMisc/RamachandranLab/MultiEthnicGWAS/2017WinterRetreatResults/ukb_chrAll_v2.British.AllPhenos.ADD.assoc.linear.ashr.results.1eNeg4.NoNAs.AllPopComps
Height

British.Ran4000 0       0       0       0       0       0
British.Ran10000        24      18      24      24      24      24
British.Ran100000       3554    3526    3540    3543    3548    3548
British.Ran200000       7952    7871    7895    7923    7943    7944
British 24500   24500   24500   24500   24500   24500
African 0       0       0       0       0       0
Caribbean       0       0       0       0       0       0
Indian  200     19      34      46      91      173
Irish   41      34      40      40      40      41


BMI

British.Ran4000 13      0       3       3       4       6
British.Ran10000        5       1       3       3       3       3
British.Ran100000       211     208     208     208     208     210
British.Ran200000       906     888     890     896     903     904
British 6060    6060    6060    6060    6060    6060
African 595     20      35      54      133     216
Caribbean       0       0       0       0       0       0
Indian  7       0       1       2       2       2
Irish   14      0       1       2       4       5


Waist

British.Ran4000 0       0       0       0       0       0
British.Ran10000        5       5       5       5       5       5
British.Ran100000       86      86      86      86      86      86
British.Ran200000       618     591     593     600     609     611
British 3294    3294    3294    3294    3294    3294
African 0       0       0       0       0       0
Caribbean       3       0       0       0       0       1
Indian  0       0       0       0       0       0
Irish   0       0       0       0       0       0


Hip

British.Ran4000 10      0       2       2       2       4
British.Ran10000        10      2       3       3       3       6
British.Ran100000       388     375     375     376     377     378
British.Ran200000       1249    1232    1233    1235    1239    1242
British 5543    5543    5543    5543    5543    5543
African 32      0       0       0       4       8
Caribbean       0       0       0       0       0       0
Indian  3       0       0       0       0       0
Irish   12      0       1       1       2       6


#20180313
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat *bim | wc
 803113 4818678 23068702
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat plink.log
PLINK v1.90b4 64-bit (20 Mar 2017)
Options in effect:
  --bfile /users/mturchin/data/ukbiobank_jun17/subsets/African/African/ukb_chrX_v2.African
  --exclude range /users/mturchin/Software/flashpca/exclusion_regions_hg19.txt
  --indep-pairwise 1000 50 0.05

Hostname: node813
Working directory: /gpfs/data/sramacha/ukbiobank_jun17/subsets/African/African
Start time: Tue Mar 13 14:15:52 2018

Random number seed: 1520964952
129170 MB RAM detected; reserving 64585 MB for main workspace.
18857 variants loaded from .bim file.
3205 people (1651 males, 1554 females) loaded from .fam.
Warning: No variants excluded by '--exclude range'.
--exclude range: 18857 variants remaining.
Using 1 thread (no multithreaded calculations invoked).
Before main variant filters, 3205 founders and 0 nonfounders present.
Calculating allele frequencies... done.
Total genotyping rate is 0.975492.
18857 variants and 3205 people pass filters and QC.
Note: No phenotypes present.
Pruned 15358 variants from chromosome 23, leaving 3499.
Pruning complete.  15358 of 18857 variants removed.
Marker lists written to plink.prune.in and plink.prune.out .

End time: Tue Mar 13 14:15:54 2018
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat /users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt | wc
 805427 128062893 371289758
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat /users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt | head -n 10
rs_id affymetrix_snp_id affymetrix_probeset_id chromosome position allele1_ref allele2_alt strand array Batch_b001_qc Batch_b002_qc Batch_b003_qc Batch_b004_qc Batch_b005_qc Batch_b006_qc Batch_b007_qc Batch_b008_qc Batch_b009_qc Batch_b010_qc Batch_b011_qc Batch_b012_qc Batch_b013_qc Batch_b014_qc Batch_b015_qc Batch_b016_qc Batch_b017_qc Batch_b018_qc Batch_b019_qc Batch_b020_qc Batch_b021_qc Batch_b022_qc Batch_b023_qc Batch_b024_qc Batch_b025_qc Batch_b026_qc Batch_b027_qc Batch_b028_qc Batch_b029_qc Batch_b030_qc Batch_b031_qc Batch_b032_qc Batch_b033_qc Batch_b034_qc Batch_b035_qc Batch_b036_qc Batch_b037_qc Batch_b038_qc Batch_b039_qc Batch_b040_qc Batch_b041_qc Batch_b042_qc Batch_b043_qc Batch_b044_qc Batch_b045_qc Batch_b046_qc Batch_b047_qc Batch_b048_qc Batch_b049_qc Batch_b050_qc Batch_b051_qc Batch_b052_qc Batch_b053_qc Batch_b054_qc Batch_b055_qc Batch_b056_qc Batch_b057_qc Batch_b058_qc Batch_b059_qc Batch_b060_qc Batch_b061_qc Batch_b062_qc Batch_b063_qc Batch_b064_qc Batch_b065_qc Batch_b066_qc Batch_b067_qc Batch_b068_qc Batch_b069_qc Batch_b070_qc Batch_b071_qc Batch_b072_qc Batch_b073_qc Batch_b074_qc Batch_b075_qc Batch_b076_qc Batch_b077_qc Batch_b078_qc Batch_b079_qc Batch_b080_qc Batch_b081_qc Batch_b082_qc Batch_b083_qc Batch_b084_qc Batch_b085_qc Batch_b086_qc Batch_b087_qc Batch_b088_qc Batch_b089_qc Batch_b090_qc Batch_b091_qc Batch_b092_qc Batch_b093_qc Batch_b094_qc Batch_b095_qc UKBiLEVEAX_b1_qc UKBiLEVEAX_b2_qc UKBiLEVEAX_b3_qc UKBiLEVEAX_b4_qc UKBiLEVEAX_b5_qc UKBiLEVEAX_b6_qc UKBiLEVEAX_b7_qc UKBiLEVEAX_b8_qc UKBiLEVEAX_b9_qc UKBiLEVEAX_b10_qc UKBiLEVEAX_b11_qc in_HetMiss in_Relatedness in_PCA PC1_loading PC2_loading PC3_loading PC4_loading PC5_loading PC6_loading PC7_loading PC8_loading PC9_loading PC10_loading PC11_loading PC12_loading PC13_loading PC14_loading PC15_loading PC16_loading PC17_loading PC18_loading PC9_loading PC20_loading PC21_loading PC22_loading PC23_loading PC24_loading PC25_loading PC26_loading PC27_loading PC28_loading PC9_loading PC30_loading PC31_loading PC32_loading PC33_loading PC34_loading PC35_loading PC36_loading PC37_loading PC38_loading PC9_loading PC40_loading in_Phasing_Input
rs28659788 Affx-13546538 AX-32115783 1 723307 C G + 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs116587930 Affx-35298040 AX-37361813 1 727841 G A + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 0 0 0 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs116720794 Affx-13637449 AX-32137419 1 729632 C T + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs3131972 Affx-13945728 AX-13191280 1 752721 A G + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
rs12184325 Affx-13963217 AX-11194291 1 754105 C T + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 -0.00019684 1.61348e-05 0.00293187 -0.00653266 -0.00053331 0.00136479 -0.00495838 0.00296911 -0.00273732 -0.00309628 -0.00278084 0.000566625 0.00118939 -0.00110896 -0.00116043 -0.00501367 -0.00522113 0.000986281 0.00279501 0.00201829 -0.00168376 0.00063532 -0.00160938 0.00369638 -0.000535131 -0.00283076 0.0016734 0.00213946 -0.00294971 0.00193457 0.00402521 -0.00347144 0.00589896 -0.00373881 -0.00189571 -0.00286888 0.000792278 -0.00191024 0.00307453 -0.000410934 1
rs3131962 Affx-13995532 AX-32225497 1 756604 A G + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
rs114525117 Affx-14027812 AX-32233025 1 759036 G A + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
rs3115850 Affx-14055733 AX-40202607 1 761147 T C + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 0
rs115991721 Affx-35298091 AX-37361837 1 767096 A G + 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA NA 1
(MultiEthnicGWAS) [  mturchin@node813  ~/data/ukbiobank_jun17/subsets/African/African]$cat /users/mturchin/data/ukbiobank_jun17/ukb_snp_qc.txt | awk '{ print $8 }' | sort | uniq -c
 805426 +
      1 strand
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/*genome.gz | sort -rg -k 10,10 | head -n 10
  2158009  2158009  2529116  2529116 UN    NA  0.0000  0.0018  0.9982  0.9991  -1  0.999732  1.0000      NA
  1877246  1877246  2988290  2988290 UN    NA  0.0000  0.0050  0.9950  0.9975  -1  0.999279  1.0000      NA
  1799741  1799741  2095912  2095912 UN    NA  0.0000  0.0066  0.9934  0.9967  -1  0.999292  1.0000      NA
  2703114  2703114  5491748  5491748 UN    NA  0.0000  0.0091  0.9909  0.9955  -1  0.999021  1.0000      NA
  2227118  2227118  5098716  5098716 UN    NA  0.0000  0.0178  0.9822  0.9911  -1  0.997419  1.0000      NA
  1651492  1651492  2212586  2212586 UN    NA  0.0000  0.0389  0.9611  0.9806  -1  0.995811  1.0000      NA
  4741676  4741676  4822865  4822865 UN    NA  0.1352  0.4565  0.4083  0.6366  -1  0.927493  1.0000 19.8074
  3030528  3030528  5307254  5307254 UN    NA  0.1080  0.5356  0.3565  0.6242  -1  0.897493  1.0000 25.3525
  2120488  2120488  2597019  2597019 UN    NA  0.1106  0.5342  0.3552  0.6223  -1  0.923354  1.0000 23.3016
  1033231  1033231  1327772  1327772 UN    NA  0.1363  0.5022  0.3615  0.6126  -1  0.926737  1.0000 23.3130
[  mturchin@login002  ~/data/ukbiobank_jun17]$for i in {25..31}; do echo $i; zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk -v iAwk=$i '{ print $iAwk }' | sort | uniq -c; done
25
 487409 0
    968 1
26
 487725 0
    652 1
27
 340646 0
 147731 1
28
 487400 0
    977 1
29
 488189 0
    188 1
30
  78674 0
 409703 1
31
  81158 0
 407219 1
(MultiEthnicGWAS) [  mturchin@node604  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | wc
    188     376    3008
(MultiEthnicGWAS) [  mturchin@node604  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
> 
>         echo $ancestry1 $ancestry2
> 
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.genome.drop.FIDIIDs | wc
> 
> done
African African
     59     118     944
Any_other_Asian_background Any_other_Asian_background
     63     126    1008
Any_other_mixed_background Any_other_mixed_background
      6      12      96
Any_other_white_background Any_other_white_background
   3289    6578   52624
British British
      0       0       0
British British.Ran4000
      6      12      96
British British.Ran10000
     22      44     352
British British.Ran100000
      0       0       0
British British.Ran200000
      0       0       0
Caribbean Caribbean
    265     530    4240
Chinese Chinese
     35      70     560
Indian Indian
    306     612    4896
Irish Irish
    518    1036    8288
Pakistani Pakistani
     73     146    1168
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | head -n 10                         
sample  pop     super_pop       gender  
HG00096 GBR     EUR     male
HG00097 GBR     EUR     female
HG00099 GBR     EUR     female
HG00100 GBR     EUR     female
HG00101 GBR     EUR     male
HG00102 GBR     EUR     female
HG00103 GBR     EUR     male
HG00105 GBR     EUR     male
HG00106 GBR     EUR     female
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $3 }' | sort | uniq -c
    661 AFR
    347 AMR
    504 EAS
    503 EUR
    489 SAS
      1 super_pop
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $2 }' | sort | uniq -c
     96 ACB
     61 ASW
     86 BEB
     93 CDX
     99 CEU
    103 CHB
    105 CHS
     94 CLM
     99 ESN
     99 FIN
     91 GBR
    103 GIH
    113 GWD
    107 IBS
    102 ITU
    104 JPT
     99 KHV
     99 LWK
     85 MSL
     64 MXL
     85 PEL
     96 PJL
    104 PUR
    102 STU
    107 TSI
    108 YRI
      1 pop
[  mturchin@login002  ~/data/1000G]$cat /users/mturchin/data/1000G/integrated_call_samples_v3.20130502.ALL.panel | awk '{ print $4 }' | sort | uniq -c
   1271 female
      1 gender
   1233 male
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.bim | awk '{ print $2 }' | wc  
  91009   91009  951062
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.bim | awk '{ print $2 }' | sort | uniq | wc
  91009   91009  951062
(MultiEthnicGWAS) [  mturchin@login002  ~/data/1000G/subsets]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.bim.rsIDs) <(cat CEU/*bim | awk '{ print $2 }' | sort | uniq) | wc
  88758   88758  924509
(MultiEthnicGWAS) [  mturchin@node639  ~/data/1000G/subsets]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.bim | wc
  88804  532824 2496343
(MultiEthnicGWAS) [  mturchin@node639  ~/data/1000G/subsets]$cat /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.bim | wc
  86595  519570 2430428
(MultiEthnicGWAS) [  mturchin@node639  ~/data/1000G/subsets]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.fam | wc
   3903   23418   97575
(MultiEthnicGWAS) [  mturchin@node639  ~/data/1000G/subsets]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.bim | wc
  86595  519570 2430428
(MultiEthnicGWAS) [  mturchin@node639  ~/data/1000G/subsets]$cat /users/mturchin/data/1000G/mturchin20/subsets/All.chrAll.phase3.genotypes.SNPs.ukb.bim.rsIDs | wc
  86595   86595  902004
(MultiEthnicGWAS) [  mturchin@node639  ~/data/1000G/subsets]$cat /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_CEU" }' | head -n 10
NA06984_NA06984 1kG_CEU
NA06985_NA06985 1kG_CEU
NA06986_NA06986 1kG_CEU
NA06989_NA06989 1kG_CEU
NA06994_NA06994 1kG_CEU
NA07000_NA07000 1kG_CEU
NA07037_NA07037 1kG_CEU
NA07048_NA07048 1kG_CEU
NA07051_NA07051 1kG_CEU
NA07056_NA07056 1kG_CEU
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat <(cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.fam | awk '{ print $1 "_" $2 "\tukb_AFR" }') <(cat /users/mturchin/data/1000G/subsets/CEU/mturchin20/CEU.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_CEU" }') <(cat /users/mturchin/data/1000G/subsets/GBR/mturchin20/GBR.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_GBR" }') <(cat /users/mturchin/data/1000G/subsets/YRI/mturchin20/YRI.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_YRI" }') <(cat /users/mturchin/data/1000G/subsets/ESN/mturchin20/ESN.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_ESN" }') <(cat /users/mturchin/data/1000G/subsets/CHB/mturchin20/CHB.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_CHB" }') <(cat /users/mturchin/data/1000G/subsets/JPT/mturchin20/JPT.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_JPT" }') <(cat /users/mturchin/data/1000G/subsets/ACB/mturchin20/ACB.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_ACB" }') <(cat /users/mturchin/data/1000G/subsets/ASW/mturchin20/ASW.chrAll.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.SNPs.ukb.fam | awk '{ print $1 "_" $2 "\t1kG_ASW" }') | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);' | perl -lane 'print $F[$#F];' | sort | uniq -c
     96 1kG_ACB
     61 1kG_ASW
     99 1kG_CEU
    103 1kG_CHB
     99 1kG_ESN
     91 1kG_GBR
    104 1kG_JPT
    108 1kG_YRI
   3142 ukb_AFR
> table(mapply(aboveLnrThrsh, Data3[Data3[,ncol(Data3)-2] == "ukb_AFR", 3], Data3[Data3[,ncol(Data3)-2] == "ukb_AFR", 4]))

FALSE  TRUE 
   27  3174 
> head(Data3[Data3[,ncol(Data3)-2] == "ukb_AFR",][!mapply(aboveLnrThrsh, Data3[Data3[,ncol(Data3)-2] == "ukb_AFR", 3], Data3[Data3[,ncol(Data3)-2] == "ukb_AFR", 4]),], n=2)
       FID     IID       PC1         PC2         PC3        PC4          PC5
23 1037820 1037820 0.0606192 0.009803607 -0.03021348 0.07459507 -0.008292438
36 1070718 1070718 0.3871950 0.110501200  0.03511729 0.03538586 -0.018424500
           PC6        PC7           PC8          PC9         PC10         PC11
23 0.012302440 0.02638180 -0.0338623800 -0.004957405 -0.003027609  0.013042100
36 0.001566919 0.01619687  0.0008836931 -0.012697710  0.002328721 -0.003112591
           PC12        PC13        PC14         PC15       PC16        PC17
23 -0.019419070  0.01977710 -0.01072059 -0.006932995 0.02763398 -0.02727798
36 -0.003934316 -0.06587703 -0.04689722 -0.004888050 0.05387120 -0.06640728
         PC18       PC19         PC20     POP rep("black", nrow(Data1))
23 0.04585786 0.01842685 -0.013312660 ukb_AFR                     black
36 0.04179971 0.04778019  0.004114662 ukb_AFR                     black
   rep(16, nrow(Data1))
23                   16
36                   16
> aboveLnrThrsh
function(x,y) { returnVal1 <- FALSE; if (y >= ((x * .555) + .005) ) { returnVal1 <- TRUE; }; return(returnVal1); }
<bytecode: 0x4a58840>
> ( 0.06061920 * .555 ) + .005
[1] 0.03864366
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($28 == 1) { print $1 "\t" $2 } }' | wc
    977    1954   15632
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($29 == 1) { print $1 "\t" $2 } }' | wc
    188     376    3008
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($29 == 1) { print $28 "\t" $29 } }' | sort | uniq -c
    188 0       1
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($28 == 1) { print $28 "\t" $29 } }' | sort | uniq -c
    977 1       0
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ print $24 }' | head -n 10
0.189792245311413
0.190936172228779
0.189889848917372
0.191182269164326
0.190705167558601
0.174676599692186
0.191355822353906
0.181140061704935
0.192046945357755
0.189565440467468
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($25 == 1) { print $1 "\t" $2 } }' | wc
    968    1936   15488
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.txt.gz | awk '{ if ($26 == 1) { print $1 "\t" $2 } }' | wc
    652    1304   10432
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | wc
 107163  535815 3812216
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) | wc 
 102191  613146 4452969
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) | wc 
   4972   34804  256323
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) | wc 
 102136  612816 4450545
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) | wc 
   5027   35189  259157
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) <(join -v 1 <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/ukb_sqc_v2.wfam.excess_relatives.FIDIIDs | sort -k 1,1)) | perl -lane 'print join("\t", @F[1..$#F]);' | sort | uniq | wc
 102737  513685 3654845
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.wukbDrops.dat | wc
 102737  513685 3654845
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.dropExcess.dat | wc
 102737  513685 3654845
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | wc
 430923 2585538 10773075
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | wc
 107163  535815 3812216
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | wc
 100210  601260 4366662
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | wc
 100066  600396 4360507
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | wc
 200276 1001380 7124961
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq | wc
 103366  516830 3677238
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | wc
  96910  484550 3447723
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -u | wc
   6456   32280  229515
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | awk '{ print $1 "\t" $1 "\t" $2 "\t" $2 "\t" $3 "\t" $4 "\tPH\tPH\tPH\t" $5 }' | head -n 10
1000104 1000104 4415454 4415454 0.077   0.0046  PH      PH      PH      0.2531
1000196 1000196 5615063 5615063 0.045   0.0143  PH      PH      PH      0.0594
1000297 1000297 5011917 5011917 0.069   0.0057  PH      PH      PH      0.2155
1000297 1000297 5970067 5970067 0.046   0.0149  PH      PH      PH      0.0575
1000368 1000368 1215781 1215781 0.045   0.0132  PH      PH      PH      0.0704
1000427 1000427 2967577 2967577 0.046   0.0149  PH      PH      PH      0.0569
1000473 1000473 2009201 2009201 0.048   0.0137  PH      PH      PH      0.0778
1000672 1000672 2001451 2001451 0.048   0.0134  PH      PH      PH      0.0749
1000775 1000775 2210841 2210841 0.073   0.0056  PH      PH      PH      0.2316
1000775 1000775 4007992 4007992 0.045   0.0144  PH      PH      PH      0.0582
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,5], c(0,.1,.2,.3,.4,.5,.6)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,5], c(0,.1,.2,.3,.4,.5,.6)));

  (0,0.1] (0.1,0.2] (0.2,0.3] (0.3,0.4] (0.4,0.5] (0.5,0.6] 
    67866     10301     28717        93       179         0 
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat ukb_chrAll_v2.African.QCed.pruned.QCed.genome.gz | awk '{ if ($10 > .2) { print $0 } } ' | head -n 10
     FID1     IID1     FID2     IID2 RT    EZ      Z0      Z1      Z2  PI_HAT PHE       DST     PPC   RATIO
  1107522  1107522  1586705  1586705 UN    NA  0.2103  0.4139  0.3758  0.5827  -1  0.887081  1.0000 14.1074
  1170700  1170700  5791451  5791451 UN    NA  0.0034  0.9759  0.0207  0.5087  -1  0.851656  1.0000 560.1667
  1240356  1240356  2883453  2883453 UN    NA  0.1805  0.5245  0.2951  0.5573  -1  0.877508  1.0000 15.7926
  1285094  1285094  5982037  5982037 UN    NA  0.2777  0.5145  0.2079  0.4651  -1  0.855754  1.0000  8.6890
  1326399  1326399  3202127  3202127 UN    NA  0.0061  0.9721  0.0219  0.5079  -1  0.851595  1.0000 481.0000
  1483629  1483629  3510376  3510376 UN    NA  0.2099  0.5649  0.2251  0.5076  -1  0.864340  1.0000 12.0766
  1504283  1504283  5252181  5252181 UN    NA  0.2269  0.5321  0.2411  0.5071  -1  0.865257  1.0000 12.3558
  1505962  1505962  4894673  4894673 UN    NA  0.4357  0.5643  0.0000  0.2822  -1  0.805076  1.0000  5.2185
  1635429  1635429  3709274  3709274 UN    NA  0.4542  0.5297  0.0161  0.2810  -1  0.811192  1.0000  5.0927
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | grep 5791451                                            5791451 1170700 0.042 0.0001 0.2489
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | grep 1586705
1586705 1107522 0.053 0.0031 0.2793
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | grep 4894673
1505962 4894673 0.037 0.0072 0.1077
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | grep 3709274
1635429 3709274 0.035 0.0074 0.1232
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | wc
 107163  535815 3812216
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ if ($5 > .1) { print $0 } }' | wc
  39291  196455 1384583
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ if ($5 > 0.0442) { print $0 } }' | wc
 106994  534970 3806273
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ if ($5 > 0.0442) { print $1 } } ' | sort | uniq | wc
  81825   81825  654596
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ if ($5 > 0.0442) { print $2 } } ' | sort | uniq | wc
  81781   81781  654244
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ if ($5 > 0.0442) { print $1"\n"$2 } } ' | sort | uniq | wc
 147627  147627 1181008
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>
>         echo $ancestry1 $ancestry2
>
>         cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun1
7/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.$
{ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | s
ort | uniq -d | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.gz
>         zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.gz | awk '{ if ($5 >= .0884) { print $0 } }' | wc
>         zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.gz | awk '{ if ($5 >= .0442) { print $0 } }' | wc
> 
> done
African African
     58     290    2063
     85     425    3027
Any_other_Asian_background Any_other_Asian_background
     29     145    1022
     55     275    1947
Any_other_mixed_background Any_other_mixed_background
      5      25     180
     12      60     432
Any_other_white_background Any_other_white_background
    161     805    5693
    244    1220    8657
British British
  36120  180600 1272685
  96910  484550 3447723
British British.Ran4000
      6      30     201
     16      80     561
British British.Ran10000
     23     115     796
     54     270    1907
British British.Ran100000
   1802    9010   63498
   4918   24590  174995
British British.Ran200000
   7312   36560  257642
  19810   99050  704662
Caribbean Caribbean
    287    1435   10204
    514    2570   18335
Chinese Chinese
     37     185    1313
     58     290    2067
Indian Indian
    333    1665   11755
    515    2575   18211
Irish Irish
    548    2740   19441
   1174    5870   41845
Pakistani Pakistani
     65     325    2283
    158     790    5585
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>
>         echo $ancestry1 $ancestry2
>
> #       cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.gz
>         cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.dropExcess.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.dropExcess.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.dropExcess.gz   
>         zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.dropExcess.gz | awk '{ if ($5 >= .0884) { print $0 } }' | wc
>         zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.dropExcess.gz | awk '{ if ($5 >= .0442) { print $0 } }' | wc
>
> done
African African
     58     290    2063
     85     425    3027
Any_other_Asian_background Any_other_Asian_background
     29     145    1022
     55     275    1947
Any_other_mixed_background Any_other_mixed_background
      5      25     180
     12      60     432
Any_other_white_background Any_other_white_background
    161     805    5693
    235    1175    8339
British British
  36120  180600 1272685
  93356  466780 3321302
British British.Ran4000
      6      30     201
     16      80     561
British British.Ran10000
     23     115     796
     54     270    1907
British British.Ran100000
   1802    9010   63498
   4792   23960  170500
British British.Ran200000
   7312   36560  257642
  18971   94855  674863
Caribbean Caribbean
    287    1435   10204
    514    2570   18335
Chinese Chinese
     37     185    1313
     58     290    2067
Indian Indian
    333    1665   11755
    515    2575   18211
Irish Irish
    548    2740   19441
   1169    5845   41665
Pakistani Pakistani
     65     325    2283
    158     790    5585
(MultiEthnicGWAS) [  mturchin@node827  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>
>         echo $ancestry1 $ancestry2
>
> #       cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/ukb22419_rel_s488363.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.gz
>         cat <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.wukbDrops.dat | awk '{ print $1 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') <(join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.fam | awk '{ print $1 }' | sort) <(cat /users/mturchin/data/ukbiobank_jun17/mturchin/ukb22419_rel_s488363.wukbDrops.dat | awk '{ print $2 "\t" $0 }' | sort -k 1,1) | perl -lane 'print join("\t", @F[1..$#F]);') | sort | uniq -d | gzip > /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.gz
>         zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.gz | awk '{ if ($5 >= .0884) { print $0 } }' | wc
>         zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.ukb22419_rel_s488363.wukbDrops.gz | awk '{ if ($5 >= .0442) { print $0 } }' | wc
>
> done
African African
     58     290    2063
     85     425    3027
Any_other_Asian_background Any_other_Asian_background
     29     145    1022
     55     275    1947
Any_other_mixed_background Any_other_mixed_background
      5      25     180
     12      60     432
Any_other_white_background Any_other_white_background
    161     805    5693
    235    1175    8339
British British
  36120  180600 1272685
  93356  466780 3321302
British British.Ran4000
      6      30     201
     16      80     561
British British.Ran10000
     23     115     796
     54     270    1907
British British.Ran100000
   1802    9010   63498
   4792   23960  170500
British British.Ran200000
   7312   36560  257642
  18971   94855  674863
Caribbean Caribbean
    287    1435   10204
    514    2570   18335
Chinese Chinese
     37     185    1313
     58     290    2067
Indian Indian
    333    1665   11755
    515    2575   18211
Irish Irish
    548    2740   19441
   1169    5845   41665
Pakistani Pakistani
     65     325    2283
    158     790    5585
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | head -n 10
FID     IID     PC1     PC2     PC3     PC4     PC5  PC6        PC7     PC8     PC9     PC10    PC11    PC12    PC13    PC14    PC15    PC16    PC17    PC18    PC19    PC20    POP
1001592 1001592 -0.1095837      -0.01515011     -0.01299081     0.06432943      0.0004121108    0.005383313     -0.001550409    0.001556439     -0.01007402     0.02734633      0.05144904      -0.004063994    -0.00563374    -0.006742348     0.003090609     -0.03031161     0.01395377      0.0005988888    -0.003488019    -0.01845045     ukb_AFR
1002560 1002560 -0.05126679     0.01461728      -0.09106646     0.06192548      -0.01045421     -0.05226747     0.003786898     0.06353808 0.03447247   -0.001364029    -0.01710308     0.004304632     0.0008717392    -0.0190005      0.002827138     -0.003705134    -0.001473413 0.006044929        -0.01078054     -0.00504672     ukb_AFR
1003036 1003036 -0.1145061      -0.02159879     0.02185083      -0.01156626     0.04841836      -0.004632897    0.004002478     -0.001414412    -0.004499457    -0.008808905    -0.01325884     0.002775132     0.01051974     -0.01290876 -0.001648434 -0.0006329809   -0.001934886 -0.001784676       0.01192168      -0.003431602    ukb_AFR
1004593 1004593 -0.105218       -0.009862499    0.02077679      -0.03174682     -0.05550549     0.001125085     0.001835        0.0002043254    0.01929151      0.003552434     0.004783147     0.0209848       -0.00339979    -0.008797007     0.007934304     -0.01611764     -0.005007673    0.008720545     -0.01115624     0.008553487     ukb_AFR
1008167 1008167 -0.09890507     -0.01256736     -0.02229432     0.09879038      -0.01613772     0.01430709      0.007016346     -0.001621529    -0.001749475    0.03302946      0.009270534     -0.01728505     -0.001844066   -0.001911498     -0.003486211    0.01333747      -0.0009225445   -0.01091033     0.006612811     0.003111421     ukb_AFR
1009965 1009965 -0.1144646      -0.01678158     0.02794845      -0.04601943     -0.04276241     0.007667866     -0.005256418    0.002732381     0.02931379      -0.006780359    -0.007257382    -0.005660453    0.009554902    -0.0003548697    -0.01683475     0.0232335 -0.004298369  0.004904626     -0.0002858674   0.002191906     ukb_AFR
1010953 1010953 -0.1162987      -0.0151895      0.01291233      -0.01975639     0.03860272      -0.01059661     0.00272378      -0.0003544893   -0.005087682    -0.004873468    -0.00357997     -0.00276457     -0.001642033   -0.007122534     0.01784744      0.01115313      -0.002351923    -0.00989843     0.004442268     -0.003581949    ukb_AFR
1012491 1012491 0.1974823       0.1503154 -0.256167  -0.1034129 0.02580212      0.1380414       0.001870625     0.08676538      -0.01502852     0.01928159      0.01958468      -0.009928409    -0.02209873     -0.01688895    0.04805649  -0.005137369 -0.0004968546   -0.0002838343   0.005522082     -0.008147094    ukb_AFR
1013297 1013297 -0.09335199     -0.004760656    0.03134298      -0.03298155     -0.03455676     0.008409651     -0.001868769    -0.01697865     0.01136585      0.007146101     0.006084252     -0.00285834     -0.007547934   0.004043744 -0.01031373  0.01298586      0.004537263  -0.002993897       -0.008761168    -0.006562762    ukb_AFR
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | wc            
   3904   89792 1026520
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/African/African/mturchin20/ukb_chrAll_v2.African.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.txt | grep ukb_AFR | wc
   3142   72266  827184
[  mturchin@node847  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`                                                                                                                                    
          ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>                                                                                                                                                                                                                              
  #       cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | grep -v PC1 | grep -v 1kG | awk '{ 
print $1 "\t" $2 }' > /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.no1kG.FIDIIDs
> #       plink --bfile /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX --keep /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1
}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.no1kG.FIDIIDs --make-bed --out /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/uk
b_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop
>
>         echo $ancestry1 $ancestry2
>
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.fam | wc
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.fam | wc
>
> done
African African
   3115   18690   77875
   3080   18480   77000
Any_other_Asian_background Any_other_Asian_background
   1697   10182   42425
   1657    9942   41425
Any_other_mixed_background Any_other_mixed_background
    983    5898   24575
    983    5898   24575
Any_other_white_background Any_other_white_background
  15503   93018  387575
  15282   91692  382050
British British
 351434 2108604 8785850
 351248 2107488 8781200
British British.Ran4000
   3876   23256   96900
   3867   23202   96675
British British.Ran10000
   9658   57948  241450
   9641   57846  241025
British British.Ran100000
  92394  554364 2309850
  92367  554202 2309175
British British.Ran200000
 176694 1060164 4417350
 176624 1059744 4415600
Caribbean Caribbean
   3854   23124   96350
   3662   21972   91550
Chinese Chinese
   1455    8730   36375
   1424    8544   35600
Indian Indian
   5203   31218  130075
   5158   30948  128950
Irish Irish
  11630   69780  290750
  11601   69606  290025
Pakistani Pakistani
   1604    9624   40100
   1597    9582   39925
(MultiEthnicGWAS) [  mturchin@node633  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/*/*/mturchin20/ukb_chrAll_v2.*.QCed.pruned.QCed.bim.noX.rsIDs | sort | uniq | wc
 314385  314385 3367027
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>         ancestry3=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`
>
>         echo $j
>         for i in {1..2}; do
>                 paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.wFullCovars.txt | awk -v iAwk=$i '{ print $(5+iAwk)}') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.txt | awk -v iAwk=$i '{ print $(2+iAwk) }') | awk '{ if ($1 != $2) { print $0 } }' | wc
>         done
> done
African;African;Afr
      1       1       5
      1       1       5
Any_other_Asian_background;Any_other_Asian_background;Asian
      1       1       5
      1       1       5
Any_other_mixed_background;Any_other_mixed_background;Mixed
      1       1       5
      1       1       5
Any_other_white_background;Any_other_white_background;White
      1       1       5
      1       1       5
British;British;Brit
      1       1       5
      1       1       5
British;British.Ran4000;Brit4k
      1       1       5
      1       1       5
British;British.Ran10000;Brit10k
      1       1       5
      1       1       5
British;British.Ran100000;Brit100k
      1       1       5
      1       1       5
British;British.Ran200000;Brit200k
      1       1       5
      1       1       5
Caribbean;Caribbean;Carib
      1       1       5
      1       1       5
Chinese;Chinese;Chi
      1       1       5
      1       1       5
Indian;Indian;Indn
      1       1       5
      1       1       5
Irish;Irish;Irish
      1       1       5
      1       1       5
Pakistani;Pakistani;Pkstn
      1       1       5
      1       1       5
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>         ancestry3=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[2];'`
> 
>         echo $j
>         for i in {1..10}; do
>                 paste <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.wFullCovars.txt | awk -v iAwk=$i '{ print $(5+iAwk)}') <(cat /users/mturchin/data/ukbiobank_jun17/subsets/${ancestry1}/${ancestry2}/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.pruned.QCed.dropRltvs.noX.PCAdrop.flashpca.pcs.txt | awk -v iAwk=$i '{ print $(2+iAwk) }') | awk '{ if ($1 != $2) { print $0 } }' | awk '{ if (NR > 1) { print $0 } }'
>         done
> done
African;African;Afr
Any_other_Asian_background;Any_other_Asian_background;Asian
Any_other_mixed_background;Any_other_mixed_background;Mixed
Any_other_white_background;Any_other_white_background;White
British;British;Brit
British;British.Ran4000;Brit4k
British;British.Ran10000;Brit10k
British;British.Ran100000;Brit100k
British;British.Ran200000;Brit200k
Caribbean;Caribbean;Carib
Chinese;Chinese;Chi
Indian;Indian;Indn
Irish;Irish;Irish
Pakistani;Pakistani;Pkstn
[  mturchin@node641  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);')`; do
>         ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>         ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>
>         echo "~~~~~~~~~~~~~~~~~~~"
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/ukb_chrAll_v2.${ancestry2}.QCed.imiss.SumStats.dropiMiss.FIDIIDs.QCcheck | head -n 5;
>
> done
~~~~~~~~~~~~~~~~~
African African 1
      3       6      48
   3205   19230   80125
   3202   19212   80050
African African 12
~~~~~~~~~~~~~~~~~
Any_other_Asian_background Any_other_Asian_background 21
      0       0       0
   1747   10482   43675
   1747   10482   43675
Any_other_Asian_background Any_other_Asian_background 15
~~~~~~~~~~~~~~~~~
Any_other_mixed_background Any_other_mixed_background 6
      1       2      16
    996    5976   24900
    995    5970   24875
Any_other_mixed_background Any_other_mixed_background 1
~~~~~~~~~~~~~~~~~
Any_other_white_background Any_other_white_background 21
      3       6      48
  15822   94932  395550
  15819   94914  395475
Any_other_white_background Any_other_white_background 22
~~~~~~~~~~~~~~~~~
British British 21
    198     396    3168
 431102 2586612 10777550
 430904 2585424 i0772600
British British 22
~~~~~~~~~~~~~~~~~
British British.Ran4000 21
      0       0       0
   3907   23442   97675
   3907   23442   97675
British British.Ran4000 22
~~~~~~~~~~~~~~~~~
British British.Ran10000 16
      3       6      48
   9743   58458  243575
   9740   58440  243500
British British.Ran10000 12
~~~~~~~~~~~~~~~~~
British British.Ran100000 15
     45      90     720
  97344  584064 2433600
  97299  583794 2432475
British British.Ran100000 14
~~~~~~~~~~~~~~~~~
British British.Ran200000 22
     91     182    1456
 194783 1168698 4869575
 194692 1168152 4867300
British British.Ran200000 21
~~~~~~~~~~~~~~~~~
Caribbean Caribbean 18
      3       6      48
   4299   25794  107475
   4296   25776  107400
Caribbean Caribbean 20
~~~~~~~~~~~~~~~~~
Chinese Chinese 11
      2       4      32
   1504    9024   37600
   1502    9012   37550
Chinese Chinese 21
~~~~~~~~~~~~~~~~~~~
Indian Indian 16
Indian Indian 14
      1       2      16
      1       2      16
   5716   34296  142900
~~~~~~~~~~~~~~~~~
Irish Irish 22
      4       8      64
  12759   76554  318975
  12755   76530  318875
Irish Irish 18
~~~~~~~~~~~~~~~~~
Pakistani Pakistani 11
      2       4      32
   1748   10488   43700
   1746   10476   43650
Pakistani Pakistani 21
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);' | grep -E "Height|BMI"`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep -v Ran100000\; | grep -v Ran200000\; | grep -v British.British\;`; do
> #       for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep -v Ran4000\; | grep -v Ran10000\;`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
>
>                 echo $pheno1 $ancestry1 $ancestry2
>                 zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.assoc.linear.gz | wc
>                 zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz | wc
>                 zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.gz | wc
>
>         done
> done
Height African African
4928145 44353305 266839666
 379089 3411801 20851978
     31     372    3211
Height Any_other_Asian_background Any_other_Asian_background
6363683 57273147 352464414
 489515 4405635 26918021
     50     600    5853
Height Any_other_mixed_background Any_other_mixed_background
7925386 71328474 431748006
 609646 5486814 32887460
     49     588    5476
Height Any_other_white_background Any_other_white_background
7828497 70456473 441450506
 602193 5419737 34036702
    203    2436   38832
Height British British.Ran4000
7880510 70924590 424833342
 606194 5455746 33498429
     62     744    9214
Height British British.Ran10000
7852131 70669179 423598249
 604011 5436099 33481647
    129    1548   20811
Height Caribbean Caribbean
5394923 48554307 288046858
 414995 3734955 22840118
     62     744    6908
Height Chinese Chinese
4541421 40872789 249528328
 349341 3144069 19179841
     27     324    3658
Height Indian Indian
6649813 59848317 362559678
 511525 4603725 28254909
     60     720    7816
Height Irish Irish
7729008 69561072 432424381
 594540 5350860 33577317
    136    1632   22659
Height Pakistani Pakistani
6794555 61150995 375575465
 522659 4703931 28757761
     58     696    6579
BMI African African
4928145 44353305 269839574
 379089 3411801 20892116
     41     492    4370
BMI Any_other_Asian_background Any_other_Asian_background
6363683 57273147 351025100
 489515 4405635 26993385
     72     864    8166
BMI Any_other_mixed_background Any_other_mixed_background
7925386 71328474 425945850
 609646 5486814 32938486
     96    1152   10303
BMI Any_other_white_background Any_other_white_background
7828497 70456473 443376863
 602193 5419737 34120040
     93    1116   11839
BMI British British.Ran4000
7880510 70924590 431791713
 606194 5455746 33569448
     63     756    7355
BMI British British.Ran10000
7852131 70669179 432176556
 604011 5436099 33571956
     56     672    6618
BMI Caribbean Caribbean
5394923 48554307 293901866
 414995 3734955 22861533
     35     420    4070
BMI Chinese Chinese
4541421 40872789 246974579
 349341 3144069 19250542
     25     300    2834
BMI Indian Indian
6649813 59848317 366031885
 511525 4603725 28333203
     49     588    6569
BMI Irish Irish
7729008 69561072 428159842
 594540 5350860 33659551
     68     816    7908
BMI Pakistani Pakistani
6794555 61150995 373707145
 522659 4703931 28817848
     73     876    8399
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for pheno1 in `echo "Height BMI Waist Hip" | perl -lane 'print join("\n", @F);' | grep -E "Height|BMI"`; do
> #       for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep -v Ran100000\; | grep -v Ran200000\; | grep -v British.British\;`; do
>         for j in `cat <(echo $UKBioBankPops | perl -lane 'print join("\n", @F);') | grep British | grep -v Ran4000\; | grep -v Ran10000\;`; do
>                 ancestry1=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[0];'`
>                 ancestry2=`echo $j | perl -ane 'my @vals1 = split(/;/, $F[0]); print $vals1[1];'`
> 
>                 echo $pheno1 $ancestry1 $ancestry2
>                 zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.assoc.linear.gz | wc
>                 zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.gz | wc
>                 zcat /users/mturchin/data/ukbiobank_jun17/subsets/$ancestry1/$ancestry2/mturchin20/$pheno1/ukb_chrAll_v2.${ancestry2}.QCed.QCed.dropRltvs.PCAdrop.noX.${pheno1}.ADD.assoc.linear.clumped.gz | wc
> 
>         done
> done
Height British British
7206707 64860363 405871574
 554363 4989267 32268257
   2151   25812  371181
Height British British.Ran100000
7533423 67800807 423429108
 579495 5215455 32984034
    358    4296   76396
Height British British.Ran200000
7399055 66591495 414626717
 569159 5122431 33043081
    846   10152  166100
BMI British British
7206707 64860363 413599776
 554363 4989267 32307830
    469    5628   88974
BMI British British.Ran100000
7533423 67800807 419061659
 579495 5215455 33054893
     30     360    6193
BMI British British.Ran200000
7399055 66591495 426211471
 569159 5122431 33101239
    116    1392   22422
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$myjobinfo

Info about jobs for user 'mturchin' submitted since 2018-04-25T00:00:00
Use option '-S' for a different date
 or option '-j' for a specific Job ID.

       JobID    JobName              Submit      State    Elapsed     ReqMem     MaxRSS
------------ ---------- ------------------- ---------- ---------- ---------- ----------
19248104             63 2018-04-17T01:59:54    RUNNING 8-15:07:28      100Gn
19248105             63 2018-04-17T01:59:54    RUNNING 8-15:07:28      100Gn
19248106             63 2018-04-17T01:59:54    RUNNING 8-15:07:28      100Gn
19248107             63 2018-04-17T01:59:54    RUNNING 8-15:07:28      100Gn
19248108             63 2018-04-17T01:59:54  COMPLETED 8-02:52:36      100Gn
19248108.ba+      batch 2018-04-17T01:59:59  COMPLETED 8-02:52:36      100Gn  26504424K #NOTE -- bytes for run of ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q
19248109             63 2018-04-17T01:59:55    RUNNING 8-15:07:28      100Gn
19309106       interact 2018-04-24T17:55:33    RUNNING   23:08:58        8Gn
19309106.0         bash 2018-04-24T17:58:31    RUNNING   23:08:56        8Gn

'ReqMem' shows the requested memory:
 A 'c' at the end of number represents Memory Per CPU, a 'n' represents Memory Per Node.
'MaxRSS' is the maximum memory used on any one node.
Note that memory specified to sbatch using '--mem' is Per Node.
(MultiEthnicGWAS) [  mturchin@login002  ~/data/dbGaP]$du -h | perl -lane 'my @vals = split(/\//, $F[1]); if ($#vals <= 2) { print join("\t", @F); }'
3.8G    ./PAGE/MEC
491M    ./PAGE/BioVU
984G    ./PAGE/IPMBioME
155G    ./PAGE/GblRefPnl
12M     ./PAGE/Summary
1.2T    ./PAGE
15G     ./eMERGE/NetworkPhenos
665G    ./eMERGE/41Phenos
679G    ./eMERGE
6.1G    ./CHARGE/GRU
6.1G    ./CHARGE
1.8T    .
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.fam | wc
 351830 2110980 8795750
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.pop | wc
 351830  351830  704896
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q | wc        
 351830  703660 6332940
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.
dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,8], c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,8], c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1)));

  (0,0.1] (0.1,0.2] (0.2,0.3] (0.3,0.4] (0.4,0.5] (0.5,0.6] (0.6,0.7] (0.7,0.8]
     1622       158       165       453      1151       978      2377      3881
(0.8,0.9]   (0.9,1]
   139253    201792
>
>
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join -a 1 -e NA -o 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 1.24 2.2 2.3 <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | awk '{ print $1 "_" $2 "\t" $8 "\t" $9 }' | sort -k 1,1) | head -n 10
1000010 1000010 -0.003599522 0.007647965 0.0005865567 -0.00489084 0.004771263 -0.003277785 0.005902177 0.0008221965 -0.004340097 0.000403033 Brit 0.907788 0.092212
1000028 1000028 -0.005514332 0.002658349 -0.01359272 0.03205603 -0.01303472 -0.0008958616 -0.006021335 0.0008436244 -0.0003250187 -0.001692929 Brit 0.955502 0.044498
1000034 1000034 -0.002592185 0.004516219 -0.0006781089 0.01852516 -0.006366412 0.002113441 0.0007143013 0.003781858 0.006932807 -0.01352818 Brit 0.900208 0.099792
1000052 1000052 -0.009982592 0.002017156 -0.008888998 -0.003530922 -0.003095497 -0.001020271 0.01020135 -0.0007155408 0.004804014 0.0006607609 Brit 0.962077 0.037923
1000087 1000087 -0.0006924554 0.002109503 -0.006056935 0.007865318 0.006068911 0.0009898732 -0.00240463 0.001571178 0.00365905 -0.006081467 Brit 0.922014 0.077986
1000091 1000091 -0.003188127 0.002573618 -0.004856461 0.006123316 0.007489638 0.003530859 0.003091557 0.006280972 0.001805805 -0.008896825 Brit 0.923568 0.076432
1000118 1000118 -0.00558069 0.002778327 0.005192975 -0.002015579 0.002182655 -0.0004847087 0.002566985 0.002252738 -0.002684748 0.0002728846 Brit 0.890508 0.109492
1000120 1000120 -0.004929173 -0.0006713002 -0.0001761087 -0.01301911 0.0001477494 0.004673278 -0.005665519 -0.001767635 -0.009664564 -0.0003985193 Brit 0.912599 0.087401
1000133 1000133 0.002422148 -0.002015878 -0.005629867 0.01136558 -0.001132653 0.002621813 0.008656357 -0.0008895999 -0.007331995 0.004300502 Brit 0.904975 0.095025
1000147 1000147 -0.001346005 0.0001900922 0.01048563 -0.002833249 0.01084346 0.003844229 0.0161348 -0.0004322772 0.01885066 9.420449e-05 Brit 0.851101 0.148899
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join -a 1 -e NA -o 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 1.24 2.2 2.3 <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | awk '{ print $1 "_" $2 "\t" $8 "\t" $9 }' | sort -k 1,1) | grep ASW | head -n 10
NA19625 NA19625 0.6184778 0.06436206 -0.08493666 -0.01268893 0.01071539 0.09628969 -0.0008550974 0.003721807 0.001250528 -0.006746007 1kG_ASW NA NA
NA19700 NA19700 0.6966187 0.2226698 -0.05743258 -0.009881946 -0.003579904 -0.003273102 -0.01039988 0.0130645 -0.0006978778 -0.001377554 1kG_ASW NA NA
NA19701 NA19701 0.7159788 0.2175532 -0.06519981 -0.005382269 0.0007043274 0.01356744 -0.006888474 0.005382841 0.005160664 0.001869222 1kG_ASW NA NA
NA19703 NA19703 0.7061361 0.226503 -0.05899938 0.004160216 0.002288756 -0.002011585 -0.005811621 0.02307956 0.000388238 0.003676506 1kG_ASW NA NA
NA19704 NA19704 0.7123394 0.2041479 -0.07302964 -0.005456321 -0.0002950597 -0.004652862 -0.003538038 0.01245724 -0.000243204 -0.002962481 1kG_ASW NA NA
NA19707 NA19707 0.6164143 0.1820688 -0.06244063 -0.006904424 -0.0006512758 -0.0002201245 -0.00189954 0.003676534 0.001683821 0.002338388 1kG_ASW NA NA
NA19711 NA19711 0.7493507 0.2284493 -0.06745015 -0.009441467 0.0090045 -0.0006531658 -0.007274752 0.01026133 0.002196734 -0.002368005 1kG_ASW NA NA
NA19712 NA19712 0.7437087 0.2257017 -0.07887202 -0.006137153 0.005824886 0.002202931 -0.005472634 0.002867819 0.000395768 -0.001958242 1kG_ASW NA NA
NA19713 NA19713 0.6295787 0.201855 -0.0569228 -0.007282128 -0.003531183 -0.001333904 -0.004538106 0.01974986 0.004531239 0.006829776 1kG_ASW NA NA
NA19818 NA19818 0.6188759 0.1879283 -0.06267238 -0.004099149 0.006939395 0.007706227 0.003355213 -0.006570511 0.007234533 0.001828544 1kG_ASW NA NA
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | wc
 352357 8104211 94994324
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | wc
 351831 3166479 18294798
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join -a 1 -e NA -o 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 1.24 2.2 2.3 <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | awk '{ print $1 "_" $2 "\t" $8 "\t" $9 }' | sort -k 1,1) | wc                   
 352357 5285355 57531877
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.TSIIBSFIN.flashpca.pcs.wAncs.txt | wc
 352856 8115688 95122739
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | wc
 351831 3166479 18294798
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.wPCs | wc
 352856 5292840 57617318
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.TSIIBSFIN.flashpca.pcs.wAncs.txt | grep Brit | wc
 351434 8082982 94746359
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep Brit | wc
 351434 3162906 18274568
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.wPCs | grep Brit | wc
 351434 5271510 57403984
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.flashpca.pcs.wAncs.QCed.txt | grep Brit | wc
 351248 8078704 94700009
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for i in `echo .1 .2 .3 .4 .5 .6 .7 .8 .9 1`; do echo $i;
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 <= awkI) { print $0 } } ' | wc
> done
.1
   1515   13635   78780
.2
   1673   15057   86996
.3
   1838   16542   95576
.4
   2291   20619  119132
.5
   3442   30978  178984
.6
   4420   39780  229840
.7
   6797   61173  353444
.8
  10675   96075  555100
.9
 149843 1348587 7791836
1
 351434 3162906 18274568
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for i in `echo .8 .825 .85 .875 .9 .925 .95 .975 .99 1`; do echo $i;
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 >= awkI) { print $0 } } ' | wc
> done
.8
 340759 3066831 17719468
.825
 338268 3044412 17589936
.85
 330132 2971188 17166864
.875
 293621 2642589 15268292
.9
 201597 1814373 10483044
.925
  94536  850824 4915872
.95
  30942  278478 1608984
.975
   7067   63603  367484
.99
   2427   21843  126204
1
      0       0       0
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurGTEpt9.FIDIIDs | wc
 201597  403194 3225552
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurGTEpt95.FIDIIDs | wc
  30942   61884  495072
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurLTEpt8.FIDIIDs | wc
  10675   10675  170800
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.NEurLTEpt8_NEurGTEpt9_Ran10k.FIDIIDs | wc
  20675   30675  330800
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.d
ropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | R -q -e "Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,8], c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1)));"
> Data1 <- read.table(file('stdin'), header=T); table(cut(Data1[,8], c(0, .1, .2, .3, .4, .5, .6, .7, .8, .9, 1)));

  (0,0.1] (0.1,0.2] (0.2,0.3] (0.3,0.4] (0.4,0.5] (0.5,0.6] (0.6,0.7] (0.7,0.8]
     1632       166       158       515      1112      1014      2386      3961
(0.8,0.9]   (0.9,1]
   145095    195791
>
>
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for i in `echo .1 .2 .3 .4 .5 .6 .7 .8 .9 1`; do echo $i;
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 <= awkI) { print $0 } } ' | wc
> done
.1 
   1525   13725   79300
.2 
   1691   15219   87932
.3 
   1849   16641   96148
.4 
   2364   21276  122928
.5 
   3476   31284  180752
.6 
   4490   40410  233480
.7 
   6876   61884  357552
.8
  10834   97506  563368
.9
 155844 1402596 8103888
1
 351434 3162906 18274568
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$for i in `echo .8 .825 .85 .875 .9 .925 .95 .975 .99 1`; do echo $i;
>         cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo | grep UKB_Brit | awk -v awkI=$i '{ if ($8 >= awkI) { print $0 } } ' | wc
> done
.8
 340600 3065400 17711200
.825
 337944 3041496 17573088
.85
 328841 2959569 17099732
.875
 289347 2604123 15046044
.9
 195600 1760400 10171200
.925
  91085  819765 4736420
.95
  29948  269532 1557296
.975
   6942   62478  360984
.99
   2426   21834  126152
1
      0       0       0
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$myjobinfo

Info about jobs for user 'mturchin' submitted since 2018-04-27T00:00:00
Use option '-S' for a different date
 or option '-j' for a specific Job ID. 

       JobID    JobName              Submit      State    Elapsed     ReqMem     MaxRSS 
------------ ---------- ------------------- ---------- ---------- ---------- ---------- 
19248104             63 2018-04-17T01:59:54    RUNNING 10-11:36:53      100Gn            
19248105             63 2018-04-17T01:59:54    RUNNING 10-11:36:53      100Gn            
19248106             63 2018-04-17T01:59:54    RUNNING 10-11:36:53      100Gn            
19248107             63 2018-04-17T01:59:54    RUNNING 10-11:36:53      100Gn            
19248109             63 2018-04-17T01:59:55  COMPLETED 10-07:19:05      100Gn            
19248109.ba+      batch 2018-04-17T01:59:59  COMPLETED 10-07:19:05      100Gn  26504360K #NOTE -- bytes for run of ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q 
19309106       interact 2018-04-24T17:55:33    RUNNING 2-19:38:23        8Gn            
19309106.0         bash 2018-04-24T17:58:31    RUNNING 2-19:38:21        8Gn            
19322709       interact 2018-04-26T16:52:37    RUNNING   20:44:07       20Gn            
19322709.0         bash 2018-04-26T16:52:46    RUNNING   20:44:06       20Gn            

'ReqMem' shows the requested memory:
 A 'c' at the end of number represents Memory Per CPU, a 'n' represents Memory Per Node.
'MaxRSS' is the maximum memory used on any one node.
Note that memory specified to sbatch using '--mem' is Per Node. 
(MultiEthnicGWAS) [  mturchin@node655  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$R -q -e "Data1 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo\", header=T); Data2 <- read.table(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo\", header=T); Data1 <- cbind(Data1, paste(Data1[,1], \"_\", Data1[,2], sep=\"\")); colnames(Data1) <- c(colnames(Data1)[-length(colnames(Data1))], \"FIDIID\"); Data2 <- cbind(Data2, paste(Data2[,1], \"_\", Data2[,2], sep=\"\")); colnames(Data2) <- c(colnames(Data2)[-length(colnames(Data2))], \"FIDIID\"); Data3 <- merge(Data1[Data1[,7] == \"UKB_Brit\", c(8,10)], Data2[Data2[,7] == \"UKB_Brit\", c(8,10)], by=\"FIDIID\"); head(Data3); cor(Data3[,2], Data3[,3]); png(\"/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.vsIBS_Qs.plot.vs1.png\", height=2000, width=2000, res=300); par(mar=c(5,5,4,2)); plot(Data3[,2], Data3[,3], xlab=\"TSI\", ylab=\"IBS\", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); abline(a=0, b=1, lwd=2); dev.off();"
> Data1 <- read.table("/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo", header=T); Data2 <- read.table("/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRIBS.mltiThrd.16.2.Q.wInfo", header=T); Data1 <- cbind(Data1, paste(Data1[,1], "_", Data1[,2], sep="")); colnames(Data1) <- c(colnames(Data1)[-length(colnames(Data1))], "FIDIID"); Data2 <- cbind(Data2, paste(Data2[,1], "_", Data2[,2], sep="")); colnames(Data2) <- c(colnames(Data2)[-length(colnames(Data2))], "FIDIID"); Data3 <- merge(Data1[Data1[,7] == "UKB_Brit", c(8,10)], Data2[Data2[,7] == "UKB_Brit", c(8,10)], by="FIDIID"); head(Data3); cor(Data3[,2], Data3[,3]); png("/users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/admixture/ukb_chrAll_v2.British.QCed.pruned.QCed.dropRltvs.noX.1kG.FINCEUGBRTSI.mltiThrd.16.2.Q.wInfo.vsIBS_Qs.plot.vs1.png", height=2000, width=2000, res=300); par(mar=c(5,5,4,2)); plot(Data3[,2], Data3[,3], xlab="TSI", ylab="IBS", cex=1.5, cex.main=1.5, cex.axis=1.5, cex.lab=1.5); abline(a=0, b=1, lwd=2); dev.off();
           FIDIID     Q1.x     Q1.y
1 1000010_1000010 0.907788 0.906883
2 1000028_1000028 0.955502 0.956391
3 1000034_1000034 0.900208 0.898419
4 1000052_1000052 0.962077 0.962581
5 1000087_1000087 0.922014 0.920621
6 1000091_1000091 0.923568 0.921129
[1] 0.9999515
null device
          1
>
>
(MultiEthnicGWAS) [  mturchin@node964  ~/data2/Neale2017]$zcat ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz | wc
 337200 1348800 18891378
(MultiEthnicGWAS) [  mturchin@login002  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data2/Neale2017/50.assoc.tsv.gz | wc
10894597 98051373 1161960549
(MultiEthnicGWAS) [  mturchin@node964  ~/data2/Neale2017]$zcat 50.assoc.tsv.gz | head -n 10
variant rsid    nCompleteSamples        AC      ytx     beta    se      tstat   pval
5:43888254:C:T  rs13184706      336474  1.23213e+04     3.83186e+02     -1.33660e-02    6.48300e-03     -2.06170e+00    3.92375e-02
5:43888493:C:T  rs58824264      336474  2.42483e+03     3.70381e+01     -1.88438e-02    1.44299e-02     -1.30589e+00    1.91592e-01
5:43888556:T:C  rs72762387      336474  1.64428e+04     6.65756e+02     -9.45691e-03    5.62698e-03     -1.68064e+00    9.28345e-02
5:43888648:C:T  rs115032754     336474  1.35047e+04     5.66843e+02     1.06178e-03     6.29484e-03     1.68674e-01     8.66053e-01
5:43888690:C:G  rs147555725     336474  1.24755e+03     4.51586e+01     -4.19957e-03    2.06522e-02     -2.03347e-01    8.38864e-01
5:43888838:G:C  rs13185925      336474  2.33424e+04     8.95665e+02     -8.69909e-03    4.74596e-03     -1.83294e+00    6.68117e-02
5:43889057:C:T  rs13189727      336474  1.25266e+04     4.21457e+02     -1.25947e-02    6.42476e-03     -1.96034e+00    4.99575e-02
5:43889207:A:G  rs4516856       336474  6.69113e+05     2.89791e+04     1.96508e-02     1.14359e-02     1.71835e+00     8.57338e-02
5:43889333:G:T  rs114787943     336474  3.03587e+03     5.56253e+01     -1.58425e-02    1.28856e-02     -1.22947e+00    2.18896e-01
(MultiEthnicGWAS) [  mturchin@node964  ~/data2/Neale2017]$zcat ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz | wc
 337200 1348800 18891378
(MultiEthnicGWAS) [  mturchin@node964  ~/data2/Neale2017]$zcat 50.assoc.tsv.gz | sed 's/:/ /g' | perl -lane 'print "chr", $F[0], "\t", $F[1], "\t", $F[1], "\t", join("_", @F[8,9,11]);' | head -n 10
chrvariant      rsid    rsid    pval__
chr5    43888254        43888254        -1.33660e-02_6.48300e-03_3.92375e-02
chr5    43888493        43888493        -1.88438e-02_1.44299e-02_1.91592e-01
chr5    43888556        43888556        -9.45691e-03_5.62698e-03_9.28345e-02
chr5    43888648        43888648        1.06178e-03_6.29484e-03_8.66053e-01
chr5    43888690        43888690        -4.19957e-03_2.06522e-02_8.38864e-01
chr5    43888838        43888838        -8.69909e-03_4.74596e-03_6.68117e-02
chr5    43889057        43889057        -1.25947e-02_6.42476e-03_4.99575e-02
chr5    43889207        43889207        1.96508e-02_1.14359e-02_8.57338e-02
chr5    43889333        43889333        -1.58425e-02_1.28856e-02_2.18896e-01
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.gz | awk '{ print "chr" $1 "\t" $3 "\t" $3 "\t" $7 "_" $9 }' | head -n 10
chrCHR  BP      BP      BETA_P
chr1    39542062        39542062        -0.02871_0.5959
chr1    39917888        39917888        0.1141_0.001633
chr1    40160585        40160585        0.07605_0.0001994
chr1    40773149        40773149        -0.1587_3.627e-18
chr1    41256213        41256213        -0.08959_0.0001172
chr1    43131653        43131653        0.02538_0.2747
chr1    43395635        43395635        0.006806_0.7148
chr1    44083519        44083519        -0.03953_0.02394
chr1    44084739        44084739        -0.04143_0.0181
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.gz | awk '{ print "chr" $1 "\t" $3 "\t" $3 "\t" $7 "_" $9 }' | grep -v chrCHR | head -n 10
chr1    39542062        39542062        -0.02871_0.5959
chr1    39917888        39917888        0.1141_0.001633
chr1    40160585        40160585        0.07605_0.0001994
chr1    40773149        40773149        -0.1587_3.627e-18
chr1    41256213        41256213        -0.08959_0.0001172
chr1    43131653        43131653        0.02538_0.2747
chr1    43395635        43395635        0.006806_0.7148
chr1    44083519        44083519        -0.03953_0.02394
chr1    44084739        44084739        -0.04143_0.0181
chr1    44086831        44086831        -0.03932_0.01469
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed -b /users/mturchin/data2/Neale2017/50.assoc.edits.bed.gz | wc
   2126   17008  201334
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed | wc
   2150    8600   73808
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed -b /users/mturchin/data2/Neale2017/50.assoc.edits.bed.gz | head -n 10
chr1    2113565 2113565 rs262688        chr1    2113565 2113565 1.57067e-02_1.93481e-03_4.75613e-16
chr1    8173369 8173369 rs7524424       chr1    8173369 8173369 -1.33126e-02_2.21580e-03_1.87992e-09
chr1    8469789 8469789 rs2661868       chr1    8469789 8469789 1.26358e-02_2.00724e-03_3.07566e-10
chr1    9329289 9329289 rs2071931       chr1    9329289 9329289 -1.31705e-02_2.06878e-03_1.93903e-10
chr1    9339467 9339467 rs9442580       chr1    9339467 9339467 2.67008e-02_2.57769e-03_3.86531e-25
chr1    10234035        10234035        rs12074936      chr1    10234035        10234035        2.05130e-02_2.73605e-03_6.52981e-14
chr1    10308958        10308958        rs4846204       chr1    10308958        10308958        2.12421e-02_2.59306e-03_2.58020e-16
chr1    10496944        10496944        rs643400        chr1    10496944        10496944        9.06957e-03_1.72791e-03_1.53127e-07
chr1    11166302        11166302        rs79558202      chr1    11166302        11166302        -1.52189e-02_1.97320e-03_1.23415e-14
chr1    17306029        17306029        rs9435731       chr1    17306029        17306029        2.88937e-02_1.72613e-03_7.21745e-63
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data2/Neale2017/UKBB_GWAS_Manifest_20170915 | head -n 10
Phenotype code  Description     File    wget command    Dropbox address 
N/A     Generic ID file of QC'ed samples        ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz    wget https://www.dropbox.com/s/f8ylaxjp4b0h5ti/ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz?dl=0 -O ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz        https://www.dropbox.com/s/f8ylaxjp4b0h5ti/ukb_sqc_v2.nealelab_UKBBqc_n377199.id.tsv.gz?dl=0
N/A     List of variants included in the analysis       variants.tsv    wget https://www.dropbox.com/s/ehnp53rfqmp6xjg/variants.tsv?dl=0 -O variants.tsv        https://www.dropbox.com/s/ehnp53rfqmp6xjg/variants.tsv?dl=0
N/A     All partioned heritability results      ukbb_all_h2part_results.txt.gz  wget https://www.dropbox.com/s/5ocbe54p4grmadx/ukbb_all_h2part_results.txt.gz?dl=0 -O ukbb_all_h2part_results.txt.gz    https://www.dropbox.com/s/5ocbe54p4grmadx/ukbb_all_h2part_results.txt.gz?dl=0   
N/A     All univariate heritability results     ukbb_all_h2univar_results.txt.gz        wget https://www.dropbox.com/s/mc0maiaykzn2qbm/ukbb_all_h2univar_results.txt.gz?dl=0 -O ukbb_all_h2univar_results.txt.gz        https://www.dropbox.com/s/mc0maiaykzn2qbm/ukbb_all_h2univar_results.txt.gz?dl=0 
N/A     Description of phenotypes acquired under application 111898 and 18597   phenosummary_final_11898_18597.tsv      wget https://www.dropbox.com/s/oe5q85454vhc3hi/phenosummary_final_11898_18597.tsv?dl=0  -O phenosummary_final_11898_18597.tsv   https://www.dropbox.com/s/oe5q85454vhc3hi/phenosummary_final_11898_18597.tsv?dl=0
1001    Duration of strenuous sports    1001.assoc.tsv.gz       wget https://www.dropbox.com/s/gajw23nukbv6uko/1001.assoc.tsv.gz?dl=0 -O 1001.assoc.tsv.gz      https://www.dropbox.com/s/gajw23nukbv6uko/1001.assoc.tsv.gz?dl=0

1210    Snoring 1210.assoc.tsv.gz       wget https://www.dropbox.com/s/ll9o0k40tvo4jju/1210.assoc.tsv.gz?dl=0 -O 1210.assoc.tsv.gz      https://www.dropbox.com/s/ll9o0k40tvo4jju/1210.assoc.tsv.gz?dl=0
1239    Current tobacco smoking 1239.assoc.tsv.gz       wget https://www.dropbox.com/s/5h5cmp97w4q5plh/1239.assoc.tsv.gz?dl=0 -O 1239.assoc.tsv.gz      https://www.dropbox.com/s/5h5cmp97w4q5plh/1239.assoc.tsv.gz?dl=0
1220    Daytime dozing / sleeping (narcolepsy)  1220.assoc.tsv.gz       wget https://www.dropbox.com/s/0trpqhos7ck0gph/1220.assoc.tsv.gz?dl=0 -O 1220.assoc.tsv.gz      https://www.dropbox.com/s/0trpqhos7ck0gph/1220.assoc.tsv.gz?dl=0
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data2/Neale2017/UKBB_GWAS_Manifest_20170915 | wc
   2425   33532  684478
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data2/Neale2017/UKBB_GWAS_Manifest_20170915 | perl -F\\t -lane 'print $#F;' | sort | uniq -c   
   2425 4
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.edits.bed.gz | wc
 554363 2217452 22020655
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.edits.bed.gz | awk '{ print $1 "_" $2 "\t" $4 }' | sort -k 1,1) | head -n 10
chr10_100017453 chr10 100017453 100017453 rs1983864 0.1332_6.665e-17
chr10_101999746 chr10 101999746 101999746 rs17729876 -0.08437_2.747e-08
chr10_102269085 chr10 102269085 102269085 rs3793706 -0.1235_1.313e-11
chr10_102684380 chr10 102684380 102684380 rs10883563 -0.1514_2.291e-23
chr10_103894609 chr10 103894609 103894609 rs75709864 0.187_5.035e-09
chr10_104269217 chr10 104269217 104269217 rs2281880 -0.1987_6.566e-39
chr10_104653717 chr10 104653717 104653717 rs12763665 0.1183_2.206e-14
chr10_104736855 chr10 104736855 104736855 rs72847291 0.2363_1.089e-12
chr10_104738011 chr10 104738011 104738011 rs74808043 -0.3367_9.203e-09
chr10_105500520 chr10 105500520 105500520 rs879544 0.1427_1.399e-15
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.edits.bed.gz | awk '{ print $1 "_" $2 "\t" $4 }' | sort -k 1,1) | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5 "_" $6 }' | head -n 10
chr10   100017453       100017453       rs1983864_0.1332_6.665e-17
chr10   101999746       101999746       rs17729876_-0.08437_2.747e-08
chr10   102269085       102269085       rs3793706_-0.1235_1.313e-11
chr10   102684380       102684380       rs10883563_-0.1514_2.291e-23
chr10   103894609       103894609       rs75709864_0.187_5.035e-09
chr10   104269217       104269217       rs2281880_-0.1987_6.566e-39
chr10   104653717       104653717       rs12763665_0.1183_2.206e-14
chr10   104736855       104736855       rs72847291_0.2363_1.089e-12
chr10   104738011       104738011       rs74808043_-0.3367_9.203e-09
chr10   105500520       105500520       rs879544_0.1427_1.399e-15
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$join <(cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed | awk '{ print $1 "_" $2 "\t" $0 }' | sort -k 1,1) <(zcat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.edits.bed.gz | awk '{ print $1 "_" $2 "\t" $4 }' | sort -k 1,1) | awk '{ print $2 "\t" $3 "\t" $4 "\t" $5 "_" $6 }' | wc        
   2150    8600  111265
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.bed | wc
   2150    8600   73808
MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/Neale2017/50.assoc.edits.bed.gz | sed 's/_/ /g' | head -n 10
chr10   100017453       100017453       rs1983864 G 0.1332 6.665e-17    chr10   100017453       100017453       G 1.61847e-02 1.82139e-03 6.37221e-19
chr10   101999746       101999746       rs17729876 A -0.08437 2.747e-08 chr10   101999746       101999746       A -1.06935e-02 1.73428e-03 7.01486e-10
chr10   102269085       102269085       rs3793706 A -0.1235 1.313e-11   chr10   102269085       102269085       A -1.26849e-02 2.07846e-03 1.04194e-09
chr10   102684380       102684380       rs10883563 C -0.1514 2.291e-23  chr10   102684380       102684380       A 1.66335e-02 1.73262e-03 8.02755e-22
chr10   103894609       103894609       rs75709864 T 0.187 5.035e-09    chr10   103894609       103894609       T 2.07535e-02 3.65019e-03 1.30472e-08
chr10   104269217       104269217       rs2281880 G -0.1987 6.566e-39   chr10   104269217       104269217       A 2.24880e-02 1.73310e-03 1.71916e-38
chr10   104653717       104653717       rs12763665 A 0.1183 2.206e-14   chr10   104653717       104653717       A 1.27449e-02 1.76699e-03 5.49445e-13
chr10   104736855       104736855       rs72847291 G 0.2363 1.089e-12   chr10   104736855       104736855       G 2.39401e-02 3.75997e-03 1.92898e-10
chr10   104738011       104738011       rs74808043 T -0.3367 9.203e-09  chr10   104738011       104738011       T -3.80366e-02 6.64563e-03 1.04406e-08
chr10   105500520       105500520       rs879544 C 0.1427 1.399e-15     chr10   105500520       105500520       C 1.53555e-02 2.03908e-03 5.06226e-14
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/Neale2017/50.assoc.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | head -n 10                                                                                                                                                                                                                 G       0.1332          6.665e-17       G       1.61847e-02     6.37221e-19
A       -0.08437                2.747e-08       A       -1.06935e-02    7.01486e-10
A       -0.1235         1.313e-11       A       -1.26849e-02    1.04194e-09
C       -0.1514         2.291e-23       A       1.66335e-02     8.02755e-22
T       0.187           5.035e-09       T       2.07535e-02     1.30472e-08
G       -0.1987         6.566e-39       A       2.24880e-02     1.71916e-38
A       0.1183          2.206e-14       A       1.27449e-02     5.49445e-13
G       0.2363          1.089e-12       G       2.39401e-02     1.92898e-10
T       -0.3367         9.203e-09       T       -3.80366e-02    1.04406e-08
C       0.1427          1.399e-15       C       1.53555e-02     5.06226e-14
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/Neale2017/50.assoc.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | perl -lane 'if ($F[0] ne $F[3]) { $F[3] = $F[0]; $F[4] = -1 * $F[4]; } print join("\t", @F);' | head -n 10
G       0.1332  6.665e-17       G       1.61847e-02     6.37221e-19
A       -0.08437        2.747e-08       A       -1.06935e-02    7.01486e-10
A       -0.1235 1.313e-11       A       -1.26849e-02    1.04194e-09
C       -0.1514 2.291e-23       C       -0.0166335      8.02755e-22
T       0.187   5.035e-09       T       2.07535e-02     1.30472e-08
G       -0.1987 6.566e-39       G       -0.022488       1.71916e-38
A       0.1183  2.206e-14       A       1.27449e-02     5.49445e-13
G       0.2363  1.089e-12       G       2.39401e-02     1.92898e-10
T       -0.3367 9.203e-09       T       -3.80366e-02    1.04406e-08
C       0.1427  1.399e-15       C       1.53555e-02     5.06226e-14
[  mturchin@login002  ~/data2/Loh2017]$zcat /users/mturchin/data2/Loh2017/body_HEIGHTz.sumstats.gz | head -n 10
SNP     CHR     POS     A1      A2      REF     EAF     Beta    se      P       N       INFO
rs10399793      1       49298   T       C       T       0.376205        -0.00104841     0.00272961      8.6E-01 458303  0.342797
rs2462492       1       54676   C       T       C       0.599409        -0.00505746     0.00270391      1.1E-01 458303  0.340158
rs3107975       1       55326   T       C       T       0.991557        0.00918983      0.015069        6.3E-01 458303  0.324228
rs74447903      1       57033   T       C       T       0.998221        -0.00814975     0.0335016       7.8E-01 458303  0.296256
1:70728_C_T     1       70728   C       T       C       0.997834        -0.0222717      0.0272397       5.9E-01 458303  0.365713
rs2462495       1       79033   A       G       A       0.00129168      -0.0429876      0.0346811       3.6E-01 458303  0.536566
rs114608975     1       86028   T       C       T       0.896401        -0.000955315    0.00432242      5.1E-01 458303  0.340885
rs6702460       1       91536   G       T       G       0.543017        -0.00371767     0.00266258      3.6E-01 458303  0.340746
rs8179466       1       234313  C       T       C       0.925496        0.00195976      0.00525025      7.0E-01 458303  0.311447
[  mturchin@login002  ~/data2/Loh2017]$zcat /users/mturchin/data2/Loh2017/body_HEIGHTz.sumstats.gz | awk '{ print "chr" $2 "\t" $3 "\t" $3 "\t" $4 "_" $8 "_" $9 "_" $10 }' | grep -v chrCHR | head -n 10
chr1    49298   49298   T_-0.00104841_0.00272961_8.6E-01
chr1    54676   54676   C_-0.00505746_0.00270391_1.1E-01
chr1    55326   55326   T_0.00918983_0.015069_6.3E-01
chr1    57033   57033   T_-0.00814975_0.0335016_7.8E-01
chr1    70728   70728   C_-0.0222717_0.0272397_5.9E-01
chr1    79033   79033   A_-0.0429876_0.0346811_3.6E-01
chr1    86028   86028   T_-0.000955315_0.00432242_5.1E-01
chr1    91536   91536   G_-0.00371767_0.00266258_3.6E-01
chr1    234313  234313  C_0.00195976_0.00525025_7.0E-01
chr1    526736  526736  C_-0.00127255_0.0176025_7.7E-01
[  mturchin20@michaels-air-2  ~/Google Drive/WorkMisc/StephensLab/bmass]$cat /Users/mturchin20/Documents/Work/LabMisc/Data/Hirschhorn/20180427_Bartell.tsv | wc        
12099520 471881280 2248674482
[  mturchin20@michaels-air-2  ~/Google Drive/WorkMisc/StephensLab/bmass]$cat /Users/mturchin20/Documents/Work/LabMisc/Data/Hirschhorn/20180427_Bartell.tsv | head -n 10
chrom	pos	heightIncAllele_loh	otherAllele_loh	pval_loh	beta_loh	htIncAlleleFreq_TSI	htIncAlleleFreq_CEU	heightIncAllele_la	otherAllele_la	pval_la	matchingSites	heightIncAllele_bn	otherAllele_bn	pval_bn	beta_bn	heightIncAllele_wood	otherAllele_wood	pval_wood	beta_wood	heightIncAllele	otherAllele	heightIncAllele_rob	otherAllele_rob	pval_rob	beta_rob	heightIncAllele_ukbfam	otherAllele_ukbfam	pval_ukbfam	beta_ukbfam	chromPos	rank_la	rank_wood	rank_loh	rank_bn	rank_rob	rank_ukbfam	inWoodPub	inLAPub
1.0	49298	C	T	0.86	0.00104841	0.869159	0.8939389999999999	.	.	.	False	.	.	.	.	.	.	.	.	C	T	.	.	1.0:49298	.	.	4173707.0	.	.	.	False	False
1.0	54676	T	C	0.11	0.00505746	.	.	.	.	.	False	.	.	.	.	.	.	.	.	T	C	.	.	.	.	.	1.0:54676	.	.	7287687.0	.	.	.	False	False
1.0	55326	T	C	0.63	0.00918983	0.985981	0.9646459999999999	.	.	.	False	.	.	.	.	.	.	.	.	T	C	.	.	1.0:55326	.	.	1461509.0	.	.	.	False	False
1.0	57033	C	T	0.78	0.00814975	.	.	.	.	.	False	.	.	.	.	.	.	.	.	C	T	.	.	.	.	.	1.0:57033	.	.	6178274.0	.	.	.	False	False
1.0	70728	T	C	0.59	0.0222717	.	.	.	.	.	False	.	.	.	.	.	.	.	.	T	C	.	.	.	.	.	1.0:70728	.	.	1837674.0	.	.	.	False	False
1.0	79033	G	A	0.36	0.0429876	.	.	.	.	.	False	.	.	.	.	.	.	.	.	G	A	.	.	.	.	.	1.0:79033	.	.	10123000.0	.	.	.	False	False
1.0	86028	C	T	0.51	0.000955315	0.0420561	0.08080810000000001	.	.	.	False	.	.	.	.	.	.	.	.	C	T	.	.	1.0:86028	.	.	1119342.0	.	.	.	False	False
1.0	91536	T	G	0.36	0.00371767	0.7009350000000001	0.606061	.	.	.	False	.	.	.	.	.	.	.	.	T	G	.	.	1.0:91536	.	.	10124038.0	.	.	.	False	False
1.0	234313	C	T	0.7	0.00195976	.	.	.	.	.	False	.	.	.	.	.	.	.	.	C	T	.	.	.	.	.	1.0:234313	.	.	5531368.0	.	.	.	False	False
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | head -n 10
chr11   10229851        10229851        rs7938543 A 0.103 1.119e-11     chr11   10229851        10229851        A 0.0095 0.0121346 0.0011 False False
chr11   110243922       110243922       rs7945071 T 0.1054 3.841e-08    chr11   110243922       110243922       T 0.0098 0.0137299 0.0081 False False
chr11   116973929       116973929       rs12269901 C -0.105 3.321e-10   chr11   116973929       116973929       G 0.016 0.0114962 1.1e-06 False False
chr11   118574675       118574675       rs494459 T 0.1167 3.932e-14     chr11   118574675       118574675       T 0.023 0.00993562 7.9e-15 False True
chr11   11986061        11986061        rs3206824 T -0.1203 5.941e-12   chr11   11986061        11986061        C 0.012 0.015550799999999997 0.00041 False False
chr11   120340060       120340060       rs2305013 T -0.2857 1.465e-16   chr11   120340060       120340060       A 0.044000000000000004 0.0389407 4.6e-06 False False
chr11   122844416       122844416       rs1461501 A -0.1145 8.939e-14   chr11   122844416       122844416       G 0.017 0.017931700000000002 5.3e-09 False False
chr11   125849462       125849462       rs621794 A -0.08981 4.498e-09   chr11   125849462       125849462       G 0.013999999999999999 0.0133652 2e-06 False False
chr11   126012786       126012786       rs4937105 T 0.09412 8.475e-09   chr11   126012786       126012786       T . 0.0149174 . False False
chr11   126081403       126081403       rs2282580 C -0.101 7.336e-10    chr11   126081403       126081403       T 0.012 0.0128589 6.500000000000001e-05 False False
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | perl -lane 'print $F[$#F-1];' | sort | uniq -c
   1913 False
     65 True
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | perl -lane 'print $F[$#F];' | sort | uniq -c
   1912 False
     66 True
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | perl -lane 'if ($F[0] ne $F[3]) { $F[3] = $F[0]; $F[4] = -1 * $F[4]; } print join("\t", @F);' | awk '{ if (($5 == ".") && ($6 == ".")) { print $0 } }' | wc
    449    2694   11178
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | perl -lane 'if ($F[0] ne $F[3]) { $F[3] = $F[0]; $F[4] = -1 * $F[4]; } print join("\t", @F);' | awk '{ if ($5 == ".") { print $0 } }' | wc
    449    2694   11178
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$intersectBed -f 1 -wa -wb -a /users/mturchin/data/ukbiobank_jun17/subsets/British/British/mturchin20/Height/ukb_chrAll_v2.British.QCed.QCed.dropRltvs.PCAdrop.noX.Height.ADD.assoc.linear.clumped.5eNeg8.wInfo.bed -b /users/mturchin/data2/HirschhornLab/20180427_Bartell_HeightGWASCombined.edits.bed.gz | sed 's/_/ /g' | awk '{ print $5 "\t" $6 "\t" "\t" $7 "\t" $11 "\t" $12 "\t" $14 }' | perl -lane 'if ($F[0] ne $F[3]) { $F[3] = $F[0]; $F[4] = -1 * $F[4]; } print join("\t", @F);' | awk '{ if ($6 == ".") { print $0 } }' | wc
    904    5424   22951
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/POPRES/NHGRI/POPRES/phs000145v2/p2/POPRES.European.covariates.txt | grep -v ^# | head -n 10

dbGaP SubjID    SUBJID  AGE     BATCH   COUNTRY_FATHER  COUNTRY_MGF     COUNTRY_MGM     COUNTRY_MOTHER  COUNTRY_PGF     COUNTRY_PGM     COUNTRY_SELF    GROUPING_COLLECTION     GROUPING_CONTINENTAL_ORIGIN     GROUPING_PCA_LABEL1     GROUPING_PCA_LABEL2     POPRES_GENDER   PRIMARY_LANGUAGE        POPRES_GENDER_INFERRED  STATUS_OVERALL  STATUS_PASSED_QC1       STATUS_PASSED_QC2
86941   46457   65      4       Switzerland     Switzerland     Switzerland     Switzerland     Switzerland     Switzerland     Switzerland     Lausanne        European        Swiss-French    EuropeW Female  French  N      Excluded By Call Rate Filtering  N       N
82610   12436   42      6       France  France  France  France  Italy   Italy   France  Lausanne        European        Mix     Mix     Female  French  N       Passed QC       Y       Y
85337   34032   55      6       France  Switzerland     Switzerland     Switzerland     France  France  Ivory Coast     Lausanne        European        Mix     Mix     Female  French  N       Passed QC       Y       Y
82544   11866   59      6       Netherlands     Netherlands     Netherlands     Netherlands     Netherlands     Netherlands     Netherlands     Lausanne        European        Netherlands     EuropeC Female  Dutch   N      Passed QC        Y       Y
86634   44017   49      4       Spain   Spain   Spain   Spain   Spain   Spain   Spain   Lausanne        European        Spain   EuropeSW        Female  Spanish N       Passed QC       Y       Y
86982   46856   59      6       Netherlands     Netherlands     Netherlands     Netherlands     Netherlands     Netherlands     Netherlands     Lausanne        European        Netherlands     EuropeC Female  Dutch   N      Passed QC        Y       Y
87036   47213   59      4       Switzerland     Switzerland     Switzerland     Switzerland     Switzerland     Switzerland     Switzerland     Lausanne        European        Swiss-German    EuropeC Female  German  N      Excluded By Call Rate Filtering  N       N
85748   37063   44      4       Macedonia       Kosovo  Kosovo  Macedonia       Kosovo  Kosovo  Macedonia       Lausanne        European        Kosovo  EuropeSE        Female  Albanian        N       Excluded By Call Rate Filtering N       N
(MultiEthnicGWAS) [  mturchin@node964  ~/data/ukbiobank_jun17/subsets/African/African/mturchin20]$cat /users/mturchin/data/POPRES/NHGRI/POPRES/phs000145v2/p2/POPRES.European.covariates.txt | grep -v ^# | awk '{ print $5 "\t" $8 "\t" $11 "\t" $14 "\t" $15 }' | head -n 10

BATCH   COUNTRY_MGM     COUNTRY_PGM     GROUPING_CONTINENTAL_ORIGIN     GROUPING_PCA_LABEL1
Switzerland     Switzerland     Switzerland     Swiss-French    EuropeW
France  France  France  Mix     Mix
France  Switzerland     Ivory   European        Mix
Netherlands     Netherlands     Netherlands     Netherlands     EuropeC
Spain   Spain   Spain   Spain   EuropeSW
Netherlands     Netherlands     Netherlands     Netherlands     EuropeC
Switzerland     Switzerland     Switzerland     Swiss-German    EuropeC
Macedonia       Macedonia       Macedonia       Kosovo  EuropeSE


~~~














