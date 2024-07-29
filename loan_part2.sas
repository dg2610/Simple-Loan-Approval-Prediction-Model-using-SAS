/*INITIAL DATA EXPLORATION*/

/* Viewing the Structure of the Dataset */
proc contents data = lab16.loan;
run;

/* Printing the Dataset */
proc print data = lab16.loan;
run;

/* Descriptive Statistics for Numerical Variables */
proc means data = lab16.loan;
run;

/* Frequency Tables for Categorical Variables */
proc freq data = lab16.loan;
tables Gender Married Dependents Education Self_Employed Credit_History Property_Area Loan_Status;
run;

/* Bar Chart for Gender */
proc sgplot data = lab16.loan;
    vbar Gender / datalabel;
    title "Frequency Distribution of Gender";
run;

/* Bar Chart for Married */
proc sgplot data = lab16.loan;
    vbar Married / datalabel;
    title "Frequency Distribution of Married";
run;

/* Bar Chart for Dependents */
proc sgplot data = lab16.loan;
    vbar Dependents / datalabel;
    title "Frequency Distribution of Dependents";
run;

/* Bar Chart for Education */
proc sgplot data = lab16.loan;
    vbar Education / datalabel;
    title "Frequency Distribution of Education";
run;

/* Bar Chart for Self_Employed */
proc sgplot data = lab16.loan;
    vbar Self_Employed / datalabel;
    title "Frequency Distribution of Self-Employed";
run;

/* Bar Chart for Credit_History */
proc sgplot data = lab16.loan;
    vbar Credit_History / datalabel;
    title "Frequency Distribution of Credit History";
run;

/* Bar Chart for Property_Area */
proc sgplot data = lab16.loan;
    vbar Property_Area / datalabel;
    title "Frequency Distribution of Property Area";
run;

/* Bar Chart for Loan_Status */
proc sgplot data = lab16.loan;
    vbar Loan_Status / datalabel;
    title "Frequency Distribution of Loan Status";
run;


/* Scatter Plot for LoanAmount vs ApplicantIncome */
proc sgscatter data = lab16.loan;
plot LoanAmount*ApplicantIncome;
run;

/* Box Plot for LoanAmount by Property_Area */
proc sgplot data = lab16.loan;
vbox LoanAmount / category=Property_Area;
run;

/* Checking for Missing Values */
proc means data=lab16.loan nmiss;
run;

/* Histograms for Numerical Variables */
proc sgplot data=lab16.loan;
histogram ApplicantIncome;
run;

proc sgplot data=lab16.loan;
histogram CoapplicantIncome;
run;

proc sgplot data=lab16.loan;
histogram LoanAmount;
run;

/* Cross-Tabulations for Categorical Variables */
proc freq data=lab16.loan;
tables Gender*Married / chisq;
tables Education*Self_Employed / chisq;
tables Credit_History*Property_Area / chisq;
run;

/* Box Plots for Numerical Variables by Categorical Variables */
proc sgplot data=lab16.loan;
vbox ApplicantIncome / category=Gender;
run;

proc sgplot data=lab16.loan;
vbox LoanAmount / category=Married;
run;

/* Correlation Analysis for Numerical Variables */
proc corr data=lab16.loan;
var ApplicantIncome CoapplicantIncome LoanAmount;
run;

/* Descriptive Statistics for Groups */
proc means data=lab16.loan n mean std min max;
class Gender Married;
var ApplicantIncome CoapplicantIncome LoanAmount;
run;

/* Exploring Interaction Effects */
proc sgplot data=lab16.loan;
vbox LoanAmount / category=Gender group=Married;
run;

proc sgplot data=lab16.loan;
vbox ApplicantIncome / category=Education group=Self_Employed;
run;


/*Data Pre-processing, EDA, Feature Engineering, and Hypothesis Testing*/

/* Handling missing values for numerical variables using mean imputation */
proc stdize data=lab16.loan reponly method=mean out=lab16.loan_imputed;
    var LoanAmount Loan_Amount_Term Credit_History;
run;

/* Handling missing values for categorical variables using mode imputation */
data lab16.loan_imputed;
    set lab16.loan_imputed;
    
    /* Mode imputation for categorical variables */
    if missing(Gender) then Gender = 'Male'; 
    if missing(Married) then Married = 'Yes'; 
    if missing(Dependents) then Dependents = '0'; 
    if missing(Self_Employed) then Self_Employed = 'No'; 
run;

/* Verify that missing values have been handled */
proc means data=lab16.loan_imputed nmiss;
run;

proc freq data=lab16.loan_imputed;
    tables Gender Married Dependents Self_Employed Credit_History / missing;
run;

/* Re-run Descriptive Statistics and Visualizations on Cleaned Data */

/* Histograms for Numerical Variables */
proc sgplot data=lab16.loan_imputed;
    histogram ApplicantIncome;
run;

proc sgplot data=lab16.loan_imputed;
    histogram CoapplicantIncome;
run;

proc sgplot data=lab16.loan_imputed;
    histogram LoanAmount;
run;

/* Box Plots for Numerical Variables by Categorical Variables */
proc sgplot data=lab16.loan_imputed;
    vbox ApplicantIncome / category=Gender;
run;

proc sgplot data=lab16.loan_imputed;
    vbox LoanAmount / category=Married;
run;

/* Correlation Analysis for Numerical Variables */
proc corr data=lab16.loan_imputed;
    var ApplicantIncome CoapplicantIncome LoanAmount;
run;

/* Normalization of Numerical Variables */
proc stdize data=lab16.loan_imputed method=range out=lab16.loan_normalized;
    var ApplicantIncome CoapplicantIncome LoanAmount;
run;

/* Creating New Features */
data lab16.loan_features;
    set lab16.loan_normalized;
    TotalIncome = ApplicantIncome + CoapplicantIncome;
    IncomeToLoanRatio = TotalIncome / LoanAmount;
run;

/* Hypothesis Testing */

/* Hypothesis 1: Higher applicant income is associated with higher loan amounts. */
proc corr data=lab16.loan_features;
    var ApplicantIncome LoanAmount;
run;

/* Hypothesis 2: Applicants with a credit history are more likely to have their loans approved. */
proc freq data=lab16.loan_features;
    tables Credit_History*Loan_Status / chisq;
run;

/* Hypothesis 3: Self-employed individuals have different loan approval rates compared to salaried individuals. */
proc freq data=lab16.loan_features;
    tables Self_Employed*Loan_Status / chisq;
run;

/* Hypothesis 4: Married applicants are more likely to apply for higher loan amounts. */
proc means data=lab16.loan_features n mean std min max;
    class Married;
    var LoanAmount;
run;

/* Hypothesis 5: Loan approval rates vary significantly across different property areas. */
proc freq data=lab16.loan_features;
    tables Property_Area*Loan_Status / chisq;
run;
