@echo off
cls
echo Welcome to TSPM! You have a couple of options!
pause
echo You can: (1-Chat with TSPM) (2-Train TSPM) (3-Play TSPM game)
set /p input= Enter a number from 1-3 here.
if input == 1 goto chat
if input == 2 goto train
if input == 3 goto game

:chat
cls
@echo off
setlocal enabledelayedexpansion
REM Set the file paths for training data and user information
set "data_file=data.txt"
set "brain_file=brain.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"

REM Initialize the chatbot name
for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"

REM Initialize the username
for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"

REM Define a function to remove punctuation (commas and periods)
set "punctuation=!user_input:,=!"
set "punctuation=!punctuation:.=!"

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your chatbot.

REM Main chat loop
:chat_loop
set /p user_input="You: "
if "%user_input%"=="" goto :chat_loop
echo You: %user_input% >> %data_file%

REM Convert user input to lowercase and remove punctuation
set "user_input_lowercase=!user_input!"
set "user_input_lowercase=!user_input_lowercase:,=!"
set "user_input_lowercase=!user_input_lowercase:.=!"

REM Check if the lowercase input (without punctuation) is in "brain.txt"
set "found=0"
for /f "usebackq delims=" %%a in ("%brain_file%") do (
    set "response=%%a"
    REM Convert the response from "brain.txt" to lowercase and remove punctuation
    set "response_lowercase=!response!"
    set "response_lowercase=!response_lowercase:,=!"
    set "response_lowercase=!response_lowercase:.=!"
    if /i "!user_input_lowercase!"=="!response_lowercase!" (
        echo %chatbot_name%: %%a
        echo %chatbot_name%: %%a >> %data_file%
        set "found=1"
        goto :chat_loop
    )
)

REM If input not found in "brain.txt," ask for clarification and learn
if %found%==0 (
    echo %chatbot_name%: I'm not sure what you mean. Can you clarify?
    set /p clarification="You: "
    echo %chatbot_name%: You mean, "!clarification!"?
    echo %chatbot_name%: You mean, "!clarification!"? >> %data_file%
    REM Convert the clarification to lowercase, remove punctuation, and save it to "brain.txt"
    set "clarification_lowercase=!clarification!"
    set "clarification_lowercase=!clarification_lowercase:,=!"
    set "clarification_lowercase=!clarification_lowercase:.=!"
    echo "!clarification_lowercase!" >> %brain_file%
)

goto :chat_loop
if input == "exit" goto menu

:train
cls
REM Set the file paths for training data and user information
set "data_file=data.txt"
set "brain_file=brain.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"

REM Initialize the chatbot name
for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"

REM Initialize the username
for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your trainbot. I can generate sentences based on what I've learned.

REM Main training loop
:train_loop
set /p user_input="You: "
if "%user_input%"=="" goto :train_loop
echo You: %user_input% >> %data_file%
echo %user_input% >> %brain_file%

REM Process the user's input and learn
REM You can implement more sophisticated logic here to generate sentences based on learned data
REM For simplicity, we will just echo a random sentence based on known words
set "random_sentence="
for /f "usebackq delims=" %%a in ("%brain_file%") do (
    set "word=%%a"
    REM Generate a random sentence by selecting a random word
    set /a "rand=!random! %% 2"
    if !rand!==0 (
        set "random_sentence=!random_sentence! !word!"
    )
)

REM Remove leading space and capitalize the first letter to mimic grammar
set "random_sentence=!random_sentence:~1!"
set "random_sentence=!random_sentence:~0,1!"^!random_sentence:~1^!"

REM Display the generated sentence
echo %chatbot_name%: %random_sentence%
echo %chatbot_name%: %random_sentence% >> %data_file%

goto :train_loop
if input == "exit" goto menu

:game
cls
REM Set the file paths for training data and user information
set "data_file=data.txt"
set "brain_file=brain.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"

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
echo %chatbot_name%: %story% >> %data_file%

REM Present the player with options
echo %chatbot_name%: What should happen next?
echo %chatbot_name%: 1. Option 1
echo %chatbot_name%: 2. Option 2
echo %chatbot_name%: 3. Option 3

set /p user_input="You: "
echo You: %user_input% >> %data_file%

REM Process the player's choice
if /i "!user_input!"=="1" (
    REM Handle option 1
    call :generateDialogue
) else if /i "!user_input!"=="2" (
    REM Handle option 2
    call :generateDialogue
) else if /i "!user_input!"=="3" (
    REM Handle option 3
    call :generateDialogue
) else (
    REM Handle invalid input
    echo %chatbot_name%: I didn't understand your choice. Please select '1,' '2,' or '3.'
    echo %chatbot_name%: I didn't understand your choice. Please select '1,' '2,' or '3.' >> %data_file%
)

REM Check if the user wants to exit
if /i "!user_input!"=="exit" goto :end

goto :game_loop

:generateDialogue
REM Generate new dialogue based on training data and "brain.txt"
set "dialogue="
for /f "usebackq delims=" %%a in ("%brain_file%") do (
    set "word=%%a"
    set /a "rand=!random! %% 2"
    if !rand!==0 (
        set "dialogue=!dialogue! !word!"
    )
)

REM Remove leading space and capitalize the first letter to mimic grammar
set "dialogue=!dialogue:~1!"
set "dialogue=!dialogue:~0,1!"^!dialogue:~1^!"

REM Display the generated dialogue
echo %chatbot_name%: %dialogue%
echo %chatbot_name%: %dialogue% >> %data_file%

goto :game_loop

:end
REM End the game
if input == "exit" goto menu
