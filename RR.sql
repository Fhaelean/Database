USE BdRR;

CREATE TABLE Disciplines
(IDDiscipline INT IDENTITY
	CONSTRAINT DisciplinePrimary PRIMARY KEY,
NameOfDiscipline VARCHAR(35) NOT NULL
	CONSTRAINT DisciplineNameUnique UNIQUE
);

CREATE TABLE StudentGroups
(IDStudentGroups INT IDENTITY
	CONSTRAINT StudentGroupPrimary PRIMARY KEY,
NameOfGroup VARCHAR(35) NOT NULL
	CONSTRAINT GroupNameUnique UNIQUE,
Course INT NOT NULL
);

CREATE TABLE Departments
(IDDepartments INT IDENTITY
	CONSTRAINT DepartmentsPrimary PRIMARY KEY,
NameOfDepartment VARCHAR(35) NOT NULL
	CONSTRAINT DepartmentNameUnique UNIQUE
);

CREATE TABLE Professors
(IDProfessors INT IDENTITY
	CONSTRAINT ProfessorsPrimary PRIMARY KEY,
ProfessorName VARCHAR(35) NOT NULL
	CONSTRAINT ProfessorNameUnique UNIQUE,
Post VARCHAR(35) NOT NULL,
IDDepartments INT NOT NULL,
	CONSTRAINT DepartmentsForeign FOREIGN KEY(IDDepartments) REFERENCES
Departments(IDDepartments)ON DELETE CASCADE
);

CREATE TABLE Exams
(IDExams INT IDENTITY
	CONSTRAINT ExamsPrimary PRIMARY KEY,
ExaminationDate DATE NOT NULL,
LectureHall VARCHAR(7) NOT NULL,
IDStudentGroups INT NOT NULL,
IDDiscipline INT NOT NULL,
IDProfessors INT NOT NULL,
	CONSTRAINT ExamUnique UNIQUE(ExaminationDate, LectureHall),
	CONSTRAINT StudGroupForeign FOREIGN KEY(IDStudentGroups) REFERENCES
StudentGroups(IDStudentGroups)ON DELETE CASCADE,
	CONSTRAINT DisciplineForeign FOREIGN KEY(IDDiscipline) REFERENCES
Disciplines(IDDiscipline)ON DELETE CASCADE,
	CONSTRAINT ProfessorsForeign FOREIGN KEY(IDProfessors) REFERENCES
Professors(IDProfessors)ON DELETE CASCADE
);

INSERT INTO Disciplines
	VALUES('Математика');
INSERT INTO Disciplines
	VALUES('Українська мова');
INSERT INTO Disciplines
	VALUES('Іноземна мова');
INSERT INTO Disciplines
	VALUES('Фізика');
INSERT INTO Disciplines
	VALUES('Історія');
INSERT INTO Disciplines
	VALUES('Теорія ймовірностей');
INSERT INTO Disciplines
	VALUES('Тестування');
INSERT INTO Disciplines
	VALUES('Теорія чисел');
INSERT INTO Disciplines
	VALUES('Інформаційна безпека');
INSERT INTO Disciplines
	VALUES('Психологія');

INSERT INTO StudentGroups
	VALUES('ФБ-10', '4');
INSERT INTO StudentGroups
	VALUES('ФБ-20', '3');
INSERT INTO StudentGroups
	VALUES('ФБ-30', '2');
INSERT INTO StudentGroups
	VALUES('ФБ-40', '1');
INSERT INTO StudentGroups
	VALUES('ФФ-10', '4');
INSERT INTO StudentGroups
	VALUES('ФФ-20', '3');
INSERT INTO StudentGroups
	VALUES('ФФ-30', '2');
INSERT INTO StudentGroups
	VALUES('ФФ-40', '1');
INSERT INTO StudentGroups
	VALUES('ФИ-10', '4');
INSERT INTO StudentGroups
	VALUES('ФИ-20', '3');

INSERT INTO Departments
	VALUES('Высшая математика');
INSERT INTO Departments
	VALUES('Гуманитарных наук');
INSERT INTO Departments
	VALUES('Естественных наук');
INSERT INTO Departments
	VALUES('Иностранных языков');
INSERT INTO Departments
	VALUES('Материаловедение');
INSERT INTO Departments
	VALUES('Права');
INSERT INTO Departments
	VALUES('Турбиностроения');
INSERT INTO Departments
	VALUES('Философии');
INSERT INTO Departments
	VALUES('Сварки');
INSERT INTO Departments
	VALUES('Радиоэлектроника');

INSERT INTO Professors
	VALUES ('Рогов Илья Глебович', 'старший викладач', 1);
INSERT INTO Professors
	VALUES ('Королёв Мстислав Мстиславович', 'доцент', 2);
INSERT INTO Professors
	VALUES ('Антонов Демьян Геласьевич', 'доцент', 3);
INSERT INTO Professors
	VALUES ('Крылова Мария Мэлсовна', 'старший викладач', 4);
INSERT INTO Professors
	VALUES ('Мельников Александр Дмитрьевич', 'професор', 5);
INSERT INTO Professors
	VALUES ('Фёдоров Ростислав Артёмович', 'старший викладач', 6);	
INSERT INTO Professors
	VALUES ('Беспалов Станислав Дмитрьевич', 'професор', 2);
INSERT INTO Professors
	VALUES ('Родионов Леонид Филатович', 'професор', 7);
INSERT INTO Professors
	VALUES ('Ермаков Денис Денисович', 'старший викладач', 8);
INSERT INTO Professors
	VALUES ('Королёва Элеонора Онисимовна', 'доцент', 1);

INSERT INTO Exams
	VALUES ('2017.01.04', '101-7', 1, 1, 1);
INSERT INTO Exams
	VALUES ('2017.01.08', '102-7', 2, 2, 2);
INSERT INTO Exams
	VALUES ('2017.01.12', '103-7', 3, 3, 3);
INSERT INTO Exams
	VALUES ('2017.01.16', '116-7', 4, 4, 4);
INSERT INTO Exams
	VALUES ('2017.01.20', '202-11', 5, 5, 5);
INSERT INTO Exams
	VALUES ('2017.01.24', '302-11', 6, 6, 6);
INSERT INTO Exams
	VALUES ('2017.01.28', '114-7', 7, 7, 7);
INSERT INTO Exams
	VALUES ('2017.02.02', '124-1', 2, 2, 2);
INSERT INTO Exams
	VALUES ('2017.02.06', '111-7', 4, 4, 4);
INSERT INTO Exams
	VALUES ('2017.02.08', '214-11', 8, 8, 8);
-------------------------------------------------------------------------------------------------------------------------------------------------
SELECT NameOfDiscipline, NameOfGroup, ExaminationDate, LectureHall, ProfessorName 
FROM Exams E 
JOIN Disciplines D ON E.IDDiscipline = D.IDDiscipline
JOIN StudentGroups SG ON E.IDStudentGroups = SG.IDStudentGroups
JOIN Professors P ON E.IDProfessors = P.IDProfessors
	WHERE NameOfGroup = 'ФБ-30';

SELECT NameOfDiscipline, NameOfGroup, ExaminationDate, LectureHall, ProfessorName 
FROM Exams E 
JOIN Disciplines D ON E.IDDiscipline = D.IDDiscipline
JOIN StudentGroups SG ON E.IDStudentGroups = SG.IDStudentGroups
JOIN Professors P ON E.IDProfessors = P.IDProfessors
JOIN Departments DP ON P.IDDepartments = DP.IDDepartments
	WHERE NameOfDepartment = 'Гуманитарных наук';

IF NOT EXISTS( 
SELECT NameOfGroup, E.ExaminationDate, E1.ExaminationDate, DATEDIFF(d, E.ExaminationDate, E1.ExaminationDate) AS [Days difference] 
FROM Exams E 
JOIN StudentGroups SG ON E.IDStudentGroups = SG.IDStudentGroups 
JOIN Exams E1 ON E.IDStudentGroups=E1.IDStudentGroups 
WHERE E.IDExams!=E1.IDExams 
AND E.ExaminationDate < E1.ExaminationDate 
AND DATEDIFF(d, E.ExaminationDate, E1.ExaminationDate) < 3 
) 
PRINT 'У кожної групи між двома іспитами проходить не менше трьох днів.' 
ELSE 
PRINT 'У кожної групи між двома іспитами не проходить не менше трьох днів.'

SELECT ProfessorName, ExaminationDate, COUNT(*) AS [Exams amount] 
FROM Exams E 
JOIN Professors P ON E.IDProfessors = P.IDProfessors 
GROUP BY ProfessorName, ExaminationDate

SELECT NameOfGroup, COUNT(*) [Exams amount] 
FROM Exams E 
JOIN StudentGroups S ON E.IDStudentGroups=S.IDStudentGroups 
GROUP BY NameOfGroup 

SELECT Course, COUNT(*) [Exams amount] 
FROM Exams E 
JOIN StudentGroups S ON E.IDStudentGroups=S.IDStudentGroups 
GROUP BY Course

GO
CREATE PROC AddToTable
@ExamDate Date,
@LectHall VARCHAR(7),
@ProfOrGroup VARCHAR(35)
AS
UPDATE Exams SET ExaminationDate = @ExamDate, LectureHall = @LectHall
WHERE (IDProfessors = @ProfOrGroup OR IDStudentGroups = @ProfOrGroup)

EXEC AddToTable '2017.01.05', '311-11', '1'

SELECT NameOfDiscipline, NameOfGroup, ExaminationDate, LectureHall, ProfessorName, Post 
FROM Exams E 
JOIN Disciplines D ON E.IDDiscipline = D.IDDiscipline
JOIN StudentGroups SG ON E.IDStudentGroups = SG.IDStudentGroups
JOIN Professors P ON E.IDProfessors = P.IDProfessors
JOIN Departments DP ON P.IDDepartments = DP.IDDepartments
	WHERE NameOfDepartment = 'Гуманитарных наук' OR NameOfDepartment = 'Иностранных языков'
	ORDER BY P.Post;

GO 
CREATE PROC Inf
@IdProf INT 
AS 
Declare @Message varchar(150) 
If EXISTS(Select * FROM Exams WHERE IDProfessors=@IdProf) 
BEGIN 
SET @Message='ФИО:'+(Select ProfessorName From Professors Where IDProfessors=@IdProf)+char(10)+
'Дисципліна:'+(Select NameOfDiscipline From Disciplines Where IDDiscipline=@IdProf)+char(10)+
'Дата проведення іспиту:'+convert(varchar(20),(Select ExaminationDate From Exams Where IDProfessors=@IdProf))+char(10)+ 
'Аудиторія:' + convert(varchar(20),(Select LectureHall From Exams Where IDProfessors=@IdProf)); 
Print @Message 
END 

EXEC Inf '3';