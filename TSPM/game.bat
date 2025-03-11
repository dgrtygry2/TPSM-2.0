@echo off
cls
setlocal enabledelayedexpansion

REM Set the file paths for training data and user information
set "data_file=data.txt"
set "brain_file=brain.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"
set "options_file=options.txt"
set "log_file=log.txt"

REM Ensure required files exist, create empty files if necessary
if not exist "%data_file%" echo. > "%data_file%"
if not exist "%brain_file%" echo. > "%brain_file%"
if not exist "%chatbotname_file%" echo AI > "%chatbotname_file%"
if not exist "%username_file%" echo Player > "%username_file%"
if not exist "%options_file%" echo "Fight the monster" > "%options_file%" & echo "Run away" >> "%options_file%"
if not exist "%log_file%" echo. > "%log_file%"

REM Initialize the chatbot name
for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"

REM Initialize the username
for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your text-based game AI.

REM Main game loop
:game_loop
REM Generate the next part of the story based on content in the brain file
set "story="
for /f "delims=" %%a in (%brain_file%) do (
    set /a "rand=!random! %% 2"
    if !rand! equ 0 set "story=!story! %%a"
)
set "story=!story:~1!"

REM Display the generated story
echo %chatbot_name%: %story%
echo %chatbot_name%: %story% >> %log_file%

REM Present options to the player
echo %chatbot_name%: What should happen next?
set "option_index=0"
for /f "delims=" %%a in (%options_file%) do (
    set /a "option_index+=1"
    echo !option_index!. %%a
)

REM Get the player's input
set /p user_input="You: "
echo You: %user_input% >> %log_file%

REM Process the player's choice
set "valid_option=0"
set "option_index=0"
for /f "tokens=1* delims= " %%a in (%options_file%) do (
    set /a "option_index+=1"
    if "%user_input%"=="%%a" (
        call :handleOption %%a
        set "valid_option=1"
        goto :break_option_loop
    )
)

REM Handle invalid input
:break_option_loop
if !valid_option! equ 0 (
    echo %chatbot_name%: Invalid choice. Please select a valid option from above.
    goto :game_loop
)

REM Handle valid choice
:handleOption
set "selected_option=%1"
echo %chatbot_name%: You chose option %selected_option%.

timeout /t 3 /nobreak >nul
echo %chatbot_name%: What do you want to do now?
goto :game_loop

:end
echo %chatbot_name%: Thanks for playing!
exit /b
