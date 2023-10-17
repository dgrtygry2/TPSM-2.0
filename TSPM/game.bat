@echo off
cls
REM Set the file paths for training data and user information
set "data_file=data.txt"
set "brain_file=brain.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"
set "options_file=options.txt"
set "log_file=log.txt"

REM Initialize the chatbot name
for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"

REM Initialize the username
for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your text-based game AI.

REM Main game loop
:game_loop
REM Generate the next part of the story based on training data and "brain.txt"
set "story="
for /f "usebackq delims=" %%a in ("%brain_file%") do (
    set "word=%%a"
    set /a "rand=!random! %% 2"
    if !rand!==0 (
        set "story=!story! !word!"
    )
)

REM Remove leading space and capitalize the first letter to mimic grammar
set "story=!story:~1!"
set "story=!story:~0,1!"^!story:~1^!"

REM Display the generated story
echo %chatbot_name%: %story%
echo %chatbot_name%: %story% >> %log_file

REM Present the player with options from "options.txt"
echo %chatbot_name%: What should happen next?
setlocal enabledelayedexpansion
for /f "usebackq delims=" %%a in ("%options_file%") do (
    set "line=%%a"
    if "!line:~0,8!"=="Options:" (
        echo %chatbot_name%: !line:~9!
        set "options="
        set "option_count=0"
    ) else if "!line:~0,14!"=="Selected Option:" (
        set "selected_option=!line:~15!"
        set /a "option_count+=1"
        set "options[!option_count!]=!selected_option!"
    }
    if "!line:~0,8!"=="Options:" (
        set "option_index=0"
    ) else if "!line:~0,14!"=="Selected Option:" (
        set /a "option_index+=1"
        echo %chatbot_name%: !option_index!. !selected_option!
    )
)
endlocal

set /p user_input="You: "
echo You: %user_input% >> %log_file

REM Process the player's choice
if /i "!user_input!"=="1" (
    REM Handle option 1
    call :handleOption 1
) else if /i "!user_input!"=="2" (
    REM Handle option 2
    call :handleOption 2
) else if /i "!user_input!"=="3" (
    REM Handle option 3
    call :handleOption 3
) else (
    REM Handle invalid input
    echo %chatbot_name%: I didn't understand your choice. Please select a valid option.
    echo %chatbot_name%: I didn't understand your choice. Please select a valid option. >> %log_file
)

REM Check if the user wants to exit
if /i "!user_input!"=="exit" goto :end

goto :game_loop

:handleOption
REM Handle the selected option by displaying and cycling through the responses
set "selected_option_index=%~1"
set "response_index=0"

:displayResponse
set /a "response_index+=1"
if defined options[%selected_option_index%][%response_index%] (
    echo %chatbot_name%: !options[%selected_option_index%][%response_index%]!
    timeout /t 10 /nobreak >nul
    echo %chatbot_name%: What do you want to do now?
    set /p user_input="You: "
    echo You: %user_input% >> %log_file
    if /i "!user_input!"=="exit" goto :end
    goto :displayResponse
)
goto :game_loop

:end
REM End the game
if /i "!user_input!"=="exit" goto menu

