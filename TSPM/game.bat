@echo off
cls
REM Set the file paths for training data and user information
set "data_file=data.txt"
set "brain_file=brain.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"
set "options_file=options.txt"
set "log_file=log.txt"

REM Ensure required files exist
if not exist "%data_file%" echo. > "%data_file%"
if not exist "%brain_file%" echo. > "%brain_file%"
if not exist "%chatbotname_file%" echo AI > "%chatbotname_file%"
if not exist "%username_file%" echo Player > "%username_file%"
if not exist "%options_file%" echo. > "%options_file%"
if not exist "%log_file%" echo. > "%log_file%"

REM Initialize the chatbot name
for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"

REM Initialize the username
for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your text-based game AI.

REM Main game loop
:game_loop
setlocal enabledelayedexpansion

REM Generate the next part of the story
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
    echo %option_index%. %%a
)

set /p user_input="You: "
echo You: %user_input% >> %log_file%

REM Process player's choice
for /f "tokens=1* delims= " %%a in (%options_file%) do (
    if "%user_input%" equ "%%a" call :handleOption %%a
)

echo %chatbot_name%: Invalid choice. Try again.
goto :game_loop

:handleOption
set "selected_option=%1"
echo %chatbot_name%: You chose option %selected_option%.

timeout /t 3 /nobreak >nul
echo %chatbot_name%: What do you want to do now?
goto :game_loop

:end
echo %chatbot_name%: Thanks for playing!
exit /b
