CREATE DATABASE lab1;
USE lab1;

CREATE TABLE Disciplines
(IDDiscipline INT IDENTITY
	CONSTRAINT DisciplinePrimary PRIMARY KEY,
NameOfDiscipline VARCHAR(35) NOT NULL
	CONSTRAINT DisciplinesNamesUnique UNIQUE,
TypeOfControl VARCHAR (35) NOT NULL,
TotalHours INT NOT NULL
);

CREATE TABLE StudentGroups
(IDStudentGroups INT IDENTITY
	CONSTRAINT StudentGroupPrimary PRIMARY KEY,
NameOfGroup VARCHAR(35) NOT NULL
	CONSTRAINT GroupNamesUnique UNIQUE,
Course INT NOT NULL,
Semester INT NOT NULL
);

CREATE TABLE Students
(IDStudents INT IDENTITY
	CONSTRAINT StudentsPrimary PRIMARY KEY,
Names VARCHAR(50) NOT NULL,
IDStudentGroups INT NOT NULL,
Sex VARCHAR(5) NOT NULL,
DateOfBirth date NOT NULL,
Adress VARCHAR(50) NOT NULL,
	CONSTRAINT StudCharUnique UNIQUE (Names, Sex, DateOfBirth, Adress),
	CONSTRAINT StudGroupForeign FOREIGN KEY (IDStudentGroups) REFERENCES
StudentGroups (IDStudentGroups) ON DELETE CASCADE
);

CREATE TABLE StudentSuccess
(IDStudentSuccess INT IDENTITY
	CONSTRAINT StudensSuccessPrimary PRIMARY KEY,
IDDiscipline INT NOT NULL,
IDStudents INT NOT NULL,
Mark INT NOT NULL,
	CONSTRAINT StudSuccessUnique UNIQUE (IDDiscipline, IDStudents, Mark),
	CONSTRAINT StudDisciplinesForeign FOREIGN KEY (IDDiscipline) REFERENCES
Disciplines(IDDiscipline) ON DELETE CASCADE,
	CONSTRAINT StudStudentsForeign FOREIGN KEY (IDStudents) REFERENCES
Students(IDStudents) ON DELETE CASCADE
);
----------------------------------------------------------------------------------lab1----------------------------------------------------------------------------
--INSERT INTO ....
--	VALUES('....', '....', '....');
----------------------------------------------------------------------------------lab3----------------------------------------------------------------------------
SELECT Names ÔÈÎ, NameOfDiscipline Ïðåäìåò, TypeOfControl Êîíòðîëü, TotalHours Êîëâî×àñîâ, Mark Óñïåøíîñòü
	FROM StudentSuccess S
		JOIN Disciplines D ON S.IDDiscipline = D.IDDiscipline
		JOIN Students St ON St.IDStudents = S.IDStudents
			WHERE NameOfDiscipline = 'Ìàòåìàòèêà' OR NameOfDiscipline = 'Ô³çèêà';
SELECT Names ÔÈÎ, NameOfDiscipline Ïðåäìåò, NameOfGroup Ãðóïïà, Mark Óñïåøíîñòü
	FROM StudentSuccess S 
		JOIN Disciplines D ON S.IDDiscipline = D.IDDiscipline
		JOIN Students St ON St.IDStudents = S.IDStudents
		JOIN StudentGroups Sg ON St.IDStudentGroups = Sg.IDStudentGroups
			WHERE NameOfDiscipline = 'Ìàòåìàòèêà' OR NameOfDiscipline = 'Ô³çèêà' OR NameOfGroup = 'ÔÁ-30' OR NameOfGroup = 'ÔÔ-30';

SELECT distinct NameOfDiscipline Ïðåäìåò, NameOfGroup Ãðóïïà, Course Êóðñ, Semester Ñåìåñòð
	FROM StudentSuccess S 
		JOIN Disciplines D ON S.IDDiscipline = D.IDDiscipline
		JOIN Students St ON St.IDStudents = S.IDStudents
		JOIN StudentGroups Sg ON St.IDStudentGroups = Sg.IDStudentGroups
			WHERE NameOfGroup = 'ÔÁ-20' AND Semester = 1;
----------------------------------------------------------------------------------lab4----------------------------------------------------------------------------
SELECT Names ÔÈÎ, NameOfDiscipline Ïðåäìåò, Mark Óñïåøíîñòü
	FROM StudentSuccess S 
		JOIN Disciplines D ON S.IDDiscipline = D.IDDiscipline
		JOIN Students St ON St.IDStudents = S.IDStudents
			WHERE Mark > (SELECT AVG(Mark) FROM StudentSuccess SS INNER JOIN Disciplines DI ON SS.IDDiscipline = DI.IDDiscipline)
SELECT Names ÔÈÎ, SumMark Ìàêñ_áàë
	FROM (SELECT Names, SUM(Mark) as SumMark FROM Students INNER JOIN StudentSuccess ON Students.IDStudents = StudentSuccess.IDStudents GROUP BY Names) a
	WHERE SumMark = (SELECT MAX(SumMark) FROM (SELECT SUM(Mark) as SumMark From Students INNER JOIN StudentSuccess ON Students.IDStudents = StudentSuccess.IDStudents GROUP BY Names)b)

SELECT Names ÔÈÎ, NameOfDiscipline Ïðåäìåò
	FROM Students INNER JOIN StudentSuccess ON Students.IDStudents = StudentSuccess.IDStudents INNER JOIN Disciplines ON StudentSuccess.IDDiscipline = Disciplines.IDDiscipline
	WHERE StudentSuccess.IDStudents IN (SELECT IDStudents FROM StudentSuccess GROUP BY StudentSuccess.IDStudents HAVING COUNT(StudentSuccess.IDStudents)>0) AND Mark BETWEEN 70 AND 100
----------------------------------------------------------------------------------lab5----------------------------------------------------------------------------
GO
CREATE VIEW ViewsStudents 
	AS SELECT Names, Mark, NameOfDiscipline, TypeOfControl, TotalHours, NameOfGroup, Course, Semester, StudentSuccess.IDStudents
		FROM Students S INNER JOIN StudentSuccess ON S.IDStudents = StudentSuccess.IDStudents
		INNER JOIN Disciplines D ON StudentSuccess.IDDiscipline = D.IDDiscipline
		INNER JOIN StudentGroups SG ON S.IDStudentGroups = SG.IDStudentGroups
GO

SELECT Names ÔÈÎ, NameOfDiscipline Ïðåäìåò, TypeOfControl Êîíòðîëü, TotalHours Êîëâî×àñîâ, Mark Óñïåøíîñòü
	FROM ViewsStudents
		WHERE NameOfDiscipline = 'Ìàòåìàòèêà' OR NameOfDiscipline = 'Ô³çèêà';

SELECT Names ÔÈÎ, NameOfDiscipline Ïðåäìåò, NameOfGroup Ãðóïïà, Mark Óñïåøíîñòü
	FROM ViewsStudents
		WHERE NameOfDiscipline = 'Ìàòåìàòèêà' OR NameOfDiscipline = 'Ô³çèêà' OR NameOfGroup = 'ÔÁ-30' OR NameOfGroup = 'ÔÔ-30';

SELECT distinct NameOfDiscipline Ïðåäìåò, NameOfGroup Ãðóïïà, Course Êóðñ, Semester Ñåìåñòð
	FROM ViewsStudents
		WHERE NameOfGroup = 'ÔÁ-20' AND Semester = 1;
----------------------------------------------------------------------------------lab6----------------------------------------------------------------------------
SELECT NameOfGroup Ãðóïïà, COUNT(DISTINCT NameOfDiscipline) ÊîëÂîÑäàíî
	FROM StudentSuccess S
		JOIN Disciplines D ON S.IDDiscipline = D.IDDiscipline
		JOIN Students ST ON ST.IDStudents = S.IDStudents
		JOIN StudentGroups SG ON ST.IDStudentGroups = SG.IDStudentGroups
			GROUP BY NameOfGroup 
----------------------------------------------------------------------------------doplab4----------------------------------------------------------------------------
SELECT Names ÔÈÎ, NameOfDiscipline Ïðåäìåò, Mark Îöåíêà 
FROM Students S INNER JOIN StudentSuccess SS 
ON S.IDStudents= SS.IDStudents INNER JOIN Disciplines D 
ON SS.IDDiscipline = D.IDDiscipline 
WHERE S.IDStudents=SS.IDStudents AND SS.IDDiscipline = D.IDDiscipline 
GROUP BY Names, NameOfDiscipline,Mark 
HAVING Mark>(SELECT AVG(Mark) 
				   FROM StudentSuccess INNER JOIN Students 
				   ON Students.IDStudents= StudentSuccess.IDStudents INNER JOIN Disciplines 
				   ON StudentSuccess.IDDiscipline = Disciplines.IDDiscipline  
				   WHERE NameOfDiscipline=D.NameOfDiscipline
				   GROUP BY NameOfDiscipline)
----------------------------------------------------------------------------------doplab5----------------------------------------------------------------------------
GO 
CREATE VIEW ViewsStudents4 
AS SELECT D.IDDiscipline, NameOfDiscipline, TypeOfControl, TotalHours, 
SG.IDStudentGroups, NameOfGroup, Course, Semester, 
S.IDStudents, Names, S.IDStudentGroups E1, Sex, DateOfBirth, Adress, 
SS.IDStudentSuccess, SS.IDDiscipline E2, SS.IDStudents E3, Mark 
FROM Students S INNER JOIN StudentSuccess SS 
ON S.IDStudents = SS.IDStudents 
INNER JOIN Disciplines D ON SS.IDDiscipline = D.IDDiscipline 
INNER JOIN StudentGroups SG ON S.IDStudentGroups = SG.IDStudentGroups 
GO 

GO 
CREATE VIEW UpdateView 
AS SELECT IDDiscipline, NameOfDiscipline, TypeOfControl, TotalHours 
FROM Disciplines 
GO
----------------------------------------------------------------------------------doplab6----------------------------------------------------------------------------
GO
CREATE PROC AvgMark
	@Names VARCHAR(50)
AS
	SELECT Names ÔÈÎ, AVG(Mark) Cåðåäí³é_áàë_ñòóäåíòà
	FROM Students S INNER JOIN StudentSuccess SS ON S.IDStudents = SS.IDStudents
	WHERE Names = @Names
	GROUP BY Names
GO


EXEC AvgMark 'Àã³òîëüºâ Îëåêñàíäð'
----------------------------------------------------------------------------------lab7----------------------------------------------------------------------------
GO 
CREATE PROC AddNote 
@NameOfDiscipline VARCHAR(35), 
@TypeOfControl VARCHAR(35), 
@TotalHours INT 
AS
IF @NameOfDiscipline = (SELECT NameOfDiscipline FROM Disciplines WHERE NameOfDiscipline = @NameOfDiscipline)
	RAISERROR (15600,-1,-1, 'AddNote');  
ELSE 
	INSERT INTO Disciplines 
	(NameOfDiscipline 
	,TypeOfControl 
	,TotalHours) 
	VALUES 
	(@NameOfDiscipline 
	,@TypeOfControl 
	,@TotalHours);
GO 

EXECUTE AddNote @NameOfDiscipline = 'Ðèñîâàíèå' 
,@TypeOfControl = 'Ïèñüìîâèé åêçàìåí' 
,@TotalHours = 50 
----------------------------------------------------------------------------------doplab7----------------------------------------------------------------------------

CREATE LOGIN Vova WITH PASSWORD='6378'
GO
CREATE USER Vova FOR LOGIN Vova;
CREATE ROLE Auditors;
GO
EXEC sp_addrolemember 'Auditors', 'Vova'

GO
CREATE USER Bill FOR LOGIN Vova;
GRANT EXEC ON AddNote
TO Bill;
GO

GO
CREATE USER John FOR LOGIN Vova;
REVOKE ALL TO John;
GO

USE master;
GO
SELECT *
FROM sys.symmetric_keys
WHERE name = '##MS_ServiceMasterKey##';
GO

GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '637887';
GO

GO
CREATE CERTIFICATE Certificate1
WITH SUBJECT = 'Protect Data';
GO

GO
CREATE SYMMETRIC KEY SymmetricKey1 
WITH ALGORITHM = AES_128 
ENCRYPTION BY CERTIFICATE Certificate1;
GO

GO
ALTER TABLE Disciplines 
ADD NameSubject_encrypt varbinary(MAX) NULL
GO

GO
---- Opens the symmetric key for use
OPEN SYMMETRIC KEY SymmetricKey1
DECRYPTION BY CERTIFICATE Certificate1;
GO
UPDATE Disciplines
SET NameSubject_encrypt = EncryptByKey(Key_GUID('SymmetricKey1'), NameOfDiscipline)
FROM Disciplines;
GO
---- Closes the symmetric key
CLOSE SYMMETRIC KEY SymmetricKey1;
GO

GO
ALTER TABLE Subjects
DROP COLUMN NameSubject;
GO

SELECT * FROM Disciplines;
--------------------------------------------------------------------------------lab9----------------------------------------------------------------------------

SELECT name, password  
FROM sys.sysusers SS 
WHERE ss.password IS NULL and issqluser = 1 and hasdbaccess = 1;

--------------------------------------------------------------------------------doplab9----------------------------------------------------------------------------
