WITH personAttributes AS (
    SELECT
        TOP 100*
    FROM
        [Attribute] a
    WHERE
        a.EntityTypeId = 15
), registrantAttributes AS (
    SELECT
        *
    FROM
        [Attribute] a
    WHERE
        a.EntityTypeId = 313
)/*, combinedAttributes AS (
    SELECT * FROM registrantAttributes
    UNION ALL
    SELECT * FROM personAttributes
)*/

SELECT
    --x.AttributeId
    x.AttributeName
    ,COUNT(*) AS [AttributeCount]
    
FROM
    (SELECT
        TOP 10000
        rt.Name As [TemplateName]
        ,rt.Id AS [RegistrationTemplateId]
        ,rtff.FieldSource
        ,CASE rtff.PersonFieldType
            WHEN 0 THEN 'FirstName'
            WHEN 1 THEN 'LastName'
            WHEN 2 THEN 'Campus'
            WHEN 3 THEN 'Address'
            WHEN 4 THEN 'Email'
            WHEN 5 THEN 'Birthdate'
            WHEN 6 THEN 'Gender'
            WHEN 7 THEN 'MaritalStatus'
            WHEN 8 THEN 'MobilePhone'
            WHEN 9 THEN 'HomePhone'
            WHEN 10 THEN 'WorkPhone'
            WHEN 11 THEN 'Grade'
            WHEN 12 THEN 'ConnectionStatus'
            WHEN 13 THEN 'MiddleName'
            WHEN 14 THEN 'AnniversaryDate'
        END AS [PersonFieldTypeName]
        ,rtff.AttributeId
        ,pa.Name As [AttributeName]
        ,rtff.IsSharedValue
        ,rtff.ShowCurrentValue
        ,rtff.IsInternal
        ,rtff.IsRequired
    FROM
        [RegistrationTemplate] rt
        INNER JOIN [RegistrationTemplateForm] rtf ON rtf.RegistrationTemplateId = rt.Id
        INNER JOIN [RegistrationTemplateFormField] rtff ON rtff.RegistrationTemplateFormId = rtf.Id
        INNER JOIN registrantAttributes pa ON pa.Id = rtff.AttributeId
    ) x
GROUP BY
    --x.AttributeId, 
    x.AttributeName
ORDER BY
    COUNT(*) DESC

/*
7426	T-Shirt Size
676	Allergy Details
12952	Primary Emergency Contact
12953	Primary Emergency Contact Phone
16981	Has Allergy
15716	Primary Parent/Guardian Name
14457	Dietary Restriction Details
15720	Primary Parent/Guardian Email
15719	Primary Parent/Guardian Phone
14456	Has Dietary Restrictions
14460	Medical Conditions Details
12955	Do you use an epi-pen?
14469	Medical Concerns Details
14454	Secondary Emergency Contact
14455	Secondary Emergency Contact Phone
16979	Has Special Needs
16980	Special Needs Details
14464	Medications Details
14458	Medical Conditions
14446	Given Name (As Written on Passport)
14447	SurName (As Written on Passport)
14449	Passport Expiration Date
15095	Passport Image
23520	Passport Number
20943	Passport Acknowledgement
21135	Passport Receipt Image
15451	Are you fluent in Spanish?
14465	Tetnus Shot Date
14466	Vaccinations Are Up To Date
14467	Had Chickenpox
14468	Understand Recommendations
15722	Secondary Parent/Guardian Name
15725	Secondary Parent/Guardian Phone
14450	Passport Issuing Country
7425	Testimony
15726	Secondary Parent/Guardian Email
33260	Preferred Hospital
33261	Medical Insurance Provider
33269	Medical Insurance Number
20855	Driver's License Photo
15721	Primary Parent/Guardian Address
1758	Driver's License Number
14452	Primary Emergency Contact - OLD DO NOT USE
14453	Primary Emergency Contact Phone - OLD DO NOT USE
15723	Secondary Parent/Guardian Gender
15724	Secondary Parent/Guardian Birthdate
15727	Secondary Parent/Guardian Address
15717	Primary Parent/Guardian Gender
15718	Primary Parent/Guardian birthdate:
16742	School
*/

/*
Do you attend Bayside?	85
If yes, which Bayside Campus do you regularly attend?	58
Have you ever attended a Bible Study?	16
School	14
Is this your first time at Breakaway?	13
Grade	13
Have you been live-scanned for Bayside Church?	12
On-Campus Parent Contact Phone Number	12
Preferred Hospital	11
Leader Request	11
Medical Insurance Number	11
Medical Insurance Provider	11
How old is your child?	10
What campus do you attend?	10
Which Bayside Campus do you regularly attend?	10
If you attend Bayside, which Campus do you regularly attend?	9
Registration Comment(s):	9
Have you been LiveScanned for Bayside?	9
Have you accepted Jesus?	9
Campus	9
Are you on any medication?	8
Are you under a Doctor's care?	8
Do you have any medical conditions?	8
Do you have special needs?	8
On-Campus Parent Contact First and Last Name	8
Passport Status	7
Please explain these conditions.	7
Please select this child's age group.	7
List your experience in Children's Ministry or Breakaway.	7
List the first & last name of your requested adult small group leader.	7
I would like to be with (Friend's First and Last Name)	7
Emergency Person is on the Trip	7
Friend Request 2	7
Have you served in a Children's Ministry or Breakaway?	7
Friend Request 1	7
Why do you want to be baptized?	7
Spartan	6
Spartan Car	6
Spouse's Name	6
Secondary Parent/Guardian phone:	6
Please explain the care.	6
Serving Ministry	6
Special Circumstances:	6
Team Choice #1	6
Team Choice #2	6
Friend Request #2	6
Family Member(s) going on the trip?	6
Friend Request	6
Friend Request #1	6
Have you been finger printed at Bayside?	6
Do you have a preference on who you would like to baptize you? If so, please specify.	6
Briefly explain your answer.	6
How many years have you participated in Mexico Outreach?	6
Internal Comments	6
Please list/describe your medications.	6
Primary Parent/Guardian address:	6
Primary Parent/Guardian birthdate:	6
Primary Parent/Guardian email:	6
Primary Parent/Guardian gender	6
Primary Parent/Guardian name:	6
Primary Parent/Guardian phone:	6
Relationship With Jesus	6
Secondary Parent/Guardian address:	6
Secondary Parent/Guardian birthdate:	6
Secondary Parent/Guardian email:	6
Secondary Parent/Guardian gender:	6
Secondary Parent/Guardian name:	6
Parent's Name (First and Last)	6
Participation	6
Please explain your special needs.	6
Parent's Phone Number	5
Mother's Name (First and Last)	5
I would like to request to be with (Leader’s First and Last Name).	5
I would like to request to be with (Leader's First and Last Name)	5
I am interested in serving in one of the following areas?	5
Are you new to Bayside?	5
Father's Name (First and Last)	5
Email	5
Team Choice #3	5
Where would you like to volunteer?	5
What campus would you like to be baptized at?	5
Which service time would you prefer?	4
Small Group Leader Request	4
Does your child need a buddy?	4
Enter Company or Name you would like displayed	4
Do you attend Bayside Church?	4
Have you completed the Bayside Kids Baptism Class OR Growth Track stepONE?	4
Do you attend Bayside Santa Rosa?	4
Fall 2021 Grade	4
Friend Choice One	4
Friend Choice Two	4
Friend or Family Request #1	4
Any allergies/special needs for this child?	4
Any information that we should be aware of about your student?	4
Age of Child?	4
1st Child's Date of Birth	4
1st Child's Name	4
2nd Child's Date of Birth	4
2nd Child's Name	4
3rd Child's Date of Birth	4
3rd Child's Name	4
Are you new to Women's Ministry?	4
Bayside Campus you attend regularly?	4
Comments	4
Contact Number for Parent on Campus with child	4
Date of Birth	4
I would like to be with (Friend’s Name).	4
If yes, please describe allergies/special needs	4
How did you hear about this study?	4
Legal Document	4
Parent's Email	4
Registration Comments	4
Reference Name	4
Reference Phone	4
Please upload a photo of your child and/or family.	4
Passport	3
Role	3
Second Golfer – First and Last Name	3
Second Golfer Email	3
Second Golfer Phone Number	3
Or person referred by?	3
Leader Request (First and Last Name)	3
Is your Spouse going on the trip?	3
Medication Details	3
Mexico Car	3
Mother's Email	3
Mother's Mobile Phone	3
Incoming 2022-2023 Grade	3
If you/child attends church elsewhere, what is the name of your church?	3
I would like to help on the following team:	3
If you attend a Bayside Campus, which do you attend?	3
If Yes, Spouse's Name	3
How long have you been married?	3
If not Bayside Church, where do you attend?	3
I am interested in serving for the Study in one of these areas?	3
Children's Ages	3
DMV	3
Briefly explain your answer	3
Child's Age	3
4th Child's Date of Birth	3
4th Child's Name	3
Additional Dinner Guests Names (if applicable to your sponsorship level)	3
Age	3
3rd Child's Allergies (if any)	3
1st Child's Allergies (if any)	3
Fourth Golfer - First and Last Name	3
Fourth Golfer Email	3
*/