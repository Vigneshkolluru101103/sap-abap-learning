*&---------------------------------------------------------------------*
*& Report  : ZVK_EMPLOYEE_REPORT
*& Author  : Kolluru Vignesh
*& Date    : 2025
*& Desc    : Employee Data Report using ALV Grid & Open SQL (SAP HANA)
*&---------------------------------------------------------------------*

REPORT zvk_employee_report.

*----------------------------------------------------------------------*
* TYPE DECLARATIONS
*----------------------------------------------------------------------*
TYPES: BEGIN OF ty_employee,
         pernr TYPE pa0001-pernr,   " Employee Number
         ename TYPE pa0001-ename,   " Employee Name
         plans TYPE pa0001-plans,   " Position
         orgtx TYPE pa0001-orgtx,   " Org Unit
         werks TYPE pa0001-werks,   " Personnel Area
         begda TYPE pa0001-begda,   " Start Date
       END OF ty_employee.

*----------------------------------------------------------------------*
* DATA DECLARATIONS
*----------------------------------------------------------------------*
DATA: lt_employee  TYPE TABLE OF ty_employee,
      ls_employee  TYPE ty_employee,
      lt_fieldcat  TYPE slis_t_fieldcat_alv,
      ls_fieldcat  TYPE slis_fieldcat_alv,
      ls_layout    TYPE slis_layout_alv.

*----------------------------------------------------------------------*
* SELECTION SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_werks FOR ls_employee-werks,
                  s_plans FOR ls_employee-plans.
  PARAMETERS:     p_date  TYPE sy-datum DEFAULT sy-datum.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
* START OF SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM fetch_employee_data.
  PERFORM build_field_catalog.
  PERFORM set_layout.
  PERFORM display_alv_report.

*----------------------------------------------------------------------*
* FORM: FETCH_EMPLOYEE_DATA
* Desc : Fetch employee data using Open SQL from PA0001 (HANA optimized)
*----------------------------------------------------------------------*
FORM fetch_employee_data.

  SELECT pernr ename plans orgtx werks begda
    FROM pa0001
    INTO CORRESPONDING FIELDS OF TABLE lt_employee
    WHERE werks IN s_werks
      AND plans IN s_plans
      AND begda LE p_date
      AND endda GE p_date.

  IF sy-subrc <> 0.
    MESSAGE 'No employee records found for given selection.' TYPE 'I'.
  ELSE.
    SORT lt_employee BY werks pernr.
  ENDIF.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: BUILD_FIELD_CATALOG
* Desc : Define ALV column headers and properties
*----------------------------------------------------------------------*
FORM build_field_catalog.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname  = 'PERNR'.
  ls_fieldcat-seltext_m  = 'Emp No'.
  ls_fieldcat-col_pos    = 1.
  ls_fieldcat-key        = 'X'.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname  = 'ENAME'.
  ls_fieldcat-seltext_m  = 'Employee Name'.
  ls_fieldcat-col_pos    = 2.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname  = 'PLANS'.
  ls_fieldcat-seltext_m  = 'Position'.
  ls_fieldcat-col_pos    = 3.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname  = 'ORGTX'.
  ls_fieldcat-seltext_m  = 'Org Unit'.
  ls_fieldcat-col_pos    = 4.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname  = 'WERKS'.
  ls_fieldcat-seltext_m  = 'Personnel Area'.
  ls_fieldcat-col_pos    = 5.
  APPEND ls_fieldcat TO lt_fieldcat.

  CLEAR ls_fieldcat.
  ls_fieldcat-fieldname  = 'BEGDA'.
  ls_fieldcat-seltext_m  = 'Start Date'.
  ls_fieldcat-col_pos    = 6.
  APPEND ls_fieldcat TO lt_fieldcat.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: SET_LAYOUT
* Desc : Set ALV display layout properties
*----------------------------------------------------------------------*
FORM set_layout.

  ls_layout-zebra          = 'X'.   " Alternating row colors
  ls_layout-colwidth_optimize = 'X'. " Auto column width
  ls_layout-box_fieldname  = ' '.

ENDFORM.

*----------------------------------------------------------------------*
* FORM: DISPLAY_ALV_REPORT
* Desc : Call ALV function to display data grid
*----------------------------------------------------------------------*
FORM display_alv_report.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_program_name       = sy-repid
      it_fieldcat          = lt_fieldcat
      is_layout            = ls_layout
      i_default            = 'X'
      i_save               = 'A'
    TABLES
      t_outtab             = lt_employee
    EXCEPTIONS
      program_error        = 1
      OTHERS               = 2.

  IF sy-subrc <> 0.
    MESSAGE 'Error displaying ALV report.' TYPE 'E'.
  ENDIF.

ENDFORM.
