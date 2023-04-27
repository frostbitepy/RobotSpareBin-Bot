*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Excel.Files
Library    RPA.HTTP
Library    RPA.Tables
Library    Telnet
Library    RPA.Desktop
Library    RPA.PDF
#Library    RPA.Browser.Playwright

  

*** Variables ***
${URL}=     https://robotsparebinindustries.com/#/robot-order
#${OUTPUT_DIR}=    receipts

*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    Get orders
    



*** Keywords ***
Open the robot order website
    Open Available Browser    ${URL}        

Close the annoying modal
    Click Button When Visible 	//button[@class="btn btn-dark"]

Download the Excel file
    Download  https://robotsparebinindustries.com/orders.csv    overwrite=${True}

Get orders
    Download the Excel file
    ${orders}=    Read table from CSV    orders.csv    header=${True}
    FOR    ${order}    IN    @{orders}
        Close the annoying modal
        Fill the form    ${order}
        Order another Robot
    END    

Fill the form
    [Arguments]    ${order}
    Select From List By Value    head    ${order}[Head]
    Click Element    id-body-${order}[Body]
    Click ELement    class:form-control
    Type Text    ${order}[Legs]
    Input Text    address    ${order}[Address]
    Click Button    id:preview
    Wait Until Keyword Succeeds    1 min    2 sec    Click Button    id:order    #//button[@class="btn btn-primary"]
    TRY
        Wait Until Element Is Visible    id:receipt
    EXCEPT    message
        Wait Until Keyword Succeeds    1 min    2 sec    Click Button    id:order
    FINALLY
        Download and store the receipt    ${order}
    END


    



Download and store the receipt
    [Arguments]    ${order}
    Wait Until Element Is Visible    id:receipt
    ${receipt_html}=    Get Element Attribute    id:receipt    outerHTML
    Html To Pdf    ${receipt_html}    ${OUTPUT_DIR}${/}receipts${/}receipt_${order}[Order number].pdf
    Screenshot    id:robot-preview-image    ${OUTPUT_DIR}${/}preview.png
    ${image}=    Create List
    ...    ${OUTPUT_DIR}${/}preview.png
    Add Files To Pdf    ${image}   ${OUTPUT_DIR}${/}receipts${/}receipt_${order}[Order number].pdf    ${True}                       


Order another Robot
    Click Button    id:order-another

Archive ouput PDFs

Close RobotSpareBin Browser