WITH RECURSIVE recursive_subs AS (
    -- Базовая часть: каждый сотрудник — корень для своего собственного дерева подчинённых.
    SELECT EmployeeID AS root_id, EmployeeID AS sub_id
    FROM Employees

    UNION ALL

    -- Рекурсивная часть: к каждому корню добавляем подчинённых уровнем глубже.
    SELECT rs.root_id, e.EmployeeID
    FROM Employees e
    INNER JOIN recursive_subs rs ON e.ManagerID = rs.sub_id
),
sub_counts AS (
    -- Для каждого сотрудника считаем число рекурсивных подчинённых (минус сам корень).
    SELECT root_id, COUNT(*) - 1 AS TotalSubordinates
    FROM recursive_subs
    GROUP BY root_id
)
SELECT e.EmployeeID,
       e.Name AS EmployeeName,
       e.ManagerID,
       d.DepartmentName,
       r.RoleName,
       (SELECT STRING_AGG(p.ProjectName, ', ' ORDER BY p.ProjectName)
        FROM Projects p
        WHERE p.DepartmentID = e.DepartmentID) AS ProjectNames,
       (SELECT STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName)
        FROM Tasks t
        WHERE t.AssignedTo = e.EmployeeID) AS TaskNames,
       sc.TotalSubordinates
FROM Employees e
LEFT JOIN Departments d  ON d.DepartmentID = e.DepartmentID
LEFT JOIN Roles       r  ON r.RoleID       = e.RoleID
INNER JOIN sub_counts sc ON sc.root_id     = e.EmployeeID
WHERE r.RoleName = 'Менеджер'
  AND sc.TotalSubordinates > 0
ORDER BY e.Name;
