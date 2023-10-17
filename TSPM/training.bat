@echo off
cls
REM Set the file paths for training data and user information
set "data_file=data.txt"
set "log_file=log.txt"
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
echo %user_input% >> %log_file

REM Ask the bot how to respond
echo %chatbot_name%: How should I respond?
set /p bot_response="You (provide response): "

REM Learn from the user's response and log it
echo %chatbot_name%: Learning from your response...
echo %bot_response% >> %log_file

REM Generate questions, prompts, and interest inquiries based on the context of the conversation
set "questions="
set "prompts="
set "interest_inquiries="
for /f "usebackq delims=" %%a in ("%log_file") do (
    set "response=%%a"
    REM Generate questions and prompts based on the context of the conversation
    if "!response!"=="I like it." (
        set "question=Why do you like it?"
        set "prompt=What else do you like?"
    )
    if "!response!"=="I don't understand." (
        set "question=What don't you understand?"
        set "prompt=Can you explain further?"
    )
    if "!response!"=="I agree." (
        set "question=Why do you agree?"
        set "prompt=What do you agree with?"
    )
    set "questions=!questions! !question!"
    set "prompts=!prompts! !prompt!"
    set "questions=!questions! Out of curiosity, Why do you think this?"
    set "prompts=!prompts! Out of curiosity, What do you mean by this?"
    set "questions=!questions! Just curious, Why do you think this?"
    set "prompts=!prompts! Just curious, What do you mean by this?"
    set "questions=!questions! Wow! {imaginative or creative word} What else?"
    set "prompts=!prompts! Why do you think {imaginative or creative word} like this?"

    REM Generate interest inquiries based on user's mention of a word or adjective
    set "words_to_inquire="
    for %%w in (interest, hobby, like, dislike) do (
        find /i "%%w" in "!response!" >nul
        if not errorlevel 1 (
            set "interest_inquiry=Ok! So you really like this %%w?"
            set "interest_inquiries=!interest_inquiries! !interest_inquiry!"
        )
    )
)

REM Display the generated questions, prompts, and interest inquiries
echo %chatbot_name%: Possible questions based on the context: %questions%
echo %chatbot_name%: %questions% >> %brain_file
echo %chatbot_name%: Prompts based on the context: %prompts%
echo %chatbot_name%: %prompts% >> %brain_file
echo %chatbot_name%: Interest inquiries: %interest_inquiries%
echo %chatbot_name%: %interest_inquiries% >> %brain_file

REM Display the bot's response based on the learned data
echo %chatbot_name%: %bot_response%
echo %chatbot_name%: %bot_response% >> %log_file

REM If the user wants to exit the training loop
if "%bot_response%"=="exit" (
    goto :train_end
)

goto :train_loop

:train_end
REM Return to the main menu or exit
set /p return_to_menu="Return to the main menu? (Y/N): "
if /i "%return_to_menu%"=="Y" (
    call TSPM.bat
) else (
    exit
)

