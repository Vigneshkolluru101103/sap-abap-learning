@AbapCatalog.sqlViewName: 'ZVK_EMP_VIEW'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Basic Data CDS View'

define view ZVK_EMPLOYEE_CDS
  as select from pa0001 as emp

{
  key emp.pernr    as EmployeeNumber,
      emp.ename    as EmployeeName,
      emp.plans    as Position,
      emp.orgtx    as OrgUnit,
      emp.werks    as PersonnelArea,
      emp.begda    as StartDate,
      emp.endda    as EndDate
}
where
  emp.endda >= $session.system_date
