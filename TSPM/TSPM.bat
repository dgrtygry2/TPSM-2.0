@echo off
cls
echo Welcome to TSPM! You have a couple of options:
pause
echo You can: (1-Chat with TSPM) (2-Train TSPM) (3-Play TSPM game)
set /p input=Enter a number from 1-3 here: 

if "%input%"=="1" goto chat
if "%input%"=="2" call training.bat
if "%input%"=="3" call game.bat
exit

:chat
cls
@echo off
setlocal enabledelayedexpansion

REM Set the file paths for training data and user information
set "data_file=data.txt"
set "log_file=log.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"

REM Ensure required files exist
if not exist "%data_file%" echo. > "%data_file%"
if not exist "%log_file%" echo. > "%log_file%"
if not exist "%chatbotname_file%" echo TSPM > "%chatbotname_file%"
if not exist "%username_file%" echo User > "%username_file%"

REM Read chatbot name
for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"

REM Read username
for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"

REM Initialize conversation history
set "conversation_history="

REM Initialize clarification count
set /a clarification_count=0

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your chatbot.

REM Main chat loop
:chat_loop
set /p user_input="You: "
if "%user_input%"=="" goto chat_loop
if /i "%user_input%"=="exit" exit

echo You: %user_input% >> "%data_file%"
set "conversation_history=!conversation_history! %user_input%"

REM Check for new words
set "new_words="
for %%a in (%user_input%) do (
    set "word=%%a"
    findstr /i /x /c:"!word!" "%data_file%" >nul
    if errorlevel 1 (
        echo !word! >> "%data_file%"
        set "new_words=!new_words! !word!"
    )
)

REM Respond based on learned words
if not "%new_words%"=="" (
    echo %chatbot_name%: I learned new words: %new_words%
    echo %chatbot_name%: I learned new words: %new_words% >> "%log_file%"
)

REM Generate a response
set "sentence_log=!sentence_log! %user_input%"
echo %chatbot_name%: What do you think about "!sentence_log!"?
echo %chatbot_name%: What do you think about "!sentence_log!" >> "%log_file%"

REM Ask for clarification if needed
set /a clarification_count+=1
if %clarification_count% leq 3 (
    echo %chatbot_name%: What do you mean by "!user_input!"? Please explain more.
    set /p user_explanation="You: "
    set "sentence_log=!sentence_log! !user_explanation!"
) else (
    echo %chatbot_name%: Please write an example roleplay conversation (max 30 lines) to help me understand.
    set "roleplay_conversation="
    for /l %%i in (1,1,30) do (
        set /p "line=Roleplay - Line %%i: "
        if "!line!"=="" goto roleplay_end
        set "roleplay_conversation=!roleplay_conversation! !line!"
    )
    :roleplay_end
    echo %chatbot_name%: Thanks for the example. I'll learn from it.
)

goto chat_loop
