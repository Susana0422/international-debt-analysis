**International Debt Analysis | SQL & PostgreSQL**


📌 Goal
Analyze selected international external debt indicators from the World Bank's International Debt Statistics (IDS) database. The analysis focuses on 2020–2024 and compares public and publicly guaranteed external debt with private nonguaranteed external debt.
Business questions

📄 Description
1. Which five countries had the highest average annual public and publicly guaranteed external debt from 2020 to 2024?
2. Which five countries had the highest average annual private nonguaranteed external debt over the same period?
3. What were Colombia's rankings and average annual debt levels for both indicators?

🧠 Skills Applied
- PostgreSQL
- pgAdmin
- SQL

📊 Key Results
- China ranked first in both categories. Its average annual debt stock was USD 495.18 billion for public and publicly guaranteed external debt and USD 661.21 billion for private nonguaranteed external debt.
- The rankings differed by debt category. Indonesia appeared in the top five for public and publicly guaranteed external debt, while Brazil ranked second for private nonguaranteed external debt.
- Colombia ranked ninth in both categories among countries included in the analysis, with an average annual debt stock of USD 97.53 billion in public and publicly guaranteed external debt and USD 59.50 billion in private nonguaranteed external debt.
Top five results
Public and publicly guaranteed external debt
Rank	Country	Average annual debt (USD billions)
1	China	495.18
2	Mexico	295.97
3	Indonesia	239.47
4	India	211.43
5	Brazil	192.78

Private nonguaranteed external debt
Rank	Country	Average annual debt (USD billions)
1	China	661.21
2	Brazil	298.37
3	India	278.39
4	Mexico	235.30
5	Türkiye	170.57

- Results reflect the countries retained in the cleaned view and with five annual observations for the relevant indicator; they should not be interpreted as a ranking of every economy or aggregate in the original source.
- Public and publicly guaranteed external debt and private nonguaranteed external debt are distinct indicators. Total external debt includes additional components, so the selected public and private indicators should not be assumed to add up to total external debt.
- The values shown are average annual debt stocks, not the sum of debt across the five years.
