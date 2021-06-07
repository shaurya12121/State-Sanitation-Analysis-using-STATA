recode MDW_Type (2/3=1 "Tap" )(4=2 "Tube-well/Hand Pump" )(else=3 "Others" ), gen(MDW_recoded)

recode Latrine_Recoded (1=1 "No Latrine" )(2=0 "Some form of Latrine "), gen( Latrine_Rec)

recode Religion (1=1 "Hindu" )(2=2 "Islam" )(else=3 "Others" ), gen(Rel_Recoded)

gen y= HH_size^2

tab1 Social_Group Rel_Recoded Sector Year  MDW_recoded  State_District 

foreach i in Social_Group Rel_Recoded Sector MDW_recoded {
tab Latrine_Rec `i' if Year==1,  col nof chi2 
tab Latrine_Rec `i' if Year==2,  col nof chi2 
}



preserve
keep if Year==1
proportion Latrine_Rec, over(State_District) 
restore 

preserve
keep if Year==2
proportion Latrine_Rec, over(State_District) 
restore

logit Latrine_Rec i.Social_Group i.Rel_Recoded i.Sector i.MDW_recoded i.Year HH_size y HUCE i.State_District,or

estat gof , group(40)

estat classification

**margins State_District Sector Rel_Recoded Social_Group MDW_recoded Year, dydx( HH_size)

**margins State_District Sector Rel_Recoded

test 1.Year =2.Year
