@echo off
cls
echo Welcome to TSPM! You have a couple of options:
pause
echo You can: (1-Chat with TSPM) (2-Train TSPM) (3-Play TSPM game)
set /p input=Enter a number from 1-3 here: 

if %input%==1 goto chat
if %input%==2 call training.bat
if %input%==3 call game.bat

:chat
cls
@echo off
setlocal enabledelayedexpansion

REM Set the file paths for training data and user information
set "data_file=data.txt"
set "log_file=log.txt"
set "chatbotname_file=chatbotname.txt"
set "username_file=username.txt"

REM Initialize the chatbot name
for /f "usebackq delims=" %%a in ("%chatbotname_file%") do set "chatbot_name=%%a"

REM Initialize the username
for /f "usebackq delims=" %%a in ("%username_file%") do set "username=%%a"

REM Initialize conversation history
set "conversation_history="

REM Initialize known words from data.txt
set "known_words="

REM Initialize sentence log
set "sentence_log="

REM Initialize clarification count
set "clarification_count=0"

REM Welcome message
echo Hello, %username%! I am %chatbot_name%, your chatbot.

REM Main chat loop
:chat_loop
set /p user_input="You: "
if "%user_input%"=="" goto chat_loop
echo You: %user_input% >> %data_file%
set "conversation_history=!conversation_history! %user_input%"

REM Process user input
set "new_words="
for %%a in (%user_input%) do (
    set "word=%%a"
    REM Check if the word is already in "data.txt"
    findstr /i /x /c:"!word!" "%data_file%" >nul
    if errorlevel 1 (
        REM If the word is not in "data.txt," add it
        echo "!word!" >> "%data_file%"
        set "new_words=!new_words! !word!"
    )
)

REM Generate a response based on the new words learned
if not "%new_words%"=="" (
    echo %chatbot_name%: I learned new words:%new_words%
    echo %chatbot_name%: I learned new words:%new_words% >> %data_file%
)

REM Create a sentence log based on the conversation history
set "sentence_log=!sentence_log! %user_input%"
REM Use the sentence log for generating responses
echo %chatbot_name%: What do you think about, "!sentence_log!"?
echo %chatbot_name%: What do you think about, "!sentence_log!" >> %log_file%

REM Ask for clarification and learn from the user's explanations
set /a "clarification_count+=1"
if %clarification_count% leq 3 (
    echo %chatbot_name%: What do you mean by "!user_input!"? Please explain more of what you mean.
    set /p user_explanation="You: "
    set "sentence_log=!sentence_log! !user_explanation!"
) else (
    REM If clarification was not successful, ask for a roleplay conversation
    echo %chatbot_name%: Please write me an example roleplay conversation of how you would say this so I can better understand what you mean by "!user_input!" (Maximum of 30 sentences).
    set "roleplay_conversation="
    for /l %%i in (1,1,30) do (
        set /p "line=Roleplay - Line %%i: "
        if "!line!"=="" goto roleplay_end
        set "roleplay_conversation=!roleplay_conversation! !line!"
    )
    :roleplay_end
    echo %chatbot_name%: Thank you for providing the roleplay conversation.

    REM Analyze and learn from the roleplay conversation
    REM You can implement this part to analyze the conversation and learn from it.

    REM After learning from the roleplay conversation, construct a new sentence
    REM based on the learned data.

    REM Provide the constructed sentence as a response.
    echo %chatbot_name%: Constructed response based on learning.
}

goto chat_loop

