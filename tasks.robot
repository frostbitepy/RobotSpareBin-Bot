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
  

*** Variables ***
${URL}=     https://robotsparebinindustries.com/#/robot-order


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
        
    END    

Fill the form
    [Arguments]    ${order}
    Select From List By Value    head    ${order}[Head]
    Click Element  id-body-${order}[Body]
    Click Element  1681951880523    ${order}[Legs]
    Input Text    address    ${order}[Address]

Download and store the receipt

Order another Robot

Archive ouput PDFs

Close RobotSpareBin Browser