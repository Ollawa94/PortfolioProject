-- showcasing our Loan Table

SELECT * FROM Loan.loan_approval_dataset;

-- highlighting the approved and rejected loans from the table

select loan_id, no_of_dependents, education, self_employed, income_annum, loan_amount, loan_term,
loan_status
FROM Loan.loan_approval_dataset
where loan_status = 'approved';

select loan_id, no_of_dependents, education, self_employed, income_annum, loan_amount, loan_term,
loan_status
FROM Loan.loan_approval_dataset
where loan_status = 'rejected';

-- counting the number of approved and rejected loans

select loan_status, count(loan_status)
FROM Loan.loan_approval_dataset
where loan_status = 'rejected';

select loan_status, count(loan_status)
FROM Loan.loan_approval_dataset
where loan_status = 'approved';

-- above analyses shows that we have more approved loans than rejected loans

-- Lets find out how many educated and non educated individual got approved or rejected for loan

select education, count(education), loan_status
FROM Loan.loan_approval_dataset
where loan_status = 'approved'
group by education;

select education, count(education), loan_status
FROM Loan.loan_approval_dataset
where loan_status = 'rejected'
group by education;

-- now lets have this in the same table

select education, 
count(case when loan_status = 'approved' then 1 end) AS approved,
count(case when loan_status = 'rejected' then 1 end) as rejected
from Loan.loan_approval_dataset
group by education;

-- Calculating the overall loan approval and rejected rate

select round((count(case when loan_status = 'approved' then 1 end) * 100) / count(*))
as approval_rate
from Loan.loan_approval_dataset;

select round((count(case when loan_status = 'rejected' then 1 end) * 100) / count(*))
as approval_rate
from Loan.loan_approval_dataset;

-- we use the round function above to convert the decimal result into a whole number

select
loan_id,
no_of_dependents,
education,
self_employed,
income_annum
loan_amount,
loan_term,
cibil_score,
residential_assets_value,
commercial_assets_value,
luxury_assets_value,
bank_asset_value,
loan_status
from Loan.loan_approval_dataset
where loan_status = 'rejected'
order by cibil_score;


select
loan_id,
no_of_dependents,
education,
self_employed,
income_annum
loan_amount,
loan_term,
cibil_score,
residential_assets_value,
commercial_assets_value,
luxury_assets_value,
bank_asset_value,
loan_status
from Loan.loan_approval_dataset
where loan_status = 'approved'
order by cibil_score;

-- Analyzing different distribution metrics, below is the cibil_score distribution

select cibil_score,
count(*) AS borrower_count
from Loan.loan_approval_dataset
group by cibil_score;

-- income_annum distribution

select income_annum,
count(case when income_annum < 1000000 then 1 end),
count(case when income_annum > 1000000 then 1 end)
from Loan.loan_approval_dataset
group by income_annum;

-- loan amount distribution

select loan_amount,
count(case when loan_amount < 10000000 then 1 end) as below,
count(case when loan_amount > 10000000 then 1 end) as above
from Loan.loan_approval_dataset
group by loan_amount;

-- self employed distribution (rejected)

select self_employed,
count(case when self_employed = 'yes' then 1 end) as Yes,
count(case when self_employed = 'no' then 1 end) as No
from Loan.loan_approval_dataset
where loan_status = 'rejected'
group by self_employed;

-- self employed distribution 

select self_employed,
count(case when self_employed = 'yes' then 1 end) as Yes,
count(case when self_employed = 'no' then 1 end) as No
from Loan.loan_approval_dataset
group by self_employed;

